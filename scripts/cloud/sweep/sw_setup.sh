#!/bin/bash
# sw_setup.sh: prepare a GPU machine (volume at /workspace) for the model-size sweep:
# a local copy of the training tree with the sweep recipe, and the data slices on local disk.
#   sw_setup.sh tree | cut NAME START NTOK | count
# Testing tool for rented cloud machines; not part of the submitted programs.
set -eu
W=/workspace; T=/root/sw; PY=$W/train/.venv/bin/python
case ${1:-} in
  tree)
    mkdir -p $T /root/slices $W/sweep/out $W/sweep/logs
    rm -rf $T/pysrc $T/training_recipes
    cp -r ${SRC:-$W/opt}/pysrc ${SRC:-$W/opt}/training_recipes $T/
    cp $W/sweep/sweep.py $T/training_recipes/
    nvidia-smi --query-gpu=name,memory.total --format=csv,noheader; nproc; free -g | sed -n 2p; df -h /root | tail -n 1
    ;;
  cut) python3 $W/sweep/sw_cut.py "$2" "$3" "$4" $W/data /root/slices; ls -la /root/slices/$2 ;;
  count)
    cd $T
    while read name l d h m; do
      S_COUNT_ONLY=1 S_NAME=$name S_DATA=x S_LAYERS=$l S_DMODEL=$d S_HEADS=$h S_DMLP=$m PYTHONPATH=. \
        $PY -m training_recipes.sweep 2>&1 | grep -a -E "SWEEP|Error|assert" | cut -c1-200
    done
    ;;
esac
