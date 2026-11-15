#!/bin/bash
# Supervisor: wakes Claude about hourly (NEXT_TICK_MIN in STATE.md), and early
# when the user sends a message to the ntfy reply topic. Runs in tmux "agent".
# Pause: touch /workspace/agent/PAUSE (the loop then only sleeps).
A=/workspace/agent
source /root/agent.env
cd $A; mkdir -p logs
T=$(cat $A/ntfy_topic)
inbox() {  # new messages on <topic>-in since the last seen id -> stdout
  local since; since=$(cat $A/.since 2>/dev/null || echo 10m)
  curl -s --max-time 20 "https://ntfy.sh/$T-in/json?poll=1&since=$since" | python3 -c '
import json,sys
last=None
for l in sys.stdin:
  try: m=json.loads(l)
  except Exception: continue
  if m.get("event")=="message":
    print("-", m.get("message","")); last=m["id"]
if last: open("/workspace/agent/.since","w").write(last)'
}
while true; do
  if [ -f $A/PAUSE ]; then sleep 300; continue; fi
  msgs=$(inbox)
  [ -n "$msgs" ] || msgs="(none)"
  now=$(date -u '+%F %T UTC')
  prompt="Tick at $now. Inbound messages from the user since the last tick:
$msgs
Follow the tick protocol in /workspace/agent/CLAUDE.md (read STATE.md first)."
  cont=--continue; [ -f $A/.started ] || cont=
  echo "=== $now tick ($cont) msgs: $msgs" >> logs/tick.log
  timeout 55m claude -p $cont --model claude-opus-5-5 --dangerously-skip-permissions \
      "$prompt" < /dev/null >> logs/tick.log 2>&1
  rc=$?; touch $A/.started
  echo "=== $(date -u '+%F %T') tick rc $rc" >> logs/tick.log
  if [ $rc != 0 ] && [ $rc != 124 ]; then
    fails=$(( ${fails:-0} + 1 ))
    [ $fails = 3 ] && bash $A/notify.sh "Agent problem" "Claude failed 3 ticks in a row (rc $rc). Check logs/tick.log." 4
  else fails=0; fi
  n=$(grep -oE 'NEXT_TICK_MIN: *[0-9]+' STATE.md 2>/dev/null | grep -oE '[0-9]+$' | tail -1)
  n=${n:-60}; [ $n -lt 10 ] && n=10; [ $n -gt 120 ] && n=120
  end=$(( $(date +%s) + n * 60 ))
  while [ $(date +%s) -lt $end ]; do   # wake early on a user message
    sleep 120
    curl -s --max-time 20 "https://ntfy.sh/$T-in/json?poll=1&since=$(cat $A/.since 2>/dev/null || echo 10m)" \
      | grep -q '"event":"message"' && break
  done
done
