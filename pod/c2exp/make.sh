#!/bin/bash
# C2 export for the split eval (standing rule 2026-11-14). Same value pipeline as st1's weights (notes/st1):
# CPU export (exp.sh), act16 scales x256, non-rope f32 -> bf16 values, rope tensors from the shipped ext file,
# then the OLD python coder (ENC_INTC encoder not on this pod; values are what matter for the split eval).
set -e
E=/root/c2exp; O=/workspace/c2exp; PY=/workspace/train/.venv/bin/python
rm -rf $E; mkdir -p $E/models; cd $E
cp -r /workspace/pr_p1c/pysrc . ; rm -rf pysrc/__pycache__
sed -i 's/assert torch.cuda.is_available()/pass/; s/torch.device("cuda")/torch.device("cpu")/; s/assert device.type == "cuda"/pass/' pysrc/export_weights.py
$PY - <<'PY'
import sys, torch
sys.path.insert(0, "/workspace/agent/pr")
from act16 import agroup
gs = {"mlp_down_in", "attn_out_in"}
sd = torch.load("/workspace/pr_c2/models/6m-q4-fp32-A.tch", map_location="cpu"); n = 0
for k in sd:
    if k.endswith(".scale") and not k.endswith("quantize_weight.scale") and agroup(k[:-6]) in gs:
        sd[k] = sd[k] * 256; n += 1
print("c2 scales x256:", n); torch.save(sd, "models/c2.tch")
PY
EXPORT_MODEL=models/c2.tch EXPORT_OUTPUT=models/c2.tfw $PY -m pysrc.export_weights > c2.export.log 2>&1 || { tail -20 c2.export.log; exit 1; }
PYTHONPATH=. $PY - <<'PY'
import numpy as np, subprocess, sys, os
from pysrc.export_weights import read_tensor_file, write_tensor_file
ship = read_tensor_file('/workspace/ext/models/6m-q4-fp32-A.tfw')
def bfr(a):
    u = a.astype(np.float32).view(np.uint32).astype(np.uint64)
    return (((u + 0x7FFF + ((u >> 16) & 1)) >> 16) << 16).astype(np.uint32).view(np.float32)
for tag, src in [("p1c", "/workspace/sub/st1_weights/pr_p1c.tfw"), ("c2", "models/c2.tfw")]:
    t = read_tensor_file(src); ents = []; nb = nr = 0
    assert list(t) == list(ship), "tensor order differs"
    for name, (dt, a) in t.items():
        if name.startswith('rope'):
            ents.append((name,) + ship[name]); nr += 1
        elif dt == 2:
            ents.append((name, dt, bfr(a))); nb += 1
        else:
            ents.append((name, dt, a))
    fn = f"/workspace/c2exp/{tag}_vals.tfw"; write_tensor_file(fn, ents)
    r = subprocess.run([sys.executable, '-m', 'pysrc.weights_compress', 'compress', fn, fn + 'c2'], capture_output=True, text=True)
    print(tag, "bf16-rounded tensors", nb, "rope from shipped", nr, "old-coder tfwc2", os.path.getsize(fn + 'c2'), r.stderr[-200:])
PY
ls -la $O; echo MAKE_DONE
