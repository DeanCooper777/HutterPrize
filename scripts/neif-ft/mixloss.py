# mixloss.py: testing tool (not part of any submitted program).
#
# Cmix-aware training loss ("mixture loss") for the training scripts of cmix-neif 2.0
# (reference/neif2/dev/training/tf/3_train/tree/rx7r.py and rx3a.py), a port of our own
# pod/train_src/pysrc/cmix_loss.py to their 208-value byte set and their loader.  It is used
# from a patched COPY of their scripts (patch_ft_tree.py puts this file next to them); the
# files of the reference tree are not changed.
#
# What it does, for every scored row of a micro-batch:
#   1. turns the transformer's 208-way distribution into the logits of the 8 bits along the
#      path of the target byte, the way the coder's Tf1Slot does (sums over the 256-leaf byte
#      tree, bytes outside the set have probability 0);
#   2. mixes each bit with the compressor's own prediction for that bit made WITHOUT the
#      transformer (the NEIF_BITS_OUT dump, one float16 logit per bit) through a small logistic
#      stand-in mixer: z = w0 * lc + w1 * lt + w2, one weight set per context;
#   3. returns the summed binary cross-entropy in nats (optionally blended with the plain
#      cross-entropy), in the units of their own loss, so their size term and logging apply.
# Bits the coder does not code (ChrForced, grammar and text-start forced bits, forced bytes)
# are +inf / -inf in the dump and cost nothing; a row of NaN (no dump for this position) falls
# back to the plain cross-entropy of that row.
#
# The stand-in mixer is NOT part of the Transformer module (it must never reach an export), has
# its own AdamW, and is fitted on the start weights before the transformer moves (prefit).
#
# Configuration: the key "ft" of the run's JSON (absent = the patched scripts do exactly what
# the originals do):
#   "ft": {
#     "perm_seed": 0,                    seed of the loader's epoch permutations (theirs: 0)
#     "no_scale_init": true,             skip the scale initialisation of a cold qat start
#     "freeze_activation_scales": true,  the int8 activation scales get no update
#     "cmix_bits": "<PKG>/cmix-bits.float16",   [n_tokens, 8] float16, package coordinates
#     "mixloss": {
#       "mode": "train" | "observe" | "off",
#           train:   the loss is the mixture loss (+ ce_weight * cross-entropy)
#           observe: the loss and its gradient are their cross-entropy, unchanged; the stand-in
#                    is still fitted (on detached logits) and its cost logged, so every arm
#                    reports the same proxy
#       "ce_weight": 0.1, "rich": true, "buckets": 8, "mixer_lr": 1e-3,
#       "mixer_init": "<W>/mixer_prefit.pt",   written by a prefit run, required by the arms
#       "prefit": {"micro_batches": 64, "steps": 400, "lr": 0.02},
#       "prefit_only": false,             fit, save mixer_init, print the costs and stop
#       "log_every": 16
#     }
#   }
from __future__ import annotations

import json
import math
import os
import types

import numpy as np
import torch
from torch import Tensor, nn
from torch.nn.functional import binary_cross_entropy_with_logits, cross_entropy, log_softmax

# bytes outside the set: probability 0 in the coder; a large finite negative number keeps the
# gradient of logsumexp finite
_LOG_ZERO: float = -80.0
# bit logits are clamped as the stretch() inputs of a cmix mixer are (p within about 6e-6)
_LOGIT_CLAMP: float = 12.0
N_STATS = 9   # see MixtureLoss.STAT_NAMES


