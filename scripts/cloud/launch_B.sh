#!/bin/bash
# Start run_B.sh detached on this pod plus the self-stop waiter (2026-11-09).
#   ssh ... "RUN_DIR=/workspace/B B_EPOCHS=128 bash -s" < launch_B.sh
# Log: /workspace/logs/gpu_B.txt ("B rc N" then "exit N" at the end).
set -u
W=/workspace
log=$W/logs/gpu_$(basename "${RUN_DIR:?set RUN_DIR}").txt
nohup setsid bash -c '
  bash /workspace/scripts/run_B.sh
  rc=$?
  echo "=== $(date -u) B rc $rc"
  echo "exit $rc"
' > "$log" 2>&1 < /dev/null &
# NO_SELFSTOP=1 on a pod without the network volume: its disk is only
# readable while it runs, so the weights are fetched first and the pod is
# stopped by hand
[ "${NO_SELFSTOP:-0}" = 1 ] || nohup setsid bash $W/scripts/selfstop.sh "$log" > /dev/null 2>&1 < /dev/null &
sleep 2
echo "started run B, log $log"; nvidia-smi -L; df -h /root | tail -1
