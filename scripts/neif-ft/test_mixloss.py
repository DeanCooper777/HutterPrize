#!/usr/bin/env python3
# test_mixloss.py: testing tool (not part of any submitted program).
# CPU unit tests of mixloss.py (the cmix-aware loss for the cmix-neif 2.0 trainer): the byte
# tree against a brute-force computation, the chain rule against the cross-entropy, forced
# bits, NaN rows, the three modes of install() on a small stand-in model, the pre-fit.
#   python test_mixloss.py <vocab-bitmap.u8>        (needs torch; run from the patched tree copy)
import json
import math
import os
import sys
import tempfile
import types

import numpy as np
import torch
from torch import nn
from torch.nn.functional import cross_entropy, log_softmax

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mixloss  # noqa: E402

torch.manual_seed(1)
BITMAP = sys.argv[1]
VB = mixloss.vocab_bytes_from_bitmap(BITMAP)
V = len(VB)
assert V == 208, V
ok_all = True


def check(name, cond, info=""):
    global ok_all
    ok_all &= bool(cond)
    print("%-62s %s %s" % (name, "ok" if cond else "FAILED", info), flush=True)


# ---- 1. bit logits against brute force -------------------------------------------------
m = mixloss.MixtureLoss(VB, rich=True, ce_weight=0.0)
N = 300
logits = torch.randn(N, V) * 2.0
tgt = torch.randint(0, V, (N,))
logp = log_softmax(logits, -1)
lt = m.bit_logits(logp, tgt)
p = logp.exp().double().numpy()
worst = 0.0
for i in range(N):
    b = VB[int(tgt[i])]
    for k in range(8):
        hi = b >> (8 - k)                       # the k bits already coded
        s1 = sum(p[i, j] for j, x in enumerate(VB) if (x >> (8 - k)) == hi and (x >> (7 - k)) & 1)
        s0 = sum(p[i, j] for j, x in enumerate(VB) if (x >> (8 - k)) == hi and not (x >> (7 - k)) & 1)
        ref = math.log(max(s1, 1e-300)) - math.log(max(s0, 1e-300))
        ref = max(-12.0, min(12.0, ref))
        worst = max(worst, abs(ref - float(lt[i, k])))
check("bit logits = brute-force subtree sums (300 rows x 8)", worst < 2e-4, "max |diff| %.2e" % worst)

# ---- 2. chain rule: the 8 bit costs of the transformer alone add up to its cross-entropy
y = m.path_bits[tgt]
soft = torch.randn(N, V) * 0.7                  # mild rows: no clamp at +-12 is reached
lps = log_softmax(soft, -1)
lts = m.bit_logits(lps, tgt)
bits_cost = torch.nn.functional.binary_cross_entropy_with_logits(lts, y, reduction="none").sum(1)
ce = -lps.gather(1, tgt[:, None]).squeeze(1)
d = float((bits_cost - ce).abs().max())
# (bits decided by the byte set alone, e.g. a subtree without set bytes, sit at the clamp of 12
# and cost 6e-6 nats each)
check("sum of 8 bit costs = cross-entropy", d < 1e-4, "max |diff| %.2e" % d)

# ---- 3. the stand-in with weights (1,0,0) is cmix alone, with (0,1,0) the transformer alone
lc = torch.randn(N, 8) * 3
mask = torch.rand(N) < 0.8
with torch.no_grad():
    m.weights.copy_(torch.tensor([1.0, 0.0, 0.0]).expand_as(m.weights))
    l1, st = m(soft, tgt, lc.half(), mask)
    ref1 = torch.nn.functional.binary_cross_entropy_with_logits(lc.half().float().clamp(-12, 12), y, reduction="none").sum(1)[mask].sum()
    check("weights (1,0,0): loss = cost of the cmix bits", abs(float(l1 - ref1)) < 1e-2 and abs(float(st[3] - ref1)) < 1e-2)
    m.weights.copy_(torch.tensor([0.0, 1.0, 0.0]).expand_as(m.weights))
    l2, st = m(soft, tgt, lc.half(), mask)
    check("weights (0,1,0): loss = cross-entropy of the scored rows", abs(float(l2 - ce[mask].sum())) < 1e-2
          and abs(float(st[1] - ce[mask].sum())) < 1e-2 and int(st[0]) == int(mask.sum()))

# ---- 4. forced bits (+-inf) cost nothing; a wrong sign is counted; NaN rows fall back to CE
m2 = mixloss.MixtureLoss(VB, rich=True, ce_weight=0.1)
with torch.no_grad():
    m2.weights.add_(torch.randn_like(m2.weights) * 0.1)
lcf = lc.clone()
forced = torch.rand(N, 8) < 0.3
lcf[forced] = torch.where(y[forced] > 0.5, torch.tensor(float("inf")), torch.tensor(float("-inf")))
nanrow = torch.rand(N) < 0.1
lcf[nanrow] = float("nan")
loss, st = m2(soft, tgt, lcf.half(), mask)
z = m2.mix(lc.half().float().clamp(-12, 12), lts)
bce = torch.nn.functional.binary_cross_entropy_with_logits(z, y, reduction="none")
row = torch.where(forced, 0.0, bce).sum(1)
use = mask & ~nanrow
ref = (0.9 * row + 0.1 * ce)[use].sum() + ce[mask & nanrow].sum()
check("forced bits cost nothing, NaN rows cost their cross-entropy", abs(float(loss.detach() - ref)) < 2e-2,
      "loss %.4f ref %.4f" % (float(loss), float(ref)))
