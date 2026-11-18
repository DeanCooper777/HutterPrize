"""Function-preserving MLP widening (2026-11-13, notes/grow-2026-11-13.md).
usage: python grow.py IN.tch OUT.tch WIDTH [SEED]
Per layer: new up rows = a random existing row of the same layer, randomly permuted and
sign-flipped (same per-row statistics and quantization grid), with that row's per-row weight
scale; new down columns = exactly 0 (a quantization level), so the model computes the same
function. Only up.weight, up.quantize_weight.scale and down.weight carry d_mlp (checked).
Same SEED -> same new rows for the QAT and the fp32 checkpoints."""
import re, sys, torch
src, dst, width = sys.argv[1], sys.argv[2], int(sys.argv[3])
g = torch.Generator().manual_seed(int(sys.argv[4]) if len(sys.argv) > 4 else 1234)
sd = torch.load(src, map_location="cpu"); out = dict(sd)
prefixes = sorted({m.group(1) for k in sd if (m := re.match(r"(.*mlp)\.up\.weight$", k))},
                  key=lambda p: int(re.search(r"\d+", p).group()))
assert len(prefixes) == 12, prefixes
for p in prefixes:
    up, sc, down = sd[p + ".up.weight"], sd[p + ".up.quantize_weight.scale"], sd[p + ".down.weight"]
    d, n = up.shape[0], width - up.shape[0]
    assert d == 768 and down.shape == (192, d) and sc.shape == (d,) and n > 0
    src_rows = torch.randint(0, d, (n,), generator=g)
    new_up = torch.stack([up[r][torch.randperm(up.shape[1], generator=g)] for r in src_rows.tolist()])
    new_up = new_up * (torch.randint(0, 2, new_up.shape, generator=g) * 2 - 1).to(up.dtype)
    out[p + ".up.weight"] = torch.cat([up, new_up])
    out[p + ".up.quantize_weight.scale"] = torch.cat([sc, sc[src_rows]])
    out[p + ".down.weight"] = torch.cat([down, torch.zeros(down.shape[0], n, dtype=down.dtype)], 1)
for k, v in out.items():  # nothing else may carry the old width
    if ".mlp." in k and k not in {p + s for p in prefixes for s in (".up.weight", ".up.quantize_weight.scale", ".down.weight")}:
        assert 768 not in v.shape, (k, v.shape)
torch.save(out, dst); print(f"grew {len(prefixes)} MLPs 768 -> {width}, saved {dst}")
