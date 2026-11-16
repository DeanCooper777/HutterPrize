#!/bin/bash
# sw_fetch.sh HOST PORT: copy the sweep's result JSON files to runs/sweep/ and print the table.
# Testing tool for rented cloud machines; not part of the submitted programs.
H=$1; P=$2; R=$(cd "$(dirname "$0")/../../.." && pwd); mkdir -p $R/runs/sweep
scp -q -i $HOME/.ssh/runpod_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -P $P "root@$H:/workspace/sweep/out/*.json" $R/runs/sweep/
python "$(dirname "$0")/sw_table.py" $R/runs/sweep ${3:-3.5}
