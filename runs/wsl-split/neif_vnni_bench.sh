#!/bin/bash
# neif_vnni_bench.sh [CPU] [JUNK_MB ...]: build neif_vnni_bench.cpp inside the chroot (pinned
# clang-18; also a compile-only check of the AVX-512 forms) and run it pinned to logical CPU CPU
# (default 2), twice. Output appended to runs/wsl-split/neif_vnni_bench_out.txt.
C=/root/noble
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
CPU=${1:-2}; shift
mkdir -p $C/work/vb
cp $W/neif_vnni_bench.cpp $C/work/vb/
chroot $C /bin/bash -c "cd /work/vb && clang++-18 -O3 -march=x86-64-v3 -mtune=znver2 -mavxvnni neif_vnni_bench.cpp -o vnni_bench && clang++-18 -O3 -march=x86-64-v3 -mtune=znver2 -mavxvnni -mavx512f -mavx512bw -mavx512dq -mavx512vnni -DBENCH_AVX512 neif_vnni_bench.cpp -o vnni_bench_512 && echo 'AVX-512 form compiles (not run)'" || exit 1
{
  echo "=== $(date -u +%FT%TZ) cpu $CPU junk $* load $(cat /proc/loadavg)"
  ps -eo ni,pcpu,comm --sort=-pcpu | sed -n 2,4p
  for i in 1 2; do taskset -c $CPU chroot $C /work/vb/vnni_bench "$@"; done
} 2>&1 | tee -a $W/neif_vnni_bench_out.txt
