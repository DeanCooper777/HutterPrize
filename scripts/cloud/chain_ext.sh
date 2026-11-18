#!/bin/bash
# wait for the phase 1 loop (pid 133) to end, then start the extension run (which starts its own self-stop)
while kill -0 133 2>/dev/null; do sleep 60; done
echo "$(date -u) phase 1 done, starting ext" >> /workspace/logs/chain.txt
NAME=gpu_ext bash /workspace/scripts/launch_variants.sh "ext 24 4 A_INIT=/workspace/full/models/6m-q4-A.tch A_MIXER=rich" >> /workspace/logs/chain.txt 2>&1
