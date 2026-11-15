mkdir -p /workspace/logs
nohup setsid bash /workspace/agent/lv2/lv2_job.sh D2 3e-8 3 > /workspace/logs/lv2_D2.txt 2>&1 < /dev/null &
nohup setsid bash /workspace/scripts/selfstop.sh /workspace/logs/lv2_D2.txt > /dev/null 2>&1 < /dev/null &
sleep 2; echo started
