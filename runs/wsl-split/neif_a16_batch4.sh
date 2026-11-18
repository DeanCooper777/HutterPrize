#!/bin/bash
# neif_a16_batch4.sh [STEP ...]: narrower mlp.down codes (build /work/tb16g, fast kernels,
# 3-stage pipeline). A variant is BITS_MIN: NEIF_ACT16_DNBITS=BITS, NEIF_ACT16_DNMIN=MIN.
#   check:  fast against slow path with a threshold (16_128) on the small chunk 20.0-20.1 M
#   rows:   transformer rows of the whole stream ("neif_rows" line)
#   v:BITS_MIN[:MASK]  the three 1 MB windows (60 M, 250 M, 420 M; 1 MB warm-up), mask 2 or MASK
# Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
B=/work/tb16g
run() { bash $W/neif_a16_run.sh $1 $2 $3 $B 3 0 "${@:4}"; }
for step in "$@"; do
  case $step in
    check)
      NEIF_ACT16_DNBITS=16 NEIF_ACT16_DNMIN=128 NEIF_ACT16_SLOW=1 run 20000000 20100000 300000 2:c_16_128_slow
      NEIF_ACT16_DNBITS=16 NEIF_ACT16_DNMIN=128 run 20000000 20100000 300000 2:c_16_128_fast
      NEIF_ACT16_DNBITS=10 NEIF_ACT16_DNMIN=2 NEIF_ACT16_SLOW=1 run 20000000 20100000 300000 162:c_10_2_slow
      NEIF_ACT16_DNBITS=10 NEIF_ACT16_DNMIN=2 run 20000000 20100000 300000 162:c_10_2_fast ;;
    rows) run 501000000 501062281 0 0:rows_total; grep -a neif_rows /root/noble/work/chunks/rows_total/log ;;
    v:*)
      spec=${step#v:}; bm=${spec%%:*}; mask=2
      case $spec in *:*) mask=${spec#*:} ;; esac
      bits=${bm%%_*}; min=${bm#*_}
      for s in 250000000 420000000 60000000; do
        NEIF_ACT16_DNBITS=$bits NEIF_ACT16_DNMIN=$min run $s $((s + 1000000)) 1000000 $mask:g${bm}_$((s / 1000000))_$mask
      done ;;
  esac
done
echo "batch4 done"
