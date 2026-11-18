#!/bin/bash
# Job C2 (2026-11-13): 3 more fp32 cooldown epochs from P1c's final checkpoint (ext had 4, P1c 1;
# P1c's one cooldown epoch was worth -277K Tier 0). Tier 0 after each epoch. Ends "exit 0".
W=/workspace; PY=$W/train/.venv/bin; D=$W/pr_c2
until grep -q "^exit 0" $W/logs/c1_job.txt; do sleep 60; done
echo "=== $(date -u) C2: P1c + 3 cooldown epochs"
rm -rf $D; mkdir -p $D/models; cp -r $W/mp/pysrc $W/mp/training_recipes $D/; ln -sfn /root/data $D/data
$PY/python $W/agent/pr/patch_src.py $D; cd $D
cp $W/pr_p1c/models/6m-q4-fp32-A.tch models/6m-q4-A.tch
export WANDB_MODE=offline PYTHONPATH=. OMP_NUM_THREADS=16 A_MIXER=rich A_ACT16=mlp_down_in,attn_out_in A_ACT16_FREEZE=1 A_KEEP_EPOCHS=1
COOLDOWN_EPOCHS=3 CHECKPOINT_PREFIX=models/6m-q4-fp32-A $PY/torchrun --nproc_per_node 1 -m training_recipes.cooldown_A > $W/logs/pr_c2_cooldown_A.log 2>&1; echo "cooldown rc $?"
for e in 1 2 3; do f=models/6m-q4-fp32-A.e$e.tch; [ -s $f ] || continue
  DATA=/root/s64 $PY/python $W/agent/tier0/tier0.py $f pr_c2_e$e 2>&1 | grep -a '"mix512"' | python3 -c "import json,sys; d=json.loads(sys.stdin.read()); print('C2 EPOCH $e tier0', round(d['mix512']), 'vs P1c', round(d['mix512'] - 95953178), 'tf_only', round(d['tf_only']))"; done
$PY/python $W/agent/up/int_bytes.py models/6m-q4-fp32-A.tch | tee $W/tier0/results/pr_c2_bytes.json
echo "$(date -u) C2 done"; echo "exit 0"
