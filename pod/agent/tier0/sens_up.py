"""ADDED STEP: more bits for sensitive groups. Tier 0 of ext with groups at 31 levels
(5-bit) or 255 levels (8-bit) instead of 15, from ext's fp32 latent weights (scale re-fit,
w = q*s exact). Variants: ref, ALL:255 (upper bound), ALL:31, then per group :31 and :255.
Needs /workspace/mp's pysrc (bits_map). usage: python sens_up.py CKPT OUTJSON"""
import sys, os, json, time, torch
from dataclasses import replace
sys.path.insert(0, "/workspace/agent/tier0")
from tier0 import build, load_data, score
from sens import requant, groups, clamp_latent
from pysrc.bits_map import group_of
from pysrc.quantization import Quantize

def set_levels(model, levels):
    for name, mod in model.named_modules():
        if isinstance(mod, Quantize) and name.endswith("quantize_weight"):
            mod.quant = replace(mod.quant, buckets=levels.get(group_of(name), 15))

def main():
    ckpt, out = sys.argv[1], sys.argv[2]
    dev = torch.device("cuda")
    sd0 = torch.load(ckpt, map_location=dev)
    model = build(dev); model.eval(); data = load_data(dev)
    G = groups(sd0); names = sorted(G)
    variants = [("ref", {}), ("ALL:255", {n: 255 for n in names}), ("ALL:31", {n: 31 for n in names})]
    for lv in (31, 255):
        for n in names:
            variants.append((f"{n}:{lv}", {n: lv}))
    results = json.load(open(out)) if os.path.exists(out) else {}
    for tag, levels in variants:
        if tag in results: continue
        t0 = time.time(); sd = dict(sd0)
        for n, lv in levels.items():
            for k in G[n]:
                sk = k.replace(".weight", ".quantize_weight.scale")
                w, s = requant(clamp_latent(sd0[k].float(), sd0[sk].float()), (lv - 1) // 2)
                sd[k] = w.to(sd0[k].dtype); sd[sk] = s.to(sd0[sk].dtype)
        set_levels(model, levels)
        model.load_state_dict(sd)
        r = score(model, data, tag); r.pop("per_slice512", None); r["levels"] = levels
        results[tag] = r; json.dump(results, open(out, "w"), indent=1)
        print(f"{tag} done in {time.time()-t0:.0f}s", flush=True)
        if tag == "ALL:31" and "ALL:255" in results:
            gain = results["ref"]["mix512"] - results["ALL:255"]["mix512"]
            print(f"upper bound: full precision beats ext by {gain:,.0f}; 2x bytes of ALL:31 = 1,064,071", flush=True)
            if gain < 1064071:
                print("upper bound below 2x the 5-bit byte cost: STOP (idea dead)", flush=True); break

if __name__ == "__main__":
    main()
