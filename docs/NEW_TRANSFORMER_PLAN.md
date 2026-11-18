# Plan: a new transformer trained to work with cmix

Written 2026-11-06. It builds on `docs/GPU_TRAINING.md`, which covers prices and the upstream recipe.

## 1. Why the transformer is the lever

- **The target.** A claim needs at least 1% on the record (100,424,672 bytes), about **1.0 MB**.
  Our current best measures −0.24% on enwik7, and I project −0.3% to −0.45% on enwik9. That
  comes from online adaptation plus tuning (see `README.md` and the experiment notes). We also
  don't know yet how our Windows build compares to the record; the enwik9 run will tell us.
- **The weights count twice.** The int4 weights (5.87M at 3.79 bits) take **2.78 MB, appended to
  both** the compressor and the archive.
  - Every 1M parameters costs about **0.95 MB, i.e. ≈0.95% of the total**.
  - So shrinking the model is itself a big lever: a ~4.1M model saves ~1.7 MB (≈1.7%). The question
    is how much archive size it gives back.
  - A bigger model has to earn ~1% of the archive per extra 1M parameters, and it also costs CPU
    time. We're near the 50 h limit, so that is hard.
- **The transformer is trained without knowing cmix exists.** It minimizes its own cross-entropy.
  At compression time cmix mixes it with ~460 other inputs that already predict much of what it
  predicts.
  - Measured: making the transformer 4.5% better through online adaptation made cmix only 0.24%
    better, because the overlap is that large.
  - So capacity spent re-learning what PPMD, fxcm, the match models and so on already know is
    wasted, and those parameters are paid for twice.

## 2. The idea: train the transformer on what cmix gets wrong

cmix codes bits. For each token, the arithmetic coder sees eight binary decisions along the path
of the actual byte. Training would go like this:

1. **Dump cmix's own bit predictions without the transformer** (and without the LSTM) on the
   full enwik9 stream: the final probability for each of the 8 bits along the actual path. That
   is 8 × float16 per token, ≈9.5 GB for our 593M tokens.
2. **Train with a "mixture" loss instead of plain cross-entropy:**
   - Convert the transformer's 205-way distribution into the same 8 bit probabilities, the way
     cmix's `ByteModel::Predict` does: subtree sums over the 256-leaf tree, with zero outside the
     vocabulary.
   - Mix each bit with cmix's prediction through a small learned logistic mixer, a stand-in for
     cmix's mixer: `p = σ(w_c·st(p_cmix) + w_t·st(p_tf) + b)`. The weights are selected by bit
     position × cmix-confidence bucket, and the mixer is trained jointly with the model.
   - The loss is the binary cross-entropy of the mixed prediction, summed over the 8 bits.
   - Gradients reach the transformer only where it can improve on cmix. Where cmix is already
     confident and right, the gradient is near zero.
3. Optionally keep a small weight on the plain cross-entropy loss, so the model stays a sensible
   predictor where the stand-in mixer is a poor model of cmix's real mixer.

Expected effect: at a given size, a lower *total* (archive, not transformer loss). Equivalently,
the same total with a smaller model, which also runs faster and frees time for online adaptation.
How large the effect is can only be measured, so the plan starts with a cheap fine-tune that
answers that before any full run.

The training code already has a related hook, `prior_logit_mixing` in `pysrc/model.py`. It mixes
the transformer's logits with PPMD's log-probabilities under a learned per-token weight. That is
the same idea one level down. Upstream trained with it off; it could be a cheap extra ablation.

### Measured on enwik6 (2026-11-06)

The dump option exists now (`--no-transformer --save-cmix-bits`). On enwik6, in compressed
bytes:

| | bytes |
|---|---|
| cmix without the transformer (and without the LSTM) | 176,346 implied by the dump; 176,384 actual |
| the transformer alone, converted to bit predictions | 139,967 |
| **real cmix with the transformer** | **131,548** |
| stand-in: static logistic mix of the two, weights per bit position | 135,040 |
| stand-in: weights per bit position × cmix-confidence bucket (64 contexts) | **133,656** |

- **The transformer is by far the strongest model.** The other ~460 inputs together improve on
  it by only 6%. That is why online adaptation, which mostly re-learns local statistics cmix
  already has, converts so poorly.
- **The stand-in is close.** A 2-input mixer with 64 weight sets lands within 1.6% of the real
  cmix. That's good enough to train against, and it gives a cheap evaluation: a new
  transformer's distributions, dumped with `--transformer-only --save-transformer-probs`
  (minutes), plus the fixed cmix bit dump give its approximate cmix result without a full cmix
  run.

## 3. Variants (GPU runs)

