#!/bin/bash
# Mixed-precision QAT variant from ext (like run_A_opt.sh, code from /workspace/mp):
#   RUN_DIR=/workspace/mpX A_BITS_MAP="L03.mlp=7,..." bash run_mp.sh
# 3+1 epochs, A_MIXER=rich, CE 0.1 (ext's recipe). Then export (+ A_BITS_MAP) and Tier 0.
set -euo pipefail
D=${RUN_DIR:?set RUN_DIR}; : ${A_BITS_MAP:?set A_BITS_MAP}
W=/workspace; PY=$W/train/.venv/bin
[ -s /root/data/ppmd-probs.float16 ] || bash $W/scripts/train_A.sh stage
mkdir -p "$D/models"
cp -r $W/mp/pysrc $W/mp/training_recipes "$D/"
ln -sfn /root/data "$D/data"
cd "$D"
export WANDB_MODE=offline PYTHONPATH=. OMP_NUM_THREADS=${OMP_NUM_THREADS:-16} A_BITS_MAP
export A_EPOCHS=${A_EPOCHS:-3} COOLDOWN_EPOCHS=${COOLDOWN_EPOCHS:-1} A_MIXER=rich
[ -s models/start.tch ] || $PY/python $W/agent/mp/make_start.py $W/ext/models/6m-q4-A.tch models/start.tch "$A_BITS_MAP"
tag=$(basename "$D")
# dry run of the later stages on the start checkpoint: export with the map, check the
# changed groups only use their levels, score with Tier 0 (should be ~ the scan's sum)
mkdir -p /root/s64; [ -s /root/s64/ppmd-probs.float16 ] || cp $W/tier0/s64/* /root/s64/
EXPORT_MODEL=models/start.tch EXPORT_OUTPUT=/root/start.tfw $PY/python -m pysrc.export_weights
$PY/python $W/agent/mp/check_levels.py /root/start.tfw "$A_BITS_MAP"
DATA=/root/s64 $PY/python $W/agent/tier0/tier0.py models/start.tch ${tag}_start 2>&1 | grep -v -i -e warn -e articles
echo "mp run in $D: $A_BITS_MAP A_EPOCHS=$A_EPOCHS COOLDOWN_EPOCHS=$COOLDOWN_EPOCHS"
A_INIT=models/start.tch TRAIN_GRAD_CKPT=0 CHECKPOINT_PREFIX=models/6m-q4-A $PY/torchrun --nproc_per_node 1 \
    -m training_recipes.train_A_finetune 2>&1 | tee $W/logs/${tag}_train_A.log
CHECKPOINT_PREFIX=models/6m-q4-fp32-A $PY/torchrun --nproc_per_node 1 \
    -m training_recipes.cooldown_A 2>&1 | tee $W/logs/${tag}_cooldown_A.log
EXPORT_MODEL=models/6m-q4-fp32-A.tch EXPORT_OUTPUT=models/6m-q4-fp32-A.tfw $PY/python -m pysrc.export_weights
$PY/python -m pysrc.weights_compress compress models/6m-q4-fp32-A.tfw models/6m-q4-fp32-A.tfwc2
ls -la models/
mkdir -p /root/s64; [ -s /root/s64/ppmd-probs.float16 ] || cp $W/tier0/s64/* /root/s64/
DATA=/root/s64 $PY/python $W/agent/tier0/tier0.py models/6m-q4-fp32-A.tch $tag 2>&1 | grep -v -i -e warn -e articles
