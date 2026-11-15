# Pod agent results (Nov 11–14)

## Tier 0 proxy (built 2026-11-11)

**What it is.** `tier0/tier0.py` runs the QAT PyTorch model (the train_A_finetune config) over a
fixed sample: 64 slices of about 512K tokens each, spread evenly over the whole enwik9 stream
(33.86M tokens, 5.7%; `/workspace/tier0/s64`). It converts each distribution into cmix's 8 bit
predictions and mixes them with the saved cmix bits (`cmix-bits.float16`, no transformer) through
a 2-input logistic stand-in mixer. The mixer is fitted on the sample by damped Newton, per
context. The total is scaled to the full stream.

**Cost and speed.** One 5090 needs about 45 s of forward pass plus about 1 min of fitting per
weight set, so about 2.5 min (~$0.05). The export check adds about 3 min.

**Export check.** For all 11 sets, the checkpoint exports byte-identically to the known `.tfwc2`.
That means the right weights were scored, under the right config (A_DMLP / A_MLP_BITS).

### Calibration (mix512 = 512 contexts: bit × cmix confidence × transformer confidence × agree)

Proxy differences are paired and summed over the 64 slices. The ± is 1 s.e. from the spread
between slices.

| weights | proxy (full-stream bytes) | proxy Δ | reference | ref Δ |
|---|---|---|---|---|
| base (upstream) | 97,478,919 | | split 97,333,762 | |
| Afull | 96,164,592 | −1,314,324 ±67,925 vs base | split 96,780,392 | −553,370 vs base |
| ext | 96,133,634 | −30,957 ±4,128 vs Afull | split 96,750,703 | −29,689 vs Afull |
| Aopt (3+1, CE 0.1) | 96,465,357 | | enwik7 1,294,411 | |
| v1a (rich mixer) | 96,458,492 | −6,859 ±3,855 vs Aopt | enwik7 1,292,302 | −2,109 (−0.16%) |
| v1b0 (CE 0) | 96,393,440 | −71,915 ±6,806 vs Aopt | enwik7 1,293,922 | −489 (−0.04%) |
| v1b3 (CE 0.3) | 96,634,499 | +169,143 ±10,131 vs Aopt | enwik7 1,293,570 | −841 (−0.06%) |
| p2c (3-bit MLP) | 97,934,679 | +1.80M (+1.87%) vs ext | enwik7 1,315,863 | +1.86% vs Afull |
| p2b (MLP 512) | 103,942,771 | +7.81M (+8.1%) vs ext | enwik7 1,410,848 | +9.2% |
| p2a (MLP 384) | 109,054,233 | +12.92M (+13.4%) vs ext | enwik7 1,500,669 | +16.2% |
| B (scratch, 384) | 99,619,538 | +3.49M (+3.6%) vs ext | enwik7 1,352,358 | +4.7% vs ext |

Other columns, same ranking everywhere. Transformer-alone CE (tf_only): base 99.10M, ext 99.26M.
cmix without the transformer: 121.68M.

**Reading.**
- **Ranking:** it matches the split eval on all three sets (ext < Afull < base).
- **Same-recipe differences are accurate:** ext vs Afull is −30,957 vs −29,689, and the noise is
  about ±4 KB.
- **Cross-recipe differences are biased:** it puts upstream→Afull at 2.4× the real gain. The
  stand-in mixer is the training objective of the A runs, so the proxy favours weights trained
  for it. The same bias explains CE weight 0 looking better and CE 0.3 looking worse in the proxy,
  while enwik7 shows tiny gains for both.
- **Richer contexts don't remove the bias:** partial-byte-node contexts (`refit.py`: node8,
  node_rich with 16K contexts) shrink the base gap only to −1.18M (still 2.0×).
- **Damaged variants (p2*, B):** the proxy's relative loss is 0.77–1.0× enwik7's. That is in line
  with the enwik7→enwik9 factor of ~0.75 used before, though no split eval exists for them.

**How to use it.** Compare variants trained with the same recipe as ext (A_MIXER=rich, CE weight
0.1, same start). Don't use it across recipes or against upstream. Confirm winners with a split
eval.

## Weight file: is better coding worth it? (CPU check, 2026-11-11)

- **The weight integers are nearly i.i.d.** Their order-0 entropy is 2,793,540 B. Per-tensor
  models give 2,789,713. Adding a row-spread, column-spread or previous-weight context saves at
  most ~10 KB per copy. Not worth a coder change.
- **Where the other ~155 KB of `.tfwc2` (2,947,485 B) goes:**
  - raw fp32 conv/norm "weight" tensors: 26,496 values (106 KB);
  - bf16 scales: 25.5K values (51 KB);
  - dt_bias: 7 KB.
- **Possible small gain:** storing the fp32 conv/norm tensors as bf16 might save ~40 KB per copy
  (~80 KB in S). It changes the model, though, so it would need a Tier 0 check and the C++ reader
  changed. Low priority.

## Per-group sensitivity of ext, no fine-tune (2026-11-11, `tier0/sens.py`)

Each variant changes one group of ext's weights; the scores are Tier 0 mix512 Δ vs ext
(96,133,608). The saving is the integer-entropy estimate ×2, since the weights are in both
binaries (`results/group_bytes.json`). The ratio is damage ÷ saving; below 1 would be a gain.
Full data: `/workspace/tier0/results/sens_ext.json`.

| best groups (3-bit, 7 levels) | damage | 2× saving | ratio |
|---|---|---|---|
| L10.attn | +434,030 | 53,868 | 8.1 |
| L11.mlp | +689,513 | 82,282 | 8.4 |
| L08.attn | +513,690 | 54,107 | 9.5 |
| L06.mlp | +799,227 | 82,671 | 9.7 |
| L02.mlp | +813,582 | 83,201 | 9.8 |

- **3-bit (7 levels), by group:**
  - other MLPs: ratio 10.9–12.9, except L00.mlp at 17.8;
  - other attention layers: 11–29;
  - embeddings: 88–237, so leave them alone.
- **5 levels on MLPs:** ratio 10.5–19.7. Every one is worse than 3-bit on the same layer.
- **3 levels on MLPs:** +2.7M to +6.0M per layer.
- **Removing a whole MLP layer:** ratio 20–89. Pruning is hopeless, as found before.
- **Later layers tolerate more** (L10/L11, L06, L08), and layer 0 tolerates least.
- **No group comes near break-even without a fine-tune.** The fine-tune has to recover about
  90% or more of the damage. For p2c, all 12 MLPs at 3-bit ended at +1.8M after QAT; the
  untrained single-layer damages add up to about 11.6M, so it recovered about 85%. At 85% the
  top-5 combination would still lose about +130 KB net, so the gain is marginal at best.
- **Test mp1:** QAT 3+1 epochs from ext with these 5 groups at 3-bit
  (`A_BITS_MAP=L10.attn=7,L11.mlp=7,L08.attn=7,L06.mlp=7,L02.mlp=7`), saving about 356 KB in S.
  It measures the real recovery. Unless the damage after QAT is below ~356 KB, mixed precision
  is dropped.

## mp1: QAT test of the five most tolerant groups at 3-bit (2026-11-11, REJECTED)

`A_BITS_MAP=L10.attn=7,L11.mlp=7,L08.attn=7,L06.mlp=7,L02.mlp=7`, 3+1 epochs from ext's QAT
checkpoint, A_MIXER=rich, CE 0.1. Ran on 5090 hwk98l1ed5jt9j, 20:40–22:50 UTC (~$2.6).

