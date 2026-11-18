#!/bin/bash
# launch_s3_loop.sh NAME "TAG TUNE": alternate cpu5g / cpu3m 32 every 2 min; if a pod has no ssh after 12 min, delete it
# and keep trying (max ~8 h); start s3_job.sh + selfstop. Log /workspace/logs/k4_NAME_launch.txt
A=/workspace/agent; NAME=$1; RF=$2; JL=/workspace/logs/k4_$NAME.txt
for i in $(seq 1 200); do
  fl=cpu3m; [ $((i % 2)) = 0 ] && fl=cpu5g
  bal=$(bash $A/rp.sh balance | python3 -c "import json,sys;print(int(json.load(sys.stdin)['data']['myself']['clientBalance']))")
  [ "$bal" -lt 20 ] && { echo "$(date -u) balance $bal < 20, giving up"; exit 1; }
  out=$(bash $A/rp.sh cpu $NAME $fl 32 2>&1)
  id=$(echo "$out" | python3 -c "import json,sys
try: print(json.load(sys.stdin).get('id',''))
except Exception: print('')")
  if [ -z "$id" ]; then echo "$(date -u) try $i $fl: $(echo "$out" | head -c 90)"; sleep 120; continue; fi
  echo "$id" > $A/k4/$NAME.id; echo "$(date -u) created $id ($fl 32)"
  hp=""; for j in $(seq 1 36); do hp=$(bash $A/rp.sh ssh $id 2>/dev/null); [ -n "$hp" ] && break; sleep 20; done
  if [ -z "$hp" ]; then echo "$(date -u) no ssh after 12 min: deleting $id"; bash $A/rp.sh delete $id; continue; fi
  set -- $hp; sleep 20
  printf "mkdir -p /workspace/logs\nnohup setsid bash /workspace/agent/k4/k4_job.sh $RF > $JL 2>&1 < /dev/null &\nnohup setsid bash /workspace/scripts/selfstop.sh $JL > /dev/null 2>&1 < /dev/null &\nsleep 2; echo started\n" > /tmp/k4start_$NAME.sh
  ssh -o StrictHostKeyChecking=no -o ConnectTimeout=30 root@$1 -p $2 'bash -s' < /tmp/k4start_$NAME.sh && { echo "$(date -u) job started on $id"; exit 0; }
  echo "$(date -u) ssh start failed on $id: deleting"; bash $A/rp.sh delete $id
done
echo "$(date -u) gave up"
