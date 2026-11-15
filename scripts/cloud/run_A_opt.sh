#!/bin/bash
# run_A_opt.sh: the complete cmix-aware retraining of the transformer on one GPU: fine-tune
# with the mixture loss (training_recipes/train_A_finetune.py), float32 cooldown
# (cooldown_A.py), export (pysrc/export_weights.py) and packing into a .tfwc2 weights file
# (pysrc/weights_compress.py). SUBMISSION.md, "Retrain the weights", refers to this script.
# Inputs: the staged training data, the code under /workspace/opt, the starting checkpoint.
# Output: RUN_DIR/models/6m-q4-fp32-A.tfwc2 (the file the compressor embeds) and checkpoints.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Run A with the optimized code (fused fake quant, sync fixes, no gradient
# checkpointing in the bf16 fine-tune) in its own directory, then export.
#   RUN_DIR=/workspace/full A_EPOCHS=24 COOLDOWN_EPOCHS=4 bash run_A_opt.sh
# RUN_DIR gets a copy of /workspace/opt's code and the starting model; data/
# points at the pod's staged copy (/root/data, see train_A.sh stage).
set -euo pipefail
D=${RUN_DIR:?set RUN_DIR}
W=/workspace
PY=$W/train/.venv/bin
[ -s /root/data/ppmd-probs.float16 ] || bash $W/scripts/train_A.sh stage
mkdir -p "$D/models"
cp -r $W/opt/pysrc $W/opt/training_recipes "$D/"
[ -s "$D/models/6m-q4.tch" ] || cp $W/opt/models/6m-q4.tch "$D/models/"
ln -sfn /root/data "$D/data"
cd "$D"
export WANDB_MODE=offline PYTHONPATH=. OMP_NUM_THREADS=${OMP_NUM_THREADS:-16}
export A_EPOCHS=${A_EPOCHS:-3} COOLDOWN_EPOCHS=${COOLDOWN_EPOCHS:-1}
tag=$(basename "$D")
echo "run A in $D: A_EPOCHS=$A_EPOCHS COOLDOWN_EPOCHS=$COOLDOWN_EPOCHS"
TRAIN_GRAD_CKPT=0 CHECKPOINT_PREFIX=models/6m-q4-A $PY/torchrun --nproc_per_node 1 \
    -m training_recipes.train_A_finetune 2>&1 | tee $W/logs/${tag}_train_A.log
CHECKPOINT_PREFIX=models/6m-q4-fp32-A $PY/torchrun --nproc_per_node 1 \
    -m training_recipes.cooldown_A 2>&1 | tee $W/logs/${tag}_cooldown_A.log
EXPORT_MODEL=models/6m-q4-fp32-A.tch EXPORT_OUTPUT=models/6m-q4-fp32-A.tfw \
    $PY/python -m pysrc.export_weights
$PY/python -m pysrc.weights_compress compress models/6m-q4-fp32-A.tfw models/6m-q4-fp32-A.tfwc2
ls -la models/
