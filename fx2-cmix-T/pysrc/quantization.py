# quantization.py: quantization-aware training (QAT) primitives for the transformer byte model.
#
# What it does: "fake quantization". In the forward pass a tensor x is replaced by
#     s * clamp(round(x / s), qmin, qmax)
# where s is a LEARNED step size ("scale", one per block of elements). The model therefore
# trains on exactly the integer grid the C++ inference kernels use, while the gradient is passed
# through the rounding (straight-through estimator) and also flows into s (learned step size
# quantization). The same module quantizes weights (15 levels, -7..7, the "int4" weights that
# are shipped) and matmul inputs / activations (256 levels, -128..127).
#
# Where it fits: training side only. pysrc/model.py wraps every quantized matmul in Quantize
# modules; pysrc/export_weights.py reads the trained scales and re-derives the integers that go
# into the weights file; cpp_infer/ (the transformer byte model inside the compressor) then
# computes y[o] = (s_act * s_w[o]) * sum_i qa[i] * qw[o][i] in integer arithmetic.
#
# How this relates to the C++ kernels' 8-bit and 16-bit activations:
#   - 8-bit path (previous winner): qa = clamp(round_half_even(x / s), -128, 127), the same
#     formula as here with buckets=256 (torch.round is round-half-even, one fp32 division).
#   - [this entry] 16-bit path (cpp_infer/src/opt/act16.*, CMIX_ACT16): the C++ side divides the
#     stored activation scale by 256 and clamps to the int16 range, i.e. 256 times finer steps
#     over the same clamp range, using the SAME weights and the SAME stored scales. In terms of
#     this file that is buckets=65536 with scale s / 256. Nothing has to be re-exported for it:
#     the stored scale is still the 256-level one learned here. Note that the recipes in this
#     tree always train with 256-level activations (there is no 16-bit switch in this Python
#     code); the finer rounding at inference only removes rounding noise from the matmul
#     inputs.
#
# Testing: scripts/cloud/test_fused_quant.py compares the fused path below against the eager
# reference. FUSED_QUANT=0 selects the eager reference at run time.
#
# Changes from the previous winning entry (fx2-cmix-transformer-v1):
#   - [this entry] FusedQuantizeFunction: the same maths compiled into one kernel per direction.
#     Purely a training-speed change (it made the cmix-aware fine-tune affordable on one GPU).
#   - Everything else (Quantization, Quantize, QuantizeFunction) is unchanged.
import torch
from torch import Tensor, inference_mode, tensor, zeros, no_grad, maximum
from torch.nn import Module, Parameter
from torch.autograd import Function
from torch.autograd.function import FunctionCtx
from math import sqrt, prod
from dataclasses import dataclass, replace
from jaxtyping import Float, Bool
from typing import Literal


# TODO: quantize positive only tensors (after relu)


ScaleInit = Literal["scaled_mean", "scaled_max"]


