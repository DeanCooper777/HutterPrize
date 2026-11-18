"""Start checkpoint for an up-bit QAT run: groups in SPEC (levels 31) get latent = their
current 4-bit value (q4*s) and scale s/2, so q31 = 2*q4: the starting model computes exactly
what IN computes. usage: python make_start_up.py IN.tch OUT.tch "embedding=31,L00.mlp=31" """
import sys, torch
sys.path.insert(0, "/workspace/agent/tier0")
from sens import groups
src, dst, spec = sys.argv[1:4]
sd = torch.load(src, map_location="cpu"); G = groups(sd); out = dict(sd)
items = [x.split("=") for x in spec.split(",") if x]
if items and items[0][0] == "ALL": items = [(g, items[0][1]) for g in G]
for g, lv in items:
    assert int(lv) == 31
    for k in G[g]:
        sk = k.replace(".weight", ".quantize_weight.scale")
        s = sd[sk].float().to(torch.bfloat16).float()
        q = (sd[k].float() / s[:, None]).round().clamp(-7, 7)
        out[k] = (q * s[:, None]).to(sd[k].dtype); out[sk] = (s / 2).to(sd[sk].dtype)
print("groups:", ",".join(f"{g}={lv}" for g, lv in items))
torch.save(out, dst); print("saved", dst)
