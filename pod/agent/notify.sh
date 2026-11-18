#!/bin/bash
# Push a message to the user's phone: notify.sh "Title" "message" [priority 1-5]
T=$(cat /workspace/agent/ntfy_topic)
curl -s -o /dev/null -w "%{http_code}\n" -H "Title: ${1:?title}" -H "Priority: ${3:-3}" \
  --data-binary "${2:?message}" "https://ntfy.sh/$T"
echo "$(date -u '+%F %T') PUSH [$1] $2" >> /workspace/agent/logs/pushes.log
