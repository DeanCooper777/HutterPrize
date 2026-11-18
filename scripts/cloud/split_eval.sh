#!/bin/bash
# split_eval.sh: fast estimate of the full-enwik9 result for one transformer weight set. The
# preprocessed stream is coded in K independent chunks in parallel (each with a warm-up
# prefix) and the ideal code lengths of the kept parts are summed. The total is biased upward,
# so only DIFFERENCES between weight sets (same K, same warm-up) are meaningful. This is the
# "split" evaluation that decided which weights went into the entry.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Approximate full-enwik9 size for a transformer weight set by coding the
# preprocessed stream (upload/stream.bin, what the -e pipeline codes) in K
# chunks in parallel on a many-core CPU pod (2026-11-08).
#
# Chunk k codes stream[s_k - WARM, e_k) from cold models; only the bits of
# [s_k, e_k) are counted, from cmix's own per-bit predictions
# (--save-cmix-bits), so the warm-up lets the models adapt first. A chunk
# loses context older than its warm-up, so the sum is larger than a real
# single-process run: compare weight sets by the DIFFERENCE of their sums
# (same K and WARM), and add it to a real run's size.
#
#   bash split_eval.sh TAG WEIGHTS.tfwc2 [K]   > /workspace/logs/split_TAG.txt
# Results: /workspace/split/TAG/c$k/score.json (and bins.npy: bits per
# 1 MiB of stream over the whole chunk, warm-up included). The build is
# shared through /workspace/split/bin/cmix: the first pod builds it, others
# wait for it.
set -uo pipefail
TAG=${1:?usage: split_eval.sh TAG WEIGHTS [K]}
WEIGHTS=${2:?weights}
K=${3:-16}
WARM=${WARM:-4000000}
W=/workspace
U=$W/upload
OUT=$W/split/$TAG
BIN=$W/split/bin
LOCAL=/root/split/$TAG
mkdir -p "$OUT" "$BIN" "$LOCAL"
echo "$(date -u) split eval $TAG: $WEIGHTS K=$K WARM=$WARM nproc=$(nproc)"

if [ ! -x "$BIN/cmix" ]; then
  if mkdir "$BIN/lock" 2> /dev/null; then
    bash $W/scripts/datagen.sh build > "$W/logs/split_build.txt" 2>&1 \
      && cp /root/run/cmix "$BIN/cmix.part" && mv "$BIN/cmix.part" "$BIN/cmix" \
      || { echo "build failed"; echo "exit 1"; exit 1; }
  else
    echo "waiting for the build on another pod"
    until [ -x "$BIN/cmix" ]; do sleep 30; done
  fi
fi
cp "$BIN/cmix" "$LOCAL/cmix"
[ -f "$U/stream.bin" ] || gunzip -k "$U/stream.bin.gz"
until [ -s "$WEIGHTS" ]; do echo "$(date -u) waiting for $WEIGHTS"; sleep 60; done
sleep 10
cp "$WEIGHTS" "$LOCAL/w.tfwc2"
md5sum "$LOCAL/w.tfwc2"

N=$(stat -c %s "$U/stream.bin")
for ((k = 0; k < K; k++)); do
  [ -f "$OUT/c$k/score.json" ] && continue
  s=$((N * k / K)); e=$((N * (k + 1) / K))
  from=$((s > WARM ? s - WARM : 0))
  (
    d=$LOCAL/c$k
    rm -rf "$d" && mkdir -p "$d" "$OUT/c$k" && cd "$d" || exit 1
    dd if="$U/stream.bin" of=in.bin iflag=skip_bytes,count_bytes \
        skip=$from count=$((e - from)) bs=4M status=none || exit 1
    t0=$(date +%s)
    "$LOCAL/cmix" -n in.bin x.cmix --raw-stream --official-vocab \
        --transformer "$LOCAL/w.tfwc2" --save-cmix-bits bits.f16 > log 2>&1
    rc=$?
    secs=$(( $(date +%s) - t0 ))
    cp log "$OUT/c$k/log"
    [ $rc -eq 0 ] || { echo "chunk $k: cmix exit $rc"; exit 1; }
    python3 - "$from" "$s" "$e" "$(stat -c %s x.cmix)" "$secs" "$OUT/c$k" <<'EOF' || exit 1
import json, sys
import numpy as np
frm, s, e, xsize, secs = map(int, sys.argv[1:6])
out = sys.argv[6]
data = np.fromfile("in.bin", np.uint8)
logit = np.fromfile("bits.f16", np.float16).astype(np.float64)
assert data.size == e - frm and logit.size == 8 * data.size, (data.size, logit.size)
bits = np.unpackbits(data)                     # MSB first, as cmix codes them
y = np.where(bits == 1, 1.0, -1.0)
cost = np.logaddexp(0.0, -y * logit) / np.log(2)   # -log2 P(actual bit)
per_byte = cost.reshape(-1, 8).sum(1)
keep = s - frm
B = 1 << 20
bins = np.add.reduceat(per_byte, np.arange(0, per_byte.size, B))
np.save(out + "/bins.npy", bins)
r = dict(start=s, end=e, warm_from=frm, seconds=secs, cmix_bytes=xsize,
         all_bits=float(per_byte.sum()), kept_bits=float(per_byte[keep:].sum()),
         kept_bytes_est=float(per_byte[keep:].sum() / 8))
r["cmix_vs_bits_ratio"] = xsize * 8 / r["all_bits"]
json.dump(r, open(out + "/score.json", "w"), indent=1)
print(json.dumps(r))
EOF
    rm -f bits.f16 in.bin ppm.*temp*
  ) > "$OUT/c$k.runlog" 2>&1 &
done
wait
python3 - "$OUT" "$K" <<'EOF'
import json, sys
out, K = sys.argv[1], int(sys.argv[2])
rs = [json.load(open(f"{out}/c{k}/score.json")) for k in range(K)]
tot = sum(r["kept_bytes_est"] for r in rs)
print(f"{out}: kept {tot:,.0f} bytes over {sum(r['end'] - r['start'] for r in rs):,} stream bytes,"
      f" max chunk {max(r['seconds'] for r in rs) / 3600:.2f} h,"
      f" cmix/bits ratio {min(r['cmix_vs_bits_ratio'] for r in rs):.5f}..{max(r['cmix_vs_bits_ratio'] for r in rs):.5f}")
json.dump(dict(total_kept_bytes=tot), open(f"{out}/total.json", "w"))
EOF
echo "$(date -u) done"
echo "exit $?"
