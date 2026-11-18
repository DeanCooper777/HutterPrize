#!/bin/bash
# neif_mt_stop.sh: stop a running batch of chunk runs (neif_mt_batch*.sh, neif_sv_batch.sh) and its cmix.
for p in $(pgrep -f "neif_mt_batch|neif_sv_batch|neif_mt_one.sh"); do kill -9 $p; done
sleep 1
for p in $(pgrep -x cmix); do kill -9 $p; done
sleep 1
pgrep -a cmix; pgrep -af "neif_mt_|neif_sv_" | grep -v neif_mt_stop
rm -f /root/noble/work/chunks/*/run/ppm.page
echo stopped
