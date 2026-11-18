#!/bin/bash
# neif_cmp_prefix.sh NAME [WAIT_BYTES]: compare the coder output of the chunk run
# /work/chunks/NAME (chroot /root/noble; a run from stream byte 0 with KEEP=1) byte for byte with
# the prefix of the official comp9's coder output (/work/off/out9.prefix, neif_official_prefix.sh)
# over the bytes both have. With WAIT_BYTES, first waits (up to 170 s) until the test output has
# that many bytes.
T=/root/noble/work/chunks/${1:?name}/run/out.cmix; O=/root/noble/work/off/out9.prefix
W=${2:-0}; t=0
while [ "$(stat -c %s $T 2> /dev/null || echo 0)" -lt "$W" ] && [ $t -lt 170 ]; do sleep 5; t=$((t + 5)); done
a=$(stat -c %s $T); b=$(stat -c %s $O); n=$((a < b ? a : b))
# a finished test run ends with the coder's flush bytes, which a longer run does not have
[ -s "$(dirname $(dirname $T))/score.json" ] && [ $a -le $b ] && n=$((a - 8))
echo "test output $a B, official prefix $b B, comparing the first $n B"
if cmp -n $n $T $O; then echo "IDENTICAL over $n bytes"; else echo "DIFFERENT"; fi
