#!/bin/bash
# GPU pod job (2026-11-12): P1 act16, control, P2a (31 lv, lambda 2), P2b (15 lv, lambda 2, only if
# P2a beats the control net). Ends "exit 0" (selfstop).
W=/workspace; R=$W/tier0/results; S=$W/agent/pr/run_pr.sh
net() { python3 -c "import json;print(json.load(open('$R/$1_summary.json'))['net_vs_ext'])" 2>/dev/null; }
echo "=== $(date -u) P1 act16"
A_ACT16=mlp_down_in,attn_out_in bash $S $W/pr_p1 act16:mlp_down_in,attn_out_in 96029250 25000; echo "P1 rc $?"
echo "=== $(date -u) control"
bash $S $W/pr_ctl none 96133678 8000; echo "control rc $?"
echo "=== $(date -u) P2a 31 levels lambda 2"
A_ENT_LAMBDA=2 bash $S $W/pr_p2a up31 96133678 8000; echo "P2a rc $?"
a=$(net pr_p2a); c=$(net pr_ctl); echo "P2a net $a control net $c"
if [ -n "$a" ] && [ -n "$c" ] && python3 -c "import sys; sys.exit(0 if $a < $c else 1)"; then
  echo "=== $(date -u) P2b 15 levels lambda 2"
  A_ENT_LAMBDA=2 bash $S $W/pr_p2b none 96133678 8000; echo "P2b rc $?"
else echo "P2b skipped (P2a not better than control)"; fi
echo "$(date -u) probes done"; echo "exit 0"
