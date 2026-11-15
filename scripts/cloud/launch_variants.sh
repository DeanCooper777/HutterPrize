#!/bin/bash
# launch_variants.sh: run several variants of the cmix-aware fine-tune (run_A_opt.sh with
# different environment settings) one after another on one GPU machine, then stop the machine.
# This is how the mixer-context, cross-entropy-weight, MLP-width and MLP-bits variants listed
# in SUBMISSION.md ("Experiments that did not make it") were trained.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Run one or more run-A variants one after another on this GPU pod, then
# stop the pod (selfstop.sh). Each spec is "DIR A_EPOCHS COOLDOWN_EPOCHS
# [VAR=value ...]" (2026-11-08):
#   ssh ... "NAME=gpu1 bash -s 'v1a 3 1 A_MIXER=rich' 'v1b0 3 1 A_CE_WEIGHT=0'" < launch_variants.sh
set -u
W=/workspace
log=$W/logs/${NAME:?set NAME}.txt
nohup setsid bash -c '
  for spec in "$@"; do
    set -- $spec
    d=$1 ae=$2 ce=$3; shift 3
    echo "=== $(date -u) $d A_EPOCHS=$ae COOLDOWN_EPOCHS=$ce $*"
    env "$@" RUN_DIR=/workspace/$d A_EPOCHS=$ae COOLDOWN_EPOCHS=$ce bash /workspace/scripts/run_A_opt.sh
    echo "=== $(date -u) $d rc $?"
  done
  echo "exit 0"
' variants "$@" > "$log" 2>&1 < /dev/null &
nohup setsid bash $W/scripts/selfstop.sh "$log" > /dev/null 2>&1 < /dev/null &
sleep 2
echo "started $NAME: $*"
