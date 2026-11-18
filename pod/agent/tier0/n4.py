"""N4: 16-bit activations with ext's 4-bit weights unchanged (Tier 0, no training).
A chosen activation quantizer gets 65536 levels and scale/256 (same clamp range, exact in
bf16). Variants: ref, ALL16, then per group. usage: python n4.py CKPT OUTJSON"""
import sys, os, json, time, re, torch
from dataclasses import replace
sys.path.insert(0, "/workspace/agent/tier0")
from tier0 import build, load_data, score
from pysrc.quantization import Quantize

def agroup(name):
    if name.endswith("quantize_weight"): return None
    for pat, g in [(r"mlp\.down\.", "mlp_down_in"), (r"mlp\.up\.", "mlp_up_in"),
                   (r"(query|key|value)_projection\.", "qkv_proj_in"), (r"output_projection\.", "attn_out_in"),
                   (r"gate_projection\.", "gates_in"), (r"quantize_(queries|keys|values)$", "qkv_quant"),
                   (r"^unembedding\.", "unemb_in"), (r"^prior_embedding\.", "prior_in")]:
        if re.search(pat, name): return g
    return "other"

def main():
    ckpt, out = sys.argv[1], sys.argv[2]
    dev = torch.device("cuda")
    sd0 = torch.load(ckpt, map_location=dev)
    model = build(dev); model.eval(); data = load_data(dev)
    mods = {n: m for n, m in model.named_modules() if isinstance(m, Quantize) and agroup(n)}
    q0 = {n: m.quant for n, m in mods.items()}
    groups = sorted({agroup(n) for n in mods})
    print("groups", groups, flush=True)
    variants = [("ref", set()), ("ALL16", set(groups))] + [(g, {g}) for g in groups]
    results = json.load(open(out)) if os.path.exists(out) else {}
    for tag, gs in variants:
        if tag in results: continue
        t0 = time.time(); sd = dict(sd0)
        for n, m in mods.items():
            if agroup(n) in gs:
                m.quant = replace(q0[n], buckets=65536); sd[n + ".scale"] = sd0[n + ".scale"] / 256
            else:
                m.quant = q0[n]
        model.load_state_dict(sd)
        r = score(model, data, tag); r.pop("per_slice512", None); r["groups"] = sorted(gs)
        results[tag] = r; json.dump(results, open(out, "w"), indent=1)
        print(f"{tag} done in {time.time()-t0:.0f}s", flush=True)
        if tag == "ALL16":
            gain = results["ref"]["mix512"] - r["mix512"]
            print(f"N4: 16-bit activations everywhere gain {gain:,.0f} B (drop if < 100,000)", flush=True)
            if gain < 100000: print("N4 STOP", flush=True); break

if __name__ == "__main__":
    main()
