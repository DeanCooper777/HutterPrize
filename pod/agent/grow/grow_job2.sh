#!/bin/bash
# Grow job part 2 (04:05 UTC 11-14): G16 at A_GROW_LR_MULT=10 did not train (step 801/1806: 8/36,864 new
# down ints nonzero, mean |w| 0.0007 vs 0.024), so it was stopped. Control (done, valid) is reused.
# G16 and G64 rerun with A_GROW_LR_MULT=100. Appends to grow_job.txt; ends "exit 0" (selfstop).
W=/workspace; PY=$W/train/.venv/bin; G=$W/grow; P=$W/pr_p1c/models; R=$W/tier0/results
echo "=== $(date -u) grow job part 2 (mult 100)"
T784=95953304; T832=95953253
export A_MIXER_INIT=$P/6m-q4-A.mixer.tch A_LR=2.5e-7 A_ACT16=mlp_down_in,attn_out_in A_ACT16_FREEZE=1 EXTRA_PATCH=$W/agent/grow/grow_patch.py
run() { tag=$1; echo "=== $(date -u) $tag"; bash $W/agent/pr/run_pr.sh $W/$tag none $2 $3 2>&1 | grep -a -e "dry-run" -e SUMMARY -e int_bytes -e A_GROW -e Error -e error | cut -c1-300; echo "$tag rc ${PIPESTATUS[0]}"
  tr "\r" "\n" < $W/logs/${tag}_train_A.log | grep -a -o "GROW step.*" | sed -n '1p;2p;$p'; tr "\r" "\n" < $W/logs/${tag}_cooldown_A.log | grep -a -o "GROW step.*" | tail -1; }
START_QAT=$G/g784_qat.tch START_FP32=$G/g784_fp32.tch A_DMLP=784 A_GROW_OLD=768 A_GROW_LR_MULT=100 run grow_g16 $T784 1000
START_QAT=$G/g832_qat.tch START_FP32=$G/g832_fp32.tch A_DMLP=832 A_GROW_OLD=768 A_GROW_LR_MULT=100 run grow_g64 $T832 1000
$PY/python - <<'PY'
import json
R = "/workspace/tier0/results"; S = {}
for t in ("grow_ctl", "grow_g16", "grow_g64"):
    try: S[t] = (json.load(open(f"{R}/{t}.json"))["mix512"], json.load(open(f"{R}/{t}_bytes.json"))["int_bytes"])
    except Exception as e: print("missing", t, e)
c = S.get("grow_ctl"); out = {"ctl": c}
for t in ("grow_g16", "grow_g64"):
    if c and t in S:
        dt, db = S[t][0] - c[0], S[t][1] - c[1]
        out[t] = {"tier0": S[t][0], "bytes": S[t][1], "d_tier0": dt, "d_bytes_x2": 2 * db, "net": dt + 2 * db, "gain_cost": -dt / (2 * db) if db else None}
        print(f"RESULT {t}: d_tier0 {dt:+,.0f} d_bytes_x2 {2 * db:+,.0f} net {dt + 2 * db:+,.0f} gain/cost {-dt / (2 * db) if db else 0:.2f}")
json.dump(out, open(f"{R}/grow_summary.json", "w"), indent=1)
PY
echo "$(date -u) grow job done"; echo "exit 0"
