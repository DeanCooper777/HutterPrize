#!/bin/bash
# Up-bit QAT variant from ext (code /workspace/mp, A_BITS_MAP with 31 levels):
#   RUN_DIR=/workspace/upX A_BITS_MAP="embedding=31,..." (or "ALL=31") bash run_up.sh
# Dry run: Tier 0 of the start must equal ext (q31 = 2*q4). Then 3+1 epochs (rich mixer,
# CE 0.1), Tier 0, int-entropy bytes. No export (C++/coder do not handle |q| > 7 yet).
set -euo pipefail
D=${RUN_DIR:?set RUN_DIR}; SPEC=${A_BITS_MAP:?set A_BITS_MAP}
W=/workspace; PY=$W/train/.venv/bin
[ -s /root/data/ppmd-probs.float16 ] || bash $W/scripts/train_A.sh stage
mkdir -p "$D/models"; cp -r $W/mp/pysrc $W/mp/training_recipes "$D/"; ln -sfn /root/data "$D/data"
cd "$D"
# A_BITS_MAP=ALL=31 is expanded to every group for bits_map
if [ "$SPEC" = "ALL=31" ]; then
  A_BITS_MAP=$(PYTHONPATH=. $PY/python -c "
import sys,torch; sys.path.insert(0,'$W/agent/tier0'); from sens import groups
print(','.join(g+'=31' for g in sorted(groups(torch.load('$W/ext/models/6m-q4-A.tch',map_location='cpu')))))" 2>/dev/null)
fi
export WANDB_MODE=offline PYTHONPATH=. OMP_NUM_THREADS=${OMP_NUM_THREADS:-16} A_BITS_MAP
export A_EPOCHS=${A_EPOCHS:-3} COOLDOWN_EPOCHS=${COOLDOWN_EPOCHS:-1} A_MIXER=rich
tag=$(basename "$D")
echo "up run $tag: $A_BITS_MAP"
[ -s models/start.tch ] || $PY/python $W/agent/up/make_start_up.py $W/ext/models/6m-q4-A.tch models/start.tch "$SPEC"
mkdir -p /root/s64; [ -s /root/s64/ppmd-probs.float16 ] || cp $W/tier0/s64/* /root/s64/
# dry run: the same transform applied to ext's final (cooldown) ckpt must score like ext (96,133,6xx)
$PY/python $W/agent/up/make_start_up.py $W/ext/models/6m-q4-fp32-A.tch /root/check_${tag}.tch "$SPEC"
DATA=/root/s64 $PY/python $W/agent/tier0/tier0.py /root/check_${tag}.tch ${tag}_check 2>&1 | grep -v -i -e warn -e articles
$PY/python - $W/tier0/results/${tag}_check.json <<'PY'
import json, sys
v = json.load(open(sys.argv[1]))["mix512"]; print("dry-run check", v, "ext 96,133,6xx")
assert abs(v - 96133650) < 20000, "start does not reproduce ext"
PY
A_INIT=models/start.tch TRAIN_GRAD_CKPT=0 CHECKPOINT_PREFIX=models/6m-q4-A $PY/torchrun --nproc_per_node 1 \
    -m training_recipes.train_A_finetune 2>&1 | tee $W/logs/${tag}_train_A.log
CHECKPOINT_PREFIX=models/6m-q4-fp32-A $PY/torchrun --nproc_per_node 1 \
    -m training_recipes.cooldown_A 2>&1 | tee $W/logs/${tag}_cooldown_A.log
DATA=/root/s64 $PY/python $W/agent/tier0/tier0.py models/6m-q4-fp32-A.tch $tag 2>&1 | grep -v -i -e warn -e articles
$PY/python $W/agent/up/int_bytes.py models/6m-q4-fp32-A.tch "$SPEC" | tee $W/tier0/results/${tag}_bytes.json
