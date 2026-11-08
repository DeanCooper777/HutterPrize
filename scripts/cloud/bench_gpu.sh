#!/bin/bash
# Step-time benchmark of run A's optimized recipes on this pod's GPU, for the
# GPU price comparison (2026-11-07). Stages the data first if needed, then
# runs each configuration for a few minutes and records the steady s/it and
# peak GPU memory. Uses its own copy of the code in /workspace/bench so it
# never touches /workspace/opt/models (a real run may be using it).
#   bash bench_gpu.sh > /workspace/logs/bench_<gpu>.txt 2>&1
set -uo pipefail
W=/workspace
B=$W/bench
[ -s /root/data/ppmd-probs.float16 ] || bash $W/scripts/train_A.sh stage || exit 1
mkdir -p $B/models
cp -r $W/opt/pysrc $W/opt/training_recipes $B/
cp $W/opt/models/6m-q4.tch $B/models/6m-q4.tch
cp $W/opt/models/6m-q4.tch $B/models/6m-q4-A.tch  # stand-in for the cooldown
ln -sfn /root/data $B/data
cd $B
export WANDB_MODE=offline PYTHONPATH=. A_EPOCHS=3 COOLDOWN_EPOCHS=1
# hosts show torch all their CPUs (256 on the PRO 6000 host) while the pod's
# cgroup allows ~27: one thread per visible CPU then starves the loader and
# leaves the GPU idle (9.4 s/step, 2026-11-07)
export OMP_NUM_THREADS=${OMP_NUM_THREADS:-16}
echo "OMP_NUM_THREADS=$OMP_NUM_THREADS nproc=$(nproc) cpu.max=$(cat /sys/fs/cgroup/cpu.max 2>/dev/null)"
PY=$W/train/.venv/bin
nvidia-smi --query-gpu=name,memory.total --format=csv,noheader

bench() {  # recipe ckpt micro_tokens seconds
  local recipe=$1 ckpt=$2 micro=$3 secs=$4 log=/root/bench_$1_$2_$3.log peak=0 m
  TRAIN_GRAD_CKPT=$ckpt TRAIN_MICRO_TOKENS=$micro timeout "$secs" \
    $PY/torchrun --nproc_per_node 1 -m training_recipes.$recipe > "$log" 2>&1 &
  local pid=$!
  while kill -0 $pid 2> /dev/null; do
    m=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)
    [ "$m" -gt "$peak" ] && peak=$m
    sleep 5
  done
  local last
  last=$(tr '\r' '\n' < "$log" | grep 'it\]' | tail -1 | grep -o '[0-9.]*s/it\|[0-9.]*it/s')
  local oom
  oom=$(grep -c -i 'out of memory' "$log")
  echo "$recipe ckpt=$ckpt micro=$micro: $last peak ${peak} MiB$([ "$oom" -gt 0 ] && echo ' OUT OF MEMORY')"
}

bench train_A_finetune 0 131072 420
bench train_A_finetune 0 262144 420
bench train_A_finetune 0 524288 420
bench cooldown_A 1 131072 480
bench cooldown_A 0 131072 480
bench cooldown_A 0 262144 480
echo "bench done"
