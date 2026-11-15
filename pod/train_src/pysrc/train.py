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


import math as math
from pysrc.entpen import penalty_per_token, weight_pairs, coded_nats
_ENT_LAM = float(os.environ.get("A_ENT_LAMBDA", "0"))
_ent_step = [0]
if _ENT_LAM > 0: print(f"A_ENT_LAMBDA {_ENT_LAM}: entropy penalty on", flush=True)


_GROW_OLD = int(os.environ.get("A_GROW_OLD", "0"))
_GROW_MULT = float(os.environ.get("A_GROW_LR_MULT", "1"))
_grow_step = [0]
_grow_cache = []
print(f"A_GROW_OLD {_GROW_OLD} A_GROW_LR_MULT {_GROW_MULT}", flush=True)


def _grow_params(m):
    if not _GROW_OLD or _GROW_MULT == 1:
        return []
    if not _grow_cache:
        P = dict(m.named_parameters())
        for k, t in P.items():
            if k.endswith("mlp.up.weight") or k.endswith("mlp.up.quantize_weight.scale"):
                _grow_cache.append((t, (slice(_GROW_OLD, None),)))
            elif k.endswith("mlp.down.weight"):
                _grow_cache.append((t, (slice(None), slice(_GROW_OLD, None))))
        assert len(_grow_cache) == 36, len(_grow_cache)
        print("GROW boosting", len(_grow_cache), "tensors", flush=True)
    return _grow_cache


def _grow_log(m, step):
    with torch.no_grad():
        P = dict(m.named_parameters()); nz = tot = 0; rn = ro = 0.0
        for k, t in P.items():
            if k.endswith("mlp.down.weight"):
                s = P[k.replace(".weight", ".quantize_weight.scale")].float()
                q = (t.float() / s[:, None]).round().clamp(-7, 7)
                qn = q[:, _GROW_OLD:]; nz += int((qn != 0).sum()); tot += qn.numel()
                rn += float(t[:, _GROW_OLD:].float().abs().mean()); ro += float(t[:, :_GROW_OLD].float().abs().mean())
        print(f"GROW step {step} new-down nonzero ints {nz}/{tot} ({nz / max(tot, 1):.1%}) mean|w| new {rn / 12:.3g} old {ro / 12:.3g}", flush=True)


def train(
    raw_model: Transformer,
    model: DDP | Transformer,
    data: CollatedArticlesDataLoader,
    cfg: TrainingConfig,
) -> CmixMixtureLoss | None:
    """returns the trained stand-in mixer when cfg.mixture_loss is set"""
    model.train()
    optimizers = make_optimizers(raw_model, cfg.optimizer_config)

    mixture: CmixMixtureLoss | None = None
    mixer_optimizer: torch.optim.AdamW | None = None
    if cfg.mixture_loss is not None:
        assert data.cmix_bits_filename is not None, (
            "the mixture loss needs the data loader's cmix_bits_filename"
        )
        mixture = CmixMixtureLoss(cfg.mixture_loss).to(data.device)
        if os.environ.get("A_MIXER_INIT"):
            mixture.load_state_dict(torch.load(os.environ["A_MIXER_INIT"], map_location=data.device))
            print("A_MIXER_INIT: loaded", os.environ["A_MIXER_INIT"], flush=True)
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
            total_step_loss += loss.detach()
            total_step_unmasked_tokens += micro_batch.loss_mask.long().sum()
            if _ENT_LAM > 0 and mixture is not None:
                _pen = penalty_per_token(raw_model, _ENT_LAM)
                loss = loss + (1 - mixture.cfg.cross_entropy_weight) * micro_batch.loss_mask.sum() * _pen
            loss = loss / data.gradient_accumulation_steps
            total_step_tokens += micro_batch.input_tokens.numel()
            loss.backward()

        _ent_step[0] += 1
        if _ENT_LAM > 0 and (_ent_step[0] % 50 == 1 or batch.is_last):
            with torch.no_grad():
                _pp = weight_pairs(raw_model)
                print(f"ENT step {_ent_step[0]} soft {float(coded_nats(_pp)) / 8 / math.log(2):,.0f} B hard {float(coded_nats(_pp, hard=True)) / 8 / math.log(2):,.0f} B (per copy, KT)", flush=True)
        _gp = _grow_params(raw_model)
        _gb = [t.detach().clone() for t, _ in _gp]
        optimizers.step()
        with torch.no_grad():
            for (t, sl), b in zip(_gp, _gb):
                t[sl] += (_GROW_MULT - 1) * (t[sl] - b[sl])
        _grow_step[0] += 1
        if _GROW_OLD and (_grow_step[0] % 50 == 1 or batch.is_last):
            _grow_log(raw_model, _grow_step[0])
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
            if os.environ.get("A_KEEP_EPOCHS"):
                torch.save(raw_model.state_dict(), f"{checkpoint_prefix}.e{int(batch.epoch)}.tch")
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
