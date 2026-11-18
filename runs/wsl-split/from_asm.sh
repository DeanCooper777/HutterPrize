#!/bin/bash
# Build the official binary from the assembly sources only (FROM_ASM) in a fresh copy of the
# working tree, and compare the result with the C++ build in /root/b_fin.
P=/mnt/c/Dean/Projects/HutterPrize; B=/root/b_asm
rm -rf $B; mkdir -p $B
cd $P && tar cf - --exclude=cmix-T-dwc/models/runB --exclude='*.tch' --exclude=cmix-T-dwc/.venv --exclude='*.o' --exclude=cmix-T-dwc/run --exclude=cmix-T-dwc/pgo_data cmix-T-dwc | tar xf - -C $B
cd $B/cmix-T-dwc; chmod +x build_and_construct_comp.sh
OFFICIAL=1 FROM_ASM=$B/cmix-T-dwc/asm ./build_and_construct_comp.sh > $B/build.log 2>&1 || { echo "BUILD_FAILED"; tail -n 6 $B/build.log | cut -c1-200; exit 1; }
grep -c "clang++-17.*-c src/\|\.cpp" $B/build.log | sed 's/^/build log lines that mention a .cpp file: /'
grep "pack.sh: [0-9]" $B/build.log | cut -c1-200
cmp run/cmix /root/b_fin/cmix-T-dwc/run/cmix && echo "comp9 built from assembly only is IDENTICAL to the C++ build ($(stat -c %s run/cmix) bytes)"
