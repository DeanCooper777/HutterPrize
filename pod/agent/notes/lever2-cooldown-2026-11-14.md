# USER DECISION 2026-11-14 ~18:05 UTC (relayed by the laptop session): LEVER 2, more and better cooldown from C2. START NOW.

Where we stand (laptop numbers, none verified by a full run yet): st2 99,588,468; C2 -29,176 (split-confirmed);
new packer + official minimal build + no lstm for the two tables: the packed binary is 101,587 B against upx's 170,140,
about -132,300 in S after +4,835 for the tables. Estimate about 99,427,000 (-0.993%), about 6.6 KB short of 99,420,425.
We want 30-40 KB more for margin. Lever 1 (yours, running) is one source; this is the other. Lever 1 continues unchanged.

## Why
Cooldown is the only training lever that paid recently: C2 (P1c + 3 fp32 cooldown epochs) gave -38,854 on Tier 0 and
-28,364 in the split eval, while C1 (12 more gentle QAT epochs) gave nothing. In C2 only the final, fully cooled epoch
gained (e1 +206K, e2 +166K, e3 -39K vs P1c), which points at the learning-rate schedule: the rate partway through is
too high for a model this converged.

## Runs (all start from C2's final checkpoint /workspace/pr_c2/models/6m-q4-fp32-A.tch; Tier 0 baseline = C2's
95,914,324, rerun C2's Tier 0 on the new pod first as the same-pod reference)
Read training_recipes/cooldown_A and c2_job.sh for the knobs; where a knob does not exist, add it with a small patch
(as grow_patch.py did) and say what you changed.
- D1: C2's exact recipe again, 3 epochs. Does a second identical pass still gain?
- D2: 3 epochs with the peak learning rate at about 0.3x C2's (same shape). Does a gentler pass avoid the mid-run loss
  and end lower?
- D3: 6 epochs at C2's peak rate (a longer tail). Only if D1 gains more than about 10 KB; otherwise replace it with
  D2's better variant at 6 epochs, or drop it.
- Averaging (free, do it for every run): save 4-5 snapshots spread over the last ~25% of the final epoch, average the
  trained (fp32) parameters of those snapshots, keep the quantized integers as they are, and Tier 0 the averaged
  checkpoint next to the final one. Check first that the quantized integers really do not change during cooldown; if
  they do, say so and skip the averaging.
Keep per-epoch checkpoints and Tier 0 each epoch (A_KEEP_EPOCHS), as in C2, so we see the curve.

## Pods and money
Two RTX 5090 pods at once are allowed for this lever (D1 and D2 in parallel), on top of the Lever 1 CPU pods. Dry-run
the later stages first (snapshot saving, averaging, Tier 0 of an averaged checkpoint, export) on a few steps. Cap for
this lever: $25. Balance about $75; st2 still needs about $12. Self-stop and delete as usual.

## Scoring
net = (Tier 0 - C2's Tier 0 on the same pod) + 2 x (weight bytes with compress3 - 2,861,392). Expect the split eval to
confirm about three quarters of a Tier 0 gain (C2: 73%). The standing rule applies: export and split-eval the best
candidate if its net beats -10,000, against /workspace/split/c2, after or beside Lever 1's confirming split eval.
If Lever 1 also has a winner, run the final split eval with BOTH (best weights + best .tune file): that combination is
what would ship.

## Pushes
One when the pods run and the dry runs passed (ETAs in CST), one per finished run (curve + averaged result), one with
the split result. Lead with the estimate vs the record, base 99,427,000, and say it is not verified by a full run.
