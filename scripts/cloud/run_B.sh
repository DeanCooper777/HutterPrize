#!/bin/bash
# run_B.sh: the three training stages plus export for experiment "run B" (a smaller
# transformer trained from scratch with the mixture loss). Rejected: see
# docs/NEW_TRANSFORMER_PLAN.md. Output: RUN_DIR/models/6m-q4-fp32-A.tfwc2 and checkpoints.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Run B of docs/NEW_TRANSFORMER_PLAN.md (2026-11-09): a model with MLP width
# B_DMLP (default 384) trained from scratch with the cmix mixture loss on all
# GPUs of this pod, in three stages like upstream, then export.
#   1. train_B.py         bf16, no quantization, B_EPOCHS        -> models/B.tch
#   2. train_A_finetune   QAT from B.tch (scales fitted first),
#                         Q_EPOCHS                               -> models/6m-q4-A.tch
#   3. cooldown_A         fp32, COOLDOWN_EPOCHS                  -> models/6m-q4-fp32-A.tch
#   RUN_DIR=/workspace/B B_EPOCHS=128 Q_EPOCHS=24 COOLDOWN_EPOCHS=4 bash run_B.sh
# A stage whose output already exists is skipped, so a rerun resumes at the
# first unfinished stage (a stage itself restarts from its beginning).
set -euo pipefail
D=${RUN_DIR:?set RUN_DIR}
W=/workspace
PY=$W/train/.venv/bin
N=$(nvidia-smi -L | wc -l)
[ -s /root/data/ppmd-probs.float16 ] || bash $W/scripts/train_A.sh stage
mkdir -p "$D/models"
cp -r $W/opt/pysrc $W/opt/training_recipes "$D/"
ln -sfn /root/data "$D/data"
cd "$D"
export WANDB_MODE=offline PYTHONPATH=. OMP_NUM_THREADS=${OMP_NUM_THREADS:-8}
export B_DMLP=${B_DMLP:-384} B_EPOCHS=${B_EPOCHS:-128}
export A_DMLP=$B_DMLP A_EPOCHS=${Q_EPOCHS:-24} COOLDOWN_EPOCHS=${COOLDOWN_EPOCHS:-4}
tag=$(basename "$D")
echo "run B in $D on $N GPUs: B_DMLP=$B_DMLP B_EPOCHS=$B_EPOCHS Q_EPOCHS=$A_EPOCHS COOLDOWN_EPOCHS=$COOLDOWN_EPOCHS"
if [ ! -s models/B.tch ]; then
  echo "=== $(date -u) stage 1"
  CHECKPOINT_PREFIX=models/B $PY/torchrun --nproc_per_node $N \
      -m training_recipes.train_B 2>&1 | tee $W/logs/${tag}_stage1.log
fi
if [ ! -s models/6m-q4-A.tch ]; then
  echo "=== $(date -u) stage 2"
  A_INIT=models/B.tch A_INIT_SCALES=256 TRAIN_GRAD_CKPT=0 CHECKPOINT_PREFIX=models/6m-q4-A \
      $PY/torchrun --nproc_per_node $N -m training_recipes.train_A_finetune 2>&1 \
      | tee $W/logs/${tag}_stage2.log
fi
if [ ! -s models/6m-q4-fp32-A.tch ]; then
  echo "=== $(date -u) stage 3"
  CHECKPOINT_PREFIX=models/6m-q4-fp32-A $PY/torchrun --nproc_per_node $N \
      -m training_recipes.cooldown_A 2>&1 | tee $W/logs/${tag}_stage3.log
fi
echo "=== $(date -u) export"
EXPORT_MODEL=models/6m-q4-fp32-A.tch EXPORT_OUTPUT=models/6m-q4-fp32-A.tfw \
    $PY/python -m pysrc.export_weights
$PY/python -m pysrc.weights_compress compress models/6m-q4-fp32-A.tfw models/6m-q4-fp32-A.tfwc2
ls -la models/
