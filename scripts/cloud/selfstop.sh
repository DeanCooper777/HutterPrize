#!/bin/bash
# Stop this pod once a run's log has its final "exit" line, so a finished
# pod does not sit idle and bill. Start it detached on the pod:
#   nohup setsid bash /workspace/scripts/selfstop.sh /workspace/logs/runA.txt \
#       > /dev/null 2>&1 < /dev/null &
# It uses the pod-scoped key RunPod puts in the container environment (read
# from process 1, because SSH sessions do not inherit it). That key is
# refused by the REST API (403) but accepted by GraphQL, whose podStop
# mutation stops the pod (2026-11-08). The image's runpodctl is too old to
# take the key from the environment.
set -u
log=${1:?usage: selfstop.sh RUN_LOG}
set -a
source <(tr '\0' '\n' < /proc/1/environ | grep -E '^RUNPOD_(API_KEY|POD_ID)=')
set +a
out=/workspace/logs/selfstop_$RUNPOD_POD_ID.txt
echo "$(date -u) waiting for 'exit' in $log" >> "$out"
until grep -q '^exit' "$log" 2> /dev/null; do sleep 60; done
sleep 30
echo "$(date -u) run done ($(grep '^exit' "$log")); stopping pod $RUNPOD_POD_ID" >> "$out"
curl -s -H 'Content-Type: application/json' -H "Authorization: Bearer $RUNPOD_API_KEY" \
  -d "{\"query\":\"mutation { podStop(input: {podId: \\\"$RUNPOD_POD_ID\\\"}) { id desiredStatus } }\"}" \
  https://api.runpod.io/graphql >> "$out" 2>&1
echo >> "$out"
