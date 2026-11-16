#!/bin/bash
# neif_pipe_seq.sh START END WARM PREFIX "PIPE..." [TRACE]: the same chunk once per PIPE value
# (0 = one process), one run after the other, results in /work/chunks/PREFIX<pipe> with the coder
# output kept; then the comparison table (neif_chunks_ls.sh) and a verdict: all runs must agree in
# coded bits, bit count, structure hash and coder output.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
START=$1; END=$2; WARM=$3; PRE=$4; PIPES=$5; TRACE=${6:-0}
names=""
for n in $PIPES; do
  bash $W/neif_local_chunk.sh $START $END $WARM $PRE$n /work/tbp $TRACE 1 $n 1 > /dev/null 2>&1
  echo "pipe $n: rc $?  $(date)"
  grep -E "neif_pipe|waiting for the queue" /root/noble/work/chunks/$PRE$n/log
  names="$names $PRE$n"
done
bash $W/neif_chunks_ls.sh $names | tee /tmp/neif_seq.txt
k=$(sed -e 's/.*| bits/bits/' -e 's/ | wall.*//' /tmp/neif_seq.txt | sort -u | wc -l)
[ "$k" = 1 ] && echo "VERDICT: all runs IDENTICAL (bits, bit count, structure hash, output size and sha256)" || echo "VERDICT: runs DIFFER"
