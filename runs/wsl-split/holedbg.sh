#!/bin/bash
# Debug the decompressor form: zero the hole in the unpacked ELF and run -d under gdb (if present)
# or catch the fault address from dmesg/strace.  holedbg.sh ELF HOLE_LO HOLE_HI SYMFILE
P=/mnt/c/Dean/Projects/HutterPrize; T=/root/hd; rm -rf $T; mkdir -p $T; cd $T
IN=$1; HL=$2; HH=$3; SYM=$4
{ head -c $HL $IN; head -c $((HH - HL)) /dev/zero; tail -c +$((HH + 1)) $IN; } > z.elf; chmod +x z.elf
D=$P/cmix-T-dwc/dictionary/english.dic; head -c 20000 $P/data/enwik6 > in.txt
$IN -c $D in.txt o.cmix > /dev/null 2>&1
./z.elf -d $D o.cmix back > z.log 2>&1; echo "zeroed-hole ELF -d rc $?"; cmp back in.txt && echo "zeroed-hole ELF decodes OK"
if command -v gdb > /dev/null; then
  gdb -q -batch -ex run -ex bt -ex "info registers rip" --args ./z.elf -d $D o.cmix back 2>&1 | grep -v "^pretrain\|^\[New\|^\[Thread" | tail -n 12 | cut -c1-200
else echo "no gdb"; fi
off=$(readelf -SW $IN | sed 's/\[ *[0-9]*\]//' | awk '$1 == ".text" { print $3, $4 }'); echo "text addr/off: $off; hole file range $HL..$HH"
