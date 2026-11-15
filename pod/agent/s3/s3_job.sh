#!/bin/bash
# Lever 1 split eval: s3_job.sh TAG TUNEFILE. K=16 k3, CMIX_TF_THREADS=1, C2 weights, vs split/c2. Log logs/s3_TAG.txt; ends "exit 0".
TAG=$1; TF=$2
export CMIX_TF_THREADS=1 CMIX_TUNE=$TF
echo "=== $(date -u) split $TAG, CMIX_TUNE=$TF: $(tr '\n' ' ' < $TF)"; nproc
rm -rf /workspace/split/$TAG
bash /workspace/agent/k3/split_eval_k3.sh $TAG /workspace/split/w/c2.tfwc2 16 > /root/s3_$TAG.log 2>&1; grep -v "^exit" /root/s3_$TAG.log | tail -3
python3 - $TAG <<'PY'
import json, sys
t = sys.argv[1]; A = f"/workspace/split/{t}"; B = "/workspace/split/c2"
ta = json.load(open(f"{A}/total.json"))["total_kept_bytes"]; tb = json.load(open(f"{B}/total.json"))["total_kept_bytes"]; neg = 0
for k in range(16):
    a = json.load(open(f"{A}/c{k}/score.json")); b = json.load(open(f"{B}/c{k}/score.json")); d = a["kept_bytes_est"] - b["kept_bytes_est"]; neg += d < 0
    print(f"chunk {k:2d} d {d:+8,.0f}  secs {a['seconds']} (c2 {b['seconds']})")
print(f"SPLIT {t} {ta:,.0f} vs c2 {tb:,.0f}: delta {ta - tb:+,.0f}, {neg}/16 chunks better")
PY
echo "$(date -u) split $TAG done"; echo "exit 0"
