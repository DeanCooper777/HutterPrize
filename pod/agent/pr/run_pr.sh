#!/bin/bash
# One probe run: RUN_DIR START(none|act16:G,..|up31) [A_BITS_MAP A_ACT16 A_ENT_LAMBDA] EXPECT TOL
# start from ext's QAT ckpt, dry-run Tier 0 of the same transform applied to ext's final ckpt,
# 3+1 epochs with ext's recipe (rich mixer, CE 0.1), Tier 0, int bytes.
set -euo pipefail
D=$1; MODE=$2; EXPECT=$3; TOL=$4
W=/workspace; PY=$W/train/.venv/bin; tag=$(basename "$D")
[ -s /root/data/ppmd-probs.float16 ] || bash $W/scripts/train_A.sh stage
mkdir -p /root/s64; [ -s /root/s64/ppmd-probs.float16 ] || cp $W/tier0/s64/* /root/s64/
rm -rf "$D"; mkdir -p "$D/models"; cp -r $W/mp/pysrc $W/mp/training_recipes "$D/"; ln -sfn /root/data "$D/data"
$PY/python $W/agent/pr/patch_src.py "$D"
[ -n "${EXTRA_PATCH:-}" ] && $PY/python $EXTRA_PATCH "$D"
cd "$D"
if [ "$MODE" = up31 ]; then
  export A_BITS_MAP=$(PYTHONPATH=. $PY/python -c "
import sys,torch; sys.path.insert(0,'$W/agent/tier0'); from sens import groups
print(','.join(g+'=31' for g in sorted(groups(torch.load('$W/ext/models/6m-q4-A.tch',map_location='cpu')))))" 2>/dev/null)
fi
export WANDB_MODE=offline PYTHONPATH=. OMP_NUM_THREADS=16 A_EPOCHS=${A_EPOCHS:-3} COOLDOWN_EPOCHS=${COOLDOWN_EPOCHS:-1} A_MIXER=rich
echo "probe $tag: MODE=$MODE A_ACT16=${A_ACT16:-} A_ENT_LAMBDA=${A_ENT_LAMBDA:-0} A_BITS_MAP=${A_BITS_MAP:-}"
$PY/python $W/agent/pr/make_start_pr.py ${START_QAT:-$W/ext/models/6m-q4-A.tch} models/start.tch "$MODE"
$PY/python $W/agent/pr/make_start_pr.py ${START_FP32:-$W/ext/models/6m-q4-fp32-A.tch} /root/check_$tag.tch "$MODE"
DATA=/root/s64 $PY/python $W/agent/tier0/tier0.py /root/check_$tag.tch ${tag}_check 2>&1 | grep -v -i -e warn -e articles
$PY/python - $W/tier0/results/${tag}_check.json $EXPECT $TOL <<'PY'
import json, sys
v = json.load(open(sys.argv[1]))["mix512"]; e, t = float(sys.argv[2]), float(sys.argv[3])
print(f"dry-run check {v:,.0f} expected {e:,.0f} +- {t:,.0f}"); assert abs(v - e) < t, "dry run FAILED"
PY
A_INIT=models/start.tch TRAIN_GRAD_CKPT=0 CHECKPOINT_PREFIX=models/6m-q4-A $PY/torchrun --nproc_per_node 1 \
    -m training_recipes.train_A_finetune > $W/logs/${tag}_train_A.log 2>&1
tr "\r" "\n" < $W/logs/${tag}_train_A.log | grep -a -e "ENT step" -e "^A_" | head -100 || true
if [ -n "${A_KEEP_EPOCHS:-}" ]; then for f in models/6m-q4-A.e*.tch; do e=${f#models/6m-q4-A.e}; e=${e%.tch}
  DATA=/root/s64 $PY/python $W/agent/tier0/tier0.py $f ${tag}_e$e 2>&1 | grep -a '"mix512"' | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); print('EPOCH $e tier0', round(d['mix512']), 'tf_only', round(d['tf_only']))" || true; done; fi
A_ENT_LAMBDA=0 A_MIXER_INIT= CHECKPOINT_PREFIX=models/6m-q4-fp32-A $PY/torchrun --nproc_per_node 1 \
    -m training_recipes.cooldown_A > $W/logs/${tag}_cooldown_A.log 2>&1
DATA=/root/s64 $PY/python $W/agent/tier0/tier0.py models/6m-q4-fp32-A.tch $tag 2>&1 | grep -v -i -e warn -e articles
$PY/python $W/agent/up/int_bytes.py models/6m-q4-fp32-A.tch "${A_BITS_MAP:-}" | tee $W/tier0/results/${tag}_bytes.json
$PY/python - $tag <<'PY'
import json, sys
t = sys.argv[1]; R = "/workspace/tier0/results"
v = json.load(open(f"{R}/{t}.json"))["mix512"]; b = json.load(open(f"{R}/{t}_bytes.json"))["int_bytes"]
EXT_T0, EXT_B = 96133678, 2789712
r = {"tag": t, "tier0": v, "d_tier0": v - EXT_T0, "int_bytes": b, "d_bytes_x2": 2 * (b - EXT_B), "net_vs_ext": v - EXT_T0 + 2 * (b - EXT_B)}
json.dump(r, open(f"{R}/{t}_summary.json", "w"), indent=1); print("SUMMARY", json.dumps(r))
PY
