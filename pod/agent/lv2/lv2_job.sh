#!/bin/bash
# Lever 2 run: lv2_job.sh TAG COOLDOWN_LR EPOCHS  (notes/lever2-cooldown-2026-11-14.md). From C2's final ckpt.
# Log /workspace/logs/lv2_TAG.txt, ends "exit 0" (selfstop).
TAG=$1; LR=$2; E=$3
W=/workspace; PY=$W/train/.venv/bin; D=$W/lv2_$TAG; R=$W/tier0/results; C2=$W/pr_c2/models/6m-q4-fp32-A.tch; L=$W/agent/lv2
echo "=== $(date -u) Lever 2 $TAG: COOLDOWN_LR $LR, $E epochs, from C2"
[ -s /root/data/ppmd-probs.float16 ] || bash $W/scripts/train_A.sh stage
mkdir -p /root/s64; [ -s /root/s64/ppmd-probs.float16 ] || cp $W/tier0/s64/* /root/s64/
rm -rf $D; mkdir -p $D/models; cp -r $W/mp/pysrc $W/mp/training_recipes $D/; ln -sfn /root/data $D/data
$PY/python $W/agent/pr/patch_src.py $D; $PY/python $L/lv2_patch.py $D
cd $D; cp $C2 models/6m-q4-A.tch
export WANDB_MODE=offline PYTHONPATH=. OMP_NUM_THREADS=16 A_MIXER=rich A_ACT16=mlp_down_in,attn_out_in A_ACT16_FREEZE=1 A_KEEP_EPOCHS=1
t0() { DATA=/root/s64 $PY/python $W/agent/tier0/tier0.py $1 $2 2>&1 | grep -a '"mix512"' > /dev/null; python3 -c "import json; print(round(json.load(open('$R/$2.json'))['mix512']))"; }
REF=$(t0 $C2 lv2_${TAG}_c2ref); echo "C2 same-pod Tier 0 $REF (C2 earlier 95,914,324, diff $((REF - 95914324)))"
echo "--- dry run: average C2 e2+e3 (forced) and Tier 0 it"
$PY/python $L/avg.py /root/dryavg.tch $W/pr_c2/models/6m-q4-fp32-A.e2.tch $W/pr_c2/models/6m-q4-fp32-A.e3.tch --force | tail -1
DRY=$(t0 /root/dryavg.tch lv2_${TAG}_dryavg); echo "dry avg Tier 0 $DRY (vs C2 $((DRY - REF)))"; [ -n "$DRY" ] || { echo "DRY RUN FAILED"; echo "exit 0"; exit 0; }
FROM=$(python3 -c "print(1 - 0.25 / $E)")
echo "=== $(date -u) cooldown (snapshots from fraction $FROM every 38 steps)"
COOLDOWN_EPOCHS=$E COOLDOWN_LR=$LR A_SNAP_FROM=$FROM A_SNAP_EVERY=38 CHECKPOINT_PREFIX=models/6m-q4-fp32-A $PY/torchrun --nproc_per_node 1 \
  -m training_recipes.cooldown_A > $W/logs/lv2_${TAG}_cooldown.log 2>&1; echo "cooldown rc $?"
tr '\r' '\n' < $W/logs/lv2_${TAG}_cooldown.log | grep -a -o "COOLDOWN_LR.*\|SNAP.*" | head -12
for e in $(seq 1 $E); do f=models/6m-q4-fp32-A.e$e.tch; [ -s $f ] || continue; v=$(t0 $f lv2_${TAG}_e$e); echo "$TAG EPOCH $e tier0 $v vs C2 $((v - REF))"; done
FIN=$(t0 models/6m-q4-fp32-A.tch lv2_${TAG}); echo "$TAG FINAL tier0 $FIN vs C2 $((FIN - REF))"
$PY/python $W/agent/up/int_bytes.py models/6m-q4-fp32-A.tch | tee $R/lv2_${TAG}_bytes.json
SN=$(ls models/6m-q4-fp32-A.snap*.tch 2>/dev/null | sort -V | tr '\n' ' '); echo "snapshots: $SN"
if [ -n "$SN" ]; then $PY/python $L/avg.py models/avg.tch $SN | tail -2
  if [ -s models/avg.tch ]; then AV=$(t0 models/avg.tch lv2_${TAG}_avg); echo "$TAG AVG tier0 $AV vs C2 $((AV - REF))"; $PY/python $W/agent/up/int_bytes.py models/avg.tch | tee $R/lv2_${TAG}_avg_bytes.json; fi; fi
python3 - $TAG $REF <<'PY'
import json, sys
t, ref = sys.argv[1], float(sys.argv[2]); R = "/workspace/tier0/results"; C2B = 2788370.505130571
for tag in (f"lv2_{t}", f"lv2_{t}_avg"):
    try: v = json.load(open(f"{R}/{tag}.json"))["mix512"]; b = json.load(open(f"{R}/{tag}_bytes.json"))["int_bytes"]
    except Exception: continue
    print(f"RESULT {tag}: Tier 0 {v - ref:+,.0f} vs C2 (same pod), int bytes x2 {2 * (b - C2B):+,.0f}, NET {v - ref + 2 * (b - C2B):+,.0f}")
PY
echo "$(date -u) $TAG done"; echo "exit 0"
