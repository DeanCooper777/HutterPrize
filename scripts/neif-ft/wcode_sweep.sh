#!/bin/bash
# wcode_sweep.sh: testing tool, not part of any submitted program.
# Runs a list of wcode_exp configurations one after the other (one core, nice 19) and prints
# the TOTAL line of each.  Lines of the list file: tag|environment|arguments
set -u
S=/mnt/c/Dean/Projects/HutterPrize/scripts/neif-ft
W=/mnt/c/Dean/Projects/HutterPrize/runs/neif-ft/wcode
while IFS='|' read -r tag env args; do
  [ -z "$tag" ] && continue
  out=$(env $env bash $S/wcode_run.sh $tag $args 2>&1 | grep -E "TOTAL|error")
  echo "$tag | $env | $args | $out"
done < "$1"
