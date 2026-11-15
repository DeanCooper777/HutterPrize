"""Step 3: search a stand-in mixer whose proxy deltas match the split eval
(base->Afull -553,370; Afull->ext -29,689). Uses saved transformer bit logits
(/workspace/tier0/lt/TAG.f16) + _common.npz (lc, y), and PPMD bit logits recomputed
here from the sample's priors in the loader's order. GPU. usage: python standin.py"""
import sys, json, time, numpy as np, torch
sys.path.insert(0, "/workspace/agent/tier0")
from tier0 import fit, load_data
from pysrc.cmix_loss import CmixMixtureLoss, MixtureLossConfig
from torch.nn.functional import binary_cross_entropy_with_logits as bce
dev = torch.device("cuda")
SC = 593343776 / 33857565 / 8 / np.log(2)
OUT = "/workspace/tier0/results/standin.json"

@torch.inference_mode()
def ppmd_bits():
    data = load_data(dev); conv = CmixMixtureLoss(MixtureLossConfig()).to(dev); P = []
    for arts, mb in data.iter_ordered_micro_batches():
        m = mb.loss_mask.reshape(-1); tg = mb.output_tokens.reshape(-1)[m]
        pr = mb.priors.reshape(-1, 205).float()[m]
        logp = torch.log_softmax(pr.clamp(min=1e-7).log(), -1)
        P.append(conv.bit_logits(logp, tg).half())
    return torch.cat(P).float().reshape(-1)

def fit_n(X, y, ctx, n_ctx, iters=15, C=1 << 22):
    """damped Newton per context for z = X @ w[ctx] (X: N x k); returns per-bit nats"""
    k = X.shape[1]; w = torch.zeros(n_ctx, k, device=dev); w[:, 0] = 0.3; w[:, 1] = 0.8
    steps = torch.tensor([1.0, 0.5, 0.25, 0.1, 0.03, 0.0], device=dev)
    for _ in range(iters):
        g = torch.zeros(n_ctx, k, device=dev); h = torch.zeros(n_ctx, k * k, device=dev)
        for i in range(0, y.numel(), C):
            x = X[i:i+C]; c = ctx[i:i+C].long(); p = torch.sigmoid((x * w[c]).sum(1))
            g.index_add_(0, c, x * (p - y[i:i+C])[:, None])
            h.index_add_(0, c, (x[:, :, None] * x[:, None, :]).reshape(-1, k * k) * (p * (1 - p))[:, None])
        d = -torch.linalg.solve(h.view(n_ctx, k, k) + 1e-2 * torch.eye(k, device=dev), g.unsqueeze(-1)).squeeze(-1)
        L = torch.zeros(len(steps), n_ctx, device=dev)
        for i in range(0, y.numel(), C):
            x = X[i:i+C]; c = ctx[i:i+C].long()
            for j, st in enumerate(steps):
                L[j].index_add_(0, c, bce((x * (w + st * d)[c]).sum(1), y[i:i+C], reduction="none"))
        w = w + steps[L.argmin(0)][:, None] * d
    out = torch.empty_like(y)
    for i in range(0, y.numel(), C):
        out[i:i+C] = bce((X[i:i+C] * w[ctx[i:i+C].long()]).sum(1), y[i:i+C], reduction="none")
    return out

def online(X, y, ctx, n_ctx, lr, B=16384):
    """approximate online logistic mixer (SGD per context, updated every B bits), in stream order"""
    k = X.shape[1]; w = torch.zeros(n_ctx, k, device=dev); w[:, 0] = 0.3; w[:, 1] = 0.8
    tot = torch.zeros((), device=dev, dtype=torch.float64)
    for i in range(0, y.numel(), B):
        x = X[i:i+B]; c = ctx[i:i+B].long(); z = (x * w[c]).sum(1); yy = y[i:i+B]
        tot += bce(z, yy, reduction="sum").double()
        w.index_add_(0, c, -lr * x * (torch.sigmoid(z) - yy)[:, None])
    return float(tot)

def main():
    t0 = time.time()
    c = np.load("/workspace/tier0/lt/_common.npz")
    lc = torch.from_numpy(c["lc"]).to(dev).float(); y = torch.from_numpy(c["y"]).to(dev).float()
    lp = ppmd_bits().clamp(-12, 12)
    assert lp.numel() == lc.numel(), (lp.numel(), lc.numel())
    n_tok = y.numel() // 8
    print("ppmd-only", float(bce(lp, y, reduction="sum")) * SC, "cmix-only", float(bce(lc, y, reduction="sum")) * SC, flush=True)
    yb = y.view(-1, 8).long(); node = torch.ones_like(yb)
    for j in range(1, 8): node[:, j] = node[:, j - 1] * 2 + yb[:, j - 1]
    b8 = (lc.abs() / 2).long().clamp(max=7)
    cnode = (node.reshape(-1) * 8 + b8).int(); del node, yb
    bit = torch.arange(8, device=dev, dtype=torch.int32).repeat(n_tok); one = torch.ones_like(lc)
    res = {}
    for tag in ["base", "Afull", "ext"]:
        lt = torch.from_numpy(np.fromfile(f"/workspace/tier0/lt/{tag}.f16", dtype=np.float16)).to(dev).float()
        tc = (lt.abs() / 2).long().clamp(max=3); ag = ((lc > 0) == (lt > 0)).long()
        c512 = (((bit * 8 + b8) * 4 + tc) * 2 + ag).int(); del tc, ag
        r = {}
        X2 = torch.stack([lc, lt, one], 1)
        r["s512"] = float(fit_n(X2, y, c512, 512).sum()) * SC
        for lr in (0.002, 0.02):
            r[f"on512_lr{lr}"] = online(X2, y, c512, 512, lr) * SC
        del X2; X3 = torch.stack([lc, lt, lp, one], 1)
        r["s512_ppmd"] = float(fit_n(X3, y, c512, 512).sum()) * SC
        r["node_ppmd"] = float(fit_n(X3, y, cnode, 2048).sum()) * SC
        for lr in (0.002, 0.02):
            r[f"on512_ppmd_lr{lr}"] = online(X3, y, c512, 512, lr) * SC
        del X3, lt, c512; torch.cuda.empty_cache()
        res[tag] = r; print(tag, json.dumps(r), f"{time.time()-t0:.0f}s", flush=True)
        json.dump(res, open(OUT, "w"), indent=1)
    print("variant  base->Afull (split -553,370)  Afull->ext (split -29,689)  ratio")
    for k in res["base"]:
        a = res["Afull"][k] - res["base"][k]; b = res["ext"][k] - res["Afull"][k]
        print(f"{k:22s} {a:12,.0f} {b:10,.0f}  {a / -553370:.2f}x {b / -29689:.2f}x")

if __name__ == "__main__":
    main()
