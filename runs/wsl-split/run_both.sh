#!/bin/bash
S=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
bash $S/split_local.sh st2 /mnt/c/Dean/Projects/HutterPrize/cmix-T-dwc/models/6m-q4-fp32.tfwc2 "15" > $S/out_st2.log 2>&1 &
sleep 60   # let the first one unpack the stream
bash $S/split_local.sh c2 $S/c2.tfwc2 "15" > $S/out_c2.log 2>&1 &
wait