| run | what | why | GPU cost (RTX 5090 community ≈ $0.69/h) |
|---|---|---|---|
| **A** | Fine-tune the existing 6M int4 model (`models/6m-q4-fp32.tch`) with the mixture loss on *our* token stream: ~16–32 epochs, with quantization-aware training throughout | Cheapest direct measurement of the effect. If it helps, it ships as is: same size, same speed. It also fixes the train/inference stream mismatch (our Windows phda9 output differs). | ~8–20 GPU-h ≈ **$10–20** |
| **B** | **~4.1M model** trained from scratch with the mixture loss: `d_mlp` 768 → 384 (the MLPs are 3.54M of the 5.87M parameters) | Tests "smaller but cmix-aware". It saves 1.77M parameters, ≈**1.7 MB** across the two copies (≈1.7% of the total), and halves the MLP matmul time. | ~140–160 GPU-h ≈ **$100–110** |
| **C** | **6M from scratch** with the mixture loss, full upstream schedule (320 + 256 + 16 epochs) | Shows whether training from scratch beats fine-tuning (A). It is the best same-size candidate. | ~210 GPU-h ≈ **$145** |

The order matters: **run A first (one evening, ~$20)**. If A shows nothing on enwik7/enwik8, the
mixture loss isn't worth B and C, and the fallback is a different B: plain 6M retrained on our own
token stream (the mismatch fix alone). If A helps, start B and C in parallel on two 8-GPU pods.
They're independent, about a day each.

Possible fourth variant, if B shows a small model loses little: ~8M parameters at **int3**
(−3…3, ≈2.8 bits). That's the same weight bytes as 6M int4, with more capacity but ~30% more
transformer CPU time. Upstream's note says lower precision "increased the loss too much", but they
measured transformer loss alone, not the cmix total.

Shapes: the C++ inference hard-codes `D=192`, `NL=12`, `DMLP=768` and the Kimi/attention layer
pattern (`cpp_infer/src/opt/model_opt.cpp`). Changing `d_mlp` is the smallest inference change:
the matmul kernels take `rows_padded`, `d_out ≤ 768`. Changing the depth or width means more
kernel work, which is why B shrinks `d_mlp`.

## 4. Preparation (status 2026-11-06)

Done locally:

1. **Token stream from our build.**
   - `runs/tokens9b/tokens.uint8`: 593,343,776 tokens (sha256 `7758…af96`).
   - `article-boundaries.int32`: 243,428 boundaries.
   - Both come from the final contest binary, and the stream is identical to the one from the
     earlier build.
   - `stream.bin` is the byte stream rebuilt from the tokens. Byte 18 is the only official
     vocabulary byte that never occurs.
2. **New compressor options** (training data only; normal compression is unchanged):
   - `--no-transformer`: cmix with a neutral input in the transformer's slot, and no LSTM.
   - `--save-cmix-bits`: fp16 logit of every coded bit.
   - `--official-vocab`: the 205-column layout even without the transformer, on any platform.
   - `--raw-stream` (`-n` only): code the input verbatim, without `-n`'s block headers. This
     replays exactly the stream the `-e` pipeline codes. Verified on Windows: the PPMD token
     stream echoed back is identical, and the priors are compared in `runs/eqtest`.
3. **Training code.**
   - `pysrc/cmix_loss.py` holds the mixture loss.
   - `data.py` gains an optional `cmix_bits_filename`.
   - `model.py` gains `forward(..., return_logits=True)`.
   - `train.py` gains `TrainingConfig.mixture_loss`. The mixer has its own AdamW and is averaged
     across GPUs by hand; it is never exported.
   - Recipes: `training_recipes/train_A_finetune.py` and `cooldown_A.py`, with 2^17-token
     micro-batches and accumulation 8/n_gpus (the same effective batch as upstream).
   - `export_weights` takes `EXPORT_MODEL` and `EXPORT_OUTPUT`.
   - Tested on CPU against the enwik6 dumps:
     - the bit conversion matches numpy to 6e-4 in logit;
     - fixed weights reproduce the known costs (139,965 and 176,345 bytes);
     - a trained mixer reaches 133,665;
     - loader alignment is checked on all 600,734 positions.
   - The full model needs CUDA (flash-linear-attention), so it is first exercised in the GPU smoke
     test.
4. **Stand-in validated** on enwik6 (section 2).

Cloud scripts (`scripts/cloud/`):

- `prepare_upload.sh` (local) builds `runs/upload/`. It contains:
  - sources and the gzipped stream;
  - hashes and boundaries;
  - Windows reference outputs for the first 4 MB of the stream.
