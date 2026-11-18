#!/bin/bash
# neif_mt_quick.sh [BUILD_DIR]: quick identity check of a NEIF_MT build on a short chunk (60.00-60.03 M, about
# 40 k model bytes): code it on one thread, decode it on one thread, code and decode it with 2 and 3
# threads; every coder output must have the same sha and every decode must end without a wrong byte.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
B=${1:-/work/tbmt}; S=60000000; E=60030000; WM=10000
bash $W/neif_mt_one.sh q_t0 t $S $E $WM $B 0 2
bash $W/neif_mt_one.sh q_u0 u $S $E $WM $B 0 2 q_t0
for n in 2 3; do
  bash $W/neif_mt_one.sh q_t$n t $S $E $WM $B $n 0,1,2,3
  bash $W/neif_mt_one.sh q_u$n u $S $E $WM $B $n 0,1,2,3 q_t0
done
