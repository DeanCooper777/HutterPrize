#!/bin/bash
# train_A.sh: first version of the driver for the cmix-aware fine-tune ("run A") on a GPU
# machine: install the Python environment, copy the training data to fast local disk, smoke
# test, run fine-tune + cooldown, export. run_A_opt.sh is the later, faster driver and reuses
# the "stage" step of this script.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Run A (docs/NEW_TRANSFORMER_PLAN.md) on a RunPod GPU pod with the network
# volume at /workspace, after scripts/cloud/datagen.sh has filled
# /workspace/data.
#
#   upload/train.tar.gz   pysrc, training_recipes, pyproject.toml, uv.lock,
#                         models/6m-q4.tch (scripts/cloud/pack_train.sh)
#
# usage: bash train_A.sh setup              install the environment
#        bash train_A.sh smoke              ~20 min: tiny run of both steps
#        bash train_A.sh run [n_gpus]       fine-tune + cooldown
# Checkpoints land in /workspace/train/models/.
set -euo pipefail
W=/workspace
T=$W/train
export WANDB_MODE=offline
export UV_CACHE_DIR=$W/uv-cache

# Unpack the training code, install the pinned environment, check that the data is there.
setup() {
  mkdir -p "$T"
  # --no-same-owner: the network volume refuses chown to the Windows uid
  tar xzf "$W/upload/train.tar.gz" --no-same-owner -C "$T"
  ln -sfn "$W/data" "$T/data"
  cd "$T"
  command -v uv > /dev/null || pip install -q uv
  uv sync
  nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv
  for f in ppmd-bytes.uint8 ppmd-probs.float16 article-boundaries.int32 cmix-bits.float16; do
    test -s "data/$f" || { echo "missing data/$f" >&2; exit 1; }
  done
  echo "setup ok"
}

# Shuffled article reads from the network volume run at ~90 MB/s, which starves
# the GPU (13 s per step, 2026-11-07); copy the data to the container disk
# (needs ~255 GB; the pod's disk must be >= 300 GB) and point data/ at it.
# The copy is lost when the pod restarts: run stage again.
stage() {
  local L=/root/data
  mkdir -p "$L"
  for f in ppmd-bytes.uint8 article-boundaries.int32 cmix-bits.float16; do
    cp "$W/data/$f" "$L/"
  done
  # the 243 GB priors in 8 parallel slices (one sequential stream is ~540 MB/s)
  local f=ppmd-probs.float16 n k
  n=$(stat -c %s "$W/data/$f")
  truncate -s "$n" "$L/$f"
  local slice=$(((n / 8 + (1 << 22) - 1) / (1 << 22)))
  for ((k = 0; k < 8; k++)); do
    dd if="$W/data/$f" of="$L/$f" bs=4M skip=$((k * slice)) seek=$((k * slice)) \
       count=$slice conv=notrunc status=none &
  done
  wait
  cmp -n 1000000000 "$W/data/$f" "$L/$f"
  for f in ppmd-bytes.uint8 ppmd-probs.float16 article-boundaries.int32 cmix-bits.float16; do
    test "$(stat -c %s "$L/$f")" -eq "$(stat -c %s "$W/data/$f")" || { echo "size $f" >&2; exit 1; }
  done
  (cd "$L" && sha256sum -c "$W/upload/tokens.sha256")
  ln -sfn "$L" "$T/data"
  echo "stage ok"
}

smoke() {
  [ -s /root/data/ppmd-probs.float16 ] || stage
  cd "$T"
  # one epoch was ~2.4 h on an RTX PRO 6000 before the sync fix; a fraction of an epoch is not
  # expressible, so the smoke test runs 1 epoch of the fine-tune with the
  # mixture loss and stops it after 15 minutes: enough to see the loss
  # going down and to measure tokens/s
  A_EPOCHS=1 timeout 15m uv run torchrun --nproc_per_node 1 \
      -m training_recipes.train_A_finetune 2>&1 | tee "$W/logs/smoke_A.log" || true
  grep -E "loss|tokens" "$W/logs/smoke_A.log" | tail -20
}

# Fine-tune, cooldown, export.
run() {
  local n=${1:-1}
  # epochs: A_EPOCHS (fine-tune) and COOLDOWN_EPOCHS, see the recipes
  [ -s /root/data/ppmd-probs.float16 ] || stage
  cd "$T"
  # CHECKPOINT_PREFIX: a checkpoint at the end of every epoch (pysrc/train.py)
  CHECKPOINT_PREFIX=models/6m-q4-A uv run torchrun --nproc_per_node "$n" \
      -m training_recipes.train_A_finetune 2>&1 | tee "$W/logs/train_A.log"
  CHECKPOINT_PREFIX=models/6m-q4-fp32-A uv run torchrun --nproc_per_node "$n" -m training_recipes.cooldown_A \
      2>&1 | tee "$W/logs/cooldown_A.log"
  export_A
}

# checkpoint -> the compressor's compressed weight file (.tfwc2)
export_A() {
  cd "$T"
  EXPORT_MODEL=models/6m-q4-fp32-A.tch EXPORT_OUTPUT=models/6m-q4-fp32-A.tfw       uv run python -m pysrc.export_weights
  uv run python -m pysrc.weights_compress compress models/6m-q4-fp32-A.tfw       models/6m-q4-fp32-A.tfwc2
  ls -la models/
}

mkdir -p "$W/logs"
case "${1:-}" in
  setup) setup ;;
  stage) stage ;;
  smoke) smoke ;;
  run) run "${2:-1}" ;;
  export) export_A ;;
  *) echo "usage: $0 setup | smoke | run [n_gpus]" >&2; exit 2 ;;
esac
