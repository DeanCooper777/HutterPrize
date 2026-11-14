#!/bin/bash
# Runs the stripped packed executable and the original side by side.
P=/mnt/c/Dean/Projects/HutterPrize; rm -rf /root/pk; mkdir -p /root/pk/a /root/pk/b; cd /root/pk
cp $P/packer/cmix_packed a/cmix; cp $P/packer/cmix_st2.elf b/cmix; chmod +x a/cmix b/cmix
D=$P/fx2-cmix-T/dictionary/english.dic; head -c 20000 $P/data/enwik6 > in.txt
for d in a b; do cd /root/pk/$d
  ./cmix > noargs.txt 2>&1; echo "$d noargs rc $? md5 $(md5sum < noargs.txt | cut -c1-10)"
  s=$(date +%s.%N); ./cmix -c $D ../in.txt out.cmix > log.txt 2>&1; rc=$?; e=$(date +%s.%N)
  echo "$d compress rc $rc size $(stat -c %s out.cmix 2>/dev/null) md5 $(md5sum < out.cmix | cut -c1-10) time $(echo "$e - $s" | bc 2>/dev/null || echo "$s $e")"
  ./cmix -d $D out.cmix back.txt > /dev/null 2>&1; cmp back.txt ../in.txt && echo "$d round trip ok"
done
cmp /root/pk/a/out.cmix /root/pk/b/out.cmix && echo PACKED_OUTPUT_IDENTICAL_TO_ORIGINAL
