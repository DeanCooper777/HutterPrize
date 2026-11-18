#!/bin/bash
# neif_a16_wait.sh [MAX_SECONDS] [LINES]: wait (at most MAX_SECONDS, default 170) until
# /root/noble/work/a16_results.txt has more than LINES lines (default: its count at the start) or
# no neif_a16_run.sh is left; then print its last lines and what runs.
R=/root/noble/work/a16_results.txt
MAX=${1:-170}; n0=$(wc -l < $R 2> /dev/null || echo 0); N=${2:-$n0}; t=0
while [ $t -lt $MAX ] && [ "$(wc -l < $R 2> /dev/null || echo 0)" -le "$N" ] && pgrep -f neif_a16_run.sh > /dev/null; do sleep 5; t=$((t + 5)); done
echo "lines $(wc -l < $R 2> /dev/null || echo 0) (was $N), waited $t s, runner: $(pgrep -f neif_a16_run.sh | wc -l), cmix: $(pgrep -x cmix | wc -l)"
tail -n 4 $R 2> /dev/null | cut -c1-400
