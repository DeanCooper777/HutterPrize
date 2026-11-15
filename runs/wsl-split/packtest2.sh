#!/bin/bash
# Pack an already built ELF with the working tree's packer and run it: packtest2.sh ELF "HOLE_LO HOLE_HI"
# Checks the full form (compress + decompress of 20 KB) and the decompressor's form (decompress).
P=/mnt/c/Dean/Projects/HutterPrize; T=/root/pt2; rm -rf $T; mkdir -p $T; cd $T
PACK_STUB_REGEN=${3:-0} PACK_HOLE="${2:-0 0}" bash $P/cmix-T-dwc/packer/pack.sh $1 $T/cmix 2>&1 | grep -E "pack.sh|FAILED|rror" | cut -c1-220
[ -x cmix ] || exit 1
CUT=$(cat cmix.cut); D=$P/cmix-T-dwc/dictionary/english.dic; head -c 20000 $P/data/enwik6 > in.txt
./cmix -c $D in.txt o.cmix > c.log 2>&1; echo "full form compress rc $? size $(stat -c %s o.cmix 2>/dev/null)"
./cmix -d $D o.cmix back > d.log 2>&1; cmp back in.txt && echo "full form round trip OK"
if [ "$CUT" -gt 0 ]; then
  head -c $CUT cmix > dcmix; printf '\001' | dd of=dcmix bs=1 seek=9 conv=notrunc 2> /dev/null; chmod +x dcmix
  python3 -c "import struct; f = open('dcmix', 'r+b'); f.seek(96); f.write(struct.pack('<Q', $CUT)); f.close()"
  ./dcmix -d $D o.cmix back2 > d2.log 2>&1; echo "decompressor form rc $?"; cmp back2 in.txt && echo "decompressor form decodes OK ($(stat -c %s dcmix) bytes)"
  ./dcmix -c $D in.txt o2.cmix > c2.log 2>&1; echo "decompressor form asked to compress: rc $? (a crash is expected)"
fi
$1 -c $D in.txt ref.cmix > /dev/null 2>&1; cmp ref.cmix o.cmix && echo "same output as the unpacked ELF"
ls -la cmix
