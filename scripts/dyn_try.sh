#!/bin/sh
# dyn_try.sh: one trial run for tuning the online adaptation ("dynamic evaluation") of the
# transformer's output layer (Predictor::DynApply / DynLearn in cmix-T-dwc/src/predictor.cpp).
#
# Testing: an experiment tool only (Windows development machine, Git Bash). It writes the
# given "name value" pairs to a CMIX_TUNE file and runs a development build on a test prefix.
# By default only the transformer is run (--transformer-only) and the script prints the
# transformer's loss; with MODE=full the whole compressor runs and the output size counts.
# Inputs: data/<file>, the weights file, the dictionary. Environment: EXE (binary under
# build/), MODE. Output: runs/dyn/<tag>/ (p.tune, log.txt, out). New in this entry.
# usage: dyn_try.sh <file> <tag> "name val" ...   -- transformer-only loss run
f=$1; tag=$2; shift 2
R=/c/Dean/Projects/HutterPrize
d=$R/runs/dyn/$tag; rm -rf $d; mkdir -p $d; cd $d
echo "ppmd_mb 2500" > p.tune
for kv in "$@"; do echo "$kv" | tr "," "
" >> p.tune; done
CMIX_TUNE=$d/p.tune $R/build/${EXE:-cmix_dyn.exe} --transformer $R/cmix-T-dwc/models/6m-q4-fp32.tfwc2 $([ "$MODE" = full ] || echo --transformer-only) -c $R/cmix-T-dwc/dictionary/english.dic $R/data/$f out > log.txt 2>&1
echo "$tag $(grep 'transformer loss' log.txt | tail -1) size $(stat -c %s out 2>/dev/null)"
