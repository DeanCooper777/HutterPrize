"""Refit stand-in mixers with other context sets on the saved Tier 0 bit logits.
usage: python refit.py TAG [TAG ...]  -> /workspace/tier0/results/refit_TAG.json"""
import sys, json, numpy as np, torch
sys.path.insert(0, "/workspace/agent/tier0")
from tier0 import fit
dev = torch.device("cuda" if torch.cuda.is_available() else "cpu")
c = np.load("/workspace/tier0/lt/_common.npz")
lc = torch.from_numpy(c["lc"]).to(dev).float(); y = torch.from_numpy(c["y"]).to(dev).float()
n_tok = lc.numel() // 8
scale = 593343776 / 33857565 / 8 / np.log(2)
yb = y.view(-1, 8).long()
node = torch.ones_like(yb)  # partial byte incl. leading 1: 1..255
for j in range(1, 8):
    node[:, j] = node[:, j - 1] * 2 + yb[:, j - 1]
node = node.reshape(-1)
b8 = (lc.abs() / 2).long().clamp(max=7)
for tag in sys.argv[1:]:
    lt = torch.from_numpy(np.fromfile(f"/workspace/tier0/lt/{tag}.f16", dtype=np.float16)).to(dev).float()
    tc = (lt.abs() / 2).long().clamp(max=3); ag = ((lc > 0) == (lt > 0)).long()
    bit = torch.arange(8, device=dev).repeat(n_tok)
    r = {"tag": tag}
    r["mix512"] = float(fit(lc, lt, y, ((bit * 8 + b8) * 4 + tc) * 2 + ag, 512).sum()) * scale
    r["node8"] = float(fit(lc, lt, y, node * 8 + b8, 256 * 8).sum()) * scale
    r["node_rich"] = float(fit(lc, lt, y, ((node * 8 + b8) * 4 + tc) * 2 + ag, 256 * 64).sum()) * scale
    print(json.dumps(r), flush=True)
    json.dump(r, open(f"/workspace/tier0/results/refit_{tag}.json", "w"))
