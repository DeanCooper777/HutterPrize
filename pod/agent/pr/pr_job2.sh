#!/bin/bash
# P1b (16-bit act scales frozen), after pr_job.sh ends. Ends "exit 0" (selfstop watches this log).
W=/workspace
until grep -q "^exit 0" $W/logs/pr_job.txt; do sleep 60; done
echo "=== $(date -u) P1b act16, scales frozen"
A_ACT16=mlp_down_in,attn_out_in A_ACT16_FREEZE=1 bash $W/agent/pr/run_pr.sh $W/pr_p1b act16:mlp_down_in,attn_out_in 96029250 25000; echo "P1b rc $?"
echo "$(date -u) P1b done"; echo "exit 0"
