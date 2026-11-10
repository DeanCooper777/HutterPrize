#!/bin/sh
# enwik6 then enwik7 with the full-length run A weights (one job at a time)
R=/c/Dean/Projects/HutterPrize
cd $R/runs/evalA
w=${W:-6m-q4-fp32-Afull}
for n in 6 7; do
  s=$(date +%s)
  $R/build/${BIN:-cmix_dump.exe} --transformer $R/fx2-cmix-T/models/$w.tfwc2 -c $R/fx2-cmix-T/dictionary/english.dic $R/data/enwik$n enwik$n.$w > log.enwik$n.$w.txt 2>&1
  echo "enwik$n $w: $(stat -c %s enwik$n.$w 2>/dev/null) bytes, $(( $(date +%s) - s )) s"
done
