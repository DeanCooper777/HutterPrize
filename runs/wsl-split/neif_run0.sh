#!/bin/bash
# Start the published cmix-neif 2.0 comp9 on enwik9 inside the chroot and watch the first minutes:
# what it prints, where the coded size can be read, memory.   neif_run0.sh [SECONDS=420] [BUILD=b0]
SEC=${1:-420}; BLD=${2:-b0}; C=/root/noble
[ -s $C/work/enwik9 ] || cp /mnt/c/Dean/Projects/HutterPrize/enwik9 $C/work/enwik9
bash /mnt/c/Dean/Projects/HutterPrize/runs/wsl-split/neif_chroot.sh sh "rm -rf /work/r_$BLD && mkdir -p /work/r_$BLD && cd /work/r_$BLD && cp /work/$BLD/comp9 . && ln -s /work/enwik9 enwik9 && (./comp9 -e enwik9 archive9 > out.txt 2> err.txt & echo \$! > pid) ; sleep $SEC; ls -la | cut -c24- | head -n 30; echo --- out; tr '\r' '\n' < out.txt | tail -n 6 | cut -c1-200; echo --- err; tr '\r' '\n' < err.txt | tail -n 12 | cut -c1-200; grep -E 'VmHWM|VmRSS' /proc/\$(pgrep -n -f 'comp9|cmix' )/status; pkill -f 'comp9 -e'; pkill -x comp9; sleep 1; pgrep -c -f comp9"
