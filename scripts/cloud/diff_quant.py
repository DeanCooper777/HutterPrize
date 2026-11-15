# diff_quant.py: debugging aid for the fused fake quantization
# (fx2-cmix-T/pysrc/quantization.py). Runs one real training micro batch and compares, call by
# call, the fused implementation with the eager reference of the previous winner. This is how
# the rounding difference described at _COMPILE_OPTIONS in quantization.py was located.
# Output: a report on stdout.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Find Quantize calls where the fused and eager fake quantization disagree
# inside run A's real model on a real micro batch (forward and backward).
# Run from /workspace/opt:
#   PYTHONPATH=. A_EPOCHS=1 torchrun --nproc_per_node 1 /workspace/scripts/diff_quant.py
import torch

import pysrc.quantization as quantization
import training_recipes.train_A_finetune as recipe
from pysrc.cmix_loss import CmixMixtureLoss

reports: list[str] = []


def compare_apply(blocks, flat_scale, quant, return_ints):
    eager = quantization.QuantizeFunction.apply(blocks, flat_scale, quant, return_ints)
    fused = quantization.FusedQuantizeFunction.apply(
        blocks.detach(), flat_scale.detach(), quant, return_ints
    )
    if not torch.equal(eager.detach(), fused):
        diff = (eager.detach().float() - fused.float()).abs()
        reports.append(
            f"forward MISMATCH shape {tuple(blocks.shape)} {blocks.dtype} "
            f"stride {blocks.stride()} contiguous {blocks.is_contiguous()} "
            f"buckets {quant.buckets} ints {return_ints}: {int((diff > 0).sum())} "
            f"elements differ, max {diff.max().item():.3e}"
        )
    elif len(reports) < 400:
        reports.append(
            f"ok shape {tuple(blocks.shape)} {blocks.dtype} contiguous "
            f"{blocks.is_contiguous()} buckets {quant.buckets} ints {return_ints}"
        )
    return eager


class Spy:
    @staticmethod
    def apply(blocks, flat_scale, quant, return_ints):
        return compare_apply(blocks, flat_scale, quant, return_ints)


# Replacement for the recipe's train(): routes every Quantize call through a comparison of
# the two implementations, runs one forward pass and exits.
def diff_train(raw_model, model, data, cfg):
    quantization.QuantizeFunction_orig = quantization.QuantizeFunction
    batch = next(iter(data))
    mb = batch.micro_batches[0]
    # route every Quantize call through the comparison
    quantization.FUSED_QUANT = False
    real = quantization.QuantizeFunction

    class Router(real):  # type: ignore[misc,valid-type]
        @staticmethod
        def apply(blocks, flat_scale, quant, return_ints):  # type: ignore[override]
            return compare_apply(blocks, flat_scale, quant, return_ints)

    quantization.QuantizeFunction = Router  # used by Quantize.forward
    quantization.QuantizeFunction.apply  # noqa: B018
    # compare_apply must call the real eager function, not the router
    globals()["quantization"].QuantizeFunction_real = real

    def compare(blocks, flat_scale, quant, return_ints):
        eager = real.apply(blocks, flat_scale, quant, return_ints)
        fused = quantization.FusedQuantizeFunction.apply(
            blocks.detach(), flat_scale.detach(), quant, return_ints
        )
        key = (tuple(blocks.shape), str(blocks.dtype), blocks.is_contiguous(), quant.buckets, return_ints)
        if not torch.equal(eager.detach(), fused):
            diff = (eager.detach().float() - fused.float()).abs()
            reports.append(f"MISMATCH {key} stride {blocks.stride()}: "
                           f"{int((diff > 0).sum())} differ, max {diff.max().item():.3e}")
        else:
            reports.append(f"ok {key}")
        return eager

    Router.apply = staticmethod(compare)  # type: ignore[method-assign]
    model.train()
    logits = model(
        input_tokens=mb.input_tokens, priors=mb.priors, loss_mask=mb.loss_mask,
        output_tokens=mb.output_tokens,
        cumulative_sequence_lengths=mb.cumulative_sequence_lengths,
        return_logits=True,
    )
    seen = set()
    for r in reports:
        if r not in seen:
            print(r, flush=True)
            seen.add(r)
    print(f"{len(reports)} Quantize calls, "
          f"{sum(r.startswith('MISMATCH') for r in reports)} mismatched", flush=True)
    raise SystemExit(0)


recipe.train = diff_train
recipe.main()
