#!/bin/bash
# neif_split_eval.sh BUILD_DIR STREAM K WARM OUT_DIR [PIPE]   run the split evaluation
# neif_split_eval.sh --plan STREAM K WARM                 only print the K chunk ranges
#
# Split ("chunk") evaluation of cmix-neif 2.0: an estimate of how a model change alters the
# compressed size of enwik9 without the 49-hour full run. The coder stream (what `-e enwik9`
# hands to the arithmetic coder, 501,062,281 B) is cut into K chunks; each chunk is coded by its
# own process of the NEIF_TEST build (mode -t, src/neif_test.h in the source tree), all K in
# parallel, and the ideal code lengths (sum of -log2 p of every coded bit, p = the probability
# handed to the arithmetic coder) of the chunks' own bytes are added up.
#
# One chunk [s, e):
#   * bytes [0, warm_from) get a structure-only pass (no model, nothing coded; about 2 MB/s, so
#     at most 4 minutes): the metadata blocks, the text start (dictionary, contributor and census
#     articles) and every page in front are read by the automata the coder needs in step
#     (metadata table, dictionary, grammar automaton, redirect/alias tables, the transformer's
#     prompt, gate and link-context automata, page counters).
#     warm_from = the first page start at or behind s - WARM.
#   * bytes [warm_from, e) are coded by the complete predictor, starting from cold models
#     (PPMd with its dictionary warm-up); only the bits of [s, e) are counted.
#   * a chunk whose warm-up would reach into the head of the stream (s - WARM < HEAD; for K = 16
#     only chunk 0) is coded from byte 0 and is a true prefix of a real run.
# The sum is biased upward (each chunk starts cold): compare variants by the DIFFERENCE of their
# totals at the same K and WARM.
#
# BUILD_DIR  directory with the test binary `cmix` and the weights container. Build it as comp9
#            is compiled, or it does not compute the same bits as comp9 (the plain `make cmix`
#            build differs from byte 79 of the output on): in a copy of src/, makefile,
#            encoder_split.lds, runtime_exports.map, pgo_data/ and the weights container
#              make -j8 prof_use CC="clang++-18 -DNEIF_TEST=1"
#            (neif_build_test.sh DIR pgo does this in the chroot of this PC).
# STREAM     the coder stream (neif_mkstream.sh; 501,062,281 B, sha256 c35d3073eeba70f2... for
#            the published entry; make it again if the change under test alters the
#            preprocessing, the dictionary or any stream stage)
# OUT_DIR    results: c<k>/score.json, c<k>/log, c<k>/time.txt, plan.tsv, total.json; a second
#            start skips the chunks that have a score.json
#
# MEMORY: plan 10 GiB of RAM per chunk process. Measured peak RSS of chunk runs on this PC:
# 6.0 GiB for the first 0.2 MB of the stream, 8.5 GiB for 1.5 MB in the middle of the stream
# (248.8 MB structure pass + 1.5 MB coded), 8.4 GiB for 1.5 MB at 15.5 MB, and 9.75 GiB for a run
# from byte 0 to 17 MB. The program sizes its PPMd page pool so that the process stays just
# below 10 GiB (as in a real run: 9.77 GiB), and a chunk of 31 MB reaches that ceiling.
# K = 16 at once therefore needs 160 GiB; with less RAM set JOBS = RAM / 10 GiB (the chunks then
# run JOBS at a time). Each process also creates its PPMd paging file ./ppm.page (14.7 GB
# apparent size, sparse; it takes disk space only as far as PPMd pages out) in its own run
# directory under OUT_DIR: put OUT_DIR on a local disk.
# CPU: one core per chunk process. On this PC (one process at a time) the model codes about
# 10 kB/s inside the metadata blocks and 1.7 to 2.2 kB/s in page text, so a chunk of
# 501 MB / 16 = 31.3 MB plus 4 MB of warm-up takes about 4.5 to 6 hours.
#
# PIPE (6th argument, default 0): every chunk runs as a pipeline of PIPE processes (NEIF_PIPE of
# the test binary, src/neif_test.h in the source tree: 2 = PPMd and transformer in front of the
# cmix models and the coder; 3 and more = 3 stages, the transformer cut in two). The result of a
# chunk is bit for bit the one of PIPE=0. A chunk then keeps 2 or 3 cores busy, so the number of
# chunks at a time is JOBS divided by the number of stages (at least 1). Memory per chunk: as
# PIPE=0 plus about 0.5 GiB (the stages share the pages they do not write; total.json gives the
# sum over the stages as max_peak_rss_gib). Speed: see the measurements in the hand-over notes;
# the third stage only pays when every stage has a core of its own.
#
# Environment: JOBS (processes at a time, default K; with PIPE every stage is a process, so
# JOBS / stages chunks run at a time), HEAD (default 16000000: a warm-up target below it means
# "run from byte 0"; the first page starts at about byte 15.28 M).
set -uo pipefail
HEAD=${HEAD:-16000000}
plan() {   # plan STREAM K WARM -> lines "k start end warm_arg"
  local n; n=$(stat -c %s "$1") || exit 1
  local K=$2 WARM=$3 k s e w
  for ((k = 0; k < K; k++)); do
    s=$((n * k / K)); e=$((n * (k + 1) / K))
    # warm_arg = s makes the binary start the model at byte 0
    if [ $((s - WARM)) -lt "$HEAD" ]; then w=$s; else w=$WARM; fi
    echo "$k $s $e $w"
  done
}
if [ "${1:-}" = "--plan" ]; then
  echo "# chunk start end warm_arg (model starts at byte 0 where warm_arg == start, else at the first page start >= start - warm_arg)"
  plan "${2:?stream}" "${3:?K}" "${4:?WARM}"
  exit 0
