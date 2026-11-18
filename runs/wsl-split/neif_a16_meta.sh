#!/bin/bash
# neif_a16_meta.sh: the metadata region (no page start, hence no window can begin inside it):
# stream bytes 0-400000 from byte 0, off and the chosen variant. No transformer row is fed there
# ("neif_rows" line), so both runs must give the same coder output.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
bash $W/neif_a16_run.sh 0 400000 0 /work/tb16g 3 0 0:p_meta0_0
NEIF_ACT16_DNBITS=10 NEIF_ACT16_DNMIN=2 bash $W/neif_a16_run.sh 0 400000 0 /work/tb16g 3 0 162:p_meta0_162
grep -a neif_rows /root/noble/work/chunks/p_meta0_0/log /root/noble/work/chunks/p_meta0_162/log
grep -a neif_rows /root/noble/work/chunks/p_w16_0/log /root/noble/work/chunks/p_w05_0/log
