#!/bin/bash
# neif_mt_build.sh [BUILD_DIR] [EXTRA_DEFS]: the NEIF_MT test build of cmix-neif 2.0 (threads for the
# transformer step and, later, the speculative step: runs/neif-par/DESIGN.md, PROGRESS.md): the PGO
# test build of neif_build_test.sh (make prof_use, -DNEIF_TEST=1) with -DNEIF_MT=1 and EXTRA_DEFS,
# from the development tree as it is, into BUILD_DIR (default /work/tbmt; a path inside the chroot
# /root/noble).  Prints the functions that lost their PGO profile entry: the list must be the one
# of the reference test builds (18 entries, none of Predict/Perceive/Encode/Decode).
# Run in WSL as root.
set -eu
C=/root/noble
B=${1:-/work/tbmt}
X=${2-}
SRC=${NEIF_SRC:-/mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev}
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
rm -rf $C/work/devmt && mkdir -p $C/work/devmt
(cd "$SRC" && tar cf - --exclude=.git .) | tar xf - -C $C/work/devmt
cat > $C/work/build_mt_in.sh <<EOF
set -eu
rm -rf $B && mkdir -p $B
cd /work/devmt
cp -a src makefile encoder_split.lds runtime_exports.map pgo_data weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5 $B/
cd $B
if ! make -j8 prof_use CC="clang++-18 -DNEIF_TEST=1 -DNEIF_MT=1 $X" > build.log 2>&1; then
  grep -n "error" build.log | head -n 40; tail -n 5 build.log; exit 1
fi
echo "warnings: \$(grep -c 'warning:' build.log || true), profile mismatches: \$(grep -c 'hash mismatch' build.log || true)"
grep 'hash mismatch' build.log | sed 's/.*(hash mismatch) //; s/ Hash.*//' | sort | tr '\n' ' '; echo
grep -n "neif_mt\|attn.cpp\|model_opt.cpp\|qmat_\|runner.cpp" build.log | grep -i "warning\|error" | grep -v "hash mismatch" | head -n 20 || true
ls -la $B/cmix
sha256sum $B/cmix
EOF
chroot $C /bin/bash /work/build_mt_in.sh
