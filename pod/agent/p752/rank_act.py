"""Ranking (b): per unit mean |input to mlp.down| (the relu^2 activation) on the first NB Tier 0 micro batches x
|dequantized down column|; drop lowest N. Run from a patched source dir with PYTHONPATH=. and A_ACT16 set.
usage: python rank_act.py CKPT N OUT.json [NB]"""
import sys, json, torch
sys.path.insert(0, "/workspace/agent/tier0")
import tier0
ckpt, N, outf = sys.argv[1], int(sys.argv[2]), sys.argv[3]; NB = int(sys.argv[4]) if len(sys.argv) > 4 else 40
dev = torch.device("cuda"); model = tier0.build(dev)
sd = torch.load(ckpt, map_location=dev); model.load_state_dict(sd); model.eval()
acc, cnt, hooks = {}, {}, []
for name, mod in model.named_modules():
    if name.endswith("mlp.down"):
        p = name[:-5]; acc[p] = torch.zeros(768, device=dev, dtype=torch.float64); cnt[p] = 0
        def h(m, inp, p=p):
            x = inp[0].detach().float().reshape(-1, 768); acc[p] += x.abs().sum(0).double(); cnt[p] += x.shape[0]
        hooks.append(mod.register_forward_pre_hook(h))
assert len(acc) == 12, list(acc)
data = tier0.load_data(dev); n = 0
with torch.inference_mode():
    for arts, mb in data.iter_ordered_micro_batches():
        model.compute_logits(input_tokens=mb.input_tokens, priors=mb.priors, cumulative_sequence_lengths=mb.cumulative_sequence_lengths)
        n += 1
        if n >= NB: break
assert all(c > 0 for c in cnt.values()), cnt
out = {}
for p in acc:
    s = sd[p + ".down.quantize_weight.scale"].float().to(torch.bfloat16).float()
    dn = (sd[p + ".down.weight"].float() / s[:, None]).round().clamp(-7, 7) * s[:, None]
    sc = (acc[p] / cnt[p]).float() * dn.norm(dim=0)
    out[p] = sc.argsort()[:N].sort().values.cpu().tolist()
json.dump(out, open(outf, "w")); print("rank_act:", len(out), "layers,", n, "batches,", cnt[p], "tokens/layer")
