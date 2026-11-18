#!/bin/bash
# neif_pipe_run.sh [build] START END WARM NAME [PIPE] [PROF] [KEEP] [SPLIT]: optionally build the PGO test
# binary (neif_pipe_build.sh), then one chunk run in the foreground (neif_local_chunk.sh), and print
# its result, time table and the sha256 of the coder output. Used for the pipeline tests.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
if [ "$1" = build ]; then shift; bash $W/neif_pipe_build.sh | tail -n 6 || exit 1; fi
START=$1; END=$2; WARM=$3; NAME=$4; PIPE=${5:-0}; PROF=${6:-0}; KEEP=${7:-1}; SPLIT=${8:-8}
D=/root/noble/work/chunks/$NAME
bash $W/neif_local_chunk.sh $START $END $WARM $NAME /work/tbp 0 $KEEP $PIPE $PROF $SPLIT
echo "rc $?"
grep -E "neif_prof|neif_pipe" $D/log
grep -E "User time|System time|Elapsed|Maximum resident" $D/time.txt
[ -f $D/run/out.cmix ] && sha256sum $D/run/out.cmix
tail -c 300 $D/log