- `datagen.sh` (Linux CPU machine): `build` (clang 22, like the Windows build), then `check`, then
  two jobs in parallel:
  - `ppmd`: priors for the whole stream, about 1 h on this laptop;
  - `bits [K]`: cmix bits in K parallel chunks, each with a 4M-token warm-up, about 32 h ÷ K.
  - `check` compares the Linux output with the Windows reference. PPMD has to match exactly; the
    cmix bits may differ slightly, since they are only a training target.
- `pack_train.sh` and `train_A.sh` (GPU machine): `setup` (uv sync), `smoke` (15 min), `run
  [n_gpus]` (fine-tune, cooldown, export to `.tfwc2`).

Still to do: evaluate the result on enwik7/enwik8 here. Use `--transformer` with the new
`.tfwc2` and full cmix, and the fast stand-in score.

## 5. Budget and timeline

| item | cost |
|---|---|
| Smoke test (1× 5090, 1 h, plus 1× H100, 1 h, to choose the cheaper GPU per token) | ~$5 |
| A fine-tune | ~$10–20 |
| B + C full runs | ~$250 |
| Network volume for data and checkpoints (~1 month) | ~$30–60 |
| Contingency for a repeat or a fourth variant | ~$150 |
| **Total** | **~$450–500** |

Rough timeline:
- **Days 0–2:** local prep (items 2–5).
- **Day 2–3:** data generation and upload, smoke test, run A.
- **Day 3–4:** evaluate A on enwik7/enwik8; decide on B and C.
- **Days 4–6:** B and C training.
- **Days 6–8:** evaluation, then the enwik9 run of the winner.

## 6. Risks

- **Stand-in mixer ≠ cmix's mixer.** If the learned 2-input mixer is a poor model of the
  ~460-input, two-layer cmix mixer, the transformer optimizes the wrong thing. Prep item 4 and run
  A are there to catch this cheaply.
- **cmix drift.** The bit dump reflects cmix as it is at dump time. Later changes to cmix models
  slightly weaken the match. Small changes like tuning should be fine.
- **Time limit.** B is faster; C is the same speed as today. Any variant has to be timed on
  enwik8 before an enwik9 run. Our enwik9 timing on this laptop is itself an estimate of the
  contest machine (i7-1165G7).
- **Spot or preemptible GPUs** need checkpoint and resume in the recipes. Verify that in the
  smoke test before relying on cheap spot pricing.

## 7. Results so far and the variation plan (2026-11-08)

### Run A results

- **GPU speedups.** With the faster training code (fused fake quantization, sync fixes, no
  gradient checkpointing in the bf16 phase), one RTX 5090 at $1.19/h does a short run (3+1
  epochs) in about 2 h and the full run (24+4) in about 11 h (~$13).

| weights | enwik6 | enwik7 |
|---|---|---|
| current (`6m-q4-fp32`) | 131,548 | 1,301,960 |
| run A short (3+1 epochs, `Aopt`) | 130,644 (−0.69%) | 1,294,411 (−0.58%) |
| run A full (24+4 epochs, `Afull`) | 130,353 (−0.91%) | 1,291,842 (−0.78%) |

- **First real enwik9 run** (current weights, this laptop): 37.5 h to compress. `archive9.exe`
  is 97,816,169 bytes, −2.60% vs 100,424,672. Decompression is still being verified.
- **Split estimate of enwik9** (`scripts/cloud/split_eval.sh`):
  - It codes the 593 MB stream in 16 chunks with a 4M-token warm-up each, on a 32-vCPU CPU pod.
    That takes about 2.5 h and $4.50 per weight set.
  - Chunked totals are larger than one continuous run, so only the difference between weight
    sets is used, added to a real run's size.
  - The current-weights chunks are run once and reused as the reference.

### Variation plan

Evaluation for every variant:

1. Train on a 5090; the pod stops itself.
2. Run enwik6 and enwik7 locally.
3. Run the split enwik9 estimate.
4. Only the final winner gets a real single-core enwik9 run plus a timing check.

**Phase 1: recipe checks.** Each is a short run (3+1 epochs, from `6m-q4.tch`), compared with
`Aopt`. A winner goes to a full run.

| # | change | note |
|---|---|---|
| 1a | `A_MIXER=rich`: 512 stand-in contexts (bit position × cmix confidence × transformer confidence × agreement) | On enwik6 a static fit reaches 133,098 bytes vs 133,656 for the 64 contexts (real cmix 131,548). |
| 1b | `A_CE_WEIGHT` 0.3 and 0 (run A used 0.1) | |
| 1c | peak learning rate ×1.5, ×2 | not started |
| 1d | penalty on the weights' compressed size | Trained weights compress about 11 KB worse, and they are stored twice. |

