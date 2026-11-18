#!/bin/bash
# neif_build_test.sh [BUILD_DIR] [plain|pgo]: build the NEIF_TEST binary of cmix-neif 2.0 (chunk
# evaluation mode "-t", src/neif_test.h) from the development copy, with the entry's own makefile
# and per-file flags and -DNEIF_TEST=1 on every compile line (through CC, as the authors' own
# training tools are built). No packer, no embedded blocks.
#   plain:           `make cmix`      no profile, no LTO, about 20 s; its output differs from
#                    comp9 from byte 79 on (not bit-identical; fine for debugging only)
#   pgo (default):   `make prof_use`  the entry's shipped profile (pgo_data/) and LTO, as comp9 is
#                    compiled, about 2 min
# Result: BUILD_DIR/cmix plus the weights container next to it (the binary reads it from the
# working directory). BUILD_DIR is a path inside the chroot /root/noble (default /work/tbp).
# Run in WSL as root:  bash neif_build_test.sh [/work/tbp] [plain|pgo]
set -eu
C=/root/noble
B=${1:-/work/tbp}
MODE=${2:-pgo}
SRC=${NEIF_SRC:-/mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev}
case $MODE in plain) TARGET=cmix ;; pgo) TARGET=prof_use ;; *) echo "mode: plain or pgo"; exit 1 ;; esac
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
rm -rf $C/work/dev && mkdir -p $C/work/dev
(cd "$SRC" && tar cf - --exclude=.git .) | tar xf - -C $C/work/dev
cat > $C/work/build_test_in.sh <<EOF
set -eu
rm -rf $B && mkdir -p $B
cd /work/dev
cp -a src makefile encoder_split.lds runtime_exports.map pgo_data weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5 $B/
cd $B
if ! make -j8 $TARGET CC="clang++-18 -DNEIF_TEST=1" > build.log 2>&1; then
  grep -n "error" build.log | head -n 40; tail -n 5 build.log; exit 1
fi
echo "warnings: \$(grep -c 'warning:' build.log || true), profile mismatches: \$(grep -c 'profile data may be out of date\|hash mismatch' build.log || true)"
ls -la $B/cmix
sha256sum $B/cmix
EOF
chroot $C /bin/bash /work/build_test_in.sh
