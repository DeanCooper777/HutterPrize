#!/bin/bash
# neif_run_chunk.sh BUILD_DIR STREAM START END WARM OUT_DIR
# One chunk run of the cmix-neif 2.0 test build (NEIF_TEST, mode -t; see src/neif_test.h):
# the complete model codes stream bytes [warm_from, END) of the coder stream STREAM, where
# warm_from is the first page start at or behind START - WARM (byte 0 if WARM >= START); the
# bytes in front get a structure-only pass. Writes OUT_DIR/score.json, OUT_DIR/log and
# OUT_DIR/time.txt (peak RSS). All paths are paths on the machine the script runs on.
# Environment, passed on to the binary: NEIF_PIPE=n (the model bytes as a pipeline of n processes,
# 2 or 3; same result, see src/neif_test.h), NEIF_PIPE_SPLIT, NEIF_PROF=1 (time table in the log),
# NEIF_T_TRACE. With a pipeline time.txt gives the CPU time of all stages, but its "Maximum
# resident set size" is the largest single stage: the sum is "pipe_peak_pss_kb" in score.json.
# On this PC run it inside the chroot:
#   wsl -d Ubuntu -u root -- bash neif_chroot.sh sh 'bash /mnt_scripts/neif_run_chunk.sh ...'
# (neif_local_chunk.sh does that.)
set -u
B=${1:?build dir}; S=${2:?stream}; START=${3:?start}; END=${4:?end}; WARM=${5:?warm}; O=${6:?out dir}
mkdir -p "$O/run" && cd "$O/run" || exit 1
# the binary reads the weights container from its working directory and writes ./.dict and
# ./ppm.page there: one directory per process
ln -sf "$B/weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5" .
TIMEV=""; [ -x /usr/bin/time ] && TIMEV="/usr/bin/time -v -o $O/time.txt"
NEIF_T_START=$START NEIF_T_END=$END NEIF_T_WARM=$WARM NEIF_T_JSON="$O/score.json" \
  $TIMEV "$B/cmix" -t "$S" "$O/run/out.cmix" > "$O/log" 2>&1
rc=$?
[ $rc -eq 0 ] || { echo "chunk $START-$END: cmix exit $rc"; tail -n 5 "$O/log"; exit 1; }
[ "${KEEP_OUT:-0}" = 1 ] || rm -f "$O/run/out.cmix"
rm -f "$O/run/ppm.page" "$O/run/.dict" "$O/run/.dict.ta"
cat "$O/score.json"
[ -f "$O/time.txt" ] && grep -E "Maximum resident|Elapsed" "$O/time.txt"
exit 0