| | Tier 0 mix512 | Δ vs ext | weights `.tfwc2` |
|---|---|---|---|
| ext | 96,133,634 | | 2,947,485 |
| mp1 start (no training) | 99,468,897 | +3,335,263 | |
| mp1 after 3+1 epochs | 96,756,665 | **+623,031** | 2,769,694 (−177,791) |

- **Entry change:** +623,031 − 2×177,791 = **+267,449**, so about 0.27% worse. Rejected.
- **Recovery:** the fine-tune recovered 81% of the untrained damage. Breaking even would need
  about 89%.
- **The measured saving matches the estimate:** −177,791 B vs ~178 KB from the integer entropy.
- **Conclusion:** mixed precision from ext doesn't pay. The most tolerant groups lose about 1.75×
  what they save after QAT. Together with the earlier results (p2a/p2b pruning, p2c all-MLP
  3-bit, run B), every way of shrinking the 6M model has cost more archive than it saved weight
  bytes.
- **Not tried:** a long QAT (24+4 epochs, ~11 h, ~$13) might recover more than 81%. The ext
  extension shows long runs give little from this start, so I expect it to stay above break-even.

## Option (b), step 1: bf16-valued conv/norm tensors (2026-11-12) — PASSES

- **What changed:** the 28,281 non-rope fp32 tensors were rounded to bf16 values (RNE) and
  stored still as F32. The low 16 bits become zero, and the coder's adaptive byte-plane models
  code them almost for free. No C++ and no format change.
- **Weights:** `.tfwc2` 2,891,585 vs 2,947,485, **−55,900 per copy, −111,800 in S**. A true bf16
  dtype would save only 965 B more and needs a C++ change.
- **Tier 0:** 96,135,391 vs ext 96,133,678, i.e. **+1,713**, within noise (paired s.e. ~4 KB).
- **C++ (split build, `-n --raw-stream`, 1 MB of the stream):** ext 74,691 vs bf16 74,695,
  i.e. +4 B.
- **Decoding:** the Python tfwc2 verify is bit-exact.
  - A C++ decode round trip isn't possible on a small input with the transformer: raw-stream is
    compress-only, `-n` block headers add 0x00 bytes outside the vocabulary, and enwik6 `-c` has
    a 198-byte vocabulary.
  - Only weight values change, not code or format, so the risk is nil.
- **Net estimate: about −110 KB (−0.11%).**
- **To ship:** round these tensors in `export_weights` (or post-process the `.tfw`). That
  changes the submission files, so the user decides.
- Files are in `/workspace/bf16/`; the shippable candidate is `ext_f32zero.tfwc2`.

## ADDED STEP (more bits for sensitive groups), first attempt invalid

- **What went wrong:** the untrained scan re-rounded ext's fp32 latent weights at 31/255 levels.
  That came out 6.9 MB *worse* (ALL:255), and the early stop fired.
- **Cause:**
  - 3–6% of the QAT latents sit beyond the 4-bit clamp (up to 44× the scale), so re-fitting
    scales to their max is wrong.
  - Even clamped latents differ from the 4-bit weights the model was trained to use (rms 10% of
    the weight rms).
  - So no untrained re-rounding is an upper bound.
- **Same flaw elsewhere:** it also affected the 3-bit scan and mp1's start checkpoint (requant
  from unclamped latents). A clamped 3-bit rescan is queued.
- **Valid test, now queued:** QAT from an exact start (q31 = 2·q4, scale halved; the dry run
  checks that Tier 0 equals ext):
  - up1 = all groups at 31 levels (upper bound);
  - up2 = embeddings + L00 at 31 levels.
- **Byte cost:** estimated from integer entropy; the start has the same entropy as ext. The C++
  and the coder would need an int8 path for |q| > 7; that is only checked if a test pays off.

## Option (b), step 2: cmix re-tune on enwik9-like chunks

- **Test design:** `tune/tune_eval.sh`. Chunks k = 3, 7, 11, 15 of K=16 (split-eval positions),
  4M warm-up, 8 MiB scored each (33.5 MB in total), ext weights, paired against `ref`.
- **Determinism:** `ref` reproduces the split-eval bins exactly.
- **Cost:** about $1.2 per round of 4 settings.

| round 1 | Δ vs ref (bytes over 33.5 MB) | per chunk c3/c7/c11/c15 |
|---|---|---|
| decay_d3 0.03 | +1,035 | +277/+264/+308/+186 |
| decay_d3 0.08 | −450 | −83/−93/−165/−109 |
| decay_t3 100M | +2,957 (invalid: the scored region never reaches d3) | |

- **Round 2 (running):** decay_d3 0.12 and 0.2, input_eps 1e-4 and 2e-5.
- **Scale:** ×17.7 to the full stream, so −450 ≈ −8 KB. Small so far.

## N4: 16-bit activations, ext's 4-bit weights unchanged (Tier 0, no training, 2026-11-12)

- **Method:** each chosen 8-bit activation quantizer gets 65,536 levels and scale/256. The clamp
  range stays the same, and the division is exact in bf16.
- **Reference:** ref mix512 96,133,697. Results in `tier0/results/n4.json`.

| 16-bit group | Δ Tier 0 |
|---|---|
| ALL | **−125,434** |
| mlp_down_in (ReLU² output) | **−75,615** |
| attn_out_in (output projection input) | −28,835 |
| mlp_up_in | −10,164 |
| unemb_in | −2,655 |
| qkv_proj_in | −3,856 |
| gates_in | −3,552 |
| qkv_quant | −1,327 |
| prior_in | −935 |

- **Verdict: above the 100 KB bar.** The gain is concentrated in the MLP down input:
  mlp_down_in + attn_out_in give −104 KB of the −125 KB.
- **No weight bytes change.** QAT at 16-bit might add more.
- **Cost:** run time. These are the int8×int4 matmuls the int16 path would replace (12 MLP-down
  + 12 output projections). No C++ was written, per instructions; the time margin and the
  platform are the user's decisions.

## N1 pre-check: transformer gain by position within its piece (ext, Tier 0 sample)

| tokens since piece start | share | cmix-only bits/token | stand-in mixed | gain bits/token | relative gain |
|---|---|---|---|---|---|
| 0–31 | 1.3% | 0.913 | 0.792 | 0.122 | 13.3% |
| 32–63 | 1.3% | 0.676 | 0.529 | 0.148 | 21.9% |
| 64–127 | 2.4% | 0.773 | 0.555 | 0.218 | 28.2% |
| 128–255 | 3.6% | 1.385 | 1.043 | 0.342 | 24.7% |
| 256–511 | 6.5% | 1.564 | 1.193 | 0.371 | 23.7% |
| 512–1023 | 11.4% | 1.593 | 1.233 | 0.360 | 22.6% |
| 1024–4095 | 35.7% | 1.687 | 1.335 | 0.352 | 20.8% |
| 4096+ | 37.8% | 1.762 | 1.411 | 0.351 | 19.9% |

- **Relative gain:** only the first 32 tokens of a piece gain clearly less than late tokens
  (13% vs ~20%). From token 32 on, the relative gain is equal or higher.
- **Ceiling, relative measure:** if bucket 0–31 matched the late rate, the gain would be
  **≈ 60 KB on enwik9**. The script printed 285 KB because of a bug: it also counted the 4096+
  bucket against the late average.
- **Ceiling, bits-per-token measure:** ≈ 670 KB, but it is confounded. Early tokens are cheap XML
  and header text (cmix-only 0.7–0.9 vs 1.7 bits/token), so less absolute gain is expected there.
- **Verdict:** by the pre-check rule, the early buckets already gain as much as the late ones
  (relative), so the **N1 fine-tune is dropped**. Cross-article context might still help in
  ways this can't measure (similar neighbouring articles), but there's no sign of it here.

