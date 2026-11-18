#!/bin/bash
# neif_a16_bench.sh: build and run neif_a16_bench.cpp inside the chroot (pinned clang-18).
C=/root/noble
mkdir -p $C/work/a16b
cp /mnt/c/Dean/Projects/HutterPrize/runs/wsl-split/neif_a16_bench.cpp $C/work/a16b/
chroot $C /bin/bash -c "cd /work/a16b && clang++-18 -O3 -march=x86-64-v3 -mtune=znver2 neif_a16_bench.cpp -o a16_bench && ./a16_bench && ./a16_bench"
echo "load: $(cat /proc/loadavg), cmix processes: $(pgrep -x cmix | wc -l)"
