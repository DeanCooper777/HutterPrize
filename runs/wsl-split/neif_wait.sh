#!/bin/bash
# neif_wait.sh NAME [MAX_SECONDS]: wait until the chunk run /work/chunks/NAME (chroot /root/noble)
# has written its score.json or no cmix process is left; then print the result and the trace tail.
D=/root/noble/work/chunks/${1:?name}; MAX=${2:-3000}; t=0
until [ -s $D/score.json ] || ! pgrep -x cmix > /dev/null || [ $t -ge $MAX ]; do sleep 10; t=$((t + 10)); done
grep neif_trace $D/log | tail -n 3
cat $D/score.json 2> /dev/null || { echo "no score.json yet"; ps -o etimes,rss -C cmix; tail -c 200 $D/log; }
grep -E "Maximum resident|Elapsed" $D/time.txt 2> /dev/null
