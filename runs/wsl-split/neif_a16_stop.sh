#!/bin/bash
# neif_a16_stop.sh: stop the running 16-bit experiment batch and its cmix processes.
pkill -f neif_a16_batch || true
pkill -f neif_a16_run.sh || true
pkill -f neif_local_chunk.sh || true
pkill -f neif_run_chunk.sh || true
pkill -x cmix || true
sleep 2
echo "left: $(pgrep -fa 'neif_a16|cmix' | grep -v neif_a16_stop | wc -l)"
free -g | sed -n 2p
