#!/bin/bash
# Test build + official build from the working tree; identity check of the test build against the pod's k3 binary.
P=/mnt/c/Dean/Projects/HutterPrize
for v in test off; do B=/root/b_$v; rm -rf $B; mkdir -p $B
  cd $P && tar cf - --exclude=cmix-T-dwc/models/runB --exclude='*.tch' --exclude=cmix-T-dwc/.venv --exclude='*.o' --exclude=cmix-T-dwc/run --exclude=cmix-T-dwc/pgo_data cmix-T-dwc | tar xf - -C $B
  cd $B/cmix-T-dwc; chmod +x build_and_construct_comp.sh
  if [ $v = off ]; then export OFFICIAL=1; else unset OFFICIAL; fi
  PACK_KEEP_ELF=$B/cmix.elf ./build_and_construct_comp.sh > $B/build.log 2>&1 || { echo "$v BUILD_FAILED"; grep -E "error" $B/build.log | head -5; tail -5 $B/build.log; exit 1; }
  echo "$v: $(grep pack.sh: $B/build.log)  comp $(stat -c %s run/cmix) dict $(stat -c %s run/comp_dict) order $(stat -c %s run/comp_order)"
done
# identity: first 1 MB of the stream, st2 weights, test build vs the pod's k3 binary (one run at a time)
T=/root/idtest; rm -rf $T; mkdir -p $T; cd $T
[ -s /root/split/stream.bin ] || gunzip -c $P/runs/upload/stream.bin.gz > /root/split/stream.bin
head -c 1000000 /root/split/stream.bin > in.bin; W=$P/cmix-T-dwc/models/6m-q4-fp32.tfwc2
cp /root/b_test/cmix.elf new; cp $P/runs/wsl-split/cmix_k3 ref; chmod +x new ref
for b in new ref; do s=$(date +%s); ./$b -n in.bin $b.cmix --raw-stream --official-vocab --transformer $W > $b.log 2>&1; echo "$b rc $? $(stat -c %s $b.cmix) bytes $(( $(date +%s) - s )) s"; rm -f ppm.temp; done
cmp new.cmix ref.cmix && echo IDENTICAL_TO_POD_K3_ON_1MB
# official build: plain round trip
D=$P/cmix-T-dwc/dictionary/english.dic; head -c 20000 $P/data/enwik6 > in.txt; cp /root/b_off/cmix-T-dwc/run/cmix_orig cmix
./cmix -c $D in.txt o.cmix > /dev/null 2>&1; ./cmix -d $D o.cmix back > /dev/null 2>&1; cmp back in.txt && echo "official round trip ok $(stat -c %s o.cmix)"
