#!/bin/bash
# step1_tov5.sh: testing tool (not part of any submitted program).
# Step 1 of the weight round trip: shipped NP2 container -> plain v5 container (same tensors),
# then the authors' NP2 writer on that v5 ("np <v5> <out> k fw np2 dead", the shipped options)
# and a comparison of the result with the shipped file.  numpy only, one core, low priority.
set -u
D=/mnt/c/Dean/Projects/HutterPrize
N=$D/reference/neif2/dev
W=$D/runs/neif-ft
S=$D/scripts/neif-ft
SHIP=$N/weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5
PY=python3
[ -x /root/neif-ft/venv/bin/python ] && PY=/root/neif-ft/venv/bin/python
cd $W
echo "== tov5"; date
nice -n 19 $PY -I $S/np2_roundtrip.py tov5 $SHIP $W/shipped_as_v5.c5 || exit 1
echo "== authors' NP2 writer on that v5"; date
rm -f $W/direct_np2.c5
nice -n 19 $PY $N/training/tf/3_train/export/np2/np2_container.py np $W/shipped_as_v5.c5 $W/direct_np2.c5 k fw np2 dead
echo "== compare"; date
sha256sum $SHIP $W/direct_np2.c5
cmp $SHIP $W/direct_np2.c5 && echo "direct_np2.c5 BYTE IDENTICAL to the shipped container"
date