## Step 2: cmix re-tune — stopped (can't pay)

| setting | Δ vs ref over 33.5 MB | ×17.7 to the full stream |
|---|---|---|
| decay_d3 0.03 | +1,035 | +18 KB |
| decay_d3 0.08 | **−450** | **−8 KB** |
| decay_d3 0.12 | −182 | −3 KB |
| decay_d3 0.2 | +1,193 | +21 KB |
| input_eps 1e-4 | +191 | +3 KB |
| input_eps 2e-5 | −56 | −1 KB |

- **Best: decay_d3 0.08, about −8 KB (0.008%).** It is unconfirmed; a full split eval costs
  ~$4.5, which isn't worth it for this alone.
- **Verdict:** the step is stopped. The constants were already near optimal for enwik9-like data.
- **Spend:** 2 rounds, ~$2.4.

## ADDED STEP result: up1, all groups at 5-bit (31 levels), QAT 3+1 from an exact start (2026-11-12) — REJECTED

- **Exact start confirmed:** q31 = 2·q4 and the scale is halved. Tier 0 of the start was
  96,133,754 vs ext 96,133,678, with identical transformer CE.
- **Tier 0 after QAT:** 95,835,221, i.e. **−298,457** vs ext. Transformer-alone CE went from
  99.26M to 98.87M. Part of this is just 3+1 more epochs of training; there was no 4-bit control.
- **Weight-integer entropy** (per-tensor order-0): 3,233,961 vs 2,789,713, i.e. **+444,248 per
  copy, +888,496 in S**. QAT spreads the ints well beyond the even start values.
- **Net ≈ +590 KB (+0.59%) worse.** The upper bound gains only 0.34× its byte cost, below the
  user's 2× rule, so the **idea is dropped** and up2 (embeddings + L00 only) is not run.
- **Deploying it would also have needed an int8 weight path in C++ and in the coder.**

## Clamped 3-bit rescan (2026-11-12)

- **Change:** latents are now clamped to ±7·s before requantizing (`tier0/results/sens_ext_clamp.json`).
- **Effect:** untrained damage is 10–60% lower than the first scan. The biggest drops are
  prior_embedding (3.44M → 1.22M), L03.attn and L07.attn.
- **Best ratios** (damage ÷ 2× saving): L10.attn 7.3, L11.mlp 7.4, L08.attn 8.0, L06.mlp 8.2,
  L09.attn 8.5, L02.mlp 8.6. Before, they were 8.1–9.8.
- **mp1 started from a needlessly damaged point:** with clamping, the untrained top-5 damage is
  ~2.83M vs 3.25M.
- **Verdict unchanged:** at mp1's 81% recovery the residual is ~0.54M vs a 356 KB saving, still a
  loss of ~+180 KB. Not re-run.

## N2: is the article-order table worth its bytes? — YES, by far (2026-11-12)

- **Correction to the plan:** the order table (`comp_order`, 201,048 B) is only in comp9.
  archive9 holds the decompressor, dictionary, weights and cmix output, and the decoder restores
  the order by sorting on page id. So break-even was an archive growth of +201 KB.
- **Streams:** built with an experimental self-extracting `-e` binary (split-build cmix +
  recompressed dictionary + chosen order). The control reproduces the current stream exactly
  (apart from a 4-byte header format difference).
  - nat_b: non-redirect articles in natural order, redirects at the end as now; order file 396 B.
  - nat_a: fully natural; order file 12 B.
  - Both streams are ~480–489 KB shorter after preprocessing.
- **K=16 split eval, ext weights:** nat_b total 101,701,412 vs ext 96,750,703, i.e.
  **+4,950,709 (+5.1%)**. With the table saving, **+4.75 MB worse**.
  - Per-chunk differences swing between −5.1M and +4.5M because the content moves between chunks;
    only the total is meaningful.
  - ext was trained on the reordered stream, which overstates the loss a little, but nowhere near
    5 MB.
- **Verdict:** the reordering is worth ~25× its table. nat_a was stopped early (pointless). No
  cheaper middle route is worth pursuing; the table is a small price.

## Step 3: stand-in mixer search (2026-11-12) — no stand-in within 1.3×

Static and online stand-ins fitted on the Tier 0 sample (`tier0/standin.py`,
`results/standin.json`). Proxy Δ vs the split eval (base→Afull −553,370; Afull→ext −29,689):

| stand-in | base→Afull | ratio | Afull→ext | ratio |
|---|---|---|---|---|
| s512 (current) | −1,314,213 | 2.37× | −30,940 | 1.04× |
| s512 + PPMD bit input | −1,182,306 | 2.14× | −31,458 | 1.06× |
| partial-byte node × cmix-confidence + PPMD | −1,097,773 | **1.98×** | −29,328 | 0.99× |
| online SGD, lr 0.002 | −1,293,223 | 2.34× | −31,701 | 1.07× |
| online + PPMD, lr 0.002 | −1,161,580 | 2.10× | −30,943 | 1.04× |
| online lr 0.02 (too fast) | −3.8M / −8.2M | 6.9× / 14.8× | | |

- **Best: node contexts + PPMD input, at 1.98×.** All variants get Afull→ext right (0.99–1.07×)
  and all overstate base→Afull by about 2×.
- **No fitted stand-in reaches the 1.3× bar.** N3 (linearizing the real cmix) is the remaining
  candidate for step 3.

## Step 3 (cont.): N3, linearized real cmix: FAILS (2026-11-12)

The patched cmix dumps, per bit, the effective weight of the transformer input through the real
mixer chain (w_eff, with SSE/clamps/other inputs held fixed). Each of the 3 weight sets was run on
4 chunks (k=3,7,11,15 of K=16, 4M warm + 8 MiB scored). The "pred" columns swap one set's
transformer logit into another set's run with its w_eff (`agent/n3/n3_analyze.py`,
`n3/n3_validation.json`).

| over 33.5 MB | real Δ (bytes) | linearized prediction | ratio |
|---|---|---|---|
| base→Afull | −32,010 | −11,426 (from base run) | 0.36× |
| Afull→ext | −1,087 | −563 | 0.52× |
| base→ext | −33,098 | −11,989 from base; reversed from ext: −7,884 (wrong sign; should be +33,098) | 0.36× |

- The first-order prediction understates gains about 3×, and run backwards it gets the sign
  wrong. The transformer's effect works mostly through cmix *adapting* to it (mixer weights,
  SSE, and the other model inputs learning over time), which a frozen linearization can't see.
- **Step 3 verdict:** no stand-in within the 1.3× bar (fitted best 1.98× over; linearized
  0.36× under). Per the plan, **the retraining bet is not started.**

## Probes P1/P2 (2026-11-12; notes/probes-2026-11-12.md)

Gate stack without the probes: 100,028,258 − 111,800 (bf16) − 56,000 (weight coder) − 8,000
(decay_d3) − 61,544 (upx --lzma) = **99,790,914 (−0.63%)**. GO needs ≤ 99,575,000, so P1 plus P2
(scored against the control) must reach −215,914.
Code: `agent/pr/` (act16 hook, entropy penalty `entpen.py`, `run_pr.sh`, `pr_job.sh`). Each run:
3+1 epochs from ext's QAT checkpoint, ext's recipe; summaries in
`tier0/results/pr_*_summary.json`.

### P1 run 1 (16-bit act. on mlp_down_in + attn_out_in, scales trainable): INVALID, worse

