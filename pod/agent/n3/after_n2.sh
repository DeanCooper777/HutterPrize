#!/bin/bash
# wait for the N2 CPU pod to finish (EXITED with its log ending "exit"), delete it, then create
# the N3 CPU pod (cpu3m 32, $1.76/h) and start n3_job.sh + selfstop. Log: /workspace/logs/n3_after.txt
A=/workspace/agent; N2ID=z110qxvwo14c4k
until bash $A/rp.sh pods | grep -q "$N2ID hutter-n2 EXITED"; do sleep 60; done
grep -q "^exit" /workspace/logs/n2_split.txt && echo "$(date -u) n2 done" || echo "$(date -u) n2 pod EXITED without exit line"
bash $A/rp.sh delete $N2ID; echo "$(date -u) n2 pod deleted"
bal=$(bash $A/rp.sh balance | python3 -c "import json,sys;print(int(json.load(sys.stdin)['data']['myself']['clientBalance']))")
[ "$bal" -lt 10 ] && { echo "balance $bal < 10, not starting N3"; exit 1; }
out=$(bash $A/rp.sh cpu hutter-n3 cpu3m 32); id=$(echo "$out" | python3 -c "import json,sys;print(json.load(sys.stdin).get('id',''))")
[ -z "$id" ] && { echo "create failed: $out" | head -c 300; exit 1; }
echo $id > $A/n3/pod.id; echo "$(date -u) created $id"
for i in $(seq 1 60); do hp=$(bash $A/rp.sh ssh $id 2>/dev/null); [ -n "$hp" ] && break; sleep 10; done
set -- $hp; sleep 20
cat > /tmp/n3_start.sh <<'R'
nohup setsid bash /workspace/agent/n3/n3_job.sh > /workspace/logs/n3_job.txt 2>&1 < /dev/null &
nohup setsid bash /workspace/scripts/selfstop.sh /workspace/logs/n3_job.txt > /dev/null 2>&1 < /dev/null &
sleep 2; echo started
R
ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=30 root@$1 -p $2 'bash -s' < /tmp/n3_start.sh && echo "$(date -u) n3 job started on $id"
