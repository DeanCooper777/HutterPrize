#!/bin/bash
# neif_a16_batch3.sh [STEP ...]: third round of the 16-bit activation experiment, fast kernels
# (build /work/tb16f), 3-stage pipeline.
#   rows:   the number of transformer rows of the whole stream (structure-only pass up to the
#           last 62 KB; "neif_rows" line of the log)
#   b12:    the three 1 MB windows (60 M, 250 M, 420 M; 1 MB warm-up) with the mlp.down code at
#           12 bits: mask 2 and mask 162
#   b10:    the same with 10 bits, mask 2 only
#   meta:   off / 162 on 5.0-6.0 M (metadata region, 1 MB warm-up)
#   warm:   off / 162 on 16-17 M with 0.5 MB warm-up, then with 16 MB warm-up (from byte 0)
# Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
B=/work/tb16f
run() { bash $W/neif_a16_run.sh $1 $2 $3 $B 3 0 "${@:4}"; }
for step in "$@"; do
  case $step in
    rows) run 501000000 501062281 0 0:rows_total; grep -a neif_rows /root/noble/work/chunks/rows_total/log ;;
    b12) for s in 60000000 250000000 420000000; do
           NEIF_ACT16_DNBITS=12 run $s $((s + 1000000)) 1000000 2:b12_$((s / 1000000))_2 162:b12_$((s / 1000000))_162
         done ;;
    b10) for s in 60000000 250000000 420000000; do
           NEIF_ACT16_DNBITS=10 run $s $((s + 1000000)) 1000000 2:b10_$((s / 1000000))_2
         done ;;
    meta) run 5000000 6000000 1000000 0:meta_5_0 162:meta_5_162 ;;
    warm) run 16000000 17000000 500000 0:w05_16_0 162:w05_16_162
          run 16000000 17000000 16000000 0:w16_16_0 162:w16_16_162 ;;
  esac
done
echo "batch3 done"
