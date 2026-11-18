#!/bin/bash
# neif_par_s0c.sh [SECONDS] [BUILD_DIR] [CPU]: stage S0c of runs/neif-par/DESIGN.md: does the test flavour
# DECODE what the official comp9 wrote?  The test build's decompressor (`cmix -d`) is run on the
# prefix of the official coder output (/work/off/out9.prefix in the chroot /root/noble, 2 MiB,
# written by the official comp9: neif_official_prefix.sh) for SECONDS seconds (default 900), then
# stopped, and the stream it has decoded so far (its temporary file) is compared byte for byte with
# the stream the official compressor coded (/work/bed/stream.bin).  A decoder whose arithmetic
# differs from the official compressor's in one bit leaves the stream within a few bytes.
# The 2 MiB prefix covers about the first 11 MB of the stream (the metadata blocks; page text
# starts at 13.0 MB), so this run cannot reach page text.
# Run in WSL as root.
set -u
C=/root/noble
SEC=${1:-900}; B=${2:-/work/tbpar0}; CPU=${3:-2}
if pgrep -x cmix > /dev/null || pgrep -x comp9 > /dev/null; then echo "another cmix/comp9 is running"; exit 1; fi
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
cat > $C/work/s0c_in.sh <<EOF
set -u
rm -rf /work/s0c && mkdir -p /work/s0c && cd /work/s0c
ln -sf $B/weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5 .
( $B/cmix -d /work/off/out9.prefix dec.out > log 2>&1 ) &
sleep $SEC
for p in \$(pgrep -x cmix); do kill -9 \$p; done
sleep 2
ls -la /work/s0c | head -n 20
tail -c 400 log; echo
T=\$(ls -S /work/s0c/*.temp 2> /dev/null | head -n 1)
[ -n "\$T" ] || { echo "no decoded stream file"; exit 1; }
n=\$(stat -c %s "\$T")
echo "decoded stream file \$T: \$n bytes in $SEC s"
if cmp -n \$n "\$T" /work/bed/stream.bin; then echo "S0C: the \$n decoded bytes are IDENTICAL to the stream the official compressor coded"
else echo "S0C: DIFFERENT"; cmp -n \$n "\$T" /work/bed/stream.bin | head -n 2; fi
rm -f /work/s0c/ppm.page
EOF
taskset -c $CPU chroot $C /bin/bash /work/s0c_in.sh
