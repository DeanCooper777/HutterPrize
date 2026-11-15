#!/bin/bash
# GPU pod: stage sample, run sens.py on ext, end with exit line (selfstop watches log)
W=/workspace; PY=$W/train/.venv/bin
mkdir -p /root/t0w /root/s64; cp -r $W/opt/pysrc /root/t0w/; cp $W/tier0/s64/* /root/s64/
cd /root/t0w; export PYTHONPATH=. DATA=/root/s64 OMP_NUM_THREADS=16
$PY/python $W/agent/tier0/sens.py /workspace/ext/models/6m-q4-fp32-A.tch /workspace/tier0/results/sens_ext.json 2>&1 | grep -v -i -e warn -e articles
echo "$(date -u) done"; echo "exit 0"
