#!/bin/bash
# Split eval of C2 (standing rule 2026-11-14), k3 build, 1 worker per chunk. Log /workspace/logs/c2split_job.txt; ends "exit 0".
export CMIX_TF_THREADS=1
echo "=== $(date -u) C2 split eval (k3 build, CMIX_TF_THREADS=1)"; nproc
rm -rf /workspace/split/c2
bash /workspace/agent/k3/split_eval_k3.sh c2 /workspace/c2exp/c2_vals.tfwc2 16 > /root/c2split.log 2>&1; grep -v "^exit" /root/c2split.log | tail -3
python3 - <<'PY'
import json
A = "/workspace/split/c2"; B = "/workspace/split/st1"
ta = json.load(open(f"{A}/total.json"))["total_kept_bytes"]; tb = json.load(open(f"{B}/total.json"))["total_kept_bytes"]
for k in range(16):
    a = json.load(open(f"{A}/c{k}/score.json")); b = json.load(open(f"{B}/c{k}/score.json"))
    print(f"chunk {k:2d} c2 {a['kept_bytes_est']:,.0f} st1 {b['kept_bytes_est']:,.0f} d {a['kept_bytes_est'] - b['kept_bytes_est']:+,.0f} ({a['seconds'] / 3600:.2f} h)")
print(f"SPLIT c2 {ta:,.0f} st1 {tb:,.0f} delta {ta - tb:+,.0f}")
PY
echo "$(date -u) c2 split done"; echo "exit 0"
