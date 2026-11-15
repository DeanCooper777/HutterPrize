#!/bin/bash
W=/workspace; PY=$W/train/.venv/bin
mkdir -p /root/t0w /root/s64; cp -r $W/mp/pysrc /root/t0w/; cp $W/tier0/s64/* /root/s64/
cd /root/t0w && PYTHONPATH=. DATA=/root/s64 OMP_NUM_THREADS=16 $PY/python $W/agent/tier0/standin.py 2>&1 | grep -v -i -e warn -e articles
echo "$(date -u) done"; echo "exit 0"
