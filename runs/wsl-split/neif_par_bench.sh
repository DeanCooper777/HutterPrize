#!/bin/bash
# neif_par_bench.sh [FAST_CPUS] [SLOW_CPUS]: build and run neif_par_bench.cpp inside the chroot (pinned
# clang-18): stage S0b of runs/neif-par/DESIGN.md, the cost of a spinning thread pool and the scaling of
# the split dense kernel on this machine.  Uses all CPUs for about a minute: not while a timing runs.
# Output also in runs/neif-par/bench.txt.  Run in WSL as root.
C=/root/noble
if pgrep -x cmix > /dev/null || pgrep -x comp9 > /dev/null; then echo "another cmix/comp9 is running"; exit 1; fi
mkdir -p $C/work/parb
cp /mnt/c/Dean/Projects/HutterPrize/runs/wsl-split/neif_par_bench.cpp $C/work/parb/
chroot $C /bin/bash -c "cd /work/parb && clang++-18 -O3 -march=x86-64-v3 -mtune=znver2 -pthread -Wall neif_par_bench.cpp -o par_bench 2>&1 | grep -E 'error|warning' | head; ./par_bench ${1:-0,1,2,3} ${2:-4,5,6,7}" | tee /mnt/c/Dean/Projects/HutterPrize/runs/neif-par/bench.txt
echo "load: $(cat /proc/loadavg)"
