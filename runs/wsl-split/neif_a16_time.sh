#!/bin/bash
# neif_a16_time.sh CPU [BUILD_DIR] [START] [END] [WARM] [ROUNDS]: timing of the fast 16-bit
# kernels. One process (no pipeline), pinned to logical CPU number CPU (taskset), NEIF_PROF=1;
# per round the configurations off, 160, 2 (16 bit), 2 (12 bit), 162, 162 with the 12-bit
# mlp.down code run one after the other, and one more "off" at the end.
# Raw output of every run (score, time table, row counts, /usr/bin/time) is appended to
# /root/noble/work/a16_timing.txt and copied to runs/wsl-split/neif_a16_timing.txt.
# Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
CPU=${1:?cpu}; B=${2:-/work/tb16f}; S=${3:-60000000}; E=${4:-60500000}; WM=${5:-100000}; ROUNDS=${6:-2}
T=/root/noble/work/a16_timing.txt
one() {  # NAME MASK BITS
  local name=$1 mask=$2 bits=$3
  NEIF_ACT16_DNBITS=$bits taskset -c $CPU bash $W/neif_a16_run.sh $S $E $WM $B 0 1 $mask:$name > /dev/null 2>&1
  local D=/root/noble/work/chunks/$name
  {
    echo "=== $name cpu $CPU build $B window $S-$E warm $WM mask $mask dnbits $bits $(date -u +%FT%TZ)"
    cat $D/score.json
    grep -a -E "neif_prof|neif_rows|neif_act16" $D/log
    grep -E "User time|System time|Elapsed|Maximum resident" $D/time.txt
  } >> $T
  grep -a "transformer driver and network" $D/log | sed "s/^/$name: /"
}
for r in $(seq 1 $ROUNDS); do
  one t${r}_off 0 16
  one t${r}_160 160 16
  one t${r}_2 2 16
  one t${r}_2b12 2 12
  one t${r}_162 162 16
  one t${r}_162b12 162 12
done
one t9_off 0 16
cp $T $W/neif_a16_timing.txt
echo "timing done"