- **Dry run:** the start transform applied to ext scores 96,029,658, i.e. −104,020 vs ext
  (N4's two groups, as expected).
- **After 3+1 epochs:** Tier 0 96,195,804, i.e. **+62,126 vs ext** and +166 KB worse than its
  own start. Transformer-alone CE rose from 99.06M to 99.33M. Int bytes +3,114 per copy.
- **Cause:** the 24 activation scales, now 256× smaller, drifted up to 8× during training and
  some flipped sign. AdamW takes steps of absolute size, so a scale 256× smaller moves 256×
  more relative to itself. The 8-bit scales and the weights moved normally.
- **Fix, queued as P1b:** freeze those 24 scales (`A_ACT16_FREEZE=1`). N4's gain needs no
  change to the scales.

### Control: 3+1 epochs from ext, nothing changed: **+198,261 vs ext** (the fine-tune itself hurts)

- **Result:** Tier 0 96,331,939; transformer-alone CE 99.26M → 99.51M. Int bytes +2,921 per copy.
  Net +204,104 vs ext.
- **Likely cause:** `train_A_finetune` restarts the LR at 10× and decays it only to 1× within
  3 epochs, and the stand-in mixer starts untrained. That suited ext's 24-epoch run (Afull →
  ext), not a 3+1 fine-tune of a converged model.
- **Re-read of earlier results against this control:**
  - P1 run 1: −136 KB vs control (with drifting scales).
  - up1 (31 levels, no penalty): −496 KB vs control, for +888 KB of S. Still a net loss
    (+392 KB), so its verdict stands.
  - mp1 (3-bit) used the same recipe. Its "81% recovery" was measured against ext, so the
    3-bit damage is overstated by up to ~200 KB. Even so, mp1's +180 KB net loss stays a loss
    or roughly even. **Not re-run.**
- **Queued (`pr_job3.sh`):** a recipe that continues from where ext stopped. A_LR 2.5e-7 gives
  a schedule of 2.5e-6 → 2.5e-7, i.e. ext's final LR and below, and the stand-in mixer starts
  from ext's trained mixer (`A_MIXER_INIT`).
  - P1c: 16-bit activations, scales frozen.
  - ctl2: same recipe, nothing changed (it should come out ≈ 0 vs ext).
  - These replace P1b.

### P2a: 31 levels, entropy penalty λ = 2, default recipe

| | Tier 0 Δ | int bytes Δ ×2 | net |
|---|---|---|---|
| vs ext | −144,485 | +194,421 | **+49,936** |
| vs control | −342,746 | +188,578 | **−154,168** |
| up1 (no penalty), vs control | −496,000 | +882,000 | +386,000 |

- **The penalty works:** weight bytes grew +97 KB per copy instead of up1's +444 KB, while
  keeping most of the Tier 0 gain. The penalty's own estimate (KT-smoothed) went from 2,790,382
  to 2,885,248 B.
- **Caveat:** the gain vs control assumes the 31-level advantage is the same with a recipe that
  doesn't damage the model. Part of it may only be repair of the recipe damage. With the
  default recipe, P2a is still a net loss vs ext.
- **Queued (`pr_job4.sh`, replaces `pr_job3.sh`):** with the gentle recipe, ctl2 (nothing
  changed), P2c (= P2a) and P1c (16-bit activations, scales frozen). P2b (15 levels, λ = 2,
  default recipe) is running first.

### P2b: 15 levels, entropy penalty λ = 2, default recipe — REJECTED (collapse)

- **Weight bytes:** 1,562,919 per copy (−1,226,793), i.e. −2,453,586 in S. They fell steadily:
  2.70M at step 51, 2.07M at step 451, 1.71M at step 951.
- **Tier 0:** 112,768,731, i.e. **+16,635,054 vs ext**. Transformer-alone CE went from 99.26M to
  134.36M, worse than cmix alone. **Net +14.2 MB.**
- **Why:** with 15 levels the penalty can only move ints toward zero or other dense bins, and at
  λ = 2 under the default recipe it kept doing that. The training objective did not register the
  damage that Tier 0 measures. The likely reason is that the stand-in mixer just stops relying
  on a worse transformer (its fallback is cmix alone), so damage looks cheap in training. Not
  investigated further: P2b was optional and the result is far from useful.
- **Caution for P2c (31 levels):** P2a did not collapse (its bytes grew), so P2c is still run.

## Job 1: Linux decompression check: VERIFIED (2026-11-12 21:07 UTC)

- **archive9 decompressed to an exact copy of enwik9** (md5 matches), on hutter-linux-sub, in
  2,055 min (34.3 h) wall time. Compression took 2,027 min with a max RSS of 10.2 GB.
- **Two warts, both from the volume filling up at ~05:45 UTC 11-12** (57% of the way through):
  - `decomp.time` and `decomp.log` stop there, so the max RSS of the decompression was lost.
  - The script reported `rc 1`. The most likely cause is the failed writes to stdout/stderr on
    the full volume, since the output is exact. Not provable now: the pod is deleted (its logs
    are all on the volume).
- **If an official run needs both numbers,** re-run decompression with the logs on local disk.

### ctl2: gentle recipe (A_LR 2.5e-7, mixer from ext), 3+1 epochs, nothing changed: **−54,985 net vs ext**

- **Result:** Tier 0 96,081,399 (−52,279 vs ext); int bytes −1,353 per copy. The default
  recipe's control was +198K.
- **Recipe:** ext's own recipe continued at its final LR, so Tier 0 is valid here (same-recipe
  differences were accurate to ~4 KB s.e.).
- **This is a new stackable item:** 99,790,914 − 54,985 = 99,735,929 (−0.69%).

### P2c: 31 levels, entropy penalty λ = 2, gentle recipe — REJECTED (penalty corrupts scales)

- **Result:** Tier 0 96,603,546, i.e. **+469,868 vs ext**. Int bytes +3,583 per copy.
  Net **+477,035 vs ext, +532,020 vs ctl2**. Transformer-alone CE 99.26M → 99.96M.
- **Weight bytes barely moved:** the gentle LR keeps the ints where they started, so the penalty
  had little to work with on the latents. The KT-coded count, 2,791,819 B per copy, is about
  the same as at the start.
- **The damage comes from the penalty's gradient on the weight scales.** A few rows had their
  scale moved by hundreds to thousands of times its start value, some with a sign flip:
  - blocks.1 query/key/forget-gate row 130;
  - blocks.3 query and key rows 130, 131, 136, 137;
  - blocks.2 mlp.up row 201.
  These look like rows with tiny start scales, where AdamW's absolute-size steps are huge
  relative to the scale (the same failure as P1 run 1). ctl2, with no penalty, kept every scale
  within 1.5%. P2a had the same problem in 22 rows (max ratio 296, some negative).
- **Verdict on P2:** as implemented, the penalty harms more than it saves at both LRs. A version
  with the weight scales frozen is untested. With the gentle LR it would probably gain little,
  because the ints barely move (ctl2: weights changed 0.14%). **Not run.**

### P1c: 16-bit activations on mlp_down_in + attn_out_in (scales frozen), gentle recipe: **−182,371 net vs ext**

- **Dry run:** 96,029,645 (−104 KB, as N4).
- **After 3+1 epochs:** Tier 0 95,953,178, i.e. **−180,500 vs ext**. Int bytes −935 per copy.
  Transformer-alone CE 99.01M.
- **vs ctl2:** −127,386. So training with the finer steps adds ~23 KB to N4's untrained
  −104 KB.
- **Cost of shipping it:** int16 activations in the 24 matmuls in C++, plus run time on the
  Linux build (N4 note). Not written, per instructions.

## GATE VERDICT (2026-11-13 02:50 UTC): NO GO — stack −0.81%, gate −0.85%

