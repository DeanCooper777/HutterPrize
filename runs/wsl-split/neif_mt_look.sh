#!/bin/bash
# neif_mt_look.sh NAME...: for each chunk run /root/noble/work/chunks/NAME: exit code, whether a result file
# exists, and the last lines of its log that are not progress lines.
cd /root/noble/work/chunks || exit 1
for n in "$@"; do
  echo "== $n rc $(cat $n/rc 2> /dev/null) result_file $(ls $n/score.json 2> /dev/null | wc -l)"
  tr '\r' '\n' < $n/log | grep -a "neif\|rror\|WRONG\|abort\|Segm" | tail -n ${LOOK_N:-5} | cut -c1-230
  [ -f $n/score.json ] && tr '\n' ' ' < $n/score.json | cut -c1-420 && echo
done
