#!/bin/bash
# one_weight.sh: testing tool (not part of any submitted program).
# Makes runs/neif-ft/oneweight_np2.c5: a valid NP2 container that differs from the shipped one in one
# integer weight (one_weight.py, then the authors' NP2 writer).  numpy only, one core, about 5 min.
export PYTHONDONTWRITEBYTECODE=1
P=/root/neif-ft/venv/bin/python
N=/mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev
S=/mnt/c/Dean/Projects/HutterPrize/scripts/neif-ft
cd /mnt/c/Dean/Projects/HutterPrize/runs/neif-ft || exit 1
nice -n 19 $P $S/one_weight.py $N/weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5 oneweight_v5.c5 || exit 1
rm -f oneweight_np2.c5
nice -n 19 $P $N/training/tf/3_train/export/np2/np2_container.py np oneweight_v5.c5 oneweight_np2.c5 k fw np2 dead