check("statistics: forced bits, fallback rows, no mismatch",
      int(st[5]) == int((forced & use[:, None]).sum()) and int(st[7]) == int((mask & nanrow).sum()) and int(st[6]) == 0
      and int(st[4]) == int((~forced & use[:, None]).sum()))
bad = lcf.clone()
i0 = int(torch.nonzero(forced.any(1) & use)[0])
k0 = int(torch.nonzero(forced[i0])[0])
bad[i0, k0] = -bad[i0, k0]
_, stb = m2(soft, tgt, bad.half(), mask)
check("a forced bit with the wrong sign is counted (alignment alarm)", int(stb[6]) == 1)

# ---- 5. gradients: finite, none from unscored rows, mixer weights get one
x = soft.clone().requires_grad_(True)
loss, _ = m2(x, tgt, lcf.half(), mask)
loss.backward()
check("gradient finite, zero on unscored rows, present on the mixer",
      bool(torch.isfinite(x.grad).all()) and float(x.grad[~mask].abs().max()) == 0.0
      and float(x.grad[mask].abs().max()) > 0 and float(m2.weights.grad.abs().max()) > 0)
xi = torch.full((4, V), 0.0)
xi[:, 3] = 60.0                                  # a saturated row: 12-logit clamps, -80 leaves
xi.requires_grad_(True)
li, _ = m2(xi, torch.tensor([3, 4, 100, 207]), torch.zeros(4, 8).half(), torch.ones(4, dtype=torch.bool))
li.backward()
check("saturated rows: loss and gradient finite", bool(torch.isfinite(li)) and bool(torch.isfinite(xi.grad).all()))


# ---- 6. install(): off / observe / train on a small stand-in for Transformer -----------
class Stub(nn.Module):
    """the three methods of pysrc.model.Transformer that mixloss touches"""

    def __init__(self):
        super().__init__()
        self.cfg = types.SimpleNamespace(vocabulary_size=V)
        self.emb = nn.Embedding(256, 16)
        self.out = nn.Linear(16, V)

    def compute_last_activation(self, input_tokens, priors, cumulative_sequence_lengths, override_window_size=None):
        return self.emb(input_tokens & 0xFF)

    def last_activation_to_logits(self, activation, priors):
        return self.out(activation)

    def forward(self, input_tokens, priors, loss_mask, output_tokens, cumulative_sequence_lengths,
                override_window_size=None):
        logits = self.last_activation_to_logits(self.compute_last_activation(
            input_tokens, priors, cumulative_sequence_lengths, override_window_size), priors)
        loss = cross_entropy(logits.view(-1, logits.size(-1)), output_tokens.flatten(), reduction="none")
        return torch.where(loss_mask.flatten(), loss.to(torch.float32), 0.0).sum()


tmp = tempfile.mkdtemp()
P = 64
inp = torch.randint(0, 200, (1, P))
outp = torch.randint(0, V, (1, P))
lm = torch.rand(1, P) < 0.9
bits = (torch.randn(1, P, 8) * 3).half()
args = dict(input_tokens=inp, priors=None, loss_mask=lm, output_tokens=outp, cumulative_sequence_lengths=None)
mb = types.SimpleNamespace(cmix_bit_logits=bits, **args)

torch.manual_seed(5)
ref_model = Stub()
ref_loss = ref_model(**args)
ref_loss.backward()
ref_grad = ref_model.out.weight.grad.clone()

# no "ft" key: nothing happens
torch.manual_seed(5)
s0 = Stub()
check("no ft key: install() returns None and adds no arguments", mixloss.install(s0, {}, torch.device("cpu"), True, 1, tmp) is None
      and mixloss.kw(mb) == {} and torch.equal(s0(**args), ref_loss))

base = {"cmix_bits": "unused-in-this-test", "perm_seed": 7,
        "mixloss": {"mode": "observe", "vocab_bitmap": BITMAP, "ce_weight": 0.1, "log_every": 1,
                    "mixer_init": os.path.join(tmp, "prefit.pt")}}
torch.manual_seed(5)
s1 = Stub()
mixloss.install(s1, {"ft": base}, torch.device("cpu"), True, 1, tmp)
w_before = mixloss.S.mixer.weights.detach().clone()
l_obs = s1(**args, **mixloss.kw(mb))
l_obs.backward()
check("observe: loss and gradient bit-identical to their forward",
      torch.equal(l_obs, ref_loss) and torch.equal(s1.out.weight.grad, ref_grad) and os.environ["FT_PERM_SEED"] == "7")
check("observe: the stand-in has its own gradient", float(mixloss.S.mixer.weights.grad.abs().max()) > 0)
mixloss.after_step()
check("after_step: the stand-in moved, log line written",
      not torch.equal(mixloss.S.mixer.weights.detach(), w_before) and os.path.exists(os.path.join(tmp, "mixloss.jsonl")))
