#!/bin/bash
# launch_fin.sh: rent one CPU machine, wait until it is reachable, and start one of the long
# test scripts of this directory on it. Run from the always-on control machine; relies on
# helper scripts that live on that machine and are not part of this repository.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# launch_fin.sh NAME VCPU SCRIPT "FLAVOR FLAVOR ..."   (run detached on hutter-agent)
# Create one CPU pod (first flavor with capacity, retry every 2 min), wait for ssh (delete the
# pod and retry if it has none after 12 min), then pipe /workspace/scripts/SCRIPT into it.
# Log: /workspace/logs/fin_NAME_launch.txt (redirect by the caller). Pod id -> agent/fin/NAME.id
A=/workspace/agent; NAME=$1; VC=$2; SC=/workspace/scripts/$3; FLS=${4:-"cpu5g cpu3g"}
mkdir -p $A/fin
for i in $(seq 1 120); do
  for fl in $FLS; do
    bal=$(bash $A/rp.sh balance | python3 -c "import json,sys;print(int(json.load(sys.stdin)['data']['myself']['clientBalance']))")
    [ "$bal" -lt 15 ] && { echo "$(date -u) balance $bal < 15, giving up"; exit 1; }
    out=$(bash $A/rp.sh cpu $NAME $fl $VC 2>&1)
    id=$(echo "$out" | python3 -c "import json,sys
try: print(json.load(sys.stdin).get('id',''))
except Exception: print('')")
    if [ -z "$id" ]; then echo "$(date -u) try $i $fl: $(echo "$out" | head -c 90)"; continue; fi
    echo "$id" > $A/fin/$NAME.id; echo "$(date -u) created $id ($fl $VC)"
    hp=""; for j in $(seq 1 36); do hp=$(bash $A/rp.sh ssh $id 2>/dev/null); [ -n "$hp" ] && break; sleep 20; done
    if [ -z "$hp" ]; then echo "$(date -u) no ssh after 12 min: deleting $id"; bash $A/rp.sh delete $id; continue; fi
    set -- $hp; sleep 20
    echo "$(date -u) ssh $1 $2"
    ssh -o StrictHostKeyChecking=no -o ConnectTimeout=30 root@$1 -p $2 'bash -s' < $SC && { echo "$(date -u) job started on $id"; exit 0; }
    echo "$(date -u) ssh start failed on $id: deleting"; bash $A/rp.sh delete $id
  done
  sleep 120
done
echo "$(date -u) gave up"
