#!/bin/bash
# Official minimal build of the working tree (final version) in WSL; keeps the unpacked ELF, a link map and
# symbol sizes for packer / layout work.  Output in /root/b_fin.
P=/mnt/c/Dean/Projects/HutterPrize
B=/root/b_fin; rm -rf $B; mkdir -p $B
cd $P && tar cf - --exclude=cmix-T-dwc/models/runB --exclude='*.tch' --exclude=cmix-T-dwc/.venv --exclude='*.o' --exclude=cmix-T-dwc/run --exclude=cmix-T-dwc/pgo_data cmix-T-dwc | tar xf - -C $B
cd $B/cmix-T-dwc; chmod +x build_and_construct_comp.sh
md5sum models/6m-q4-fp32.tfwc2
export OFFICIAL=1 PACK_STUB_REGEN=${PACK_STUB_REGEN:-0}

PACK_KEEP_ELF=$B/cmix.elf ./build_and_construct_comp.sh > $B/build.log 2>&1 || { echo "BUILD_FAILED"; grep -E "error" $B/build.log | head -5; tail -5 $B/build.log; exit 1; }
echo "$(grep pack.sh: $B/build.log)  comp $(stat -c %s run/cmix) dict $(stat -c %s run/comp_dict) order $(stat -c %s run/comp_order)"
cp cmix.map cmix.sym order.ld $B/ 2>/dev/null; grep -E "compress-only|enc_only|order:" $B/build.log; python3 packer/enc_only.py list $B/cmix.sym | head -n 45
ls -la $B/cmix.elf run/cmix_orig; readelf -SW $B/cmix.elf | grep -E "^\s+\[" | head -n 40
cp $B/cmix.elf $P/packer/cmix_fin_off.elf
