#!/bin/bash
# neif_e_run.sh NAME STOP PIPE [BUILD_DIR]: one run of the NORMAL compress command (`cmix -e enwik9 out`) of a
# NEIF_TEST build made by neif_e_build.sh, inside the chroot /root/noble, in /work/e/NAME.
#   STOP  NEIF_E_STOP: the coder stops behind this many stream bytes and the process ends (0 = the whole
#         stream: about 50 h in one process on this PC, do not)
#   PIPE  NEIF_PIPE: 0 = one process (the reference); 2 or 3 = the opt-in multi-process compression
#         (NOT the official run; runs/neif-par/PROGRESS.md, "Multi-process compression")
# While the coder runs, the stream it codes (out.cmix.temp) is compared with /work/bed/stream.bin.
# One line per run on stdout and in /root/noble/work/e_results.txt: exit code, size and sha256 of the coder
# output, the figures of the `neif_e:` line, wall time of the whole command.
# KILL_AFTER=s: kills the newest cmix process (a front stage of the pipeline) s seconds after the coder has
# started, to show that a broken pipeline leaves no output.
# Refuses to start while another cmix/comp9 runs.  Run in WSL as root.
set -u
C=/root/noble
NAME=${1:?}; STOP=${2:?}; PIPE=${3:?}; B=${4:-/work/tbKe}
KA=${KILL_AFTER:-0}
if pgrep -x cmix > /dev/null || pgrep -x comp9 > /dev/null; then echo "another cmix/comp9 is running"; exit 1; fi
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
O=/work/e/$NAME
rm -rf $C$O
cat > $C/work/e_run_in.sh <<EOF
mkdir -p $O && cd $O || exit 1
cp $B/e/cmix ./cmix
export PATH=.:\$PATH
export NEIF_E_STOP=$STOP
[ $PIPE -gt 1 ] && export NEIF_PIPE=$PIPE
( # the stream the coder is given, checked while it runs; then the optional kill
  while [ ! -e out ] && [ -e cmix ]; do sleep 2; done
  sleep 3
  n=\$(stat -c %s out.cmix.temp 2> /dev/null || echo 0)
  if [ "\$n" = "\$(stat -c %s /work/bed/stream.bin)" ] && cmp -s out.cmix.temp /work/bed/stream.bin; then echo "stream IDENTICAL \$n" > stream_check; else echo "stream DIFFERENT \$n" > stream_check; fi
  if [ $KA -gt 0 ]; then
    sleep $KA
    echo "killing \$(pgrep -n -x cmix) of \$(pgrep -x cmix | tr '\n' ' ')" > kill_note
    kill -9 \$(pgrep -n -x cmix)
  fi
) &
/usr/bin/time -v -o time.txt ./cmix -e /work/enwik9 out > log 2>&1
echo \$? > rc
wait
rm -f ppm.page .main* .ready4cmix out.cmix.temp .intro .coda .decomp_bin weights-*.c5 cmix
EOF
chroot $C /bin/bash /work/e_run_in.sh
D=$C$O
rc=$(cat $D/rc 2> /dev/null || echo 99)
if [ -f $D/out ]; then sz=$(stat -c %s $D/out); sha=$(sha256sum $D/out | cut -d' ' -f1); else sz=NONE; sha=NO_OUTPUT_FILE; fi
ar=no; [ -e $D/archive9 ] && ar=YES
line=$(tr '\r' '\n' < $D/log | grep -a "^neif_e: [0-9]" | tail -n 1)
wall=$(grep "Elapsed (wall" $D/time.txt | sed 's/.*): //'); rss=$(grep "Maximum resident" $D/time.txt | sed 's/.*: //')
echo "$NAME e stop $STOP pipe $PIPE rc $rc out $sz B sha256 $sha archive9 $ar $(cat $D/stream_check 2> /dev/null) | $line | command wall $wall, max rss of the first process $rss kB" | tee -a $C/work/e_results.txt
tr '\r' '\n' < $D/log | grep -a "neif_pipe\|neif_e: STOP" | cut -c1-220 | tail -n 12
[ -f $D/kill_note ] && cat $D/kill_note
exit $rc
