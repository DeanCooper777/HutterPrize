#!/bin/bash
# neif_pk_time.sh TAG CPU START END WARM ROUNDS BUILD...: timing of dense-kernel build flavours
# (e.g. /work/tbN = test build, /work/tbK = NEIF_PACKED, /work/tbF = NEIF_PFD=12288): one process
# (no pipeline), pinned to logical CPU number CPU, NEIF_PROF=1, 16-bit switch off; per round every
# BUILD once, in the order given, and the first BUILD once more at the end.
# Raw output: /root/noble/work/pk_timing_TAG.txt, copied to runs/wsl-split/neif_pk_timing_TAG.txt;
# the result lines (with the sha of the coder output) also go to /root/noble/work/a16_results.txt.
# Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
TAG=$1; CPU=$2; S=$3; E=$4; WM=$5; ROUNDS=$6; shift 6
T=/root/noble/work/pk_timing_$TAG.txt
one() {  # NAME BUILD
  local name=${TAG}_$1 B=$2
  NEIF_ACT16=0 taskset -c $CPU bash $W/neif_a16_run.sh $S $E $WM $B 0 1 0:$name > /dev/null 2>&1
  local D=/root/noble/work/chunks/$name
  {
    echo "=== $name cpu $CPU build $B window $S-$E warm $WM mask 0 dnbits 16 $(date -u +%FT%TZ) load $(cut -d' ' -f1-3 /proc/loadavg) top: $(ps -eo ni,pcpu,comm --sort=-pcpu | sed -n 2,3p | tr '\n' ';')"
    cat $D/score.json
    grep -a -E "neif_prof|neif_rows" $D/log
    grep -a -A 45 "per-part profile" $D/log
    grep -E "User time|System time|Elapsed|Maximum resident" $D/time.txt
    grep "^$name " /root/noble/work/a16_results.txt | grep -o "sha [0-9a-f]*"
  } >> $T
  cp $T $W/neif_pk_timing_$TAG.txt
}
for r in $(seq 1 $ROUNDS); do
  for B in "$@"; do one r${r}_$(basename $B) $B; done
done
one r9_$(basename $1) $1
echo "timing $TAG done"
