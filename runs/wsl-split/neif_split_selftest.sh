#!/bin/bash
# neif_split_selftest.sh [BUILD_DIR]: a two-minute check of the mechanics of neif_split_eval.sh on
# this PC (chroot /root/noble): the first 400,000 B of the coder stream as a "stream", K = 2,
# one process at a time. Both chunks start at byte 0 (the piece lies inside the metadata block),
# so the sum of their kept bytes must equal the coded size of one run over the 400,000 B.
# (The numbers mean nothing for the model: the grammar zone ends at the cut stream's length.)
set -eu
C=/root/noble; B=${1:-/work/tbp}
if pgrep -x cmix > /dev/null || pgrep -x comp9 > /dev/null; then echo "another cmix/comp9 is running"; exit 1; fi
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
cp /mnt/c/Dean/Projects/HutterPrize/runs/wsl-split/neif_split_eval.sh $C/work/neif_split_eval.sh
cat > $C/work/selftest_in.sh <<EOF
set -eu
rm -rf /work/selftest && mkdir -p /work/selftest
head -c 400000 /work/bed/stream.bin > /work/selftest/s.bin
JOBS=1 bash /work/neif_split_eval.sh $B /work/selftest/s.bin 2 100000 /work/selftest/out
cat /work/selftest/out/total.json
EOF
chroot $C /bin/bash /work/selftest_in.sh
