# Time the training data loader alone (no model): seconds per batch of
# 8 micro batches x 2**17 tokens, and the raw priors read inside it.
# Run from /workspace/train: uv run python /workspace/scripts/bench_loader.py
import time

import numpy as np
import torch

from pysrc.data import CollatedArticlesDataLoader

data = CollatedArticlesDataLoader(
    tokens_filename="data/ppmd-bytes.uint8",
    priors_filename="data/ppmd-probs.float16",
    article_boundaries_filename="data/article-boundaries.int32",
    cmix_bits_filename="data/cmix-bits.float16",
    mmap=True,
    epochs=1,
    micro_batch_tokens=2**17,
    gradient_accumulation_steps=8,
    max_article_tokens=2**17,
    max_merge_tokens=None,
    device=torch.device("cuda"),
    rank=0,
    world_size=1,
)
it = data._iter_no_prefetch()
for i in range(4):
    t = time.time()
    next(it)
    torch.cuda.synchronize()
    print(f"batch {i}: {time.time() - t:.2f} s", flush=True)

# raw read of the same amount of priors in article-sized random slices
priors = data._priors
starts = data._article_starts
rng = np.random.default_rng(1)
t = time.time()
n = 0
for a in rng.permutation(len(starts) - 1)[:4000]:
    s, e = int(starts[a]), int(starts[a + 1])
    n += np.array(priors[s:e]).nbytes
print(f"raw random article reads: {n / 1e6:.0f} MB in {time.time() - t:.2f} s")
