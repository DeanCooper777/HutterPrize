# on the GPU pod: replace selfstop on the batch log with batch -> refit -> selfstop on refit log
W=/workspace; L=$W/logs/tier0_refit.txt
until grep -q "^exit" $W/logs/tier0_batch.txt; do sleep 15; done
cd /root/t0w; export PYTHONPATH=.
$W/train/.venv/bin/python $W/agent/tier0/refit.py base ext Afull Aopt v1a v1b0 v1b3 p2c p2b p2a B > $L 2>&1
echo "exit $?" >> $L
