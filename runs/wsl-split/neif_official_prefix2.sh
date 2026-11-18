#!/bin/bash
# neif_official_prefix2.sh [BYTES] [DIR] [LIMIT_S] [COMP9]: as neif_official_prefix.sh, but into DIR (default
# /work/off3 in the chroot /root/noble; /work/off with the 2 MiB prefix is left alone) and with a time
# limit that can be set (default 6000 s).  Runs the official comp9 (`-e enwik9`) until its coder output
# file has BYTES bytes (default 3 MiB, which reaches page text: about 1 h), stops it, keeps the prefix as
# DIR/out9.prefix and removes the large temporary files.  Run in WSL as root.
set -eu
C=/root/noble
WANT=${1:-3145728}; D=${2:-/work/off3}; LIM=${3:-6000}; BIN=${4:-/work/b0/comp9}
if pgrep -x cmix > /dev/null || pgrep -x comp9 > /dev/null; then echo "another cmix/comp9 is running"; exit 1; fi
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
cat > $C/work/off2_in.sh <<EOF
set -u
rm -rf $D && mkdir -p $D && cd $D
cp $BIN ./comp9
sha256sum ./comp9
( ./comp9 -e /work/enwik9 out9 > log 2>&1 ) &
t0=\$(date +%s)
while :; do
  sleep 10
  n=\$(stat -c %s out9 2> /dev/null || echo 0)
  if [ "\$n" -ge $WANT ]; then break; fi
  if ! pgrep -f "comp9 -e" > /dev/null && ! pgrep -x comp9 > /dev/null; then echo "comp9 ended early"; break; fi
  if [ \$((\$(date +%s) - t0)) -gt $LIM ]; then echo "time limit"; break; fi
done
echo "after \$((\$(date +%s) - t0)) s: out9 has \$(stat -c %s out9 2> /dev/null) B"
cp out9 out9.prefix
for p in \$(pgrep -x comp9) \$(pgrep -f "comp9 -e") \$(pgrep -f "/work/enwik9 out9"); do kill -9 \$p 2> /dev/null; done
sleep 2
tail -c 300 log; echo
rm -f ppm.page .main* .ready4cmix out9.cmix.temp
ls -la $D | head -n 30
sha256sum out9.prefix
EOF
chroot $C /bin/bash /work/off2_in.sh