# Description of one quantizer.
#   buckets          number of integer levels: 15 -> -7..7 (weights), 256 -> -128..127
#                    (activations); 3 and 4 select the StretchedElasticQuant variant below
#   block_size       how many consecutive elements of the last dimension share one scale
#                    (None = the whole last dimension, e.g. one scale per weight row)
#   scale_dtype      precision the scale is rounded to before use (bfloat16)
#   arithmetic_dtype precision of the divide / round / multiply (float32, as in the C++)
#   scale_init       how the scale is calibrated before training, see initialize_scale
#   epsilon          optional lower bound on |scale|
@dataclass(frozen=True, slots=True)
class Quantization:
    buckets: int
    block_size: int | None
    scale_dtype: torch.dtype
    arithmetic_dtype: torch.dtype
    scale_init: ScaleInit
    epsilon: float | None

    # Integer range: symmetric for odd bucket counts (15 -> -7..7), two's-complement style for
    # even ones (256 -> -128..127).
    @property
    def int_range(self) -> tuple[int, int]:
        qmin: int = -(self.buckets // 2)
        qmax: int = (self.buckets - 1) // 2
        assert qmax - qmin + 1 == self.buckets
        return qmin, qmax

    @property
    def qmin(self) -> int:
        return self.int_range[0]

    @property
    def qmax(self) -> int:
        return self.int_range[1]

    def __post_init__(self) -> None:
        assert self.buckets != 2, (
            "the code is incorrect for 1 bit quantization but it's not used so i didn't fix it"
        )


# A quantizer attached to one tensor of the model (a weight matrix or a matmul input). Holds the
# learned scales as a Parameter. `size` is the trailing shape of the tensor it quantizes;
# `batched` says whether leading batch dimensions precede it (activations) or not (weights).
class Quantize(Module):
    def __init__(
        self,
        quant: Quantization,
        size: tuple[int, ...],
        batched: bool,
        scale_weight_dtype: torch.dtype,
        flatten_scale: bool,
    ) -> None:
        super().__init__()

        if quant.block_size is None:
            quant = replace(quant, block_size=size[-1])
            assert quant.block_size is not None

        self.quant = quant

        self.size = size
        self.batched = batched

        assert size[-1] % quant.block_size == 0
        self.n_blocks = prod(size) // quant.block_size

        scale_shape: tuple[int, ...] = size[:-1] + (size[-1] // quant.block_size,)
        if flatten_scale:
            scale_shape = (prod(scale_shape),)
        assert prod(scale_shape) == self.n_blocks

        self.scale = Parameter(zeros(size=scale_shape, dtype=scale_weight_dtype))

    # Calibration, run without gradients for `steps` batches before QAT starts:
    #   scaled_mean (activations): average over the batches of 2 * mean|x| / sqrt(qmax), the usual
    #                              learned-step-size initialisation;
    #   scaled_max  (weights):     max|x| / qmax, so that no weight is clipped at the start.
    def initialize_scale(
        self,
        sample_blocks: Float[Tensor, "batch n_blocks block_size"],
        steps: int,
    ) -> None:
        with no_grad():  # there is a small chance that decorating the function with `@no_grad()` will interact with torch.copile in ore cursed ways than `with no_grad()`. it should probabbly not happen because it's mostly only a thing in older versions of torch. but we use `with no_grad()` instead of `@no_grad()` just in case. also, `inference_mode` sometimes can  interact with torch.compile in more cursed ways than `no_grad`, though this is also mostly only a thing in older versions of torch
            scale: Float[Tensor, " n_blocks"]

            if self.quant.scale_init == "scaled_mean":
                k: float = 2 / sqrt(self.quant.qmax)
                scale = k * sample_blocks.type_as(self.scale).abs().mean((0, -1))
                scale = scale.reshape(self.scale.shape).type_as(self.scale)
                self.scale.add_(scale / steps)
            elif self.quant.scale_init == "scaled_max":
                k: float = 1 / self.quant.qmax
                scale = k * sample_blocks.type_as(self.scale).abs().amax((0, -1))
                scale = scale.reshape(self.scale.shape).type_as(self.scale)
                maximum(self.scale, scale, out=self.scale)
            else:
                raise ValueError(f"unknown scale init '{self.quant.scale_init}'")

    # View the tensor as (batch, n_blocks, block_size) so that each block lines up with one scale.
    def reshape_input(
        self, input: Tensor
    ) -> Float[Tensor, "batch n_blocks block_size"]:
        assert self.quant.block_size is not None

        if not self.batched:
            assert input.shape == self.size
            return input.view(1, self.n_blocks, self.quant.block_size)

        assert len(input.shape) >= len(self.size)
        assert input.shape[-len(self.size) :] == self.size
        return input.view(-1, self.n_blocks, self.quant.block_size)

    def forward(
        self, input: Tensor, initialize_scales_steps: int | None, return_ints: bool
    ) -> Tensor:
        assert self.quant.block_size is not None

        blocks = self.reshape_input(input)

        # Calibration mode: only gather statistics, pass the input through unquantized.
        if initialize_scales_steps is not None:
            self.initialize_scale(blocks, steps=initialize_scales_steps)
            return input

        # [this entry] On CUDA use the fused (compiled) implementation unless FUSED_QUANT=0; on CPU
        # (export, tests) use the eager reference of the previous winner.
        quantize_function = (
            FusedQuantizeFunction if FUSED_QUANT and input.is_cuda else QuantizeFunction
        )
        fake_quantized: Tensor = quantize_function.apply(  # type: ignore
            blocks, self.scale.view(-1), self.quant, return_ints
        )

        if return_ints:
            assert fake_quantized.dtype == torch.int64
        else:
            assert fake_quantized.dtype == input.dtype

        return fake_quantized.view(input.shape)

    # The scales as raw bfloat16 bytes (used by the export / test-data code).
    @inference_mode()
    def serialize_scale(self) -> bytes:
        scale = self.scale.to(self.quant.scale_dtype)
        assert scale.dtype == torch.bfloat16
        return scale.cpu().detach().view(torch.uint16).numpy().tobytes()


# 3- and 4-level quantizers (StretchedElasticQuant). Kept from the previous winner; the shipped
# model does not use them (its weights are 15-level, its activations 256-level).
_STRETCHED_ELASTIC_CLIP_VAL: float = 1 - 1e-2


def _stretched_elastic_params(buckets: int) -> tuple[float, float]:
    # n_levels, shift from https://arxiv.org/abs/2502.02631 (StretchedElasticQuant)
    if buckets == 3:
        return 1.5, 0.0
    if buckets == 4:
        return 2.0, 0.5
    raise ValueError(f"no StretchedElasticQuant params for buckets={buckets}")


# Fused fake quantization (2026-11-07). The eager QuantizeFunction below runs
# ~10 elementwise kernels per direction over every activation, in fp32, and
# saves a full fp32 copy for backward; on run A that was ~72% of GPU time
# (memory bound, the model's matmuls are small). The fused path compiles just
# the elementwise math into one kernel per direction and saves the input
# instead of the fp32 copy. The bf16 rounding of the scales stays in eager
# code, outside the compiled region (torch.compile of the whole model used to
# drop it). FUSED_QUANT=0 selects the eager reference.
import os as _os

FUSED_QUANT: bool = _os.environ.get("FUSED_QUANT", "1") != "0"

# one compiled kernel per (shape, dtype, buckets): the model has a few dozen,
# more than dynamo's default of 8 per function, past which it fails (with
# fullgraph=True) or falls back to eager. In torch 2.12 dynamo's config is per thread (autograd runs
# backward on its own thread, which still saw 8), so it is set in whichever
# thread calls the compiled functions; hasattr() is False on the config
# module, hence the try.
def _raise_recompile_limits() -> None:
    if torch._dynamo.config.recompile_limit >= 1024:
        return
    for name in ("recompile_limit", "accumulated_recompile_limit"):
        try:
            setattr(torch._dynamo.config, name, 1024)
        except (AttributeError, KeyError):
            pass


# Inductor's default division is not IEEE round-to-nearest: on real weights
# and activations a few values per tensor land on a rounding boundary of
# x / scale and quantize to the neighbouring level (2026-11-07). This option
# makes it divide exactly like eager.
_COMPILE_OPTIONS = {"eager_numerics.division_rounding": True}


# [this entry] Scale preparation shared by the fused forward and backward: broadcast shape
# (1, n_blocks, 1), round to bf16, widen to fp32, apply epsilon. Done in eager code on purpose
# (see the note above) so that the bf16 rounding is never optimised away.
def _prepared_scale(flat_scale: Tensor, quant: Quantization) -> Tensor:
    scale = flat_scale.unsqueeze(0).unsqueeze(-1)
    scale = scale.to(quant.scale_dtype).to(quant.arithmetic_dtype)
    if quant.epsilon is not None:
        epsilon = tensor(quant.epsilon, dtype=scale.dtype, device=scale.device)
        scale = (2 * (scale >= 0).type_as(scale) - 1) * scale.abs().maximum(epsilon)
    return scale


# [this entry] The rounding step on already-scaled values x = input / scale. The last line is
# the one the shipped model uses: round half to even, then clamp to the integer range.
def _fq_quantized(x: Tensor, buckets: int, qmin: int, qmax: int) -> Tensor:
    if buckets == 2:
        return 2 * (x >= 0).type_as(x) - 1
    if buckets in (3, 4):
        n_levels, shift = _stretched_elastic_params(buckets)
        clamped = x.clamp(-_STRETCHED_ELASTIC_CLIP_VAL, _STRETCHED_ELASTIC_CLIP_VAL)
        return ((clamped * n_levels - shift).round() + shift) / n_levels
    return x.round().clamp(qmin, qmax)


# [this entry] Fused forward: divide, round, clamp and (unless the integers themselves are
# wanted) multiply back by the scale, in one compiled kernel.
@torch.compile(dynamic=False, fullgraph=True, options=_COMPILE_OPTIONS)
def _fq_forward(
    blocks: Tensor, scale: Tensor, buckets: int, qmin: int, qmax: int,
    return_ints: bool,
) -> Tensor:
    x = blocks.to(scale.dtype) / scale
    q = _fq_quantized(x, buckets, qmin, qmax)
    if return_ints:
        return q.to(torch.int64)
    return (scale * q).to(blocks.dtype)


# [this entry] Fused backward. Recomputes x = input / scale from the saved input instead of
# saving an fp32 copy. Gradients, the same formulas as QuantizeFunction.backward below:
#   d/d input : grad_out where qmin <= x <= qmax, else 0          (straight-through estimator)
#   d/d scale : sum over the block of grad_out * t / norm, with
#               t = round(x) - x inside the range, qmin below it, qmax above it
#               norm = sqrt(numel * qmax)                        (learned step size scaling)
@torch.compile(dynamic=False, fullgraph=True, options=_COMPILE_OPTIONS)
def _fq_backward(
    grad_out: Tensor, blocks: Tensor, scale: Tensor, buckets: int, qmin: int,
    qmax: int,
) -> tuple[Tensor, Tensor]:
    x = blocks.to(scale.dtype) / scale
    g = grad_out.to(scale.dtype)
    if buckets == 2:
        lo, hi = -1.0, 1.0
        small_value, big_value = 0.0, 0.0  # unused: sign term below
    elif buckets in (3, 4):
        n_levels, shift = _stretched_elastic_params(buckets)
        lo, hi = -_STRETCHED_ELASTIC_CLIP_VAL, _STRETCHED_ELASTIC_CLIP_VAL
        big_value = (n_levels - shift) / n_levels
        small_value = -big_value
    else:
        lo, hi = float(qmin), float(qmax)
        small_value, big_value = float(qmin), float(qmax)
    too_small = x < lo
    too_big = hi < x
    within = too_small.logical_not().logical_and(too_big.logical_not())
    grad_input = g * within.type_as(g)
    if buckets == 2:
        term = 2 * (x >= 0).type_as(x) - 1
        norm = sqrt(x.numel())
    else:
        term = (
            too_small.type_as(g) * small_value
            + too_big.type_as(g) * big_value
            + within.type_as(g) * (_fq_quantized(x, buckets, qmin, qmax) - x)
        )
        norm = sqrt(x.numel()) if buckets in (3, 4) else sqrt(x.numel() * qmax)
    grad_scale = (g * term).sum(0).sum(-1) / norm
    return grad_input.to(grad_out.dtype), grad_scale.to(grad_out.dtype)


# [this entry] autograd wrapper around the two compiled kernels. Saves the unquantized input and
# the prepared scale for backward.
class FusedQuantizeFunction(Function):
    @staticmethod
    def forward(
        ctx: FunctionCtx,
        blocks: Tensor,
        flat_scale: Tensor,
        quant: Quantization,
        return_ints: bool,
    ) -> Tensor:
        assert quant.block_size is not None and blocks.ndim == 3
        assert blocks.size(1) == flat_scale.numel()
        _raise_recompile_limits()
        scale = _prepared_scale(flat_scale, quant)
        ctx.save_for_backward(blocks, scale)
        ctx.quant = quant  # type: ignore[attr-defined]
        return _fq_forward(
            blocks, scale, quant.buckets, quant.qmin, quant.qmax, return_ints
        )

    @staticmethod
    def backward(ctx: FunctionCtx, grad_out: Tensor):  # type: ignore[override]
        blocks, scale = ctx.saved_tensors  # type: ignore[attr-defined]
        quant: Quantization = ctx.quant  # type: ignore[attr-defined]
        _raise_recompile_limits()
        grad_input, grad_scale = _fq_backward(
            grad_out.contiguous(), blocks, scale, quant.buckets, quant.qmin,
            quant.qmax,
        )
        return grad_input, grad_scale, None, None


# Eager reference implementation (previous winner, unchanged). Same maths as the fused path,
# one elementwise torch op at a time; used on CPU and when FUSED_QUANT=0.
class QuantizeFunction(Function):
    @staticmethod
    def forward(
        ctx: FunctionCtx,
        blocks: Float[Tensor, "batch n_blocks block_size"],
        flat_scale: Float[Tensor, " n_blocks"],
        quant: Quantization,
        return_ints: bool,
    ) -> Float[Tensor, "batch n_blocks block_size"]:
        assert quant.block_size is not None
        assert quant.buckets >= 2

        input_dtype = blocks.dtype
        blocks = blocks.to(quant.arithmetic_dtype)

        assert blocks.ndim == 3
        assert flat_scale.ndim == 1
        assert blocks.size(1) == flat_scale.numel()
        assert blocks.size(2) == quant.block_size

        # The scale is rounded to bf16 before use, the precision it is kept in when serialized.
        scale: Float[Tensor, "1 n_blocks 1"] = flat_scale.unsqueeze(0).unsqueeze(-1)
        scale = scale.to(quant.scale_dtype).type_as(blocks)
        if quant.epsilon is not None:
            epsilon = tensor(quant.epsilon, dtype=scale.dtype, device=scale.device)
            scale = (2 * (scale >= 0).type_as(scale) - 1) * scale.abs().maximum(epsilon)

        scaled_blocks = blocks / scale

        if quant.buckets == 2:
            # 1-bit binary quantization from https://arxiv.org/abs/2502.02631
            quantized_blocks = nonzero_sign(scaled_blocks)
            dequantized_blocks = scale * quantized_blocks
        elif quant.buckets in (3, 4):
            # 1.58-bit / 2-bit StretchedElasticQuant from https://arxiv.org/abs/2502.02631
            n_levels, shift = _stretched_elastic_params(quant.buckets)
            clamped = scaled_blocks.clamp(
                -_STRETCHED_ELASTIC_CLIP_VAL, _STRETCHED_ELASTIC_CLIP_VAL
            )
            quantized_blocks = ((clamped * n_levels - shift).round() + shift) / n_levels
            dequantized_blocks = scale * quantized_blocks
        # General case (15-level weights, 256-level activations): integer = round-half-even(x / s)
        # clamped; the fake-quantized value is s * integer.
        else:
            quantized_blocks = scaled_blocks.round().clamp(quant.qmin, quant.qmax)
            dequantized_blocks = scale * quantized_blocks

        ctx.save_for_backward(scaled_blocks)
        ctx.quant = quant  # type: ignore[attr-defined]

        if return_ints:
            return quantized_blocks.to(torch.int64)

        return dequantized_blocks.to(input_dtype)

    @staticmethod
    def backward(  # type: ignore[reportIncompatibleMethodOverride]
        ctx: FunctionCtx, grad_out: Float[Tensor, "batch n_blocks block_size"]
    ) -> tuple[
        Float[Tensor, "batch n_blocks bolck_size"],
        Float[Tensor, " n_blocks"],
        None,
        None,
    ]:
        scaled_blocks: Float[Tensor, "batch n_blocks block"]
        (scaled_blocks,) = ctx.saved_tensors  # type: ignore[attr-defined]
        quant: Quantization = ctx.quant  # type: ignore[attr-defined]

        grad_dtype = grad_out.dtype
        grad_out = grad_out.to(quant.arithmetic_dtype)

        if quant.buckets == 2:
            too_small: Bool[Tensor, "batch n_blocks block_size"] = scaled_blocks < -1
            too_big: Bool[Tensor, "batch n_blocks block_size"] = 1 < scaled_blocks
            within_bounds: Bool[Tensor, "batch n_blocks block_size"] = (
                too_small.logical_not().logical_and(too_big.logical_not())
            )

            grad_input: Float[Tensor, "batch n_blocks block_size"] = (
                grad_out * within_bounds.type_as(grad_out)
            )

            grad_flat_scale: Float[Tensor, " n_blocks"] = (
                (grad_out * nonzero_sign(scaled_blocks))
                .sum(0)  # sum along batch dimension
                .sum(-1)  # sum along block_size dimension
            )
            # paper grad_scale = 1 / sqrt(numel * Qp_initial) with Qp_initial = 1
            grad_flat_scale = grad_flat_scale / sqrt(scaled_blocks.numel())
        elif quant.buckets in (3, 4):
            n_levels, shift = _stretched_elastic_params(quant.buckets)
            clip_val = _STRETCHED_ELASTIC_CLIP_VAL
            qp_paper = (n_levels - shift) / n_levels
            qn_paper = -qp_paper

            too_small = scaled_blocks < -clip_val
            too_big = clip_val < scaled_blocks
            within_bounds = too_small.logical_not().logical_and(too_big.logical_not())

            grad_input = grad_out * within_bounds.type_as(grad_out)

            clamped = scaled_blocks.clamp(-clip_val, clip_val)
            rounded = ((clamped * n_levels - shift).round() + shift) / n_levels
            middle = rounded - scaled_blocks

            grad_flat_scale = (
                (
                    grad_out
                    * (
                        too_small.type_as(grad_out) * qn_paper
                        + too_big.type_as(grad_out) * qp_paper
                        + within_bounds.type_as(grad_out) * middle
                    )
                )
                .sum(0)
                .sum(-1)
            )
            # paper grad_scale = 1 / sqrt(numel * Qp_initial) with Qp_initial = 1
            grad_flat_scale = grad_flat_scale / sqrt(scaled_blocks.numel())
        # General case: straight-through gradient for the input, learned-step-size gradient for the
        # scale (see the formulas at _fq_backward).
        else:
            too_small = scaled_blocks < quant.qmin
            too_big = quant.qmax < scaled_blocks
            within_bounds = too_small.logical_not().logical_and(too_big.logical_not())

            grad_input = grad_out * within_bounds.type_as(grad_out)

            grad_flat_scale = (
                (
                    grad_out
                    * (
                        too_small.type_as(grad_out) * quant.qmin
                        + too_big.type_as(grad_out) * quant.qmax
                        + within_bounds.type_as(grad_out)
                        * (scaled_blocks.round() - scaled_blocks)
                    )
                )
                .sum(0)  # sum along batch dimension
                .sum(-1)  # sum along block_size dimension
            )
            grad_flat_scale = grad_flat_scale / sqrt(scaled_blocks.numel() * quant.qmax)

        return grad_input.to(grad_dtype), grad_flat_scale.to(grad_dtype), None, None


# sign(x) with sign(0) = +1.
def nonzero_sign(x: Tensor) -> Tensor:
    return 2 * (x >= 0).type_as(x) - 1


# ruff: noqa: F722
