#!/bin/bash
# create the k3 CPU pod (cpu3m 32 for 30 min of retries, then cpu5g 32), start k3_job.sh + selfstop. Log /workspace/logs/k3_launch.txt
A=/workspace/agent; id=""
for i in $(seq 1 40); do
  fl=cpu3m; [ $i -gt 15 ] && fl=cpu5g
  out=$(bash $A/rp.sh cpu hutter-c2split $fl 32 2>&1)
  id=$(echo "$out" | python3 -c "import json,sys
try: print(json.load(sys.stdin).get('id',''))
except Exception: print('')")
  [ -n "$id" ] && { echo "$id" > $A/c2split.pod.id; echo "$(date -u) created $id ($fl 32)"; break; }
  echo "$(date -u) try $i $fl: $(echo "$out" | head -c 100)"; sleep 120
done
[ -n "$id" ] || { echo "$(date -u) gave up"; exit 1; }
for j in $(seq 1 60); do hp=$(bash $A/rp.sh ssh $id 2>/dev/null); [ -n "$hp" ] && break; sleep 20; done
[ -z "$hp" ] && { echo "$(date -u) no ssh"; exit 1; }
set -- $hp; sleep 20
printf 'mkdir -p /workspace/logs\nnohup setsid bash /workspace/agent/c2exp_split_job.sh > /workspace/logs/c2split_job.txt 2>&1 < /dev/null &\nnohup setsid bash /workspace/scripts/selfstop.sh /workspace/logs/c2split_job.txt > /dev/null 2>&1 < /dev/null &\nsleep 2; echo started\n' > /tmp/k3start.sh
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=30 root@$1 -p $2 'bash -s' < /tmp/k3start.sh && echo "$(date -u) job started on $id"
