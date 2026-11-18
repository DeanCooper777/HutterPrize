#!/bin/bash
# neif_a16_batch5.sh [STEP ...]: the chosen variant (mask 162 = mlp.down + both output
# projections, mlp.down code 10 bits with codes below 2 dropped; fast kernels, build /work/tb16g,
# 3-stage pipeline) against off on further windows.
#   meta:  5.0-6.0 M (metadata region), 1 MB warm-up
#   w05:   16-17 M with 0.5 MB warm-up
#   w16:   16-17 M with 16 MB warm-up (model from byte 0)
#   prof:  per-site time table (build /work/tb16gp, one process, CPU 2), off and the variant,
#          60.0-60.3 M with 0.1 MB warm-up; raw output in neif_a16_timing_pf.txt
# Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
B=/work/tb16g
pair() { bash $W/neif_a16_run.sh $1 $2 $3 $B 3 0 0:$4_0; NEIF_ACT16_DNBITS=10 NEIF_ACT16_DNMIN=2 bash $W/neif_a16_run.sh $1 $2 $3 $B 3 0 162:$4_162; }
for step in "$@"; do
  case $step in
    meta) pair 5000000 6000000 1000000 p_meta5 ;;
    w05) pair 16000000 17000000 500000 p_w05 ;;
    w16) pair 16000000 17000000 16000000 p_w16 ;;
    prof) bash $W/neif_a16_time2.sh pf 2 /work/tb16gp 60000000 60300000 100000 1 160:160:16:1 2b10:2:10:2 162b10:162:10:2 ;;
  esac
done
echo "batch5 done"
