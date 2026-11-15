#!/bin/bash
# Full submission build in WSL from the Windows working tree, with the pk packer.
set -e
P=/mnt/c/Dean/Projects/HutterPrize; B=/root/build; rm -rf $B; mkdir -p $B
cd $P && tar cf - --exclude=cmix-T-dwc/models/runB --exclude='*.tch' --exclude=cmix-T-dwc/.venv --exclude='*.o' --exclude=cmix-T-dwc/run --exclude=cmix-T-dwc/pgo_data cmix-T-dwc | tar xf - -C $B
cd $B/cmix-T-dwc; ls models | head; chmod +x build_and_construct_comp.sh
( time ./build_and_construct_comp.sh ) > $B/build.log 2>&1 || { echo BUILD_FAILED; tail -25 $B/build.log; exit 1; }
grep -E "check passed|no reciprocal|pack.sh:|^real" $B/build.log
ls -la run/cmix run/cmix_orig
