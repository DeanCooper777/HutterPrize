"""Start checkpoint for a mixed-precision QAT run: requantize the groups named in
A_BITS_MAP-style SPEC (levels 7 or 5) of IN.tch (per-row scale grid fit, w = q*s).
usage: python make_start.py IN.tch OUT.tch "L03.mlp=7,L05.attn=5" """
import sys, torch
sys.path.insert(0, "/workspace/agent/tier0")
from sens import requant, groups
src, dst, spec = sys.argv[1:4]
sd = torch.load(src, map_location="cpu"); G = groups(sd); out = dict(sd)
for item in filter(None, spec.split(",")):
    g, lv = item.split("="); qmax = (int(lv) - 1) // 2
    assert int(lv) in (5, 7), "use 5 or 7 levels"
    for k in G[g]:
        sk = k.replace(".weight", ".quantize_weight.scale")
        w, s = requant(sd[k].float(), qmax)
        out[k] = w.to(sd[k].dtype); out[sk] = s.to(sd[sk].dtype)
        print(k, "levels", int(lv))
torch.save(out, dst); print("saved", dst)
