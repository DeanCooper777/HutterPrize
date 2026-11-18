#!/bin/bash
# neif_par_build.sh [BUILD_DIR] [EXTRA_DEFS]: the NEIF_PAR measurement build of cmix-neif 2.0
# (measurements for a multi-threaded decoder: runs/neif-par/DESIGN.md, src/neif_test.h namespace par).
# The PGO test build of neif_build_test.sh (make prof_use, -DNEIF_TEST=1) with -DNEIF_PAR=1 and, by
# default, -DFX2_PROF (the per-site time table of the transformer, which neif_par_bounds.py reads
# from the log), into BUILD_DIR (default /work/tbpar; a path inside the chroot /root/noble).
# The source is a copy of the development tree with runs/neif-par/neif_par.diff on top: if the six
# files the diff changes are still the ones it was made from (runs/neif-par/base.sha256), the
# changed copies of runs/neif-par/par are taken, otherwise the diff is applied with patch.
# The development tree itself is not touched.  Heavy (a build): run it when the machine is free.
# Run in WSL as root:  bash neif_par_build.sh [/work/tbpar] ["-DFX2_PROF"]
set -eu
C=/root/noble
B=${1:-/work/tbpar}
X=${2--DFX2_PROF}
P=/mnt/c/Dean/Projects/HutterPrize
SRC=${NEIF_SRC:-$P/reference/neif2/dev}
PAR=$P/runs/neif-par
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
rm -rf $C/work/devpar && mkdir -p $C/work/devpar
(cd "$SRC" && tar cf - --exclude=.git .) | tar xf - -C $C/work/devpar
if grep -q "namespace par" $C/work/devpar/src/neif_test.h; then
  echo "neif_par: the development tree already has the NEIF_PAR changes, taken as it is"
elif (cd $C/work/devpar && sha256sum -c --quiet $PAR/base.sha256 > /dev/null 2>&1); then
  (cd $PAR/par && tar cf - src) | tar xf - -C $C/work/devpar
  echo "neif_par: the six base files are unchanged, the changed copies are taken"
else
  echo "neif_par: the development tree has moved on, applying neif_par.diff"
  cp $PAR/neif_par.diff $C/work/devpar/
  if ! chroot $C /bin/bash -c "cd /work/devpar && { command -v patch > /dev/null || apt-get install -y -q patch > /dev/null; } && patch -p1 --dry-run < neif_par.diff > /dev/null && patch -p1 < neif_par.diff"; then
    echo "neif_par: the diff does not apply to the current tree"; exit 1
  fi
fi
cat > $C/work/build_par_in.sh <<EOF
set -eu
rm -rf $B && mkdir -p $B
cd /work/devpar
cp -a src makefile encoder_split.lds runtime_exports.map pgo_data weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5 $B/
cd $B
if ! make -j8 prof_use CC="clang++-18 -DNEIF_TEST=1 -DNEIF_PAR=1 $X" > build.log 2>&1; then
  grep -n "error" build.log | head -n 40; tail -n 5 build.log; exit 1
fi
echo "warnings: \$(grep -c 'warning:' build.log || true), profile mismatches: \$(grep -c 'profile data may be out of date\|hash mismatch' build.log || true)"
grep -n "neif_test.h\|predictor.cpp\|runner.cpp\|encoder.cpp\|tf1_engine.cpp" build.log | grep -i "warn\|error" | head -n 20 || true
ls -la $B/cmix
sha256sum $B/cmix
EOF
chroot $C /bin/bash /work/build_par_in.sh
echo "neif_par: compare the count of profile mismatches with the one of the reference test build"
echo "(neif_build_test.sh; build.log there): a new mismatch means a hot function lost its profile entry."
