#!/bin/bash
# neif_a16_run.sh START END WARM BUILD_DIR PIPE PROF MASK[:NAME] [MASK[:NAME] ...]
# 16-bit activation experiment (src/tf1/opt/act16_test.h): one chunk run per MASK, one after the
# other, with NEIF_ACT16=MASK (0 = the entry's 8-bit path), through neif_local_chunk.sh; the coder
# output is kept and its sha256 printed. Results in /root/noble/work/chunks/NAME (default name
# a16_<START in MB>_<MASK>) and one summary line per run appended to /root/noble/work/a16_results.txt.
# Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
START=$1; END=$2; WARM=$3; B=$4; PIPE=$5; PROF=$6; shift 6
R=/root/noble/work/a16_results.txt
for mn in "$@"; do
  MASK=${mn%%:*}; NAME=a16_$((START / 1000000))_$MASK
  case $mn in *:*) NAME=${mn#*:} ;; esac
  D=/root/noble/work/chunks/$NAME
  export NEIF_ACT16=$MASK
  bash $W/neif_local_chunk.sh $START $END $WARM $NAME $B 0 1 $PIPE $PROF 8 > /dev/null 2>&1
  rc=$?
  if [ $rc -ne 0 ] || [ ! -f $D/score.json ]; then echo "$NAME rc $rc FAILED"; tail -n 5 $D/log; continue; fi
  sha=$(sha256sum $D/run/out.cmix | cut -c1-16); rm -f $D/run/out.cmix
  line=$(python3 -c "
import json,sys
j=json.load(open('$D/score.json'))
print('%s build %s start %d end %d warm_from %d mask %s kept_bits %.3f total_bits %.3f coded_bytes %d model_s %.1f model_cpu_s %.1f front_cpu %s sha %s' % ('$NAME','$B',j['start'],j['end'],j['warm_from'],'$MASK',j['kept_bits'],j['total_bits'],j['coded_bytes'],j['model_seconds'],j['model_cpu_seconds'],j['front_cpu_seconds'],'$sha'))
")
  echo "$line" | tee -a $R
  grep -h "neif_act16" $D/log | sort -u | head -n 3
done
