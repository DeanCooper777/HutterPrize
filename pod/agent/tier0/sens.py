"""Per-layer sensitivity of a weight set under Tier 0 (no training).
Each variant changes one group of quantized matrices in the state dict:
  q7 = 3-bit (7 levels), q5 = 5 levels, q3 = 3 levels, zero = removed (weights 0).
The quantized variants re-fit per-row scales (grid search like requant_mlp) and
store w = q*s, so the model's 4-bit fake quant reproduces exactly that precision.
usage: python sens.py CKPT OUTJSON"""
import sys, os, json, re, time, torch
sys.path.insert(0, "/workspace/agent/tier0")
from tier0 import build, load_data, score

def clamp_latent(w, s_old):
    """the function the 4-bit model computes uses clamp(w, -7s, 7s); latents beyond that are dead"""
    lim = 7 * s_old.to(torch.bfloat16).float()[:, None]
    return torch.maximum(torch.minimum(w, lim), -lim)

def requant(w, qmax):
    amax = w.abs().amax(1).clamp_min(1e-12)
    grid = torch.linspace(0.3, 1.0, 71, device=w.device)
    best_s = None; best_e = None
    for c in grid:
        s = (c * amax / qmax).to(torch.bfloat16).float()
        q = (w / s[:, None]).round().clamp(-qmax, qmax)
        e = ((q * s[:, None] - w) ** 2).sum(1)
        if best_e is None: best_s, best_e = s, e
        else:
            m = e < best_e; best_s = torch.where(m, s, best_s); best_e = torch.where(m, e, best_e)
    q = (w / best_s[:, None]).round().clamp(-qmax, qmax)
    return q * best_s[:, None], best_s

def groups(sd):
    g = {}
    for k in sd:
        if not k.endswith(".weight") or k.replace(".weight", ".quantize_weight.scale") not in sd:
            continue
        m = re.match(r"blocks\.(\d+)\.(attention|mlp)\.", k)
        name = f"L{int(m.group(1)):02d}.{'attn' if m.group(2) == 'attention' else 'mlp'}" if m else k.split(".")[0]
        g.setdefault(name, []).append(k)
    return g

def main():
    ckpt, out = sys.argv[1], sys.argv[2]
    dev = torch.device("cuda")
    sd0 = torch.load(ckpt, map_location=dev)
    model = build(dev); model.eval()
    data = load_data(dev)
    G = groups(sd0)
    nparams = {n: sum(sd0[k].numel() for k in ks) for n, ks in G.items()}
    variants = [("ref", None, None)]
    for n in sorted(G):
        variants.append((n + ":q7", n, 3))
    for n in sorted(G):
        if n.endswith(".mlp"):
            variants.append((n + ":q5", n, 2)); variants.append((n + ":q3", n, 1)); variants.append((n + ":zero", n, 0))
    kinds = os.environ.get("SENS_KINDS", "q7,q5,q3,zero").split(",")
    variants = [v for v in variants if v[0] == "ref" or v[0].split(":")[1] in kinds]
    results = json.load(open(out)) if os.path.exists(out) else {}
    for tag, n, qmax in variants:
        if tag in results: continue
        t0 = time.time()
        sd = dict(sd0)
        if n is not None:
            for k in G[n]:
                sk = k.replace(".weight", ".quantize_weight.scale")
                if qmax == 0:
                    sd[k] = torch.zeros_like(sd0[k])
                else:
                    w, s = requant(clamp_latent(sd0[k].float(), sd0[sk].float()), qmax)
                    sd[k] = w.to(sd0[k].dtype); sd[sk] = s.to(sd0[sk].dtype)
        model.load_state_dict(sd)
        r = score(model, data, tag)
        r.pop("per_slice512", None)
        r["group"] = n; r["qmax"] = qmax; r["params"] = nparams.get(n, 0)
        results[tag] = r
        json.dump(results, open(out, "w"), indent=1)
        print(f"{tag} done in {time.time()-t0:.0f}s", flush=True)
    print("sens done")

if __name__ == "__main__":
    main()
