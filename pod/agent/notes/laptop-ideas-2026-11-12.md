# New tests from the laptop session (2026-11-12 ~01:00 UTC), approved by the user

The user asked the laptop session to review the project for ideas beyond the queue, approved
the four items below, and is adding money to the account to cover them (roughly $20-25 extra).
The RULE CHANGE still holds: no approvals needed, $10 floor, one GPU pod at a time plus one CPU
pod, push a short update after each result, score everything as Δarchive + 2×Δweights, don't
touch GitHub or the submission files. These are ADDED to your queue; nothing is cancelled. Use
your judgment on details: where I guessed at how your tools work, do what is correct, and stop a
line if a pre-check shows it can't pay.

Suggested order: N2 on a CPU pod as soon as the tune pod is done (it needs no GPU). N1-precheck
and N4 in your next 5090 session (they are short, inference only). Then the N1 fine-tune. N3 is
input to your step 3 (stand-in mixer), not a separate step.

## N1. Cross-article context for the transformer (the biggest bet)

**Fact.** The transformer starts from an empty context at every article: `TransformerByteUpdate`
in `src/predictor.cpp` calls `begin_article()` after each `kArticleSeparator`, and training used
articles as separate sequences. Measured on `article-boundaries.int32`: 243,427 articles, median
1,074 tokens, 34% shorter than 256 tokens. 8.8% of all tokens are in the first 256 tokens of
their article, 15.4% in the first 512, 26.9% in the first 1,024. The attention window is 1,024,
so a large share of tokens is predicted with less context than the model could use. The article
reordering puts similar articles next to each other, and the transformer is the one model that
can't use that.

**Pre-check (free, do first).** From the saved Tier 0 bit logits of ext (`tier0/lt`), the cmix
bits and the article boundaries, bucket tokens by position within their article (0-31, 32-63,
64-127, 128-255, 256-511, 512-1023, 1024-4095, 4096+). Per bucket report: token share, cmix-only
cost, mixed (stand-in) cost, and the transformer's gain in bits/token. If the gain per token is
clearly lower in the early buckets than in the late ones, there is room. Give a rough ceiling:
the bytes gained if the early buckets reached the late buckets' gain rate. It is only
suggestive, because early tokens are different content (XML headers, redirects). If the early
buckets already gain as much as the late ones, drop N1 and say so.

**Test.** Fine-tune from ext's QAT checkpoint with ext's recipe (A_MIXER=rich, CE 0.1, 3+1
epochs), changing only how sequences are cut: the contiguous stream in compression order, cut
into pieces of exactly 2^17 tokens, with a fresh context only at piece starts and NO reset at
article boundaries. Probably the smallest change is to give the loader a boundaries file that
lists multiples of 131,072 instead of the article starts; check what the loader does with it
(shuffling, the first token of a piece, the last token not being fed) and keep it consistent
with the C++.

**C++ side.** Add a tune key (e.g. `tf_article_reset`, default 1) that turns off the separator
test, so pieces are only cut at `kMaxArticleTokens`. Size and speed are unchanged.

**Evaluation.** Tier 0 must cut pieces the same way, and it is a different recipe, so Tier 0 is
only a sanity check here. The judge is a split eval against ext (same weight size, so Δarchive is
the score). As a control, also run ext itself with no resets and no training (Tier 0 only).

**Decision.** If the 3+1 run gains more than ~50 KB in the split eval, run the long version
(24+4 epochs, ~$13): for run A the gain grew from −0.58% to −0.78% with more epochs. If it's flat
or worse, record it and stop.

## N2. Is the article-order table worth its bytes?

**Fact.** `comp_order` (the cmix-compressed `src/readalike_prepr/data/new_article_order`) is
about 201 KB and is in BOTH comp9 and archive9, so it costs about 402 KB of S. The reordering
was designed for cmix before the transformer existed. The transformer doesn't depend on article
order (apart from its PPMD prior input), so the reordering may now be worth less than it costs.

**Test.** Build the preprocessed stream with the articles in their natural enwik9 order (read
`article_reorder.h` / `misc.h` to see how the order file is applied and what an identity order
means; the file has 172,277 entries, not one per article). Run the K=16 split eval on that
stream with ext's weights and compare the total with ext's existing split total (96,750,703).
enwik9 is at `/workspace/sub/enwik9.gz`.

**Decision.** Break-even is an archive growth of about +402 KB (2 × the real `comp_order` size;
check its size on the Linux build). Report the number either way. Notes:
- ext was trained with PPMD priors from the reordered stream, so this test slightly overstates
  the loss; a result modestly above break-even is still interesting.
- If natural order loses much more than 402 KB, the reordering stays. If you see a cheap middle
  route (a coarser order that costs far fewer bytes), note it in RESULTS.md, don't build it.
- If it wins, the decode path (restoring the original order) must still round-trip; only look
  into that if the number says it is worth it.

## N4. Activation precision: bytes are expensive, time may not be

**Fact.** Weights cost bytes twice; activation precision costs only run time. Activations are
8-bit, and the MLPs use ReLU squared, which has a wide dynamic range. Upstream reports the
quantized model's loss is 2.6% above the bf16 model's, without saying how much of that is
weights and how much is activations.

**Test (inference only, Tier 0, same weights as ext).** Keep the 4-bit weights exactly as they
are. Replace the 8-bit activation quantizers with 16-bit ones over the same clamp range (finer
steps, same scale range), first everywhere, then per group: MLP down input (the ReLU² output),
MLP up input, attention q/k/v quantizers, attention projections' inputs, unembedding input.
Report Δ Tier 0 per group. No training.

**Decision.** If everything at 16-bit gains less than ~100 KB, drop it. If more, report which
groups carry the gain. Do NOT implement C++: the int16 matmul path costs time (roughly 2× for the
affected matmuls), the Linux box has no time margin, and the platform choice is the user's. The
user needs the size of the prize first.

## N3. For your step 3: linearize the real cmix instead of fitting a stand-in

Your finding is that the learned stand-in overstates what real cmix keeps (2.0-2.4×). A
candidate that uses cmix's own mixer weights:

- In a cmix run WITH the transformer, dump per coded bit: the final logit before SSE, the
  transformer's stretched bit input `x_tf`, and the effective weight on it,
  `w_eff = Σ_i w1[i]·w0_i[tf] + w1[tf_direct]` (layer-0 mixers output a dot product that layer 1
  takes stretched, so the chain rule is just the product of the weights on the transformer's
  input; decide how to treat the dyn input and SSE, and say what you chose).
- Predicted cost for another weight set: BCE of `σ(logit_final + w_eff·(x_tf_new − x_tf_old))`.
- Validate before any training: from a dump made with base weights, plug in Afull's and ext's
  bit probabilities and compare the predicted differences with the split eval (base→Afull
  −553,370; Afull→ext −29,689). It is first order (the mixers re-adapt), so expect it to
  understate rather than overstate.
- If it lands within ~1.3×, it can serve as the training loss for step 3 (no jointly trained
  mixer), with a fresh dump from ext.

This is a suggestion. If your own stand-in search already found something that calibrates
better, use that.

## FYI, no action

The laptop measured the shipped weight coder: it spends 2,819,956 B on the int4 weights, while
static per-tensor tables would take 2,789,713 B (−28 KB per copy, −56 KB in S). It needs a
format + C++ change, so it waits for the user. Row/column context models gain nothing (the
weights are iid within a tensor).

## Reporting

One section per item in RESULTS.md with the numbers and the verdict, and a short push after
each. Lead pushes with the best full-entry estimate as usual.
