#!/bin/bash
# Replaces pr_job3.sh (17:50 UTC 11-12). After pr_job.sh: gentle recipe (A_LR 2.5e-7, mixer from
# ext). ctl2 (nothing changed), P2c (= P2a: 31 levels, lambda 2), P1c (16-bit act., scales frozen).
W=/workspace; S=$W/agent/pr/run_pr.sh
until grep -q "^exit 0" $W/logs/pr_job.txt; do sleep 60; done
export A_LR=2.5e-7 A_MIXER_INIT=$W/ext/models/6m-q4-A.mixer.tch
echo "=== $(date -u) ctl2 gentle, nothing changed"
bash $S $W/pr_ctl2 none 96133678 8000; echo "ctl2 rc $?"
echo "=== $(date -u) P2c gentle, 31 levels lambda 2"
A_ENT_LAMBDA=2 bash $S $W/pr_p2c up31 96133678 8000; echo "P2c rc $?"
echo "=== $(date -u) P1c gentle, act16 frozen"
A_ACT16=mlp_down_in,attn_out_in A_ACT16_FREEZE=1 bash $S $W/pr_p1c act16:mlp_down_in,attn_out_in 96029250 25000; echo "P1c rc $?"
echo "$(date -u) job4 done"; echo "exit 0"
