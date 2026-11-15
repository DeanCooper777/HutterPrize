#!/bin/bash
# Job P (user 2026-11-14 10:10, notes/c2split-752-2026-11-14.md): prune P1c 768 -> 752, gentle 3+1, vs grow_ctl.
# Log /workspace/logs/p752_job.txt, ends "exit 0" (selfstop).
W=/workspace; PY=$W/train/.venv/bin; A=$W/agent/p752; O=$W/p752; P=$W/pr_p1c/models; R=$W/tier0/results; S=$W/grow/src
echo "=== $(date -u) Job P (752)"
[ -s /root/data/ppmd-probs.float16 ] || bash $W/scripts/train_A.sh stage
mkdir -p /root/s64; [ -s /root/s64/ppmd-probs.float16 ] || cp $W/tier0/s64/* /root/s64/
cd $S; export A_ACT16=mlp_down_in,attn_out_in A_ACT16_FREEZE=1 DATA=/root/s64 PYTHONPATH=.
t0() { $PY/python $W/agent/tier0/tier0.py $1 $2 2>&1 | grep -a '"mix512"' | cut -c1-220; python3 -c "import json; print(round(json.load(open('$R/$2.json'))['mix512']))"; }
echo "P1c rerun:"; T_P1C=$(t0 $P/6m-q4-fp32-A.tch p752_p1c_check | tail -1); echo "P1c $T_P1C (last night 95,953,317, diff $((T_P1C - 95953317)))"
T_CTL=95944581
if [ $(( T_P1C - 95953317 )) -gt 1000 ] || [ $(( 95953317 - T_P1C )) -gt 1000 ]; then
  echo "P1c moved > 1,000: rerun control Tier 0"; T_CTL=$(t0 $W/grow_ctl/models/6m-q4-fp32-A.tch grow_ctl_rerun | tail -1); echo "ctl rerun $T_CTL"; fi
echo "=== $(date -u) rankings"
$PY/python $A/rank_w.py $P/6m-q4-fp32-A.tch 16 $O/rank_a.json
$PY/python $A/rank_act.py $P/6m-q4-fp32-A.tch 16 $O/rank_b.json 40 2>&1 | grep -a "rank_act\|Error\|error"
best=; bestv=999999999
for r in a b; do [ -s $O/rank_$r.json ] || continue
  $PY/python $A/prune_idx.py $P/6m-q4-fp32-A.tch /root/p752_fp32_$r.tch $O/rank_$r.json
  v=$(A_DMLP=752 t0 /root/p752_fp32_$r.tch p752_untrained_$r | tail -1); echo "UNTRAINED rank $r: Tier 0 $v, damage vs P1c $((v - T_P1C))"
  [ -n "$v" ] && [ "$v" -lt "$bestv" ] && { best=$r; bestv=$v; }
done
[ -n "$best" ] || { echo "NO RANKING WORKED"; echo "exit 0"; exit 0; }
python3 - $O/rank_a.json $O/rank_b.json <<'PY'
import json, sys
try:
    a, b = (json.load(open(f)) for f in sys.argv[1:3]); print("overlap a/b per layer:", [len(set(a[p]) & set(b[p])) for p in a])
except Exception as e: print("overlap n/a", e)
PY
echo "CHOSEN rank $best (untrained $bestv)"
$PY/python $A/prune_idx.py $P/6m-q4-A.tch $O/p752_qat.tch $O/rank_$best.json
$PY/python $A/prune_idx.py $P/6m-q4-fp32-A.tch $O/p752_fp32.tch $O/rank_$best.json
echo "=== $(date -u) fine-tune pr_p752"
export A_MIXER_INIT=$P/6m-q4-A.mixer.tch A_LR=2.5e-7 EXTRA_PATCH=$W/agent/grow/grow_patch.py A_DMLP=752
START_QAT=$O/p752_qat.tch START_FP32=$O/p752_fp32.tch bash $W/agent/pr/run_pr.sh $W/pr_p752 none $bestv 1000 2>&1 | grep -a -e "dry-run" -e SUMMARY -e int_bytes -e Error -e error | cut -c1-300
echo "pr_p752 rc ${PIPESTATUS[0]}"
python3 - $T_CTL <<'PY'
import json, sys
R = "/workspace/tier0/results"; tc = float(sys.argv[1]); bc = 2788777.6041668607
t = json.load(open(f"{R}/pr_p752.json"))["mix512"]; b = json.load(open(f"{R}/pr_p752_bytes.json"))["int_bytes"]
dt, db = t - tc, b - bc; net = dt + 2 * db
r = {"tier0": t, "int_bytes": b, "ctl_tier0": tc, "d_tier0": dt, "d_bytes_x2": 2 * db, "net": net, "loss_over_saving": dt / (-2 * db) if db else None}
json.dump(r, open(f"{R}/p752_summary.json", "w"), indent=1)
print(f"RESULT p752: Tier 0 {t:,.0f} (ctl {tc:,.0f}) d {dt:+,.0f}; bytes {b:,.1f} d x2 {2 * db:+,.0f}; NET {net:+,.0f}; loss/saving {r['loss_over_saving']:.2f}")
PY
echo "$(date -u) Job P done"; echo "exit 0"
