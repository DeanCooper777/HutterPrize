#!/bin/bash
# neif_a16_verify.sh [BUILD_DIR]: fast kernels of the 16-bit experiment against the slow reference
# path (NEIF_ACT16_SLOW=1): same coder output (sha in /root/noble/work/a16_results.txt) expected
# for every mask. Small chunk 20.0-20.1 M (0.3 MB warm-up), then the 1.5 MB reference chunk
# 250.0-250.3 M (off must be 727e97767d69fb56, mask 162 f3697c2bc8209710 as the slow builds gave).
# Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
B=${1:-/work/tb16f}
S=20000000; E=20100000; WM=300000
run() { bash $W/neif_a16_run.sh $S $E $WM $B 3 0 "$@"; }
for m in 160 2 162; do
  NEIF_ACT16_SLOW=1 run $m:v_${m}_slow
  run $m:v_${m}_fast
done
for nb in 12 9; do
  NEIF_ACT16_DNBITS=$nb NEIF_ACT16_SLOW=1 run 2:v_2b${nb}_slow
  NEIF_ACT16_DNBITS=$nb run 2:v_2b${nb}_fast
done
run 0:v_off
S=250000000; E=250300000; WM=1200000
run 0:v_ref_off 162:v_ref_162
echo "verify done"
