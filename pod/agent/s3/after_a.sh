#!/bin/bash
# start split c when split a's log ends (on hutter-agent). Log /workspace/logs/s3_after_a.txt
until grep -q "^exit 0" /workspace/logs/s3_hutter-s3a.txt 2>/dev/null; do sleep 60; done
echo "$(date -u) s3a done; launching s3c"
bash /workspace/agent/s3/launch_s3_loop.sh hutter-s3c "s3c /workspace/agent/s3/c.tune" > /workspace/logs/s3_hutter-s3c_launch.txt 2>&1
echo "$(date -u) launcher exited: $(tail -n 1 /workspace/logs/s3_hutter-s3c_launch.txt)"
