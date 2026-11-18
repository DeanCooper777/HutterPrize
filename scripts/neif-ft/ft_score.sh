#!/bin/bash
# ft_score.sh: testing tool (not part of any submitted program).
#
#   ft_score.sh <test build dir> <coder stream> <weights root> <out root> <jobs> <arm> [...]
#
# Scores weight containers of the fine-tune pilot with the real compressor: the NEIF_TEST chunk
# mode of cmix-neif 2.0 (`cmix -t`, NEIF_T_WEIGHTS_ANY=1), K chunks per arm, the same chunks for
# every arm.  <weights root>/<arm>/np2/weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5 is the arm's
# container (ft_run.sh export; arm "start" = the shipped weights through the same export).
# Result per chunk: <out root>/<arm>/c<start>/score.json (ft_score_table.py sums them).
# Chunks (environment): K=32 chunks, kept part LEN=1000000 bytes, WARM=1200000 bytes of model
# warm-up in front, first start FIRST=16000000, STEP=15000000 apart (all behind the gated
# metadata blocks, which end at stream byte 13,023,914).  NEIF_PIPE=3: three processes per
# chunk, about 9.3 GB in all (measured on this project's PC); <jobs> chunks run at a time.
# Finished chunks are skipped, so the command can be repeated.
set -u
B=${1:?build dir}; S=${2:?stream}; WR=${3:?weights root}; OR=${4:?out root}; J=${5:?jobs}; shift 5
K=${K:-32}; LEN=${LEN:-1000000}; WARM=${WARM:-1200000}; FIRST=${FIRST:-16000000}; STEP=${STEP:-15000000}
SHIP=weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5
one() {   # one <arm> <start>
  local a=$1 st=$2 o="$OR/$1/c$2"
  [ -s "$o/score.json" ] && return 0
  rm -rf "$o"; mkdir -p "$o/run"; cd "$o/run" || return 1
  cp "$WR/$a/np2/$SHIP" . || return 1      # the binary reads the container from its working directory
  NEIF_T_WEIGHTS_ANY=1 NEIF_PIPE=${NEIF_PIPE:-3} NEIF_T_START=$st NEIF_T_END=$((st + LEN)) NEIF_T_WARM=$WARM \
    NEIF_T_JSON="$o/score.json" "$B/cmix" -t "$S" "$o/run/out.cmix" > "$o/log" 2>&1
  local rc=$?
  rm -rf "$o/run"
  [ $rc -eq 0 ] || { echo "FAILED $a $st (exit $rc)"; rm -f "$o/score.json"; return 1; }
  echo "done $a $st $(grep -a 'neif_test cost' "$o/log" | tail -n 1)"
}
n=0
for i in $(seq 0 $((K - 1))); do
  st=$((FIRST + i * STEP))
  for a in "$@"; do          # the arms of one chunk next to each other in time
    one "$a" "$st" &
    n=$((n + 1))
    if [ $((n % J)) -eq 0 ]; then wait; fi
  done
done
wait
echo "all chunks done"
