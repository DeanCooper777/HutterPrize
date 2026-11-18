#!/bin/bash
# neif_a16_build.sh [BUILD_DIR] [EXTRA_DEFS]: the PGO test build of neif_build_test.sh (make
# prof_use, -DNEIF_TEST=1) into BUILD_DIR (default /work/tb16, so that /work/tbp stays the
# reference test build), optionally with more defines, e.g. "-DFX2_PROF" for the per-site time
# table of the transformer (printed at the end of a single-process -t run).
# Run in WSL as root.
set -eu
C=/root/noble
B=${1:-/work/tb16}
X=${2:-}
SRC=/mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
rm -rf $C/work/dev16 && mkdir -p $C/work/dev16
(cd "$SRC" && tar cf - --exclude=.git .) | tar xf - -C $C/work/dev16
cat > $C/work/build_a16_in.sh <<EOF
set -eu
rm -rf $B && mkdir -p $B
cd /work/dev16
cp -a src makefile encoder_split.lds runtime_exports.map pgo_data weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5 $B/
cd $B
if ! make -j8 prof_use CC="clang++-18 -DNEIF_TEST=1 $X" > build.log 2>&1; then
  grep -n "error" build.log | head -n 40; tail -n 5 build.log; exit 1
fi
echo "warnings: \$(grep -c 'warning:' build.log || true), profile mismatches: \$(grep -c 'profile data may be out of date\|hash mismatch' build.log || true)"
grep -n "act16\|model_opt" build.log | grep -i "warn\|error" | head -n 20 || true
ls -la $B/cmix
sha256sum $B/cmix
EOF
chroot $C /bin/bash /work/build_a16_in.sh
