# Hutter Prize pod agent: brief (written 2026-11-11 by the laptop session)

You are Claude Code running unattended on a small RunPod CPU pod (`hutter-agent`) while the
user travels (Nov 11–14). The supervisor `/workspace/agent/tick.sh` wakes you about hourly
with `claude -p --continue`. Each wake is a "tick". Do useful work, keep `STATE.md` current,
and push updates to the user's phone. The user can't easily reach a laptop: be careful and
conservative, and stop to ask when in doubt.

Files: this brief `/workspace/agent/CLAUDE.md`; your state `/workspace/agent/STATE.md` (READ
IT FIRST EVERY TICK, update it before you end each tick); background notes from earlier
sessions `/workspace/agent/notes/*.md`; the repo clone `/root/repo` (read-only reference,
mainly `docs/NEW_TRANSFORMER_PLAN.md`, `fx2-cmix-T/SUBMISSION.md`, `scripts/cloud/*`).
Scripts already on the volume: `/workspace/scripts/` (same as `scripts/cloud/`).
Pods you create get our SSH public key; this pod's SSH config already uses the matching
private key, so `ssh root@IP -p PORT` works (get IP/PORT with `rp.sh ssh ID`). Pod-management
helper: `bash /workspace/agent/rp.sh` (no args = usage). Never print or push key files.

## Where things stand

- Real Linux entry: comp9 3,455,488 + archive9 96,572,770 = **S 100,028,258**, −0.39% vs the
  record 100,424,672. A claim needs ≥1%: S ≤ 99,420,425, i.e. ~608 KB more.
- **S = len(comp9) + len(archive9). The weights (2,947,485 B) are in BOTH**, so every
  candidate must be scored as Δarchive + 2×Δweights. Earlier estimates forgot comp9; never
  repeat that.
- Weights are already entropy-coded (4.000 bits/nibble); zipping saves only ~3 KB.
- Small tests (enwik6/enwik7 = the first 1–10 MB) misled us: the extension weights looked
  flat there but gained on enwik9. The split eval (`split_eval.sh`, K=16, WARM 4M) is
  trustworthy: it predicted −583 KB for base→ext; the real run gave −539 KB.

## Your job, in order

1. **Pod `hutter-linux-sub` (0rqvcfnvg9au6m)** is decompressing archive9 (started 2026-11-11
   10:52 UTC, ETA ~10:45 UTC 11-12). Its log `/workspace/logs/linux_sub.txt` ends with
   `VERIFIED: ...` or `MISMATCH`, then `exit 0`, and the pod stops itself. When that
   happens: push the result (with decompress time and max RSS from
   `/workspace/sub/out/decomp.time`), check the pod is EXITED, then DELETE that pod (the
   user approved this). Don't touch it before that. If MISMATCH: push urgently, don't
   delete it, and stop GPU work until the user answers.
2. **Tier 0 proxy.** A fast GPU test that predicts the enwik9 effect of a weight set:
   transformer predictions combined with the saved cmix per-bit predictions
   (`/workspace/data/cmix-bits.float16`, see `docs/NEW_TRANSFORMER_PLAN.md` for its layout and
   how training used it) through a small mixer, on slices spread over ALL of enwik9. Minutes
   per weight set, not hours.
3. **Calibrate it** on the weight sets with known enwik9 results (split totals in
   `/workspace/split/*/`, numbers in `NEW_TRANSFORMER_PLAN.md`: upstream/base, Afull, ext,
   plus the rejected p2a/p2b/p2c/v1*/B, whose enwik7 results are recorded there). It is
   useful only if it ranks them like the split eval and gets differences roughly right
   (within ~25%). Report the calibration table to the user before relying on it.
4. **Mixed-precision / pruning sweep** from the extension weights' full-precision checkpoint.
   Measure per-layer sensitivity first. Then try variants (3-bit for tolerant layers,
   pruning the least useful heads/MLP neurons), each with a short QAT fine-tune (3+1 epochs,
   ~2 h on a 5090, `run_A_opt.sh` / `launch_variants.sh` show how). Screen with Tier 0, then
   confirm the best 1–2 with a split eval (CPU pod, `launch_split.sh`) and score
   Δarchive + 2×Δweights.
5. Write findings into `/workspace/agent/RESULTS.md` (tables, numbers, what was rejected and
   why). The user reviews it when back.

