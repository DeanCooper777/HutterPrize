#!/bin/bash
# neif_mt_s4quick.sh [BUILD_DIR]: quick identity check of the speculation machinery (stage S4) on the short
# chunk 60.00-60.03 M: single thread; `-t` with the step speculated on the transformer thread (every byte is
# known to the compressor), without and with 20 % of the guesses made wrong on purpose; `-u` with the guess
# taken from the stream (NEIF_MT_SPEC=2), without and with faults.  Every `t` line must show the same sha,
# every `u` line 0 wrong bytes.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
B=${1:-/work/tbmt}; S=60000000; E=60030000; WM=10000
rep() { tr '\r' '\n' < /root/noble/work/chunks/$1/log | grep -a "neif_mt" | cut -c1-220; }
bash $W/neif_mt_one.sh s4_t0 t $S $E $WM $B 0 2
export NEIF_MT_SPEC=1
bash $W/neif_mt_one.sh s4_t1 t $S $E $WM $B 1 2,3; rep s4_t1
NEIF_MT_FAULT=200 bash $W/neif_mt_one.sh s4_t1f t $S $E $WM $B 1 2,3; rep s4_t1f
bash $W/neif_mt_one.sh s4_t2 t $S $E $WM $B 2 1,2,3; rep s4_t2
export NEIF_MT_SPEC=2
bash $W/neif_mt_one.sh s4_u1 u $S $E $WM $B 1 2,3 s4_t0; rep s4_u1
NEIF_MT_FAULT=200 bash $W/neif_mt_one.sh s4_u1f u $S $E $WM $B 1 2,3 s4_t0; rep s4_u1f
