# List every GPU->host synchronization in one run A training micro batch
# (forward + mixture loss + backward), grouped by the calling code.
# Run from /workspace/opt:
#   PYTHONPATH=. A_EPOCHS=1 torchrun --nproc_per_node 1 /workspace/scripts/find_syncs.py
import collections
import traceback
import warnings

import torch

import training_recipes.train_A_finetune as recipe
from pysrc.cmix_loss import CmixMixtureLoss

sites: collections.Counter = collections.Counter()


def on_warning(message, category, filename, lineno, file=None, line=None):
    if "synchroniz" not in str(message):
        return
    frames = [
        f for f in traceback.extract_stack()[:-1]
        if "/warnings.py" not in f.filename and "find_syncs.py" not in f.filename
    ]
    # the innermost few frames from site-packages / pysrc identify the site
    key = " <- ".join(
        f"{f.filename.split('site-packages/')[-1].split('/workspace/')[-1]}:{f.lineno} {f.name}"
        for f in reversed(frames[-4:])
    )
    sites[key] += 1


def sync_train(raw_model, model, data, cfg):
    mixture = CmixMixtureLoss(cfg.mixture_loss).to(data.device)
    batch = next(iter(data))
    mbs = batch.micro_batches[:2]

    def step(mb):
        logits = model(
            input_tokens=mb.input_tokens, priors=mb.priors, loss_mask=mb.loss_mask,
            output_tokens=mb.output_tokens,
            cumulative_sequence_lengths=mb.cumulative_sequence_lengths,
            return_logits=True,
        )
        mixture(logits, mb.output_tokens, mb.cmix_bit_logits, mb.loss_mask).backward()

    model.train()
    step(mbs[0])  # warm up (compiles)
    torch.cuda.synchronize()
    warnings.showwarning = on_warning
    warnings.simplefilter("always")
    torch.cuda.set_sync_debug_mode("warn")
    step(mbs[1])
    torch.cuda.set_sync_debug_mode(0)
    print(f"{sum(sites.values())} synchronizations in one micro batch:")
    for key, n in sites.most_common():
        print(f"{n:4d}  {key}")
    raise SystemExit(0)


recipe.train = sync_train
recipe.main()