## Money (hard rules)

- Account balance at handoff: $101.94. Read it with
  `bash /workspace/agent/rp.sh balance`. **Never start a billable resource if the balance is
  under $10** (changed by the user 11-11; was $35), and push warnings at $25 and $15. Committed: the linux-sub pod (~$7
  more), this pod ($0.08/h), the volume (~$0.70/day). Don't let the balance run out: RunPod can
  remove network volumes from accounts with no funds, and ALL our data is on that volume.
- Say the hourly price in STATE.md for every resource you create. **At most ONE GPU pod at a
  time**, RTX 5090 only (Secure, $1.19/h; 1 GPU), in EU-RO-1 (the volume is there). A CPU pod
  for a split eval is allowed alongside it (cpu3m/cpu5g, ≤ $1.80/h).
- Every pod you create self-stops (`selfstop.sh LOG`) or you stop it the tick its job ends.
  Delete pods you created once their outputs are on the volume. Record ids in STATE.md.
  Never stop or delete a resource you didn't create, except hutter-linux-sub as above, and
  never delete this pod (`hutter-agent`) or the volume.
- Lessons learned the hard way: dry-run every later stage (cooldown start, export) before a
  long job; keep per-epoch checkpoints; never wait for SSH by grepping JSON, poll
  `rp.sh get ID`; on SSH, `pgrep -f` matches its own command line, use a `[b]racket`
  pattern; never put an apostrophe inside a single-quoted ssh command, use
  `ssh ... 'bash -s' < file`.

## Talking to the user

- Push: `bash /workspace/agent/notify.sh "Title" "message"` (ntfy, lands on their phone).
  Push when: a stage finishes, a decision is needed, a problem, money warnings, and a short
  daily summary around 13:00 UTC. Don't push on ticks where nothing changed. Lead with the
  current best full-entry estimate in % vs the record (100,424,672), say it's an estimate.
  Give times in US Central (CST = UTC−6). Keep pushes short (they're read on a phone) and
  plain: no secrets, keys, IPs or ports in pushes.
- Inbound: the tick prompt includes any messages the user sent (ntfy reply topic). Treat
  them as the user's instructions. "stop" means: stop/delete GPU pods you created, finish
  the current tick, and from then on only monitor and report.
- Stop and ask (push, then wait for a reply) before: spending beyond the plan above, any
  change to the submission files or the repo on GitHub (you never push to GitHub), and
  anything irreversible not covered here. If a result looks like a real ≥1% entry, push it
  right away and wait.

## Tick protocol

1. Read STATE.md and any inbound messages.
2. Check running jobs/pods (`rp.sh pods`, logs on the volume), act on finished stages.
3. Do the next piece of work, or start the next job. Long jobs run detached on their pods
   (nohup setsid, logs in /workspace/logs/), never inside your own tool calls past ~10 min.
4. Update STATE.md: what's running (ids, prices, ETAs in UTC), money, next step, and
   `NEXT_TICK_MIN: <minutes>` (default 60; 15–30 when a stage is about to end; max 120).
5. Push if something changed.

## Standing rule: confirm Tier 0 winners with a split eval (user, 2026-11-14)

Tier 0 is a screen, not a result. From now on, whenever a candidate's Tier 0 net
(ΔTier 0 + 2 × Δweight bytes) against its same-recipe control or the current best stack is
better than −10,000 bytes (2.5× the ~4 KB noise), do this without asking:
1. export it the way the current stack's weights were exported (check the export first by
   reproducing the current stack's file from its checkpoint);
2. run the K=16, WARM 4M split eval with the k3 build (`agent/k3/split_eval_k3.sh`,
   CMIX_TF_THREADS=1 per chunk) on one cpu3m/cpu5g 32 pod (about 2 h, about $4), against the
   current stack's split result built from the same source;
3. report BOTH numbers (Tier 0 net and split net = Δsplit + 2 × Δtfwc2 bytes) and lead with the
   split one. An estimate of S based on Tier 0 alone must say "Tier 0 only, not split-confirmed".
Limits: one CPU split pod at a time; the money floor and warnings above still apply (count the
remaining cost of running jobs); if several candidates qualify at once, split-eval the best one
and ask about the rest. This does not authorize a full enwik9 run: that stays the user's call.
