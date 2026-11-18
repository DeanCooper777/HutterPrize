#!/bin/bash
# slot_run.sh: testing tool (not part of any submitted program).
# slot_run.sh main | neg
#   main: one chunk run of the test build /work/tbtap (stream bytes 250.0-250.3 M, warm-up 1.2 M,
#         NEIF_PIPE=3) with the shipped weights; prints the result file, the sha256 of the coder
#         output and the cost line.  Reference: total_bits 2508178.191, 313,523 B, sha 727e97767d69fb56.
#   neg:  negative test of NEIF_T_WEIGHTS_ANY with a container that differs in one weight
#         (runs/neif-ft/oneweight_np2.c5): a short run without the switch must be refused, the same
#         run with the switch must load and code.
# One large process at a time (neif_local_chunk.sh refuses otherwise).  Run in WSL as root.
D=/mnt/c/Dean/Projects/HutterPrize
W=$D/runs/wsl-split
F=$D/runs/neif-ft
C=/root/noble
case ${1:-main} in
main)
  bash $W/neif_local_chunk.sh 250000000 250300000 1200000 tap_250 /work/tbtap 0 1 3 0 8
  echo "rc $?"
  sha256sum $C/work/chunks/tap_250/run/out.cmix; ls -l $C/work/chunks/tap_250/run/out.cmix
  grep -a "neif_test cost\|neif_test:" $C/work/chunks/tap_250/log
  cp -f $C/work/chunks/tap_250/score.json $F/tap_250_score.json
  rm -f $C/work/chunks/tap_250/run/out.cmix
  ;;
neg)
  # a build directory with the same binary and the changed container under the shipped name
  rm -rf $C/work/tbneg && mkdir -p $C/work/tbneg
  cp $C/work/tbtap/cmix $C/work/tbneg/
  cp $F/oneweight_np2.c5 $C/work/tbneg/weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5
  sha256sum $C/work/tbneg/weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5
  echo "== without the switch (must be refused)"
  unset NEIF_T_WEIGHTS_ANY
  bash $W/neif_local_chunk.sh 250000000 250020000 100000 neg_off /work/tbneg 0 0 0 0 8
  echo "rc $?"; tail -n 3 $C/work/chunks/neg_off/log
  echo "== with NEIF_T_WEIGHTS_ANY=1 (must load and code)"
  export NEIF_T_WEIGHTS_ANY=1
  bash $W/neif_local_chunk.sh 250000000 250020000 100000 neg_on /work/tbneg 0 0 0 0 8
  echo "rc $?"; grep -a "neif_test" $C/work/chunks/neg_on/log
  echo "== the same short chunk with the shipped weights, for comparison"
  unset NEIF_T_WEIGHTS_ANY
  bash $W/neif_local_chunk.sh 250000000 250020000 100000 neg_ref /work/tbtap 0 0 0 0 8
  echo "rc $?"; grep -a "neif_test" $C/work/chunks/neg_ref/log
  ;;
esac
