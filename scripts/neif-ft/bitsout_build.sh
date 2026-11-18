#!/bin/bash
# bitsout_build.sh: testing tool (not part of any submitted program).
# bitsout_build.sh prep | syntax | build [plain|pgo]
#   The bit-dump tool of cmix-neif 2.0 (NEIF_TF_OFF / NEIF_BITS_OUT in mode -t), built from a
#   COPY of the development tree with runs/neif-ft/neif_bitsout.diff applied; the development
#   tree itself is not changed.
#   prep:   copy the tree to /work/bitsout_src inside the chroot /root/noble and apply the diff
#   syntax: clang -fsyntax-only of the three changed translation units with the makefile's own
#           flags and -DNEIF_TEST=1 -DNEIF_BITS_DUMP=1 (seconds, one core; no binary)
#   build:  the test build into /work/tbbits (as runs/wsl-split/neif_build_test.sh does, with
#           the second macro): plain = about 20 s, pgo = profile + LTO as comp9 (default)
# The chunk test build (-DNEIF_TEST=1 alone, /work/tbtap) is a different binary and unaffected.
# Run in WSL as root.  `build` is a large job: one at a time on this PC.
set -eu
C=/root/noble
D=/mnt/c/Dean/Projects/HutterPrize
SRC=${NEIF_SRC:-$D/reference/neif2/dev}
B=/work/tbbits
DEFS="-DNEIF_TEST=1 -DNEIF_BITS_DUMP=1"
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
case ${1:-prep} in
prep)
  rm -rf $C/work/bitsout_src && mkdir -p $C/work/bitsout_src
  (cd "$SRC" && tar cf - --exclude=.git .) | tar xf - -C $C/work/bitsout_src
  (cd $C/work/bitsout_src && patch -p1 < $D/runs/neif-ft/neif_bitsout.diff)
  ;;
syntax)
  cat > $C/work/bitsout_syntax_in.sh <<EOF
set -u
cd /work/bitsout_src
make -n -B cmix CC="clang++-18 $DEFS" 2>/dev/null > /work/bitsout_make_n.txt
rc=0
for f in src/coder/encoder.cpp src/predictor.cpp src/runner.cpp; do
  line=\$(grep -- " -c\\( \\|\$\\)" /work/bitsout_make_n.txt | grep -- "\$f" | head -n 1)
  [ -n "\$line" ] || { echo "no compile line for \$f"; rc=1; continue; }
  # the compile line without its output, its -c and its source files, then this one file
  cmd="\$(echo "\$line" | sed -e 's/ -o [^ ]*//' -e 's/ -c\\( \\|\$\\)/ /' -e 's# src/[^ ]*\\.cpp##g') -fsyntax-only \$f"
  if nice -n 19 bash -c "\$cmd" 2> /work/bitsout_syntax.err; then echo "syntax ok: \$f"; else echo "SYNTAX ERROR: \$f"; grep -m 12 "error" /work/bitsout_syntax.err; rc=1; fi
done
exit \$rc
EOF
  chroot $C /bin/bash /work/bitsout_syntax_in.sh
  ;;
build)
  MODE=${2:-pgo}
  case $MODE in plain) TARGET=cmix ;; pgo) TARGET=prof_use ;; *) echo "mode: plain or pgo"; exit 1 ;; esac
  if pgrep -x cmix > /dev/null || pgrep -x comp9 > /dev/null; then echo "another cmix/comp9 is running"; exit 1; fi
  cat > $C/work/bitsout_build_in.sh <<EOF
set -eu
rm -rf $B && mkdir -p $B
cd /work/bitsout_src
cp -a src makefile encoder_split.lds runtime_exports.map pgo_data weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5 $B/
cd $B
if ! make -j8 $TARGET CC="clang++-18 $DEFS" > build.log 2>&1; then
  grep -n "error" build.log | head -n 40; tail -n 5 build.log; exit 1
fi
echo "warnings: \$(grep -c 'warning:' build.log || true), profile mismatches: \$(grep -c 'profile data may be out of date\|hash mismatch' build.log || true)"
ls -la $B/cmix; sha256sum $B/cmix
EOF
  chroot $C /bin/bash /work/bitsout_build_in.sh
  ;;
esac
