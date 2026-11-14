#!/bin/bash
# Full submission build in WSL from the Windows working tree, with the pk packer.
set -e
P=/mnt/c/Dean/Projects/HutterPrize; B=/root/build; rm -rf $B; mkdir -p $B
cd $P && tar cf - --exclude=fx2-cmix-T/models/runB --exclude='*.tch' --exclude=fx2-cmix-T/.venv --exclude='*.o' --exclude=fx2-cmix-T/run --exclude=fx2-cmix-T/pgo_data fx2-cmix-T | tar xf - -C $B
cd $B/fx2-cmix-T; ls models | head; chmod +x build_and_construct_comp.sh
( time ./build_and_construct_comp.sh ) > $B/build.log 2>&1 || { echo BUILD_FAILED; tail -25 $B/build.log; exit 1; }
grep -E "check passed|no reciprocal|pack.sh:|^real" $B/build.log
ls -la run/cmix run/cmix_orig
