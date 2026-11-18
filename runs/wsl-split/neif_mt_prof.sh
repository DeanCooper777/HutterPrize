#!/bin/bash
# neif_mt_prof.sh BUILD_DIR MT [CPUS] [START] [END] [WARM]: one `-t` chunk run with NEIF_PROF=1 and NEIF_MT=MT;
# prints the result line and the profile sections of the transformer and of the total.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
B=${1:?}; MT=${2:?}; CPUS=${3:-0,1,2,3}; S=${4:-60000000}; E=${5:-60030000}; WM=${6:-10000}
export NEIF_PROF=1
bash $W/neif_mt_one.sh pf_$MT t $S $E $WM $B $MT $CPUS
tr '\r' '\n' < /root/noble/work/chunks/pf_$MT/log | grep -a "neif_prof\|neif_mt\|per-part\|mlp up\|mlp down\|attn step\|TOTAL" | cut -c1-150
