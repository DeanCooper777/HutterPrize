#!/bin/bash
# neif_cmp_off.sh NAME...: compare the kept coder output of chunk runs from stream byte 0
# (/work/chunks/NAME/run/out.cmix in the chroot /root/noble) byte for byte with the prefix of the
# official comp9's coder output (/work/off/out9.prefix, 2 MiB, neif_official_prefix.sh), over the
# bytes both have; the last 8 bytes of a finished test run are the coder's flush and are left out.
O=/root/noble/work/off/out9.prefix
for n in "$@"; do
  T=/root/noble/work/chunks/$n/run/out.cmix
  a=$(stat -c %s $T); b=$(stat -c %s $O); m=$((a - 8)); [ $m -le $b ] || m=$b
  if cmp -n $m $T $O; then echo "$n: IDENTICAL to the official comp9 output over the first $m bytes (test output $a B)"; else echo "$n: DIFFERENT"; fi
done
