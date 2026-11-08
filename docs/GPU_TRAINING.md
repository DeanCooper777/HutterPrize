# Retraining the transformer on rented GPUs

Researched 2026-11-05. Prices change weekly, so re-check them before renting.

## What upstream did (fx2-cmix-T)

* Training code is in the repo: `training_recipes/train_6m.py` → `quantize.py` → `cooldown.py`,
  run with `uv run torchrun --nproc_per_node $N_GPUS -m training_recipes.<step>` (PyTorch DDP +
  `torch.compile`, deps pinned in `uv.lock`).
* Model: 12 layers, d_model 192, Kimi linear attention + sliding-window attention, ~6M params,
  205-byte vocabulary. Optimizer: Muon (lr 5e-4, wd 0.1) + AdamW. 320 epochs over enwik9, with
  cosine warmup and decay.
* Hardware: **8× RTX 5090 for 26 h ≈ 208 GPU-hours** (writeup.md). If you have fewer GPUs, scale
  the batch down and gradient accumulation up by 8/N. The result is then identical, just slower.
* Training data (`make_training_data.sh`): runs the compressor in `--ppmd-only` mode over the
  full enwik9. It writes the token stream, the PPMD prior for every token (float16 × 205), and the
  article boundaries. That is **~300 GB** and takes a long CPU run. **It must be generated with the
  same build that will be submitted**, because the transformer learns on the exact PPMD outputs and
  token stream it will see at compression time. (Our Windows build's phda9 output differs; see
  the README.)

## Prices per GPU-hour (on-demand, early Nov 2026)

| GPU | RunPod Community / Secure | Lambda | Market range |
|---|---|---|---|
| RTX 5090 | $0.69 / $1.19 | — | $0.50–1.25 (spot from ~$0.25) |
| RTX 4090 | $0.34 / $0.89 | — | — |
| A100 80GB | $1.39 / $1.79 | $3.19 | — |
| H100 SXM | $2.69 / $3.99 | $4.59–4.89 | from ~$1.93 (Vast.ai) |
| B200 | $5.98 / $7.99 | $7.69–7.99 | $2.12–6.42 |

Sources: runpod.io/pricing, lambda.com/pricing (new prices from 2026-11-16), amcompute.com and
spheron.network aggregators. Vast.ai's live grid didn't render; its interruptible instances are
listed as "50%+ cheaper".

## Cost estimates

| scenario | cost |
|---|---|
| Reproduce upstream (8× 5090 × 26 h) on RunPod Community | **~$145** |
| Same on RunPod Secure | ~$250 |
| Same on spot/marketplace 5090s ($0.25–0.50) | ~$50–105, with interruption risk |
| H100 instead (guess: 1 H100 ≈ 1.5–2.5× a 5090 for this small model) | ~$230–375 |
| Research budget: ~5 full runs + small ablations | **~$750–1,500** |
| Persistent volume, 300 GB data + checkpoints | ~$30–60/month |

A bigger model costs roughly linearly more GPU time. More importantly, it costs **CPU time at
compression**, and that is the real constraint. The transformer already uses ~55–59% of the ~50 h
budget, so a larger model needs a matching speed-up elsewhere (see "Performance work" in the
README).

## Practical plan

1. **Account.** RunPod (or Vast.ai) with prepaid credits. No quota requests are needed, unlike
   AWS/GCP/Azure, where H100 quota is often refused for new accounts.
2. **Data.** Build the Linux compressor on a cheap CPU box (or here under WSL2). Run
   `make_training_data.sh` once and keep the 300 GB on a **network volume** so every GPU pod
   mounts it without regenerating it. Download enwik9 on the pod
   (`wget http://mattmahoney.net/dc/enwik9.zip`) rather than uploading it.
3. **Smoke test.** Rent one 5090 for an hour with a PyTorch template (CUDA ≥ 12.8 for Blackwell).
   Run `uv sync` and train a few hundred steps with the 1-GPU batch settings. Measure tokens/s and
   extrapolate the full run. Do the same for one H100 to choose the cheaper GPU per token.
4. **Full run.** 8× 5090 on-demand (~$145), checkpointing to the network volume every ~30 min.
   Before using spot instances, check that the recipes can resume: optimizer state and
   data-loader position.
5. **Evaluate on CPU.** Use `--load-transformer-probs` / `--transformer` on enwik6/enwik7 here.
   Then run the full enwik9 run with `-e` before considering a submission.

Egress is negligible: the result is a ~3 MB weights file.
