#!/bin/bash
# Lever 4 job (Tier 0 only). Log /workspace/logs/l4_job.txt, ends "exit 0".
W=/workspace; PY=$W/train/.venv/bin
echo "=== $(date -u) Lever 4"
mkdir -p /root/s64; [ -s /root/s64/ppmd-probs.float16 ] || cp $W/tier0/s64/* /root/s64/
cd $W/grow/src; export A_ACT16=mlp_down_in,attn_out_in A_ACT16_FREEZE=1 DATA=/root/s64 PYTHONPATH=.
$PY/python $W/agent/l4/l4.py $W/pr_c2/models/6m-q4-fp32-A.tch $W/tier0/results/l4.json 2>&1 | grep -v -i -e warn -e "articles"
echo "$(date -u) L4 done"; echo "exit 0"
