#!/bin/bash
# neif_a16_waitp.sh PATTERN [MAX_SECONDS]: wait until no process matches PATTERN (pgrep -f), at most MAX_SECONDS (170).
P=${1:?pattern}; MAX=${2:-170}; t=0
while [ $t -lt $MAX ] && pgrep -f "$P" > /dev/null; do sleep 5; t=$((t + 5)); done
echo "waited $t s, still running: $(pgrep -f "$P" | wc -l)"
