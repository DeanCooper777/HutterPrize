"""Ranking (a): per unit |dequantized up row| * |dequantized down column| (4-bit grids, bf16 scales); drop lowest N.
usage: python rank_w.py CKPT N OUT.json"""
import sys, re, json, torch
sd = torch.load(sys.argv[1], map_location="cpu"); N = int(sys.argv[2]); out = {}
def dq(w, s): s = s.float().to(torch.bfloat16).float(); return (w.float() / s[:, None]).round().clamp(-7, 7) * s[:, None]
for k in sd:
    m = re.match(r"(.*mlp)\.up\.weight$", k)
    if not m: continue
    p = m.group(1)
    up = dq(sd[p + ".up.weight"], sd[p + ".up.quantize_weight.scale"])
    dn = dq(sd[p + ".down.weight"], sd[p + ".down.quantize_weight.scale"])
    sc = up.norm(dim=1) * dn.norm(dim=0)
    out[p] = sc.argsort()[:N].sort().values.tolist()
json.dump(out, open(sys.argv[3], "w")); print("rank_w:", len(out), "layers")
