#!/bin/bash
# Retry creating the Tier 0 5090 pod every 5 min (max 8 h); when created, wait for SSH and
# start run_batch.sh + selfstop.sh on it. Pod id -> /workspace/agent/tier0/pod.id
A=/workspace/agent; T=$A/tier0
JOB=${1:?job script}; JLOG=${2:?job log}
for i in $(seq 1 240); do
  [ -s $T/STOP_AUTOLAUNCH ] && { echo "$(date -u) stop file"; exit 0; }
  bal=$(bash $A/rp.sh balance | python3 -c "import json,sys;print(int(json.load(sys.stdin)['data']['myself']['clientBalance']))")
  [ "$bal" -lt 40 ] && { echo "$(date -u) balance $bal < 40, giving up"; exit 1; }
  # never two GPU pods
  if bash $A/rp.sh pods | grep -v -e hutter-agent -e hutter-linux-sub -e hutter-tune -e hutter-n2 -e hutter-n3 -e hutter-st1 -e hutter-st2 -e hutter-fullc2 -e hutter-s3 | grep -q RUNNING; then echo "$(date -u) another pod running, waiting"; sleep 120; continue; fi
  out=$(bash $A/rp.sh gpu ${POD_NAME:-hutter-tier0} ${DISK:-100} 2>&1)
  id=$(echo "$out" | python3 -c "import json,sys
try: print(json.load(sys.stdin).get('id',''))
except Exception: print('')")
  if [ -n "$id" ]; then echo "$id" > $T/pod.id; echo "$(date -u) created $id"; break; fi
  echo "$(date -u) try $i: $(echo "$out" | head -c 120)"; sleep 120
done
[ -s $T/pod.id ] || { echo "$(date -u) gave up"; exit 1; }
for j in $(seq 1 60); do
  hp=$(bash $A/rp.sh ssh $id 2>/dev/null); [ -n "$hp" ] && break; sleep 20
done
[ -z "$hp" ] && { echo "$(date -u) no ssh after 20 min"; exit 1; }
set -- $hp; sleep 20
cat > $T/remote_start.sh <<'R'
mkdir -p /workspace/logs
nohup setsid bash JOB > JLOG 2>&1 < /dev/null &
nohup setsid bash /workspace/scripts/selfstop.sh JLOG > /dev/null 2>&1 < /dev/null &
sleep 2; echo started
R
sed -i "s#JOB#$JOB#; s#JLOG#$JLOG#g" $T/remote_start.sh
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=30 root@$1 -p $2 'bash -s' < $T/remote_start.sh && echo "$(date -u) batch started on $id"
