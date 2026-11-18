#!/bin/bash
# neif_par_bench2.sh [MAIN_CPU] [OTHER_CPU]: build and run neif_par_bench2.cpp inside the chroot: the cost of a
# spinning second thread for the first one.  Output also in runs/neif-par/bench2.txt.  Run in WSL as root.
C=/root/noble
if pgrep -x cmix > /dev/null || pgrep -x comp9 > /dev/null; then echo "another cmix/comp9 is running"; exit 1; fi
mkdir -p $C/work/parb
cp /mnt/c/Dean/Projects/HutterPrize/runs/wsl-split/neif_par_bench2.cpp $C/work/parb/
chroot $C /bin/bash -c "cd /work/parb && clang++-18 -O2 -march=x86-64-v3 -mwaitpkg -pthread -Wall neif_par_bench2.cpp -o par_bench2 2>&1 | grep -E 'error|warning' | head; ./par_bench2 ${1:-2} ${2:-3}" | tee /mnt/c/Dean/Projects/HutterPrize/runs/neif-par/bench2.txt
