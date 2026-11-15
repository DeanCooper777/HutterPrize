#!/bin/bash
# CPU pod job: one tune round; names in /workspace/tune/round.txt (one line, space separated)
bash /workspace/agent/tune/tune_eval.sh $(cat /workspace/tune/round.txt)
echo "exit 0"