| item | Δ S (bytes) | status |
|---|---|---|
| real Linux entry | 100,028,258 | verified (decompress exact) |
| bf16-valued conv/norm tensors | −111,800 | measured (Tier 0 +1.7 KB, noise) |
| static per-tensor weight coder | −56,000 | measured on the laptop |
| cmix decay_d3 0.08 | −8,000 | 4-chunk test, unconfirmed |
| upx --lzma | −61,544 | measured on the laptop |
| gentle fine-tune (ctl2) | −54,985 | Tier 0, same recipe as ext |
| P1c vs ctl2 (16-bit act., trained) | −127,386 | Tier 0; needs C++ int16 |
| P2 (entropy-penalized quant.) | 0 | rejected: P2a +50 KB, P2b collapse, P2c +477 KB vs ext |
| **stack** | **99,608,543 (−0.81%)** | GO needs ≤ 99,575,000; short by **33,543** |

- **Which runs this stack uses:** ctl2 and P1c are the same gentle recipe, and P1c's own weight
  set contains both. So the stack is just 99,790,914 + P1c's net vs ext (−182,371). No
  additivity assumption is needed, because P2 adds nothing.
- **Uncertainties:**
  - Tier 0 s.e. is ~4 KB for same-recipe differences; earlier, Tier 0 vs the real run was
    −583 KB predicted vs −539 KB real (split eval). A 1.08× overstatement would cost ~15 KB here.
  - decay_d3 is unconfirmed.
  - The 16-bit path's run-time cost is unknown.
- **What was tried and rejected in this round:**
  - P1 run 1: activation scales drifted.
  - Control with the default recipe: +198 KB; the recipe damages a converged model.
  - P2a/b/c: the penalty's gradient on the weight scales corrupts rows; at λ = 2 with 15
    levels the transformer collapsed.
- **Spend this round:** ~$13.5 of 5090 time (10:38 UTC 11-12 → 02:42 UTC 11-13).
- **Untested ideas (not started, per the gate rule):**
  - A longer gentle fine-tune: ctl2 shows that 3+1 epochs gain 55 KB; more epochs might gain
    more.
  - P1 with 16-bit activations on more groups (N4 ALL16 was −125 KB untrained vs −104 KB for
    the two).
  - P2 with the weight scales frozen.
  The 33.5 KB gap is small enough that one of these might close it. That is the user's call.

## Round st1 (2026-11-13)

### Job B: K=16 split eval of the st1 build vs ext: **Δarchive −192,808**

- **Total:** st1 96,557,895 vs ext 96,750,703. Every chunk is negative: −12.5 to −14.4 KB in
  chunks 0–11, −6.5 to −9.5 KB in chunks 12–15. The cmix/bits ratio is 1.00003–1.00033 (normal).
- **st1 build:** P1c weights (act16, gentle fine-tune), bf16 values, the new weight coder,
  act16 in C++, decay_d3 0.08. cmix was built from `st1_src.tar.gz` with the split make line;
  results are in `/workspace/split/st1/`.
- **Agreement:** the laptop expected ~−190 KB (Tier 0 −180 KB + decay_d3 −8 KB).
- **Estimated S:** 100,028,258 − 192,808 (archive) − 2×85,687 (weights 2,861,798 vs 2,947,485)
  − 2×37,804 (packed binary 169,060 vs 206,864) = **99,588,468 (−0.83%)**. The claim line is
  99,420,425, so 168,043 is still missing.
