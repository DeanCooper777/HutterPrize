"""Lever 4 (2026-11-14): which 8-bit activation groups would gain from 16 bits on C2 (Tier 0, no training).
Run from a patched source dir with A_ACT16=mlp_down_in,attn_out_in (the shipped two). Adds groups like tier0/n4.py
(65536 levels, scale/256). Variants: base, +each remaining group, ALL, best-2, best-3. usage: python l4.py CKPT OUT.json"""
import sys, os, json, time, torch
from dataclasses import replace
sys.path.insert(0, "/workspace/agent/tier0"); sys.path.insert(0, "/workspace/agent/pr")
from tier0 import build, load_data, score
from act16 import agroup
from pysrc.quantization import Quantize
ckpt, out = sys.argv[1], sys.argv[2]; dev = torch.device("cuda")
sd0 = torch.load(ckpt, map_location=dev); model = build(dev); model.eval(); data = load_data(dev)
SHIP = {"mlp_down_in", "attn_out_in"}
mods = {n: m for n, m in model.named_modules() if isinstance(m, Quantize) and agroup(n)}
q0 = {n: m.quant for n, m in mods.items()}
groups = sorted({agroup(n) for n in mods} - SHIP)
info = {}
dims = {}
def _hk(n):
    def f(mm, inp):
        dims.setdefault(n, list(inp[0].shape[-1:]))
        return None
    return f
hooks = [m.register_forward_pre_hook(_hk(n)) for n, m in mods.items()]
R = json.load(open(out)) if os.path.exists(out) else {}
def run(tag, extra):
    if tag in R: return R[tag]["mix512"]
    t0 = time.time(); sd = dict(sd0)
    for n, m in mods.items():
        g = agroup(n)
        if g in extra and g not in SHIP:
            m.quant = replace(q0[n], buckets=65536); sd[n + ".scale"] = sd0[n + ".scale"] / 256
        else:
            m.quant = q0[n]
    model.load_state_dict(sd); r = score(model, data, tag); r.pop("per_slice512", None); r["extra"] = sorted(extra)
    R[tag] = r; json.dump(R, open(out, "w"), indent=1); print(f"{tag} {r['mix512']:,.0f} ({time.time() - t0:.0f}s)", flush=True)
    return r["mix512"]
base = run("base", set())
for h in hooks: h.remove()
for g in groups:
    ns = [n for n in mods if agroup(n) == g]
    info[g] = {"n_quantizers": len(ns), "examples": ns[:3], "in_dims": sorted({tuple(dims.get(n, [])) for n in ns})}
R["_info"] = {g: {k: (list(map(list, v)) if k == "in_dims" else v) for k, v in d.items()} for g, d in info.items()}; R["_info"]["base_groups"] = sorted(SHIP)
json.dump(R, open(out, "w"), indent=1)
gain = {g: run(f"+{g}", {g}) - base for g in groups}
run("ALL", set(groups))
top = sorted(groups, key=lambda g: gain[g])
run("best2:" + "+".join(top[:2]), set(top[:2])); run("best3:" + "+".join(top[:3]), set(top[:3]))
print("L4 SUMMARY (Tier 0 delta vs base, negative = better):")
for k, v in R.items():
    if not k.startswith("_"): print(f"  {k:40s} {v['mix512'] - base:+10,.0f}")
