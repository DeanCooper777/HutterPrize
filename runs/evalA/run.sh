#!/bin/sh
# enwik6: full cmix with the current transformer weights vs run A (optimized code)
R=/c/Dean/Projects/HutterPrize
cd $R/runs/evalA
for w in 6m-q4-fp32 6m-q4-fp32-Aopt; do
  s=$(date +%s)
  $R/build/cmix_dump.exe --transformer $R/fx2-cmix-T/models/$w.tfwc2 -c $R/fx2-cmix-T/dictionary/english.dic $R/data/enwik6 enwik6.$w > log.$w.txt 2>&1
  echo "$w: $(stat -c %s enwik6.$w 2>/dev/null) bytes, $(( $(date +%s) - s )) s"
done
