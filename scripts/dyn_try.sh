#!/bin/sh
# usage: dyn_try.sh <file> <tag> "name val" ...   -- transformer-only loss run
f=$1; tag=$2; shift 2
R=/c/Dean/Projects/HutterPrize
d=$R/runs/dyn/$tag; rm -rf $d; mkdir -p $d; cd $d
echo "ppmd_mb 2500" > p.tune
for kv in "$@"; do echo "$kv" | tr "," "
" >> p.tune; done
CMIX_TUNE=$d/p.tune $R/build/${EXE:-cmix_dyn.exe} --transformer $R/fx2-cmix-T/models/6m-q4-fp32.tfwc2 $([ "$MODE" = full ] || echo --transformer-only) -c $R/fx2-cmix-T/dictionary/english.dic $R/data/$f out > log.txt 2>&1
echo "$tag $(grep 'transformer loss' log.txt | tail -1) size $(stat -c %s out 2>/dev/null)"
