#!/bin/bash
# neif_a16_batch2.sh [STEP ...]: second round of the 16-bit activation experiment (build
# /work/tb16n = /work/tb16 plus the nonzero-code counter of mlp.down; same arithmetic).
#   fine250: window 250 M with 2 = mlp.down input alone, 1 = mlp.up input alone,
#            162 = mlp.down + both output projections
#   pick:    windows 60 M and 420 M with 2 and 162
#   more:    windows 60 M and 420 M with 3 (MLP up + down) and 163 (MLP + output projections)
# Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
run() { bash $W/neif_a16_run.sh $1 $(($1 + 1000000)) 1000000 /work/tb16n 3 0 "${@:2}"; }
for step in "$@"; do
  case $step in
    fine250) run 250000000 2 1 162 ;;
    pick) run 60000000 2 162; run 420000000 2 162 ;;
    more) run 60000000 3 163; run 420000000 3 163 ;;
    io) run 60000000 3840; run 420000000 3840 ;;
  esac
done
echo "batch2 done"
