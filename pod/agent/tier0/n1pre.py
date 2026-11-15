"""N1 pre-check: ext's gain over cmix-alone by token position within its piece (context
length), from the saved Tier 0 bit logits. usage: python n1pre.py"""
import sys, json, numpy as np, torch
sys.path.insert(0, "/workspace/agent/tier0")
from tier0 import fit, load_data
from torch.nn.functional import binary_cross_entropy_with_logits as bce
dev = torch.device("cuda")
data = load_data(dev); P = []
for arts, mb in data.iter_ordered_micro_batches():
    cu = mb.cumulative_sequence_lengths.cpu_values[0].numpy()  # packed doc boundaries
    n = int(mb.loss_mask.shape[-1]); idx = np.arange(n)
    start = cu[np.searchsorted(cu, idx, side="right") - 1]
    pos = idx - start            # output position j predicts token j+1 with j+1 tokens of context
    m = mb.loss_mask.reshape(-1).cpu().numpy()
    P.append(pos[m])
pos = np.concatenate(P)
c = np.load("/workspace/tier0/lt/_common.npz")
lc = torch.from_numpy(c["lc"]).to(dev).float(); y = torch.from_numpy(c["y"]).to(dev).float()
assert pos.size * 8 == lc.numel(), (pos.size, lc.numel())
lt = torch.from_numpy(np.fromfile("/workspace/tier0/lt/ext.f16", dtype=np.float16)).to(dev).float()
n_tok = pos.size; bit = torch.arange(8, device=dev).repeat(n_tok)
b8 = (lc.abs() / 2).long().clamp(max=7)
ctx = ((bit * 8 + b8) * 4 + (lt.abs() / 2).long().clamp(max=3)) * 2 + ((lc > 0) == (lt > 0)).long()
mix = fit(lc, lt, y, ctx, 512).view(-1, 8).sum(1).cpu().numpy() / np.log(2)
cm = bce(lc, y, reduction="none").view(-1, 8).sum(1).cpu().numpy() / np.log(2)
edges = [0, 32, 64, 128, 256, 512, 1024, 4096, 1 << 30]
b = np.digitize(pos, edges) - 1
SC = 593343776 / 33857565
rows = []
for i in range(len(edges) - 1):
    s = b == i; k = int(s.sum())
    if not k: continue
    rows.append(dict(bucket=f"{edges[i]}-{edges[i+1]-1}", share=k / n_tok, cmix_bpt=float(cm[s].mean()),
                     mixed_bpt=float(mix[s].mean()), gain_bpt=float((cm[s] - mix[s]).mean()),
                     gain_pct=float((cm[s] - mix[s]).sum() / cm[s].sum())))
late = [r for r in rows if r["bucket"] in ("1024-4095", "4096-1073741823")]
late_pct = sum(r["gain_pct"] * r["share"] for r in late) / sum(r["share"] for r in late)
ceil = 0.0
for r in rows:
    if r["gain_pct"] < late_pct:
        k = r["share"] * n_tok; ceil += (late_pct - r["gain_pct"]) * r["cmix_bpt"] * k / 8 * SC
for r in rows: print(json.dumps(r))
print(f"late relative gain {late_pct:.4f}; rough ceiling if early buckets matched it: {ceil:,.0f} B on enwik9", flush=True)
json.dump(dict(rows=rows, late_pct=late_pct, ceiling=ceil), open("/workspace/tier0/results/n1pre.json", "w"), indent=1)
