# train.py: the training loop shared by every recipe in training_recipes/.
#
# What it does: iterates the data loader (pysrc/data.py), runs the transformer (pysrc/model.py)
# on each micro batch, accumulates gradients over a batch, steps the optimizers
# (pysrc/optimizer.py) and logs (pysrc/logger.py). Before the first step it can calibrate the
# quantization scales (pysrc/quantization.py). The recipes build the model, the loader and a
# TrainingConfig and call train(); afterwards they save the checkpoint that
# pysrc/export_weights.py turns into the weights file shipped inside the compressor.
#
# Where it fits: training side only; nothing here runs during compression.
#
# Changes from the previous winning entry (fx2-cmix-transformer-v1):
#   - [this entry] TrainingConfig.mixture_loss: train on the cmix-aware mixture loss
#     (pysrc/cmix_loss.py) instead of the transformer's own cross-entropy. This is what
#     produces the weights of this entry (smaller archive at the same model size).
#   - [this entry] the stand-in mixer has its own AdamW and is averaged across GPUs by hand.
#   - [this entry] per-epoch checkpoints (CHECKPOINT_PREFIX), so that a rented GPU dying late
#     in a run does not lose the run.
#   - [this entry] train() returns the trained stand-in mixer; the recipes save it beside the
#     checkpoint for inspection (nothing loads it again: each stage starts a fresh mixer).
from torch import Tensor, inference_mode
from torch.nn.parallel import DistributedDataParallel as DDP
import torch.distributed as dist
from tqdm import trange, tqdm
from dataclasses import dataclass
from jaxtyping import Float, Int
from typing import Callable

from pysrc.model import Transformer
from pysrc.quantization import Quantize
from pysrc.data import CollatedArticlesDataLoader
from pysrc.model import InitializeScales
from pysrc.optimizer import make_optimizers, OptimizerConfig
from pysrc.logger import Logger, LoggerConfig
from pysrc.cmix_loss import CmixMixtureLoss, MixtureLossConfig
import os
import torch


# Per-run settings.
#   initialize_scales_steps         batches used to calibrate the quantization scales before
#                                   training (None = scales already trained, skip)
#   initialize_weight_scales_first  calibrate weight scales before or after activation scales
#   window_size_schedule            optional attention-window curriculum, a function of the
#                                   fraction of training done
@dataclass(frozen=True, slots=True)
class TrainingConfig:
    initialize_scales_steps: int | None
    initialize_weight_scales_first: bool
    optimizer_config: OptimizerConfig
    window_size_schedule: Callable[[float], int | Int[Tensor, ""]] | None
    logger_config: LoggerConfig
    # train against cmix (pysrc/cmix_loss.py) instead of plain cross-entropy;
    # the data loader must then have a cmix_bits_filename
    mixture_loss: MixtureLossConfig | None = None