fi
B=$(cd "${1:?usage: neif_split_eval.sh BUILD_DIR STREAM K WARM OUT_DIR}" && pwd)
S=$(readlink -f "${2:?stream}")
K=${3:?K}; WARM=${4:?WARM}; PIPE=${6:-0}
mkdir -p "${5:?out dir}"; O=$(cd "$5" && pwd)
JOBS=${JOBS:-$K}
# a chunk with a pipeline is 2 or 3 processes: that many fewer chunks at a time
STAGES=1; [ "$PIPE" -ge 2 ] && STAGES=2; [ "$PIPE" -ge 3 ] && STAGES=3
PROCS=$JOBS; JOBS=$((JOBS / STAGES)); [ "$JOBS" -ge 1 ] || JOBS=1
[ -x "$B/cmix" ] || { echo "$B/cmix is missing"; exit 1; }
[ -f "$B/weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5" ] || { echo "the weights container is missing in $B"; exit 1; }
echo "$(date -u) split eval: build $B ($(sha256sum "$B/cmix" | cut -c1-16)) stream $S K=$K WARM=$WARM PIPE=$PIPE processes=$PROCS chunks_at_a_time=$JOBS nproc=$(nproc)"
free -g | sed -n 2p
plan "$S" "$K" "$WARM" > "$O/plan.tsv"
cat "$O/plan.tsv"

run_chunk() {   # k start end warm_arg
  local k=$1 d=$O/c$1
  rm -rf "$d/run"; mkdir -p "$d/run"; cd "$d/run" || return 1
  # the binary reads the weights from its working directory and writes ./.dict and ./ppm.page there
  ln -sf "$B/weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5" .
  local timev=""; [ -x /usr/bin/time ] && timev="/usr/bin/time -v -o $d/time.txt"
  NEIF_T_START=$2 NEIF_T_END=$3 NEIF_T_WARM=$4 NEIF_T_JSON="$d/score.json.part" NEIF_PIPE=$PIPE \
    $timev "$B/cmix" -t "$S" "$d/run/out.cmix" > "$d/log" 2>&1
  local rc=$?
  rm -rf "$d/run"
  [ $rc -eq 0 ] && [ -s "$d/score.json.part" ] || { echo "chunk $k: cmix exit $rc (see $d/log)"; return 1; }
  mv "$d/score.json.part" "$d/score.json"
  echo "$(date -u) chunk $k done: $(tr -d '\n' < "$d/score.json" | cut -c1-200)"
}

fail=0
while read -r k s e w; do
  [ -f "$O/c$k/score.json" ] && { echo "chunk $k: already done"; continue; }
  run_chunk "$k" "$s" "$e" "$w" &
  while [ "$(jobs -rp | wc -l)" -ge "$JOBS" ]; do wait -n || fail=1; done
done < "$O/plan.tsv"
while [ "$(jobs -rp | wc -l)" -gt 0 ]; do wait -n || fail=1; done

python3 - "$O" "$K" <<'EOF' || fail=1
import json, sys
out, K = sys.argv[1], int(sys.argv[2])
rs = []
for k in range(K):
    try:
        rs.append(json.load(open(f"{out}/c{k}/score.json")))
    except Exception as ex:
        print(f"chunk {k}: no result ({ex})")
        sys.exit(1)
for k, r in enumerate(rs):
    assert r["kept_from"] == r["start"], f"chunk {k}: the model started behind the chunk start; raise WARM"
    assert r["forced_byte_mismatch"] == 0, f"chunk {k}: structure pass out of step"
tot = sum(r["kept_bytes"] for r in rs)
n = sum(r["end"] - r["start"] for r in rs)
ratio = [r["coded_vs_bits_ratio"] for r in rs]
res = dict(total_kept_bytes=tot, stream_bytes=n, K=K,
           max_chunk_hours=max(r["seconds"] for r in rs) / 3600,
           # CPU time of all stages of a chunk (wall time for results of an older binary)
           cpu_hours=sum(r.get("cpu_seconds", r["seconds"]) for r in rs) / 3600,
           pipe=max(r.get("pipe", 0) for r in rs),
           # one process: its peak RSS; a pipeline: the sum over its stages (proportional set sizes)
           max_peak_rss_gib=max(max(r["peak_rss_kb"], r.get("pipe_peak_pss_kb", 0)) for r in rs) / 2**20,
           coded_vs_bits_ratio=[min(ratio), max(ratio)],
           chunks=[dict(k=k, start=r["start"], end=r["end"], warm_from=r["warm_from"],
                        kept_bytes=r["kept_bytes"], bits_per_byte=r["kept_bits_per_byte"],
                        seconds=r["seconds"]) for k, r in enumerate(rs)])
json.dump(res, open(f"{out}/total.json", "w"), indent=1)
print(f"{out}: kept {tot:,.0f} bytes over {n:,} stream bytes, max chunk {res['max_chunk_hours']:.2f} h,"
      f" {res['cpu_hours']:.1f} core-hours, max peak RSS {res['max_peak_rss_gib']:.2f} GiB,"
      f" coded/bits ratio {min(ratio):.5f}..{max(ratio):.5f}")
EOF
echo "$(date -u) done, exit $fail"
exit $fail
