#!/bin/bash
# neif_a16_final.sh: last measurement chain of the 16-bit activation experiment: the chosen
# variant (mask 162, mlp.down code 10 bits, codes below 2 dropped) on the three 1 MB windows,
# then the metadata window and the 16-17 M window with short and with 16 MB warm-up.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
grep -m1 "cpu MHz" /proc/cpuinfo
bash $W/neif_a16_batch4.sh v:10_2:162
bash $W/neif_a16_batch5.sh meta w05 w16
echo "final chain done"
