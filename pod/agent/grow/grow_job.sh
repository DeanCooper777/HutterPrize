#!/bin/bash
# MLP-widening test (user decision 2026-11-13 23:40, notes/grow-2026-11-13.md). Ends "exit 0" (selfstop).
# Dry run: Tier 0 of P1c, G16-grown and G64-grown final ckpts on this pod (must agree within 1,000).
# Then control (768), G16 (784), G64 (832): gentle recipe 3+1 from P1c, new entries at 10x LR.
W=/workspace; PY=$W/train/.venv/bin; G=$W/grow; P=$W/pr_p1c/models; R=$W/tier0/results
echo "=== $(date -u) grow job"
[ -s /root/data/ppmd-probs.float16 ] || bash $W/scripts/train_A.sh stage
mkdir -p /root/s64; [ -s /root/s64/ppmd-probs.float16 ] || cp $W/tier0/s64/* /root/s64/
# dry run with the PATCHED source (act16 hook) and act16 on, like run_pr (first attempt 00:07 used
# unpatched /workspace/mp without A_ACT16: invalid, 121.4M)
rm -rf $G/src; mkdir -p $G/src; cp -r $W/mp/pysrc $W/mp/training_recipes $G/src/
$PY/python $W/agent/pr/patch_src.py $G/src; $PY/python $W/agent/grow/grow_patch.py $G/src
cd $G/src; export A_ACT16=mlp_down_in,attn_out_in A_ACT16_FREEZE=1
DATA=/root/s64 PYTHONPATH=. $PY/python $W/agent/tier0/tier0.py $P/6m-q4-fp32-A.tch grow_p1c_check 2>&1 | grep -a '"mix512"' | cut -c1-200
for w in 784 832; do A_DMLP=$w DATA=/root/s64 PYTHONPATH=. $PY/python $W/agent/tier0/tier0.py $G/g${w}_fp32.tch grow_g${w}_check 2>&1 | grep -a '"mix512"' | cut -c1-200; done
$PY/python - <<'PY' > /tmp/dry.txt
import json
R = "/workspace/tier0/results"; v = {t: json.load(open(f"{R}/grow_{t}_check.json"))["mix512"] for t in ("p1c", "g784", "g832")}
ok = all(abs(v[t] - v["p1c"]) < 1000 for t in ("g784", "g832")) and abs(v["p1c"] - 95953178) < 8000
print(f"DRY p1c {v['p1c']:,.0f} (old pod 95,953,178) g784 {v['g784'] - v['p1c']:+,.0f} g832 {v['g832'] - v['p1c']:+,.0f} {'PASS' if ok else 'FAIL'}")
print(round(v["p1c"]), round(v["g784"]), round(v["g832"]))
PY
cat /tmp/dry.txt | head -1
if ! grep -q PASS /tmp/dry.txt; then echo "DRY RUN FAILED: not training"; echo "exit 0"; exit 0; fi
read T0 T784 T832 < <(sed -n 2p /tmp/dry.txt)
export A_MIXER_INIT=$P/6m-q4-A.mixer.tch A_LR=2.5e-7 A_ACT16=mlp_down_in,attn_out_in A_ACT16_FREEZE=1 EXTRA_PATCH=$W/agent/grow/grow_patch.py
run() { tag=$1; echo "=== $(date -u) $tag"; bash $W/agent/pr/run_pr.sh $W/$tag none $2 $3 2>&1 | grep -a -e "dry-run" -e SUMMARY -e int_bytes -e A_GROW -e Error -e error | cut -c1-300; echo "$tag rc ${PIPESTATUS[0]}"
  tr "\r" "\n" < $W/logs/${tag}_train_A.log | grep -a -e "^GROW" | sed -n '1p;2p;$p'; tr "\r" "\n" < $W/logs/${tag}_cooldown_A.log | grep -a "^GROW" | tail -1; }
START_QAT=$P/6m-q4-A.tch START_FP32=$P/6m-q4-fp32-A.tch A_DMLP=768 run grow_ctl $T0 8000
START_QAT=$G/g784_qat.tch START_FP32=$G/g784_fp32.tch A_DMLP=784 A_GROW_OLD=768 A_GROW_LR_MULT=10 run grow_g16 $T784 1000
START_QAT=$G/g832_qat.tch START_FP32=$G/g832_fp32.tch A_DMLP=832 A_GROW_OLD=768 A_GROW_LR_MULT=10 run grow_g64 $T832 1000
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