**Phase 2: model size, the main bet.** Every 1M parameters costs about 0.95% of the total, and
the MLPs hold 3.54M of the 5.87M.

| # | change | expected |
|---|---|---|
| 2a | MLP width 768 → 384, made by keeping the most useful half of each MLP's units in run A's weights, then a full mixture fine-tune | About −1.7% from weight bytes, minus lost prediction, and about 20–25% less transformer time. C++: `DMLP` becomes a build constant. |
| 2b | width 512 | middle point |
| 2c | 3-bit MLP weights at width 768 | about −0.9%; needs a new kernel |

**Also running:** an extension of run A. It continues from the end of the full fine-tune
(`/workspace/full/models/6m-q4-A.tch`) for 24 more epochs plus a 4-epoch cooldown, to see whether
the gain from longer training keeps going.

**Phase 3 is on hold** (training from scratch, B/C at ~$60–215 each) until phase 2 shows whether
fine-tuning plateaus.

### Results, phase 1 and phase 2 (2026-11-08)

Split enwik9 estimate for Afull: 553,370 bytes smaller than the current weights, so the entry
would be about 97,262,799 bytes (−3.15% vs the record, unverified).

| weights (all from run A's weights) | weight file | enwik6 | enwik7 |
|---|---|---|---|
| Aopt (3+1 epochs, CE weight 0.1) | 2.94 MB | 130,644 | 1,294,411 |
| 1a: richer mixer contexts (3+1) | 2.94 MB | 130,374 | 1,292,302 |
| 1b: CE weight 0.3 (3+1) | 2.94 MB | 130,500 | 1,293,570 |
| 1b: CE weight 0 (3+1) | 2.94 MB | 130,638 | 1,293,922 |
| Afull (24+4) | 2,941,833 | 130,353 | 1,291,842 |
| 2a: width 384, pruned, no fine-tune | 2,088,507 | 176,861 | |
| 2a: width 384, pruned + 3+1 epochs | 2,082,282 | 154,541 (+18.6%) | 1,500,669 (+16.2%) |
| 2b: width 512, pruned + 3+1 epochs | 2,367,087 | 143,716 (+10.3%) | 1,410,848 (+9.2%) |

- **Phase 1:** the richer mixer helps (about −0.2%); the CE weight barely matters (0.3 is used
  from now on).
- **Phase 2 by pruning fails.** Width 384 saves 1.72 MB (−1.7%) and width 512 saves 1.15 MB
  (−1.1%), but the archive grows 9–16%. The short fine-tune repairs only about half the damage.
- **The damage is real, not a bug.** Dropping only 32 of 768 units per layer (by
  |up|²·|down|) costs 11% on enwik6 (144,502 bytes; loss 1.31 → 1.59 nats/token). The width-736
  build and zeroing the same units in the 768 build give identical output, so the C++ (`-DFX2_DMLP`,
  `pysrc/prune_mlp.py`, `A_DMLP`) is correct.
- A smaller model would have to be trained from scratch (phase 3), not cut down from run A.

**Variant 2c (3-bit MLP weights, 7 levels, 3+1 epoch QAT fine-tune from Afull's start, 2026-11-08):** weights 2,464,278 B (−477,555 vs Afull, ≈ −0.95% of the entry since they count twice), but enwik6 132,953 (+2.0%) and enwik7 1,315,863 (+1.86% vs Afull 1,291,842). Scaled to enwik9 (×0.75) the archive grows ≈ +1.3 MB, more than the weight saving, so the entry gets ≈ 0.3% worse. Rejected.

**Extension run (Afull + 24 epochs incl. 4-epoch cooldown, 2026-11-08/09):** weights 2,947,485 B (+5,652 vs Afull). enwik6 130,364 (+11), enwik7 1,291,904 (+62): flat on the small sets. Split enwik9 (K=16, WARM 4 MB) total 96,750,703 vs Afull 96,780,392 (−29,689). Net entry change ≈ −29,689 + 2×5,652 = −18,385 → estimated entry ≈ 97,244,414 (−3.17% vs 100,424,672). Small but real gain; the extra epochs help only later in enwik9. Training longer from this start has nearly run out.

**Run B result (2026-11-09).** Phase 3 model trained from scratch (d_mlp 384, mixture loss, 128 + 24 QAT + 4 cooldown epochs on 4x RTX PRO 6000, ~11.6 h, ~$116). Weights 2,023,160 bytes (-907,492 vs current), but enwik6 137,117 (+5.2% vs ext 130,364) and enwik7 1,352,358 (+4.7% vs ext 1,291,904), far beyond the ~1.7% the weight saving can pay for. Rejected; checkpoints kept in cmix-T-dwc/models/runB/. Best remains the extension weights (-3.17% est.).