- **Run time:** chunks took 2.71–3.01 h (ext's max was 2.76 h).
- **Job A restarted as st2** (user decision 11:20 UTC). st1 had reached 7.42% after 3 h 07 min;
  its `rss.log` is in `sub/out_st1/`.

### Job C1: P1c + 12 gentle epochs (act16 frozen, A_LR 2.5e-7, P1c's mixer): trend says no gain

Tier 0 of each QAT checkpoint (before cooldown). The matching baseline is **P1c's own QAT
checkpoint: 96,230,372** (after its 1-epoch cooldown: 95,953,178).

| epoch | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|
| Tier 0 (M) | 96.619 | 96.628 | 96.600 | 96.611 | 96.536 | 96.518 | 96.450 | 96.335 | 96.299 | 96.302 |

- **Every epoch is worse than the start.** The LR restart (10× = 2.5e-6) costs ~390 KB at
  first, and 12 epochs recover only to +72 KB vs the start, flattening at epochs 11–12.
- The final cooled-down number is pending, but a gain over P1c is unlikely.
- **Side finding:** P1c's single fp32 cooldown epoch was worth −277 KB on Tier 0
  (96,230,372 → 95,953,178). ext had a 4-epoch cooldown; P1c had 1.
- **Queued C2** (`pr/c2_job.sh`, same pod, after C1): 3 more cooldown epochs from P1c's final
  checkpoint, with Tier 0 after each.
- **C1's final cooldown never ran.** The job died at ~16:50 UTC because the volume was full
  again: Tier 0 had saved 541 MB of logits for every checkpoint it scored. Freed ~9 GB.
  `tier0.py` now saves logits only with `TIER0_SAVE_LT=1`. C1 was not rerun, given its trend.

### Job C2: P1c + 3 more fp32 cooldown epochs: **−39,666 net vs P1c** (Tier 0 estimate)
| checkpoint | Tier 0 (mix512) | vs P1c (95,953,178) |
|---|---|---|
| epoch 1 | 96,159,119 | +205,941 |
| epoch 2 | 96,119,652 | +166,474 |
| epoch 3 (final) | 95,914,324 | **−38,854** |
- Weight bytes: 2,788,370.5 vs P1c 2,788,776.7 → −406 per copy, −812 in S. Net −39,666 vs P1c
  (−222,037 vs ext).
- Only the final, fully cooled epoch gains; the middle epochs are worse (a higher learning rate
  partway through the schedule). The gain is well above the ~4 KB Tier 0 noise for same-family diffs.
- Stack estimate: 99,588,468 − 39,666 ≈ **99,548,800 (−0.87% vs record)**; a claim needs
  99,420,425, so it is still ~128 KB short. Not exported or split-evaluated; checkpoint
  /workspace/pr_c2/models/6m-q4-fp32-A.tch (= e3). Pod hutter-c1 deleted 21:40 UTC (~$16 total incl. C1).
- **st2 memory cap works (first full-scale test):** the first remap fired at 21:39 UTC (22.1%,
  8 h 33 min in): VmRSS 8,802,496 → 7,784,716 kB, RssFile 2.91 → 1.89 GB. Max sampled RSS so far
  9.01 GB (< 9.3 GB target). VmHWM in rss.log dropped at the remap, so it is not a lifetime peak.

### k2 kernels: Linux check (2026-11-14, on hutter-agent, 2 shared vCPUs; notes/k2-2026-11-14.md)
- **Kernel test** (`test_act16`, clang++-17 -O3 -march=x86-64-v3): **ALL OK**, 0 mismatches at d_mlp 768/784/832.
  ticks/call (st2 → k2): spmv16 5,327 → 3,338 (768), 4,793 → 3,287 (784), 5,494 → 3,588 (832);
  gemv16 1,508 → 1,362 (768), 1,530 → 1,387, 1,605 → 1,439; cold (600 it, 768): spmv16 20,382 → 12,000,
  gemv16 5,809 → **6,339 (slower cold)**.
- **Submission build** (build_and_construct_comp.sh, fresh from both tarballs): both pass the AVX2-only
  and no-reciprocal-estimate checks. st2 run/cmix 3,333,077, cmix_orig 170,140 (= expected);
  **k2 run/cmix 3,334,525, cmix_orig 171,588: +1,448 B packed → +2,896 in S** (the binary is in comp9 and archive9).
- **Identical output:** first 1,000,000 B of stream.bin (-n --raw-stream --official-vocab --transformer):
  st2 74,522 = k2 74,522, cmp identical; first 3,000,000 B: 288,657 both, identical.
- **Decode check: not possible on a small input on Linux.** enwik6 -c fails with the default vocabulary
  (198 ≠ 205 bytes) and with --official-vocab (the input has 0x00). The next full run is the decode test.
- **Speed** (3 MB, alternating, one process at a time, user CPU s): st2 489.6 / 480.6 / 495.7 (mean 488.6);
  k2 486.9 / 492.6 / 471.3 (mean 483.6) → **−1.0%, inside the noise** (spread ~3% per version).
  The kernel speedup is real in the test, but on this pod the transformer's 16-bit kernels are too small a
  share of the time to show end to end (Windows measured −5.6%).

### k3 multi-core compress mode (CMIX_PIPE): Linux test 2026-11-14 (notes/pipe-2026-11-14.md)
Pod hutter-k3 (cpu3m 32 vCPU, $1.76/h, AMD EPYC 9655P 96 cores / 192 threads host, L3 384 MiB, ~02:50–05:12 UTC, ~$4.2; deleted).
Build: split make line (clang++-22, non-PGO) + `-DCMIX_PIPE -pthread` on all 12 compile commands (checked) + `-pthread` at link.
(First tarball lacked src/models/byte-model.h; the laptop fixed it at 02:31.)
- **Identity: YES.** First 2,000,000 B of stream.bin, split-eval command line, st2 weights: unset, 8, 31, 31 threads
  (and 2, 4, 16) all give 182,394 B, cmp identical.
- **Scaling** (2 MB, one run at a time, wall): none 302.3 s; 2: 132.1; 4: 130.0; 8: 148.7; 16: 121.8; 31: 136.6 / 133.7.
  "coder waited" 0.0 s in every case → the coder thread is the limit from 2 workers on; speedup ~2.3×.
- **Split eval K=16, WARM 4M, CMIX_TF_THREADS=1 per chunk** (16 coders + 16 workers on 32 vCPUs; chosen because
  1 worker already keeps up on 2 MB and more threads would oversubscribe): **every chunk's x.cmix size and score
  identical to st1; total 96,557,895 = st1.** Chunks 1.76–1.99 h (st1: 2.71–3.23 h) → **~1.6× faster wall**,
  max chunk 1.99 h vs 3.23 h. With 1 worker the coder did wait in some chunks (232–1,098 s of ~1.9 h), so the
  split is partly worker-bound under full load.
- **Estimate for a single-stream full enwik9 compress in this mode** (not run): st2's real single-thread compress
  on cpu3g is on pace for ~38–39 h (29.5% at 11 h 29 min). Ratios: split under full load 0.63 (1.9 h vs 3.0 h);
  idle 2 MB 0.43 (130 s vs 302 s, early stream only). So roughly **17–25 h** on a pod like this, coder-bound,
  memory permitting (rings ~1.3 GB; set CMIX_TUNE ppmd_rss_mb 60000). Decompression stays single-thread
  (~st2's decompress time), so the decompress time limit, not compress, sets the bound.

### MLP widening (more weights), 2026-11-14 (notes/grow-2026-11-13.md): **net loss, gain/cost 0.08–0.11 → "not proven"**
Function-preserving growth of P1c's MLPs (new up rows = permuted/sign-flipped copies of random existing rows with their
scales; new down columns = 0), then the gentle recipe 3+1 epochs (A_LR 2.5e-7, P1c's mixer, act16 frozen), new entries at
a higher rate (per-entry update × MULT after each optimizer step, also in cooldown). Pod hutter-grow (5090, 00:07–08:04 UTC, ~$11, deleted).
- **Dry run** (same pod, patched source): P1c 95,953,317 (old pod 95,953,178); grown 784 −13, grown 832 −63 → function preserved.
  (A first dry run with the unpatched source and no act16 gave 121.4M for all: invalid, caught before training, ~30 min lost.)
- **MULT 10 (as planned) did not train:** while a new down weight quantizes to 0, its up row gets no gradient. G16 at step 801/1806:
  8 of 36,864 new down ints nonzero, mean |w| 0.0007 vs 0.024 old. Stopped; G16 and G64 rerun at **MULT 100**
  (new entries 2.5e-5 → 2.5e-6 in QAT, 1e-5 in cooldown). Then 22–23% of new down ints nonzero, mean |w| 0.0026 (~11% of old).

| run | d_mlp | Tier 0 | int bytes | Δ Tier 0 vs ctl | Δ bytes ×2 | **net** | gain/cost |
|---|---|---|---|---|---|---|---|
| control | 768 | 95,944,581 | 2,788,777.6 | 0 | 0 | 0 | – |
| G16 | 784 | 95,938,956 | 2,822,168.3 | −5,625 | +66,781 | **+61,156** | 0.08 |
| G64 | 832 | 95,915,835 | 2,917,838.9 | −28,747 | +258,123 | **+229,376** | 0.11 |

- Control vs P1c (same pod): −8,735 (the fine-tune alone).
- The gain grows a bit faster than the size (×4 units → ×5.1 gain), but stays at about 1/10 of the byte cost.
  New down weights that stayed 0 coded almost free, but the new up rows cost full price (+33 KB / +129 KB per copy).
- **Reading (one-sided test):** net ≥ 0, so "not proven", not "disproven": only ~22% of the new down weights left zero and
  they reached ~11% of the old weights' size in 3+1 epochs. A real growth run would need roughly a 10× better gain per
  byte than seen here to pay; nothing here points to that.
- Not done (for the write-up): the C++ side reads d_mlp from the weights file config, but the kernels and the 16-bit path
  have only run at 768 (the k2 kernel test passed at 784/832); transformer time grows with the MLP width.

### C2 split eval (standing rule 2026-11-14): **split net −29,038 vs st1 (Tier 0 net was −39,666)**
- Export: P1c's pipeline (CPU export, act16 scales ×256, non-rope f32 → bf16 values, rope from the shipped file), checked:
  P1c through it gives st1's exact output on 1 MB (74,522, cmp identical). C2 on 1 MB: 74,481. Coded with the OLD python
  coder (the laptop's ENC_INTC encoder is not on the pod): C2 2,890,342 vs P1c 2,890,679 → −337/copy (int entropy: −406).
  Files /workspace/c2exp/{p1c,c2}_vals.tfw(c2).
- Split K=16, WARM 4M, k3 build, CMIX_TF_THREADS=1 (pod hutter-c2split, cpu3m 32, 10:29–12:30 UTC, ~$3.6, deleted):
  **C2 96,529,532 vs st1 96,557,895 → Δ −28,364; every chunk gains (−450 … −2,674).** Chunks 1.48–1.97 h.
- **Split net = −28,364 + 2 × (−337) = −29,038** (−29,176 with the int-entropy byte Δ). Split/Tier 0 = 0.73.
- **New split-confirmed estimate: S ≈ 99,588,468 − 29,038 = 99,559,430 (−0.86% vs record); 139,005 short of a claim.**
  Shipping C2 needs the laptop's INTC export (exact bytes) and a full run; not done.
- **Correction (12:55 UTC): exact bytes with the new coder (ENC_INTC, compress3, laptop):** c2.tfwc2 2,861,392 vs st2's
  2,861,798 → −406 per copy. **Split net = −28,364 + 2 × (−406) = −29,176; estimate 99,588,468 − 29,176 = 99,559,292
  (−0.86%), 139,867 short of a claim.** Split Δ vs Tier 0's −38,854: 0.73. File /workspace/split/w/c2.tfwc2.

### Job P: d_mlp 768 → 752 (prune 16 least useful units per layer, gentle 3+1): **net +643,453 → shrinking by small steps loses**
Pod hutter-p752 (5090, 12:58–15:07 UTC, ~$3, deleted). P1c Tier 0 rerun on that pod 95,953,235 (−82 vs last night) → control stands.
- Untrained damage (Tier 0 vs P1c): ranking (a) |dq up row|·|dq down col| **+4,430,842**; ranking (b) mean |down input| (40 Tier 0
  batches, 5.2M tokens) × |dq down col| **+2,864,010** → used (b). The two rankings share 1 unit in total.
- After the gentle 3+1 (same recipe as grow_ctl): Tier 0 96,663,953 vs control 95,944,581 → **+719,372**; int bytes 2,750,818.0 vs
  2,788,777.6 → **−75,919 in S**. **Net +643,453; loss/saving 9.48.** The fine-tune recovered ~75% of the untrained damage.
- Reading: every existing unit is fully used; removing even the 2% least useful costs ~10× their bytes. With the widening result
  (new units worth ~0.1× their bytes), the MLP width is not a lever in either direction at this recipe.

### Lever 1 (cmix tune constants), round 1 (2026-11-14; C2 weights, k3 build single-thread, chunks 3/7/11/15, WARM 4M, LEN 8 MiB)
Pods hutter-tune2a/b (cpu3m 32). ref and ref2 (two pods) give identical bytes. Δ = sum over 4 chunks vs ref, ×17.7 ≈ full stream.
Batches of 32 jobs took ~2.5–4 h (host load ~100), so 13 lower-priority settings were skipped for the $30 cap
(decay_d1 0.85, decay_d2 0.48, decay_d3, decay_t1/t2/t3, input_eps, tf_mixer_lr 0.0012).

| setting | Δ 4 chunks | ×17.7 | per chunk (3/7/11/15) |
|---|---|---|---|
| dyn_lr 7.7e-4 | −985 | **−17,431** | −300/−234/−345/−105 |
| dyn_lr 4.8e-4 | −560 | −9,920 | −177/−134/−190/−60 |
| dyn_fx 1 | −361 | **−6,383** | −119/−63/−94/−84 |
| tf_mixer_buckets 16 + mode 1 | −111 | −1,964 | −35/−24/−19/−33 |
| dyn_l1 0 / tfb 16 / tfb 8 / sse_sm7mw 4915 | −44 … −10 | −770 … −175 | |
| dyn_blr 1e-4 / 3e-4 / 1e-3 | +3 … +25 | +46 … +438 | |
| sse_x1wr 3721 / decay_d1 0.5 | +35 / +133 | +621 / +2,356 | |
| sse_x2wr 4992 / dyn_lr 1.8e-4 / decay_d2 0.18 | +465 … +1,003 | +8,234 … +17,755 | |
| dyn_decay 1e-6 / 1e-5 / 1e-4 | +1,757 … +5,054 | +31,102 … +89,459 | |
| tf_mixer 16 + l1_ctx 1 / sse_sm6mw 4096 | +2,585 / +4,305 | +45,746 / +76,203 | |
(pod A's batch 2 — tfb 32, tfb16 mode 2, l0off+l1ctx, lr 0.0032, sse sm6 8192 / sm7 13107 / x1 9923 / x2 13312 — still running.)
- **dyn_lr is monotone up to the largest value tried → round 2 extends it (1.2e-3, 2e-3, 3e-3) and combines with dyn_fx 1 and the
  mode-1 tf mixer.** Timing: same-pod same-batch runs within the noise (pods differ by ~1.5×), no setting looked slower.

### Lever 2, D1: C2's cooldown recipe again from C2 (COOLDOWN_LR 1e-7, 3 epochs): **net −592 → no gain**
Pod hutter-lv2-D1 (5090, 17:34–20:33 UTC, ~$4.2, deleted). Same-pod C2 Tier 0 95,914,545 (+221 vs earlier).
| checkpoint | Tier 0 vs C2 (same pod) |
|---|---|
| epoch 1 | +283,876 |
| epoch 2 | +205,600 |
| epoch 3 | −139 |
| final | +133 |
- int bytes 2,788,007.8 vs C2 2,788,370.5 → −725 in S. **Net −592 (noise).** A second identical pass only comes back to where it started.
- Snapshots in the last 25% (steps 1672/1710/1748/1786/1806): quantized ints still change inside the window (17,208 / 4,864 /
  1,566 / 1,536 differ from the final) → averaging skipped as instructed. Dry run (forced average of C2 e2+e3) was +160,780.
- Lever 1 round 1 batch 2 (pod A): tfb 32, tfb16 mode 2, tfb16 lr 0.0032, sse sm7 4915 all within ±500 full-scale; l0off+l1ctx
  +49,625, sse sm6 8192 +150,952, x1 9923 +3,437, sm7 13107 +4,163, x2 13312 +8,236 (worse).

### Lever 2, D2: cooldown from C2 at 0.3× the peak rate (COOLDOWN_LR 3e-8, 3 epochs): **net +1,170 → no gain. Lever 2 closed.**
Pod hutter-lv2-D2 (5090, 18:23–21:25 UTC, ~$4.2, deleted). Same-pod C2 Tier 0 95,914,571 (+247).
| checkpoint | Tier 0 vs C2 (same pod) |
|---|---|
| epoch 1 | +218,077 |
| epoch 2 | +171,619 |
| epoch 3 | +1,333 |
| final | +1,763 |
- int bytes 2,788,074.1 → −593 in S; **net +1,170.** Snapshot ints still change in the window (3,064 / 1,571 / 1,536 / 1,536) → no averaging.
- **Reading:** the mid-run loss is nearly as large at 0.3× the rate as at 1× (e1 +218K vs +284K), so it is not caused by the rate
  being too high. Every cooldown pass from C2 ends back at C2 (D1 −592, D2 +1,170): C2 is at the bottom this recipe can reach.
  (One guess for the mid-run bump, not tested: the cooldown starts a fresh stand-in mixer, as C2 did, and the transformer first
  adapts to it.) D3 dropped (rule: D1 < 10 KB and D2 no gain). Lever 2 spend ≈ $8.5 of $25.

### Lever 4: 16-bit activations on more groups (Tier 0 on C2, no training), 2026-11-14
Pod hutter-l4 (5090, ~15 min incl. a crashed first try, ~$0.5, deleted). Base = C2 with the shipped two groups (mlp_down_in,
attn_out_in) at 16 bits: Tier 0 95,914,318 (C2 95,914,324). Each row adds that group at 16 bits (65,536 levels, scale/256).
Weight bytes don't change, so the delta is the whole net.

| group | what it is | quantizers | input width | Tier 0 Δ | C++ kernel (k3 act16.h) |
|---|---|---|---|---|---|
| mlp_up_in | input to mlp.up (192 → 768), every layer | 12 | 192 | **−12,022** | gemv16p_add is dense 192×192 packed rows: needs a 768-row variant (same inner loop, more rows) |
| qkv_proj_in | input to query/key/value projections (192 → 192 each), every layer | 36 | 192 | −3,552 | gemv16p_add fits as is (three 192×192); q/k/v read the same input, so one int16 quantization could serve all three if the scales agree |
| gates_in | input to the forget-gate low-rank projections (192 → 64 → …), every layer | 36 | 64 and 192 | −2,661 | new small variants (64-wide input / low-rank shapes) |
| unemb_in | input to the unembedding (192 → 205) | 1 | 192 | −2,010 | gemv16p_add with 205 rows (pad to 208): small variant |
| qkv_quant | quantized queries/keys/values inside softmax attention (layers 3, 7, 11) | 9 | 64 | −430 | new: int16 attention / KV cache |
| prior_in | input to the prior embedding (205-dim) | 1 | 205 | −63 | not worth it |
| **all six** | | | | **−22,337** | |
| best 2 (mlp_up_in + qkv_proj_in) | | | | −14,550 | |
| best 3 (+ gates_in) | | | | −17,888 | |
- Untrained Tier 0 (split usually confirms ~3/4). Roughly additive (sum of singles −20,738 vs all −22,337).
- mlp_up_in is the one that matters (and needs only a 768-row version of the existing dense kernel); qkv_proj_in is the
  cheapest to wire (existing kernel). Time cost not measured; the up matmul is the second-largest in each layer.

### Lever 1 split eval (a): dyn_lr 7.7e-4 + dyn_fx 1 (= the laptop's full run hutter-fullc2): **−14,493 vs split/c2, 16/16 chunks better**
Pod hutter-s3a (cpu5g 32, 23:18–01:11 UTC, ~$2.8, deleted). K=16, WARM 4M, k3 build, CMIX_TF_THREADS=1, C2 weights, CMIX_TUNE.
s3a 96,515,039 vs c2 96,529,532. Per chunk (0..15): −1,075, −2,024, −2,034, −1,271, −183, −342, −429, −1,299, −224, −1,019, −536,
−1,339, −1,139, −187, −392, −1,000. Seconds per chunk 4,793–6,751 vs c2 5,328–7,078 (mean ×0.89) — but s3a ran
on cpu5g and c2 on cpu3m, so this is not a speed result; dyn_lr/dyn_fx don't change the work per bit.
- Round-1 chunk test predicted −17.4 K (dyn_lr) and −6.4 K (dyn_fx) separately; the split gives −14.5 K for both together.
- Written to /workspace/tune/best-2026-11-14.tune for now (b = dyn_lr 1.2e-3 and c = dyn_lr 2e-3 still running).
- Stacked estimate: laptop base 99,427,000 (st2 + C2 + new packer, packer not full-run verified) − 14,493 = **99,412,507 (−1.008%)**,
  7.9 KB under the claim line 99,420,425. Estimate only.

### k4 split eval, CMIX_ACT16=15 (shipped two + mlp.up input + q/k/v projection inputs at 16 bits): **−15,016 vs split/c2, 16/16 chunks better**
Pod hutter-k4w (cpu3m 32, EPYC 9654, 23:58–01:41 UTC, ~$3, deleted). K=16, k3 toolchain build of k3 + k4 overlay (bin_k4), default constants,
CMIX_TF_THREADS=1, C2 weights. k4_15 96,514,516 vs c2 96,529,532. Identity first: k4 with CMIX_ACT16 unset == bin_k3 on 1 MB (74,480).
- Time per chunk vs c2 (both cpu3m, different hosts/loads): mean ×0.933, max ×1.074 → no slowdown visible above host noise.
- Tier 0 had predicted −14,550 for these two groups (untrained); the split gives −15,016 (≈1.03×, unusually full confirmation).
- Weight bytes unchanged. Not yet combined with the tune constants in one run (additivity untested).

### Lever 1 split eval (b): dyn_lr 1.2e-3 (no dyn_fx): **−19,505 vs split/c2, 16/16 chunks better** — best so far
Pod hutter-s3b (cpu3m 32, 23:20–02:17 UTC on an overloaded host (load ~240), ~$5.2, deleted). s3b 96,510,027 vs c2 96,529,532.
/workspace/tune/best-2026-11-14.tune = `dyn_lr 1.2e-3` now (c = 2e-3 still running). Round 2's 2-chunk test had 1.2e-3 at −25.8 K
(×35.4); split confirms ~3/4. Source default to change if it holds: dyn_lr 3e-4 → 1.2e-3 in src/predictor.cpp (tune::Get("dyn_lr", ...)).

### k4 split eval, CMIX_ACT16=7 (shipped two + mlp.up input): **−11,836 vs split/c2, 16/16 chunks better**
Pod hutter-k4b (cpu3m, EPYC 9655P, 23:56–02:00 UTC, ~$3.8 incl. build, deleted). k4_7 96,517,696. Time vs c2 mean ×1.095, max ×1.243;
k4_15 (strictly more 16-bit work) was ×0.933 on another cpu3m host, so these ratios reflect host load, not the kernels. A same-host
A/B timing (k3 vs k4 at 3/7/15, one process at a time) is needed for a real speed number.
- Summary: mlp.up input −11,836 (Tier 0 −12,022); + q/k/v inputs −15,016 (Tier 0 −14,550): q/k/v adds ~3.2 K.

### Lever 1 split eval (c): dyn_lr 2e-3: **−20,207 vs split/c2, 16/16 chunks better** (only 702 better than b)
Pod hutter-s3c (cpu5g 32, 01:12–04:22 UTC, ~$4.7, deleted). s3c 96,509,325. Per chunk: −1,164, −3,236, −2,934, −1,680, −63, −402, −790,
−1,728, −343, −1,679, −924, −1,854, −1,462, −127, −557, −1,263.
- Split ladder: 7.7e-4 + dyn_fx −14,493 · 1.2e-3 −19,505 · 2e-3 −20,207. The optimum is flat between 1.2e-3 and 2e-3; the
  final version's 1.2e-3 is within ~0.7 KB of the best tested. (Round 2 had 3e-3 worse than 2e-3 on 2 chunks.)
- Lever 1 total spend ≈ $33 of $40 (incl. ~$5 lost to a pod that never booted).

### st2 full run: COMPRESSION DONE (Linux, hutter-st2 cpu3g 8, single-thread): **S = 99,596,639 (−0.825%)** — real, not an estimate
comp9 3,333,077 + archive9 96,263,562 (enwik9.comp 93,131,533). Compress 2026-11-13 13:02 → 11-15 06:15 UTC: **41 h 13 min wall,
39.0 h user (95% on CPU)**, max RSS **9,100,672 kB (9.32 GB)** (old run 10.2 GB; the ppmd_rss_mb cap works). Exit 0.
- Split-eval estimate for st1 was 99,588,468: real is +8,171 (0.008%) → the K=16 split eval is accurate for this stack.
- Decompression started 06:15 UTC 11-15 (single-thread, ~41 h → ~23:30 UTC 11-16), then md5 check.

### Laptop's full multi-core run hutter-fullc2 (C2 weights, dyn_lr 7.7e-4 + dyn_fx 1, k3 pipe, 6 workers): **S = 99,572,534 (−0.849%)** — real
comp9 3,338,615 (k3 binary, old upx packing) + archive9 96,233,919; enwik9.comp 93,096,352. 10 h 58 min wall (27.5 h CPU), max RSS
19.3 GB (look-ahead rings + ppmd_rss_mb 60000; compression only, so the 10 GB limit applies to decompression).
- **Calibration:** enwik9.comp vs st2's 93,131,533 → **−35,181 real**, against split predictions C2 −28,364 + tune(a) −14,493 =
  −42,857 → the full run confirms ~82% of the split-eval gains (st1's split, by contrast, was within 8 KB). Expect the fin run's
  gains (vs st2) to land near ~0.8× the split numbers: split sum C2 −28,364 + dyn_lr 1.2e-3 −19,505 + k4_15 −15,016 = −62,885 →
  ~−51,500 real on the stream, plus the new packer (laptop: ~−132,300 in S).
