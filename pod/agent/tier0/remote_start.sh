mkdir -p /workspace/logs
nohup setsid bash /workspace/agent/l4/l4_job.sh > /workspace/logs/l4_job.txt 2>&1 < /dev/null &
nohup setsid bash /workspace/scripts/selfstop.sh /workspace/logs/l4_job.txt > /dev/null 2>&1 < /dev/null &
sleep 2; echo started
