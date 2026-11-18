#!/bin/bash
# GPU pod (300 GB disk): N1 pre-check, N4, up1 QAT (ALL=31), clamped 3-bit rescan, stand-in search. Ends "exit 0".
W=/workspace; PY=$W/train/.venv/bin
mkdir -p /root/t0w /root/s64; cp -r $W/mp/pysrc /root/t0w/; cp $W/tier0/s64/* /root/s64/
t0() { (cd /root/t0w && PYTHONPATH=. DATA=/root/s64 OMP_NUM_THREADS=16 $PY/python "$@" 2>&1 | grep -v -i -e warn -e articles); }
echo "=== $(date -u) N1 pre-check"; t0 $W/agent/tier0/n1pre.py
echo "=== $(date -u) N4 16-bit activations"; t0 $W/agent/tier0/n4.py $W/ext/models/6m-q4-fp32-A.tch $W/tier0/results/n4.json
echo "=== $(date -u) up1 ALL=31"
RUN_DIR=$W/up1 A_BITS_MAP="ALL=31" bash $W/agent/up/run_up.sh; echo "up1 rc $?"
echo "=== $(date -u) clamped 3-bit rescan"; SENS_KINDS=q7 t0 $W/agent/tier0/sens.py $W/ext/models/6m-q4-fp32-A.tch $W/tier0/results/sens_ext_clamp.json
echo "=== $(date -u) stand-in search"; t0 $W/agent/tier0/standin.py
echo "$(date -u) done"; echo "exit 0"
