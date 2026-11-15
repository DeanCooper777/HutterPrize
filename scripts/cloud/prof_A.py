# prof_A.py: profile one training step of the cmix-aware fine-tune (time per micro batch with
# the plain loss and with the mixture loss, then a profiler table). Also prints a numerical
# fingerprint (losses, gradient norm) used to confirm that speed changes such as FUSED_QUANT
# did not change the computation. Output on stdout.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Profile run A's training step: time per 2**17-token micro batch (forward +
# backward) with plain CE and with the mixture loss, then a torch.profiler
# table. Builds the model exactly like the recipe by replacing its train().
# Run from /workspace/train:
#   PYTHONPATH=. A_EPOCHS=1 uv run torchrun --nproc_per_node 1 /workspace/scripts/prof_A.py
import time

import torch
from torch.profiler import ProfilerActivity, profile

import importlib
import os

# PROF_RECIPE: the recipe module to profile (default the fine-tune)
recipe = importlib.import_module(os.environ.get("PROF_RECIPE", "training_recipes.train_A_finetune"))
from pysrc.cmix_loss import CmixMixtureLoss


def prof_train(raw_model, model, data, cfg):
    mixture = CmixMixtureLoss(cfg.mixture_loss).to(data.device)
    t = time.time()
    batch = next(iter(data))
    print(f"first batch: {time.time() - t:.2f} s", flush=True)
    micro_batches = batch.micro_batches[:3]

    def step(mb, use_mixture):
        kwargs = dict(
            input_tokens=mb.input_tokens,
            priors=mb.priors,
            loss_mask=mb.loss_mask,
            output_tokens=mb.output_tokens,
            cumulative_sequence_lengths=mb.cumulative_sequence_lengths,
        )
        if use_mixture:
            logits = model(**kwargs, return_logits=True)
            loss = mixture(logits, mb.output_tokens, mb.cmix_bit_logits, mb.loss_mask)
        else:
            loss = model(**kwargs)
        loss.backward()

    model.train()
    # numerical fingerprint (no optimizer step happens here, so runs with
    # different code paths, e.g. FUSED_QUANT=0/1, must agree closely)
    for use_mixture in (False, True):
        losses = []
        for mb in micro_batches:
            kwargs = dict(
                input_tokens=mb.input_tokens, priors=mb.priors,
                loss_mask=mb.loss_mask, output_tokens=mb.output_tokens,
                cumulative_sequence_lengths=mb.cumulative_sequence_lengths,
            )
            if use_mixture:
                logits = model(**kwargs, return_logits=True)
                loss = mixture(logits, mb.output_tokens, mb.cmix_bit_logits, mb.loss_mask)
            else:
                loss = model(**kwargs)
            loss.backward()
            losses.append(loss.item())
        grad_norm = torch.sqrt(sum((p.grad.double() ** 2).sum() for p in raw_model.parameters() if p.grad is not None)).item()
        print(f"fingerprint mixture={use_mixture}: losses {losses} grad norm {grad_norm:.9e}", flush=True)
        for p in raw_model.parameters():
            p.grad = None
    for use_mixture in (False, True):
        for mb in micro_batches:
            step(mb, use_mixture)
        torch.cuda.synchronize()
        t = time.time()
        for mb in micro_batches:
            step(mb, use_mixture)
        torch.cuda.synchronize()
        print(f"mixture={use_mixture}: {(time.time() - t) / 3:.3f} s per micro batch", flush=True)

    with profile(activities=[ProfilerActivity.CPU, ProfilerActivity.CUDA]) as p:
        for mb in micro_batches:
            step(mb, True)
        torch.cuda.synchronize()
    averages = p.key_averages()
    print(averages.table(sort_by="self_cpu_time_total", row_limit=25), flush=True)
    print(averages.table(sort_by="self_cuda_time_total", row_limit=25), flush=True)
    raise SystemExit(0)


recipe.train = prof_train
recipe.main()
