#!/bin/bash
# Start split_eval.sh detached on this pod plus the self-stop waiter.
#   ssh ... "TAG=base WEIGHTS=/workspace/split/w/6m-q4-fp32.tfwc2 bash -s" < launch_split.sh
set -u
W=/workspace
log=$W/logs/split_${TAG}.txt
nohup setsid bash $W/scripts/split_eval.sh "$TAG" "$WEIGHTS" "${K:-16}" > "$log" 2>&1 < /dev/null &
nohup setsid bash $W/scripts/selfstop.sh "$log" > /dev/null 2>&1 < /dev/null &
sleep 2
echo "started $TAG"; nproc; free -g | head -2