def vocab_bytes_from_bitmap(path: str) -> list[int]:
    """the byte values of the frozen set in set order (index i = i-th smallest byte);
    the file is training/tf/2_package/vocab-bitmap.u8: 32 bytes, bit (b % 8) of byte b // 8"""
    bm = open(path, "rb").read()
    assert len(bm) == 32, "vocab bitmap must be 32 bytes, %s has %d" % (path, len(bm))
    return [b for b in range(256) if (bm[b // 8] >> (b % 8)) & 1]


class MixtureLoss(nn.Module):
    """the stand-in mixer and the loss; `weights` is its only parameter"""

    STAT_NAMES = ("tokens", "ce_nats", "mix_nats", "cmix_only_nats", "coded_bits", "forced_bits",
                  "forced_mismatch", "fallback_rows", "calls")

    def __init__(self, vocab_bytes: list[int], *, buckets: int = 8, rich: bool = True,
                 ce_weight: float = 0.1, prob_floor: float = 0.0,
                 initial_weights: tuple[float, float, float] = (0.3, 0.8, 0.0)) -> None:
        super().__init__()
        self.v = len(vocab_bytes)
        self.buckets = int(buckets)
        self.rich = bool(rich)
        self.ce_weight = float(ce_weight)
        # the coder has no floor on the slot row beyond RowFloor(3e-8) of the engine; 0 = none
        self.log_floor = math.log(prob_floor) if prob_floor > 0 else None
        n_ctx = 8 * self.buckets * (8 if self.rich else 1)
        self.weights = nn.Parameter(torch.tensor([list(initial_weights)] * n_ctx, dtype=torch.float32))
        vb = torch.tensor(vocab_bytes, dtype=torch.int64)
        assert vb.numel() == len(set(vocab_bytes)) and bool((vb[1:] > vb[:-1]).all())
        j = torch.arange(8, dtype=torch.int64)
        # target byte b: the node at depth j on its path is b >> (8 - j) (the root is 0 at depth
        # 0); its children at depth j + 1 are 2n and 2n + 1; the coded bit is (b >> (7 - j)) & 1
        self.register_buffer("vocab_bytes", vb, persistent=False)
        self.register_buffer("path_nodes", vb[:, None] >> (8 - j)[None, :], persistent=False)
        self.register_buffer("path_bits", ((vb[:, None] >> (7 - j)[None, :]) & 1).float(), persistent=False)

    # -- 1. transformer row -> the 8 bit logits of the target byte
    def bit_logits(self, logp: Tensor, targets: Tensor) -> Tensor:
        """log probabilities (N, V) and target tokens (N,) -> logit of P(bit = 1) for the 8 bits
        on the path of each target byte (N, 8), most significant bit first"""
        n = logp.shape[0]
        if self.log_floor is not None:
            logp = logp.clamp(min=self.log_floor)
        leaves = logp.new_full((n, 256), _LOG_ZERO).index_copy(1, self.vocab_bytes, logp)
        levels = [leaves]                       # levels[-1]: depth 8 (the leaves)
        for d in range(7, 0, -1):               # depth d: log mass under each of its 2^d nodes
            levels.append(torch.logsumexp(levels[-1].view(n, 1 << d, 2), dim=-1))
        levels.reverse()                        # levels[k]: depth k + 1
        nodes = self.path_nodes[targets]
        out = []
        for k in range(8):
            c0 = levels[k].gather(1, 2 * nodes[:, k:k + 1])
            c1 = levels[k].gather(1, 2 * nodes[:, k:k + 1] + 1)
            out.append(c1 - c0)
        return torch.cat(out, dim=1).clamp(-_LOGIT_CLAMP, _LOGIT_CLAMP)

    # -- 2. the stand-in
    def contexts(self, lc: Tensor, lt: Tensor) -> Tensor:
        """weight set per bit: bit position x cmix confidence [x transformer confidence x agreement];
        discrete, no gradient flows through the choice"""
        b = (lc.abs() / 2).long().clamp(max=self.buckets - 1)
        ctx = torch.arange(8, device=lc.device)[None, :] * self.buckets + b
        if self.rich:
            tconf = (lt.detach().abs() / 2).long().clamp(max=3)
            agree = ((lc > 0) == (lt.detach() > 0)).long()
            ctx = (ctx * 4 + tconf) * 2 + agree
        return ctx

    def mix(self, lc: Tensor, lt: Tensor) -> Tensor:
        w = self.weights[self.contexts(lc, lt)]
        return w[..., 0] * lc + w[..., 1] * lt + w[..., 2]

    @staticmethod
    def split_cmix(cmix_bit_logits: Tensor):
        """dump row (N, 8) -> (lc clamped finite, coded: the bit was coded, nan_row, inf sign)"""
        lc = cmix_bit_logits.float()
        nan_row = torch.isnan(lc).any(dim=1)
        coded = torch.isfinite(lc) & ~nan_row[:, None]
        sign = lc > 0
        lc = torch.nan_to_num(lc, nan=0.0, posinf=_LOGIT_CLAMP, neginf=-_LOGIT_CLAMP).clamp(-_LOGIT_CLAMP, _LOGIT_CLAMP)
        return lc, coded, nan_row, sign

    # -- 3. the loss
    def forward(self, logits: Tensor, output_tokens: Tensor, cmix_bit_logits: Tensor, loss_mask: Tensor):
        """(loss, stats).  loss: summed nats over the scored rows, (1 - a) * mixture + a * CE on
        rows with a dump row, CE on rows without.  stats: float64 vector, see STAT_NAMES; every
        row is computed and the unscored ones are zeroed with where() (no host sync)."""
        mask = loss_mask.reshape(-1)
        logits = logits.reshape(-1, logits.shape[-1]).float()
        targets = output_tokens.reshape(-1)
        lc, coded, nan_row, sign = self.split_cmix(cmix_bit_logits.reshape(-1, 8))
        logp = log_softmax(logits, dim=-1)
        lt = self.bit_logits(logp, targets)
        y = self.path_bits[targets]
        z = self.mix(lc, lt)
        bce = binary_cross_entropy_with_logits(z, y, reduction="none")
        mix_row = torch.where(coded, bce, 0.0).sum(1)
        ce_row = -logp.gather(1, targets[:, None]).squeeze(1)
        a = self.ce_weight
        use = mask & ~nan_row
        fb = mask & nan_row
        loss = torch.where(use, (1.0 - a) * mix_row + a * ce_row, 0.0).sum() + torch.where(fb, ce_row, 0.0).sum()
        with torch.no_grad():
            d = torch.float64
            cm = binary_cross_entropy_with_logits(lc, y, reduction="none")
            forced = ~coded & ~nan_row[:, None] & use[:, None]
            stats = torch.stack([
                mask.sum().to(d),
                torch.where(mask, ce_row, 0.0).sum().to(d),
                torch.where(use, mix_row, 0.0).sum().to(d),
                torch.where(coded & use[:, None], cm, 0.0).sum().to(d),
                (coded & use[:, None]).sum().to(d),
                forced.sum().to(d),
                # a forced bit is known to the coder: its sign must be the bit of the target byte;
                # anything else is a misaligned dump
                (forced & (sign != (y > 0.5))).sum().to(d),
                fb.sum().to(d),
                torch.ones((), dtype=d, device=logits.device),
            ])
        return loss, stats


# ------------------------------------------------------------------------------------------
# glue to the training scripts (one state per process)
class _State:
    def __init__(self):
        self.on = False


S = _State()


def install(raw, cfgj: dict, device, main_p: bool, world: int, out: str):
    """called by the patched rx7r.py / rx3a.py after the model is built and install_mixed ran,
    BEFORE the data loader is made.  Without the key "ft" it does nothing."""
    ft = cfgj.get("ft")
    S.on = False
    if not ft:
        return None
    S.ft, S.raw, S.device, S.main_p, S.world, S.out = ft, raw, device, main_p, world, out
    S.mode = "off"
    S.step_n = 0
    os.environ["FT_PERM_SEED"] = str(int(ft.get("perm_seed", 0)))
    # the int8 activation quantizers are the batched ones (rx3.install_mixed skips them for the
    # same reason); their scales stay where the start state has them
    if ft.get("freeze_activation_scales"):
        from pysrc.quantization import Quantize
        S.frozen = [(n, m.scale, m.scale.detach().clone()) for n, m in raw.named_modules()
                    if isinstance(m, Quantize) and m.batched]
        for _, p, _ in S.frozen:
            p.requires_grad_(False)
        if main_p:
            print("ft: %d activation scales frozen (%d values)" % (len(S.frozen), sum(p.numel() for _, p, _ in S.frozen)), flush=True)
    else:
        S.frozen = []
    ml = ft.get("mixloss") or {}
    S.mode = ml.get("mode", "off")
    assert S.mode in ("off", "observe", "train"), S.mode
    if S.mode == "off":
        os.environ.pop("FT_CMIX_BITS", None)
        if main_p:
            print("ft: mixture loss off", flush=True)
        return S
    assert ft.get("cmix_bits"), "ft.mixloss needs ft.cmix_bits (the NEIF_BITS_OUT dump in package coordinates)"
    os.environ["FT_CMIX_BITS"] = ft["cmix_bits"]
    S.ml = ml
    vb = vocab_bytes_from_bitmap(ml.get("vocab_bitmap") or os.path.join(os.environ["TFT_DATA_DIR"], "vocab-bitmap.u8"))
    assert len(vb) == raw.cfg.vocabulary_size, (len(vb), raw.cfg.vocabulary_size)
    S.mixer = MixtureLoss(vb, buckets=int(ml.get("buckets", 8)), rich=bool(ml.get("rich", True)),
                          ce_weight=float(ml.get("ce_weight", 0.1)),
                          prob_floor=float(ml.get("prob_floor", 0.0))).to(device)
    S.opt = torch.optim.AdamW(S.mixer.parameters(), lr=float(ml.get("mixer_lr", 1e-3)), weight_decay=0.0)
    S.stats = torch.zeros(N_STATS, dtype=torch.float64, device=device)
    S.log_every = int(ml.get("log_every", 16))
    S.fitted = False
    orig_forward = raw.forward            # the bound Transformer.forward (their loss)

    def forward(self, input_tokens, priors, loss_mask, output_tokens, cumulative_sequence_lengths,
                override_window_size=None, cmix_bit_logits=None, **kw):
        if cmix_bit_logits is None or not torch.is_grad_enabled():
            # scale initialisation, PROBE, full evaluation: their forward, untouched
            return orig_forward(input_tokens=input_tokens, priors=priors, loss_mask=loss_mask,
                                output_tokens=output_tokens, cumulative_sequence_lengths=cumulative_sequence_lengths,
                                override_window_size=override_window_size, **kw)
        assert not kw, kw
        activation = self.compute_last_activation(
            input_tokens=input_tokens, priors=priors, cumulative_sequence_lengths=cumulative_sequence_lengths,
            override_window_size=override_window_size)
        logits = self.last_activation_to_logits(activation, priors=priors)
        if S.mode == "train":
            loss, st = S.mixer(logits, output_tokens, cmix_bit_logits, loss_mask)
            S.stats += st
            return loss
        # observe: their loss, statement for statement (pysrc/model.py Transformer.forward) ...
        ce = cross_entropy(logits.view(-1, logits.size(-1)), output_tokens.flatten(), reduction="none")
        loss = torch.where(loss_mask.flatten(), ce.to(torch.float32), 0.0).sum()
        # ... and the stand-in keeps learning beside it, on detached logits, with its own backward
        ml_loss, st = S.mixer(logits.detach(), output_tokens, cmix_bit_logits, loss_mask)
        ml_loss.backward()
        S.stats += st
        return loss

    raw.forward = types.MethodType(forward, raw)
    S.on = True
    if main_p:
        print("ft: mixture loss %s (ce_weight %g, %d contexts, mixer lr %g), bits %s, perm seed %s"
              % (S.mode, S.mixer.ce_weight, S.mixer.weights.shape[0], float(ml.get("mixer_lr", 1e-3)),
                 ft["cmix_bits"], os.environ["FT_PERM_SEED"]), flush=True)
    return S


def kw(mb) -> dict:
    """extra keyword arguments of the model call for one micro-batch"""
    if not S.on:
        return {}
    b = getattr(mb, "cmix_bit_logits", None)
    assert b is not None, "the loader carries no cmix bits (FT_CMIX_BITS / patched zpdump.py?)"
    return {"cmix_bit_logits": b}


def after_step() -> None:
    """after every optimizer step of the transformer: one step of the stand-in, the log line"""
    if not S.on:
        return
    S.step_n += 1
    if S.world > 1:   # the same stand-in on every rank: mean of the ranks' gradients
        import torch.distributed as dist
        for p in S.mixer.parameters():
            if p.grad is None:
                p.grad = torch.zeros_like(p)
            dist.all_reduce(p.grad)
            p.grad /= S.world
    S.opt.step()
    S.opt.zero_grad()
    if S.step_n % S.log_every == 0:
        flush_stats()


def flush_stats() -> dict:
    v = S.stats.clone()
    S.stats.zero_()
    if S.world > 1:
        import torch.distributed as dist
        dist.all_reduce(v)
    r = dict(zip(MixtureLoss.STAT_NAMES, v.tolist()))
    n = max(r["tokens"], 1.0)
    ln2 = math.log(2.0)
    line = {"ft_step": S.step_n, "mode": S.mode, "tokens": int(r["tokens"]),
            "ce_bits_per_tok": r["ce_nats"] / n / ln2, "mix_bits_per_tok": r["mix_nats"] / n / ln2,
            "cmix_only_bits_per_tok": r["cmix_only_nats"] / n / ln2,
            "coded_bits": int(r["coded_bits"]), "forced_bits": int(r["forced_bits"]),
            "forced_mismatch": int(r["forced_mismatch"]), "fallback_rows": int(r["fallback_rows"])}
    if r["forced_mismatch"] > 0:
        raise RuntimeError("ft: %d forced bits of the cmix dump contradict the target byte: the dump is misaligned"
                           % int(r["forced_mismatch"]))
    if S.main_p:
        with open(os.path.join(S.out, "mixloss.jsonl"), "a") as f:
            f.write(json.dumps(line) + "\n")
    return line


def save(out: str | None = None) -> None:
    """the stand-in beside the state of the run (never inside model.tch); also the check that
    the frozen scales have not moved"""
    check_frozen()
    if not S.on or not S.main_p:
        return
    torch.save({"weights": S.mixer.weights.detach().cpu(), "opt": S.opt.state_dict(), "step": S.step_n},
               os.path.join(out or S.out, "mixer.pt"))


def check_frozen() -> None:
    """the frozen scales must be bit-identical to the start"""
    for n, p, ref in getattr(S, "frozen", []):
        if not torch.equal(p.detach(), ref):
            raise RuntimeError("ft: frozen activation scale %s moved" % n)


@torch.no_grad()
def _collect(raw, data, k: int):
    """(lc, lt, y, coded) of the scored rows of k micro-batches spread evenly over the stream,
    with the transformer as it is now (eval mode, their forward path)"""
    groups = list(data._iter_micro_batch_articles(range(data.n_articles), drop_last=False))
    idx = sorted(set(int(round(x)) for x in np.linspace(0, len(groups) - 1, min(k, len(groups)))))
    idx = [i for j, i in enumerate(idx) if j % data.world_size == data.rank]
    was = raw.training
    raw.eval()
    acc = [[], [], [], []]
    tot = torch.zeros(3, dtype=torch.float64, device=S.device)   # tokens, CE nats, fallback rows
    for i in idx:
        mb = data._make_micro_batch(groups[i])
        act = raw.compute_last_activation(input_tokens=mb.input_tokens, priors=mb.priors,
                                          cumulative_sequence_lengths=mb.cumulative_sequence_lengths,
                                          override_window_size=None)
        logits = raw.last_activation_to_logits(act, priors=mb.priors).float()
        logits = logits.reshape(-1, logits.shape[-1])
        m = mb.loss_mask.reshape(-1)
        t = mb.output_tokens.reshape(-1)[m]
        logp = log_softmax(logits[m], dim=-1)
        lc, coded, nan_row, _ = MixtureLoss.split_cmix(mb.cmix_bit_logits.reshape(-1, 8)[m])
        tot += torch.stack([m.sum(), -logp.gather(1, t[:, None]).sum(), nan_row.sum()]).double()
        keep = ~nan_row
        acc[0].append(lc[keep].half())
        acc[1].append(S.mixer.bit_logits(logp[keep], t[keep]).half())
        acc[2].append(S.mixer.path_bits[t[keep]].bool())
        acc[3].append(coded[keep])
    raw.train(was)
    return [torch.cat(a) for a in acc], tot


def prefit_or_load(raw, data) -> bool:
    """before the first training step.  Returns True when the run must stop here (prefit_only).
    A resumed run takes the stand-in saved with its state; an arm takes mixer_init; a prefit run
    fits the stand-in on the model as loaded and writes mixer_init."""
    if not S.on:
        return False
    ml = S.ml
    own = os.path.join(S.out, "mixer.pt")
    if os.path.isdir(os.path.join(S.out, "state")) and os.path.exists(own):
        st = torch.load(own, map_location=S.device, weights_only=True)
        S.mixer.weights.data.copy_(st["weights"])
        S.opt.load_state_dict(st["opt"])
        S.step_n = int(st["step"])
        if S.main_p:
            print("ft: stand-in resumed from %s (step %d)" % (own, S.step_n), flush=True)
        return False
    init = ml.get("mixer_init")
    if not ml.get("prefit_only"):
        assert init and os.path.exists(init), \
            "ft: mixer_init %r missing: run the prefit configuration first (an unfitted stand-in hurt our control)" % init
        st = torch.load(init, map_location=S.device, weights_only=True)
        assert st["weights"].shape == S.mixer.weights.shape, "mixer_init was fitted with other contexts"
        S.mixer.weights.data.copy_(st["weights"])
        if S.main_p:
            print("ft: stand-in loaded from %s (prefit: %s)" % (init, json.dumps(st.get("report", {}))), flush=True)
        return False
    assert S.world == 1, "run the prefit on one card"
    pf = ml.get("prefit") or {}
    (lc, lt, y, coded), tot = _collect(raw, data, int(pf.get("micro_batches", 64)))
    lc, lt, yf = lc.float(), lt.float(), y.float()
    n_tok = float(tot[0])
    ln2 = math.log(2.0)

    def cost(z):
        return float(torch.where(coded, binary_cross_entropy_with_logits(z, yf, reduction="none"), 0.0).sum())

    with torch.no_grad():
        rep = {"tokens": int(n_tok), "fallback_rows": int(tot[2]), "coded_bits": int(coded.sum()),
               "ce_bits_per_tok": float(tot[1]) / n_tok / ln2,
               "cmix_only_bits_per_tok": cost(lc) / n_tok / ln2,
               "tf_bits_as_coded_per_tok": cost(lt) / n_tok / ln2,
               "standin_before_bits_per_tok": cost(S.mixer.mix(lc, lt)) / n_tok / ln2}
    # the fit is a logistic regression per context (convex): full-batch Adam on the sample
    opt = torch.optim.Adam(S.mixer.parameters(), lr=float(pf.get("lr", 0.02)))
    with torch.enable_grad():
        for _ in range(int(pf.get("steps", 400))):
            opt.zero_grad()
            l = torch.where(coded, binary_cross_entropy_with_logits(S.mixer.mix(lc, lt), yf, reduction="none"), 0.0).sum()
            (l / max(float(coded.sum()), 1.0)).backward()
            opt.step()
    with torch.no_grad():
        rep["standin_after_bits_per_tok"] = cost(S.mixer.mix(lc, lt)) / n_tok / ln2
    S.opt.zero_grad()
    if S.main_p:
        print("PREFIT " + json.dumps(rep), flush=True)
        if init:
            torch.save({"weights": S.mixer.weights.detach().cpu(), "report": rep}, init)
            print("ft: stand-in saved to %s" % init, flush=True)
    return True
