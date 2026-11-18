#!/bin/bash
# sw_run.sh: run a list of sweep points one after another on this machine (several lists can
# run side by side on one large GPU). Each line of the list file:
#   NAME SLICE LAYERS DMODEL HEADS DMLP EPOCHS [BATCH_TOKENS]
# A point whose result JSON exists is skipped.   sw_run.sh LIST_FILE
# Testing tool for rented cloud machines; not part of the submitted programs.
W=/workspace; T=${SW_TREE:-/root/sw}; PY=$W/train/.venv/bin/python
cd $T
export WANDB_MODE=offline PYTHONPATH=. OMP_NUM_THREADS=${OMP_NUM_THREADS:-6} TORCHINDUCTOR_CACHE_DIR=/root/ti_$(basename $1)
while read name slice l d h m ep bt; do
  [ -z "$name" ] && continue
  [ -s $W/sweep/out/$name.json ] && continue
  echo "$(date -u +%H:%M:%S) start $name"
  S_NAME=$name S_DATA=/root/slices/$slice S_LAYERS=$l S_DMODEL=$d S_HEADS=$h S_DMLP=$m S_EPOCHS=$ep \
    S_BATCH=${bt:-131072} S_PATCH=${S_PATCH:-0} $PY -m training_recipes.sweep > $W/sweep/logs/$name.log 2>&1
  echo "$(date -u +%H:%M:%S) end $name rc $?"
  tr '\r' '\n' < $W/sweep/logs/$name.log | grep -a RESULT | cut -c1-400
done < "$1"
