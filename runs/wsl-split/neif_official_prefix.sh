#!/bin/bash
# neif_official_prefix.sh [BYTES] [COMP9]: run the official comp9 (`-e enwik9`) only until its
# coder output file has BYTES bytes (default 2 MiB; the coder writes in blocks of 1 MiB and the
# file grows in whole 4-KiB blocks, so ask for a multiple of 1 MiB), then stop it and keep the
# output prefix as /work/off/out9.prefix inside the chroot /root/noble (about 20 min for 2 MiB;
# neif_off_stop.sh stops it by hand and removes its large temporary files).
# Used to compare the test build's coder output byte for byte. Run in WSL as root.
set -eu
C=/root/noble
WANT=${1:-2097152}; BIN=${2:-/work/b0/comp9}
if pgrep -x cmix > /dev/null || pgrep -x comp9 > /dev/null; then echo "another cmix/comp9 is running"; exit 1; fi
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
cat > $C/work/off_in.sh <<EOF
set -u
rm -rf /work/off && mkdir -p /work/off && cd /work/off
cp $BIN ./comp9
( ./comp9 -e /work/enwik9 out9 > log 2>&1 ) &
t0=\$(date +%s)
while :; do
  sleep 10
  n=\$(stat -c %s out9 2> /dev/null || echo 0)
  if [ "\$n" -ge $WANT ]; then break; fi
  if ! pgrep -f "comp9 -e" > /dev/null && ! pgrep -x comp9 > /dev/null; then echo "comp9 ended early"; break; fi
  if [ \$((\$(date +%s) - t0)) -gt 3000 ]; then echo "time limit"; break; fi
done
echo "after \$((\$(date +%s) - t0)) s: out9 has \$(stat -c %s out9 2> /dev/null) B"
ps -o pid,etimes,rss,cmd -C comp9 | cut -c1-120
ps aux | grep -E "comp9|memfd" | grep -v grep | cut -c1-150
cp out9 out9.prefix
pkill -f "comp9 -e" || true; pkill -x comp9 || true; sleep 2
for p in \$(pgrep -f "/work/enwik9 out9"); do kill -9 \$p; done
tail -c 300 log
ls -la /work/off | head -n 30
sha256sum out9.prefix
EOF
chroot $C /bin/bash /work/off_in.sh
