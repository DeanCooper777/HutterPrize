#!/bin/bash
# Job C1 (2026-11-13): longer gentle fine-tune with act16 (scales frozen), continuing from P1c.
# 12 epochs (A_LR 2.5e-7 schedule: 2.5e-6 -> 2.5e-7), Tier 0 after every epoch, 1 cooldown epoch,
# Tier 0, int bytes, then CUDA export (act16 scales x256) -> .tfw. Ends "exit 0" (selfstop).
W=/workspace; P=$W/pr_p1c/models
export START_QAT=$P/6m-q4-A.tch START_FP32=$P/6m-q4-fp32-A.tch A_MIXER_INIT=$P/6m-q4-A.mixer.tch
export A_LR=2.5e-7 A_EPOCHS=12 A_KEEP_EPOCHS=1 A_ACT16=mlp_down_in,attn_out_in A_ACT16_FREEZE=1
echo "=== $(date -u) C1: P1c + 12 gentle epochs"
bash $W/agent/pr/run_pr.sh $W/pr_c1 none 95953178 8000; echo "C1 rc $?"
echo "=== $(date -u) export"
cd $W/pr_c1 && $W/train/.venv/bin/python - <<'PY'
import sys, torch
sys.path.insert(0, "/workspace/agent/pr")
from act16 import agroup
sd = torch.load("models/6m-q4-fp32-A.tch", map_location="cpu"); n = 0
for k in sd:
    if k.endswith(".scale") and not k.endswith("quantize_weight.scale") and agroup(k[:-6]) in {"mlp_down_in", "attn_out_in"}:
        sd[k] = sd[k] * 256; n += 1
print("scales x256:", n); torch.save(sd, "models/c1_export.tch")
PY
EXPORT_MODEL=models/c1_export.tch EXPORT_OUTPUT=models/c1.tfw PYTHONPATH=. $W/train/.venv/bin/python -m pysrc.export_weights > c1.export.log 2>&1 && ls -la models/c1.tfw || tail -20 c1.export.log
echo "$(date -u) C1 done"; echo "exit 0"
