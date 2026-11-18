#!/bin/bash
# neif_e_build.sh [BUILD_DIR] [DEFS]: a NEIF_TEST build of cmix-neif 2.0 that can run the NORMAL compress
# command (`cmix -e enwik9 OUT`), for the opt-in multi-process compression (NEIF_PIPE=2|3 in the
# environment; runs/neif-par/PROGRESS.md, "Multi-process compression").
# `make prof_use` (the PGO test build, DEFS default "-DNEIF_TEST=1 -DNEIF_PACKED=1") into BUILD_DIR
# (default /work/tbKe, a path inside the chroot /root/noble), then BUILD_DIR/e/cmix = that binary with
# the embedded blocks of the official comp9 appended (hint package, article order, weights container,
# 12-byte size header: the last bytes of /work/b0/comp9), which `-e` unpacks from its own file.
# The binary is not packed; `-e` finds itself as ./cmix, so a run needs BUILD_DIR/e/cmix copied into its
# working directory and "." in PATH (neif_e_run.sh does both).
# Prints the functions whose PGO profile entry was discarded (must be the 18 of the reference test builds).
# Run in WSL as root; not while a timing runs.
set -eu
C=/root/noble
B=${1:-/work/tbKe}
X=${2:--DNEIF_TEST=1 -DNEIF_PACKED=1}
SRC=${NEIF_SRC:-/mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev}
OFF=${NEIF_OFFICIAL:-/work/b0/comp9}
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
rm -rf $C/work/deve && mkdir -p $C/work/deve
(cd "$SRC" && tar cf - --exclude=.git .) | tar xf - -C $C/work/deve
cat > $C/work/build_e_in.sh <<EOF
set -eu
rm -rf $B && mkdir -p $B
cd /work/deve
cp -a src makefile encoder_split.lds runtime_exports.map pgo_data weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5 $B/
cd $B
if ! make -j8 prof_use CC="clang++-18 $X" > build.log 2>&1; then
  grep -n "error" build.log | head -n 40; tail -n 5 build.log; exit 1
fi
echo "warnings: \$(grep -c 'warning:' build.log || true), profile mismatches: \$(grep -c 'hash mismatch' build.log || true)"
grep 'hash mismatch' build.log | sed 's/.*(hash mismatch) //; s/ Hash.*//' | sort | tr '\n' ' '; echo
grep -n "runner.cpp\|neif_test.h" build.log | grep -i "warning\|error" | grep -v "hash mismatch" | head -n 20 || true
mkdir -p $B/e
python3 - $OFF $B/cmix $B/e/cmix <<'PY'
import struct, sys
off = open(sys.argv[1], 'rb').read()
d, o, w = struct.unpack('<3i', off[-12:])
tail = off[len(off) - 12 - d - o - w:]
assert 0 < d < 1 << 22 and 0 < o < 1 << 22 and 0 < w < 1 << 24, (d, o, w)
open(sys.argv[3], 'wb').write(open(sys.argv[2], 'rb').read() + tail)
print('embedded blocks of the official comp9: hint package %d B, article order %d B, weights %d B' % (d, o, w))
PY
chmod 755 $B/e/cmix
ls -la $B/cmix $B/e/cmix
sha256sum $B/cmix $B/e/cmix
EOF
chroot $C /bin/bash /work/build_e_in.sh
