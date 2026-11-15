"""Drop listed MLP units. usage: python prune_idx.py IN.tch OUT.tch RANK.json  (RANK: {prefix: [drop idx]})"""
import sys, json, torch
src, dst, rk = sys.argv[1:4]
sd = torch.load(src, map_location="cpu"); drop = json.load(open(rk)); out = dict(sd)
for p, idx in drop.items():
    d = sd[p + ".up.weight"].shape[0]; keep = torch.tensor(sorted(set(range(d)) - set(idx)))
    out[p + ".up.weight"] = sd[p + ".up.weight"][keep].clone()
    out[p + ".up.quantize_weight.scale"] = sd[p + ".up.quantize_weight.scale"][keep].clone()
    out[p + ".down.weight"] = sd[p + ".down.weight"][:, keep].clone()
for k, v in out.items():
    if ".mlp." in k: assert 768 not in v.shape, (k, v.shape)
torch.save(out, dst); print(f"pruned {len(drop)} MLPs by {len(next(iter(drop.values())))} units -> {dst}")
