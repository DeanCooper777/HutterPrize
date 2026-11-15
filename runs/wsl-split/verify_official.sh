#!/bin/bash
# Full verification of the official build under WSL: compress enwik9 with run/cmix (= comp9), then
# decompress the archive in a separate directory and compare md5. Runs in the FOREGROUND of the
# wsl.exe session that starts it (a WSL VM pauses its processes when no session is attached).
#   verify_official.sh [BUILD_DIR]     default /root/b_fin/cmix-T-dwc
# Log: /root/verify/log.txt, mirrored to runs/verify-official/log.txt in the repository (Windows
# side) after every phase; memory samples in /root/verify/rss.log.
set -u
P=/mnt/c/Dean/Projects/HutterPrize; B=${1:-/root/b_fin/cmix-T-dwc}; R=/root/verify; W=$P/runs/verify-official
mkdir -p $W; rm -rf $R; mkdir -p $R/c9 $R/d9
log=$R/log.txt; t() { date "+%F %T %Z"; }; say() { echo "$(t) $*" | tee -a $log; cp -f $log $W/log.txt; }
command -v /usr/bin/time > /dev/null || apt-get install -y -q time > /dev/null 2>&1
say "verification of the official build; comp9 = $B/run/cmix ($(stat -c %s $B/run/cmix) bytes, md5 $(md5sum $B/run/cmix | cut -c1-32))"
say "host: $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | xargs); $(nproc) cpus; $(free -g | awk 'NR == 2 { print $2 }') GB"
cp $B/run/cmix $R/c9/cmix; cp $P/enwik9 $R/c9/enwik9
[ "$(md5sum $R/c9/enwik9 | cut -c1-32)" = e206c3450ac99950df65bf70ef61a12d ] || { say "enwik9 md5 WRONG"; exit 1; }
# memory sampler (once a minute)
( while true; do for p in $(pgrep -x cmix) $(pgrep -x archive9); do
    echo "$(date +%F_%T) pid $p $(grep -E 'VmHWM|VmRSS|RssAnon|RssFile' /proc/$p/status | tr -s '\t \n' ' ')" >> $R/rss.log; done; sleep 60; done ) &
SAMPLER=$!
# progress mirror (every 10 minutes) so the state can be read from Windows
( while true; do sleep 600; { tail -n 3 $log; echo "c9: $(tail -c 40 $R/c9/progress.log 2> /dev/null | tr '\r\n' '  ')"; echo "d9: $(tail -c 40 $R/d9/progress.log 2> /dev/null | tr '\r\n' '  ')"; date; } > $W/progress.txt; done ) &
MIRROR=$!

say "compress start"
cd $R/c9; s=$(date +%s)
/usr/bin/time -v ./cmix -e enwik9 enwik9.comp > $R/comp.log 2> $R/comp.time; rc=$?
say "compress rc $rc, $(( ($(date +%s) - s) / 60 )) min, $(grep 'Maximum resident' $R/comp.time | xargs), $(grep 'Elapsed' $R/comp.time | xargs)"
if [ $rc != 0 ] || [ ! -s archive9 ]; then say "COMPRESS FAILED: $(tail -c 300 $R/comp.log | tr '\r' '\n' | tail -n 2)"; kill $SAMPLER $MIRROR; exit 1; fi
say "comp9 $(stat -c %s cmix) archive9 $(stat -c %s archive9) S $(( $(stat -c %s cmix) + $(stat -c %s archive9) )) enwik9.comp $(stat -c %s enwik9.comp)"
cp archive9 $R/d9/archive9; cp archive9 $R/archive9.keep
rm -f $R/c9/enwik9 $R/c9/*.temp $R/c9/.main* $R/c9/un1 $R/c9/.ready4cmix

say "decompress start"
cd $R/d9; s=$(date +%s)
/usr/bin/time -v ./archive9 > $R/decomp.log 2> $R/decomp.time; rc=$?
say "decompress rc $rc, $(( ($(date +%s) - s) / 60 )) min, $(grep 'Maximum resident' $R/decomp.time | xargs), $(grep 'Elapsed' $R/decomp.time | xargs)"
if [ "$(md5sum enwik9_uncompressed 2> /dev/null | cut -c1-32)" = e206c3450ac99950df65bf70ef61a12d ]; then say "VERIFIED: enwik9_uncompressed == enwik9"; else say "MISMATCH or missing output"; fi
cp -f $R/comp.time $R/decomp.time $R/rss.log $W/ 2> /dev/null
kill $SAMPLER $MIRROR 2> /dev/null
say "done"
