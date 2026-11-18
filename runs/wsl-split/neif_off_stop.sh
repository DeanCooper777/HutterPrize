#!/bin/bash
# neif_off_stop.sh: stop the official comp9 started by neif_official_prefix.sh, keep the prefix of
# its coder output (/work/off/out9.prefix in the chroot) and remove its large temporary files.
cd /root/noble/work/off || exit 1
[ -s out9.prefix ] || cp out9 out9.prefix
for p in $(pgrep -x comp9) $(pgrep -f "^./comp9 -e"); do kill -9 "$p" 2> /dev/null; done
sleep 2
ps -eo pid,etimes,rss,args | grep -E "comp9|cmix" | grep -v grep | cut -c1-100
ls -la out9.prefix; sha256sum out9.prefix
rm -f ppm.page .main* .ready4cmix out9.cmix.temp
du -sh /root/noble/work/off
