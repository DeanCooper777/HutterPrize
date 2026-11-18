#!/bin/bash
# neif_mt_batch8.sh: the last checks of the final test binary: the validation decode (pass, the two negative
# tests, three more failures), the quick identity check of the speculative step, then the official build of the
# edited tree against the published comp9.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
bash $W/neif_sv_batch.sh quick neg neg2
bash $W/neif_mt_s4quick.sh /work/tbmt
bash $W/neif_build_official_dev.sh 2>&1 | tail -n 4
cp /root/noble/work/mt_results.txt /mnt/c/Dean/Projects/HutterPrize/runs/neif-par/meas/mt_results.txt
