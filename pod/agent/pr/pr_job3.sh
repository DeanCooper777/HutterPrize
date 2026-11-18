#!/bin/bash
# After pr_job.sh: low-LR recipe (A_LR 2.5e-7: schedule 2.5e-6 -> 2.5e-7, i.e. continue at ext's
# final LR) + stand-in mixer started from ext's trained mixer. The control (default recipe) was
# +198K worse than ext. P1c = 16-bit act. (scales frozen), ctl2 = same recipe, nothing changed.
W=/workspace
until grep -q "^exit 0" $W/logs/pr_job.txt; do sleep 60; done
export A_LR=2.5e-7 A_MIXER_INIT=$W/ext/models/6m-q4-A.mixer.tch
echo "=== $(date -u) P1c act16 frozen, low LR, ext mixer"
A_ACT16=mlp_down_in,attn_out_in A_ACT16_FREEZE=1 bash $W/agent/pr/run_pr.sh $W/pr_p1c act16:mlp_down_in,attn_out_in 96029250 25000; echo "P1c rc $?"
echo "=== $(date -u) ctl2 low LR, ext mixer"
bash $W/agent/pr/run_pr.sh $W/pr_ctl2 none 96133678 8000; echo "ctl2 rc $?"
echo "$(date -u) job3 done"; echo "exit 0"