def train(
    raw_model: Transformer,
    model: DDP | Transformer,
    data: CollatedArticlesDataLoader,
    cfg: TrainingConfig,
) -> CmixMixtureLoss | None:
    """returns the trained stand-in mixer when cfg.mixture_loss is set"""
    model.train()
    optimizers = make_optimizers(raw_model, cfg.optimizer_config)

    # [this entry] The stand-in mixer of the mixture loss. It lives outside the Transformer module
    # (so it is neither wrapped by DDP nor exported) and gets a plain AdamW without weight decay.
    mixture: CmixMixtureLoss | None = None
    mixer_optimizer: torch.optim.AdamW | None = None
    if cfg.mixture_loss is not None:
        assert data.cmix_bits_filename is not None, (
            "the mixture loss needs the data loader's cmix_bits_filename"
        )
        mixture = CmixMixtureLoss(cfg.mixture_loss).to(data.device)
        mixer_optimizer = torch.optim.AdamW(
            mixture.parameters(),
            lr=cfg.mixture_loss.mixer_learning_rate,
            weight_decay=0.0,
        )

    initialize_scales(raw_model=raw_model, model=model, data=data, cfg=cfg)

    logger = Logger(
        model=raw_model,
        cfg=cfg.logger_config,
        rank=data.rank,
        world_size=data.world_size,
    )

    total_batches: int = (
        len(data)  # type: ignore[arg-type]
        if hasattr(data, "__len__")
        else data.approximate_length()  # type: ignore[union-attr]
    )
    # One iteration = one optimizer step = gradient_accumulation_steps micro batches on this rank.
    for batch in tqdm(data, desc="training", total=total_batches):
        window_size: int | Int[Tensor, ""] | None = (
            cfg.window_size_schedule(batch.fraction_done)
            if cfg.window_size_schedule is not None
            else None
        )

        learning_rates = optimizers.update_learning_rate_schedule(
            fraction_done=batch.fraction_done
        )

        total_step_loss: Float[Tensor, ""] = 0.0  # type: ignore
        total_step_unmasked_tokens: Int[Tensor, ""] = 0  # type: ignore
        total_step_tokens: int = 0
        for micro_batch in batch.micro_batches:
            # Plain training (previous winner): the model returns its summed cross-entropy.
            # [this entry] Mixture training: the model returns logits, and the loss is the coding
            # cost of the stand-in mixer that combines them with cmix's own per-bit predictions.
            if mixture is None:
                loss = model(
                    input_tokens=micro_batch.input_tokens,
                    priors=micro_batch.priors,
                    loss_mask=micro_batch.loss_mask,
                    output_tokens=micro_batch.output_tokens,
                    cumulative_sequence_lengths=micro_batch.cumulative_sequence_lengths,
                    override_window_size=window_size,
                )
            else:
                logits = model(
                    input_tokens=micro_batch.input_tokens,
                    priors=micro_batch.priors,
                    loss_mask=micro_batch.loss_mask,
                    output_tokens=micro_batch.output_tokens,
                    cumulative_sequence_lengths=micro_batch.cumulative_sequence_lengths,
                    override_window_size=window_size,
                    return_logits=True,
                )
                loss = mixture(
                    logits,
                    micro_batch.output_tokens,
                    micro_batch.cmix_bit_logits,
                    micro_batch.loss_mask,
                )
            # Losses are sums over tokens; the logged value below is the mean per predicted token
            # (with the mixture loss: the mixed cost in nats per token, not the transformer's own).
            total_step_loss += loss.detach()
            total_step_unmasked_tokens += micro_batch.loss_mask.long().sum()
            loss = loss / data.gradient_accumulation_steps
            total_step_tokens += micro_batch.input_tokens.numel()
            loss.backward()

        optimizers.step()
        optimizers.zero_grad()
        if mixture is not None:
            # the mixer is outside DDP: average its gradients by hand so all
            # ranks keep identical mixer weights
            if dist.is_initialized():
                for p in mixture.parameters():
                    dist.all_reduce(p.grad, op=dist.ReduceOp.AVG)
            mixer_optimizer.step()
            mixer_optimizer.zero_grad()

        # end of an epoch: keep a checkpoint so a late failure does not lose
        # the whole run (CHECKPOINT_PREFIX, e.g. models/6m-q4-A)
        checkpoint_prefix: str | None = os.environ.get("CHECKPOINT_PREFIX")
        if (
            checkpoint_prefix
            and float(batch.epoch).is_integer()
            and (not dist.is_initialized() or dist.get_rank() == 0)
        ):
            torch.save(raw_model.state_dict(), f"{checkpoint_prefix}.epoch.tch")
            if mixture is not None:
                torch.save(mixture.state_dict(), f"{checkpoint_prefix}.epoch.mixer.tch")

        logger.train_step(
            epoch=batch.epoch,
            loss=(total_step_loss / total_step_unmasked_tokens).item(),
            n_tokens=total_step_tokens,
            learning_rates=learning_rates,
            last_step=batch.is_last,
        )
    return mixture


# Calibrate the learned quantization scales before QAT starts (previous winner, unchanged):
# one step for the weight scales (they depend only on the weights), then
# initialize_scales_steps batches for the activation scales, which are statistics of the
# activations. Under DDP each rank calibrates on its own data and the results are combined
# (mean for "scaled_mean", max for "scaled_max") so that all ranks start identical.
@inference_mode()
def initialize_scales(
    raw_model: Transformer,
    model: DDP | Transformer,
    data: CollatedArticlesDataLoader,
    cfg: TrainingConfig,
) -> None:
    if cfg.initialize_scales_steps is None:
        return

    weight_steps: int = 1
    activation_steps: int = cfg.initialize_scales_steps

    initialize_weight_scales = InitializeScales(
        weight_steps=weight_steps, activation_steps=None
    )
    initialize_activations_scales = InitializeScales(
        weight_steps=None,
        activation_steps=activation_steps * data.gradient_accumulation_steps,
    )

    data_iterator = iter(data)

    for step in trange(
        weight_steps + activation_steps, desc="initializing quantization scales"
    ):
        batch = next(data_iterator)

        initialize_weight_scales_this_step: bool = (
            step < weight_steps
            if cfg.initialize_weight_scales_first
            else step >= activation_steps
        )
        initialize_scales = (
            initialize_weight_scales
            if initialize_weight_scales_this_step
            else initialize_activations_scales
        )

        for micro_batch in (
            [batch.micro_batches[0]]
            if initialize_weight_scales_this_step
            else batch.micro_batches
        ):
            model(
                input_tokens=micro_batch.input_tokens,
                priors=micro_batch.priors,
                loss_mask=micro_batch.loss_mask,
                output_tokens=micro_batch.output_tokens,
                cumulative_sequence_lengths=micro_batch.cumulative_sequence_lengths,
                override_window_size=cfg.window_size_schedule(0)
                if cfg.window_size_schedule is not None
                else None,
                initialize_scales=initialize_scales,
            )

    if dist.is_initialized():
        for module in raw_model.modules():
            if isinstance(module, Quantize):
                if module.quant.scale_init == "scaled_mean":
                    dist.all_reduce(module.scale.data, op=dist.ReduceOp.SUM)
                    module.scale.data /= dist.get_world_size()
                elif module.quant.scale_init == "scaled_max":
                    dist.all_reduce(module.scale.data, op=dist.ReduceOp.MAX)
                else:
                    assert False, "unreachable"


# ruff: noqa: F722
