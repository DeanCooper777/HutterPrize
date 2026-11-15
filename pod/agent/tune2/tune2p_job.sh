#!/bin/bash
# Lever 1 tune round on a CPU pod: names from /workspace/tune2/$1 (e.g. round1_a.txt). Log /workspace/logs/tune2_$POD.txt, ends "exit 0".
echo "=== $(date -u) tune2 $1"; nproc; free -g | head -2
bash /workspace/agent/tune2/tune2p_eval.sh $(cat /workspace/tune2/$1) 2>&1 | grep -v "^exit"
echo "$(date -u) round done"; echo "exit 0"
