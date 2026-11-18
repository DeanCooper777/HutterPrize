"""order-0 per-tensor entropy (bytes) of the quantized weight ints of a checkpoint under a
levels map (A_BITS_MAP style, default 15). usage: python int_bytes.py CKPT [SPEC]"""
import sys, json, torch, numpy as np
sys.path.insert(0, "/workspace/agent/tier0")
from sens import groups
sd = torch.load(sys.argv[1], map_location="cpu"); G = groups(sd)
spec = sys.argv[2] if len(sys.argv) > 2 else ""
lv = dict(x.split("=") for x in spec.split(",") if x)
if "ALL" in lv: lv = {g: lv["ALL"] for g in G}
tot = 0
for g, ks in G.items():
    qmax = (int(lv.get(g, 15)) - 1) // 2
    for k in ks:
        s = sd[k.replace(".weight", ".quantize_weight.scale")].float().to(torch.bfloat16).float()
        q = (sd[k].float() / s[:, None]).round().clamp(-qmax, qmax).numpy()
        _, c = np.unique(q, return_counts=True); p = c / c.sum(); tot += -(c * np.log2(p)).sum() / 8
print(json.dumps({"ckpt": sys.argv[1], "spec": spec, "int_bytes": tot}))
