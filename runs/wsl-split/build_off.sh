#!/bin/bash
# Official (minimal) build in WSL + checks against the test build in /root/build.
P=/mnt/c/Dean/Projects/HutterPrize; B=/root/build_off; rm -rf $B; mkdir -p $B
cd $P && tar cf - --exclude=cmix-T-dwc/models/runB --exclude='*.tch' --exclude=cmix-T-dwc/.venv --exclude='*.o' --exclude=cmix-T-dwc/run --exclude=cmix-T-dwc/pgo_data cmix-T-dwc | tar xf - -C $B
cd $B/cmix-T-dwc; chmod +x build_and_construct_comp.sh
OFFICIAL=1 ./build_and_construct_comp.sh > $B/build.log 2>&1 || { echo BUILD_FAILED; grep -E "error" $B/build.log | head; tail -8 $B/build.log; exit 1; }
grep -E "pack.sh:" $B/build.log
ls -la run/cmix run/cmix_orig /root/build/cmix-T-dwc/run/cmix /root/build/cmix-T-dwc/run/cmix_orig | awk '{print $5, $9}'
D=$P/cmix-T-dwc/dictionary/english.dic; T=/root/offtest; rm -rf $T; mkdir -p $T/o $T/t; head -c 20000 $P/data/enwik6 > $T/in.txt
cp run/cmix_orig $T/o/cmix; cp /root/build/cmix-T-dwc/run/cmix_orig $T/t/cmix
for d in o t; do (cd $T/$d; ./cmix -c $D ../in.txt out.cmix > /dev/null 2>&1; ./cmix -d $D out.cmix back > /dev/null 2>&1; cmp back ../in.txt && echo "$d round trip ok $(stat -c %s out.cmix) $(md5sum < out.cmix | cut -c1-10)"); done
cd $T/o; ./cmix --raw-stream x y > /dev/null 2>&1; echo "official with a long option: rc $?"
