#!/bin/bash
# neif_a16_time2.sh TAG CPU BUILD_DIR START END WARM ROUNDS CFG...: timing of 16-bit activation
# variants; CFG = NAME:MASK:BITS:MIN (NEIF_ACT16, NEIF_ACT16_DNBITS, NEIF_ACT16_DNMIN).
# One process (no pipeline), pinned to logical CPU number CPU, NEIF_PROF=1; per round "off" and
# then every CFG, and one more "off" at the end. With a -DFX2_PROF build the per-site table of
# the transformer is in the raw output too.
# Raw output: /root/noble/work/a16_timing_TAG.txt, copied to runs/wsl-split/neif_a16_timing_TAG.txt.
# Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
TAG=$1; CPU=$2; B=$3; S=$4; E=$5; WM=$6; ROUNDS=$7; shift 7
T=/root/noble/work/a16_timing_$TAG.txt
one() {  # NAME MASK BITS MIN
  local name=${TAG}_$1 mask=$2 bits=$3 min=$4
  NEIF_ACT16_DNBITS=$bits NEIF_ACT16_DNMIN=$min taskset -c $CPU bash $W/neif_a16_run.sh $S $E $WM $B 0 1 $mask:$name > /dev/null 2>&1
  local D=/root/noble/work/chunks/$name
  {
    echo "=== $name cpu $CPU build $B window $S-$E warm $WM mask $mask dnbits $bits dnmin $min $(date -u +%FT%TZ)"
    cat $D/score.json
    grep -a -E "neif_prof|neif_rows|neif_act16" $D/log
    grep -a -A 45 "per-part profile" $D/log
    grep -E "User time|System time|Elapsed|Maximum resident" $D/time.txt
  } >> $T
  cp $T $W/neif_a16_timing_$TAG.txt
}
for r in $(seq 1 $ROUNDS); do
  one r${r}_off 0 16 1
  for c in "$@"; do
    IFS=: read -r n m b mn <<< "$c"
    one r${r}_$n $m $b $mn
  done
done
one r9_off 0 16 1
echo "timing $TAG done"
