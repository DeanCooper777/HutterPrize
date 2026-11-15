#!/bin/bash
# launch2.sh NAME ROUNDFILE : create cpu3m 32 (then cpu5g 32), start tune2p_job.sh ROUNDFILE + selfstop. Log /workspace/logs/tune2_NAME_launch.txt
A=/workspace/agent; NAME=$1; RF=$2; JL=/workspace/logs/s3_$NAME.txt; id=""
for i in $(seq 1 40); do
  fl=${FLAVOR:-cpu3m}; [ -z "${FLAVOR:-}" ] && [ $i -gt 10 ] && fl=cpu5g
  out=$(bash $A/rp.sh cpu $NAME $fl 32 2>&1)
  id=$(echo "$out" | python3 -c "import json,sys
try: print(json.load(sys.stdin).get('id',''))
except Exception: print('')")
  [ -n "$id" ] && { echo "$id" > $A/s3/$NAME.id; echo "$(date -u) created $id ($fl 32)"; break; }
  echo "$(date -u) try $i $fl: $(echo "$out" | head -c 100)"; sleep 120
done
[ -n "$id" ] || { echo "$(date -u) gave up"; exit 1; }
for j in $(seq 1 60); do hp=$(bash $A/rp.sh ssh $id 2>/dev/null); [ -n "$hp" ] && break; sleep 20; done
[ -z "$hp" ] && { echo "$(date -u) no ssh: deleting $id"; bash $A/rp.sh delete $id; exit 1; }
set -- $hp; sleep 20
printf "mkdir -p /workspace/logs\nnohup setsid bash /workspace/agent/s3/s3_job.sh $RF > $JL 2>&1 < /dev/null &\nnohup setsid bash /workspace/scripts/selfstop.sh $JL > /dev/null 2>&1 < /dev/null &\nsleep 2; echo started\n" > /tmp/t2start_$NAME.sh
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=30 root@$1 -p $2 'bash -s' < /tmp/t2start_$NAME.sh && echo "$(date -u) job started on $id"
