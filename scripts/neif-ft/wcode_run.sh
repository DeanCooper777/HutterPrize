#!/bin/bash
# wcode_run.sh: testing tool, not part of any submitted program.
# Builds wcode_exp.c (a few KB, gcc -O2, no cmix code) and runs it once at low priority on
# one core.   wcode_run.sh <tag> <mask hex> [lr] [limit] [selmode] [scalefirst]
# Output: runs/neif-ft/wcode/exp_<tag>.tsv ; prints the class sums.
set -u
D=/mnt/c/Dean/Projects/HutterPrize
S=$D/scripts/neif-ft
W=$D/runs/neif-ft/wcode
B=/root/neif-ft/wcode_exp
mkdir -p /root/neif-ft
if [ ! -x $B ] || [ $S/wcode_exp.c -nt $B ]; then
  nice -n 19 gcc -O2 -o $B $S/wcode_exp.c -lm || exit 1
fi
tag=$1; shift
nice -n 19 taskset -c 7 $B $W/shipped.raw 583 "$@" > $W/exp_$tag.tsv || exit 1
grep '^#' $W/exp_$tag.tsv
