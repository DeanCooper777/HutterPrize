#!/bin/bash
# Variant build for size experiments: copy the source of /root/b_fin (already extracted), apply a sed script to the
# makefile, build OFFICIAL, report sizes.   build_var.sh NAME 'sed-expression-for-makefile' [extra env assignments]
N=$1; SED=$2; shift 2
B=/root/b_$N; rm -rf $B; mkdir -p $B
cd /root/b_fin && tar cf - --exclude='*.o' --exclude=fx2-cmix-T/run --exclude=fx2-cmix-T/pgo_data --exclude=fx2-cmix-T/cmix --exclude='*.map' fx2-cmix-T | tar xf - -C $B
cd $B/fx2-cmix-T
[ -n "$SED" ] && sed -i "$SED" makefile
grep -n "^LFLAGS :=" makefile
export OFFICIAL=1
for kv in "$@"; do export "$kv"; done
PACK_KEEP_ELF=$B/cmix.elf ./build_and_construct_comp.sh > $B/build.log 2>&1 || { echo "$N BUILD_FAILED"; grep -E "error|undefined" $B/build.log | head -8; tail -5 $B/build.log; exit 1; }
echo "$N: $(grep pack.sh: $B/build.log)  comp $(stat -c %s run/cmix) dict $(stat -c %s run/comp_dict) order $(stat -c %s run/comp_order)"
readelf -hW $B/cmix.elf | grep -E "Type:"; size -A $B/cmix.elf | grep -E "text|rodata|rela|dyn|plt|got|data|Total" | tr -s ' ' | tr '\n' ';'; echo
# quick behaviour check: plain round trip on 20 KB
T=$B/rt; mkdir -p $T; cd $T; P=/mnt/c/Dean/Projects/HutterPrize
D=$P/fx2-cmix-T/dictionary/english.dic; head -c 20000 $P/data/enwik6 > in.txt; cp $B/fx2-cmix-T/run/cmix_orig cmix
./cmix -c $D in.txt o.cmix > /dev/null 2>&1; ./cmix -d $D o.cmix back > /dev/null 2>&1; cmp back in.txt && echo "$N round trip ok $(stat -c %s o.cmix)"