with torch.no_grad():
    check("no bits / no_grad (PROBE, evaluation): their forward", torch.equal(s1(**args), ref_loss)
          and torch.equal(s1(**args, **mixloss.kw(mb)), ref_loss))

cfg_t = json.loads(json.dumps(base))
cfg_t["mixloss"]["mode"] = "train"
torch.manual_seed(5)
s2 = Stub()
mixloss.install(s2, {"ft": cfg_t}, torch.device("cpu"), True, 1, tmp)
l_tr = s2(**args, **mixloss.kw(mb))
l_tr.backward()
with torch.no_grad():
    lg = s2.last_activation_to_logits(s2.compute_last_activation(inp, None, None), None)
    want, _ = mixloss.S.mixer(lg, outp, bits, lm)
check("train: loss = mixture loss, gradient differs from the cross-entropy gradient",
      abs(float(l_tr - want)) < 1e-3 and not torch.allclose(s2.out.weight.grad, ref_grad))
mixloss.after_step()
mixloss.save(tmp)
st = torch.load(os.path.join(tmp, "mixer.pt"), weights_only=True)
check("save: mixer.pt beside the run, nothing of it in the model state",
      st["weights"].shape == mixloss.S.mixer.weights.shape and not any("mixer" in k or "weights" == k for k in s2.state_dict()))


# ---- 7. pre-fit on a problem where both sources carry information ----------------------
class Data:
    world_size, rank, n_articles = 1, 0, 8

    def _iter_micro_batch_articles(self, articles, drop_last):
        for a in articles:
            yield [a]

    def _make_micro_batch(self, group):
        g = torch.Generator().manual_seed(100 + group[0])
        n = 4096
        true = torch.randn(n, V, generator=g) * 2.5
        tg = torch.multinomial(torch.softmax(true, -1), 1, generator=g).squeeze(1)
        mm = mixloss.S.mixer
        # the compressor's bits: the true bit logits plus noise; the model: the true row plus noise
        lcb = mm.bit_logits(log_softmax(true, -1), tg) + torch.randn(n, 8, generator=g) * 1.5
        self_logits = true + torch.randn(n, V, generator=g) * 1.5
        return types.SimpleNamespace(input_tokens=self_logits[None], priors=None, loss_mask=torch.ones(1, n, dtype=torch.bool),
                                     output_tokens=tg[None], cumulative_sequence_lengths=None, cmix_bit_logits=lcb.half()[None])


class Stub2(Stub):
    def compute_last_activation(self, input_tokens, priors, cumulative_sequence_lengths, override_window_size=None):
        return input_tokens                      # the "activation" is the row itself

    def last_activation_to_logits(self, activation, priors):
        return activation


cfg_p = json.loads(json.dumps(base))
cfg_p["mixloss"].update(mode="train", prefit_only=True, prefit={"micro_batches": 8, "steps": 300, "lr": 0.05})
s3 = Stub2()
mixloss.install(s3, {"ft": cfg_p}, torch.device("cpu"), True, 1, tmp)
stop = mixloss.prefit_or_load(s3, Data())
rep = torch.load(os.path.join(tmp, "prefit.pt"), weights_only=True)["report"]
print("   prefit report:", json.dumps({k: round(v, 4) if isinstance(v, float) else v for k, v in rep.items()}))
check("prefit: stops the run, saves mixer_init", stop and os.path.exists(os.path.join(tmp, "prefit.pt")))
check("prefit: stand-in beats both sources and its own start",
      rep["standin_after_bits_per_tok"] < min(rep["cmix_only_bits_per_tok"], rep["tf_bits_as_coded_per_tok"], rep["standin_before_bits_per_tok"]))
check("prefit: transformer bits as coded = cross-entropy (chain rule on the sample)",
      abs(rep["tf_bits_as_coded_per_tok"] - rep["ce_bits_per_tok"]) < 0.02 * rep["ce_bits_per_tok"])
cfg_a = json.loads(json.dumps(cfg_p))
cfg_a["mixloss"]["prefit_only"] = False
s4 = Stub2()
mixloss.install(s4, {"ft": cfg_a}, torch.device("cpu"), True, 1, tempfile.mkdtemp())
check("an arm loads the fitted stand-in and goes on", mixloss.prefit_or_load(s4, Data()) is False
      and torch.equal(mixloss.S.mixer.weights.detach().cpu(), torch.load(os.path.join(tmp, "prefit.pt"), weights_only=True)["weights"]))
cfg_m = json.loads(json.dumps(cfg_a))
cfg_m["mixloss"]["mixer_init"] = os.path.join(tmp, "missing.pt")
mixloss.install(Stub2(), {"ft": cfg_m}, torch.device("cpu"), True, 1, tempfile.mkdtemp())
try:
    mixloss.prefit_or_load(s4, Data())
    check("an arm without mixer_init is refused", False)
except AssertionError:
    check("an arm without mixer_init is refused", True)

print("ALL OK" if ok_all else "SOME TESTS FAILED")
sys.exit(0 if ok_all else 1)
