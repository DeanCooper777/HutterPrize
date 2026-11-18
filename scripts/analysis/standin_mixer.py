# standin_mixer.py: offline check of the idea behind the cmix-aware training loss
# (cmix-T-dwc/pysrc/cmix_loss.py), done with numpy on enwik6 before any GPU time was spent.
#
# Question: if cmix's own per-bit predictions made WITHOUT the transformer and the
# transformer's byte distribution (turned into per-bit predictions) are combined by a tiny
# logistic mixer with fixed, fitted weights, how close does that come to the size the real
# compressor reaches with the transformer? Close enough (see the numbers in
# docs/NEW_TRANSFORMER_PLAN.md and SUBMISSION.md), so that mixer was used as the differentiable
# stand-in for cmix in training.
#
# Testing: an analysis tool only; not part of the entry.
# Inputs (dumps written by test options of the compressor on enwik6): the token stream, cmix's
# bit logits (--no-transformer --save-cmix-bits) and the transformer's probabilities
# (--save-transformer-probs). Output: a table of sizes in bytes on stdout.
#
# Changes from the previous winning entry (fx2-cmix-transformer-v1): New in this entry.
"""Stand-in mixer check on enwik6: how well does a tiny logistic mix of
cmix-without-transformer (per-bit logits) and the transformer (byte
distribution -> per-bit probabilities along the path) reproduce the real
cmix-with-transformer size?"""
import numpy as np

D = r'C:\Dean\Projects\HutterPrize\runs\dump6'
mask = [0xe8, 0x16, 0x04, 0x00, 0xff, 0xff, 0xff, 0x03, 0x01, 0xfc, 0x0f,
        0xf9, 0xfe, 0xff, 0xff, 0x07] + [0xff] * 16
vocab = np.array([i for i in range(256) if (mask[i // 8] >> (i % 8)) & 1])
tok = np.fromfile(D + r'\nt\tok.u8', dtype=np.uint8)
N = len(tok)
byt = vocab[tok]
bits = np.unpackbits(byt.astype(np.uint8)[:, None], axis=1)  # N x 8, MSB first
lc = np.fromfile(D + r'\nt\bits.f16', dtype=np.float16).astype(np.float32).reshape(N, 8)

tp = np.fromfile(D + r'\tf\tfprobs.f16', dtype=np.float16).reshape(N, 205)
# the row written at step t is the distribution for token t+1? It is the
# distribution passed downstream after byte t, i.e. the prediction of byte
# t+1. Row 0 predicts byte 1; byte 0 was predicted by the initial uniform.
p205 = np.ones((N, 205), np.float32)
p205[1:] = tp[:-1].astype(np.float32)
p205 = np.maximum(p205, 1e-6)
# Transformer -> bits: spread the 205 probabilities over the 256 byte values, take cumulative
# sums, and for each of the 8 bits of the actual byte form P(bit = 1 | bits so far) as a ratio
# of interval masses. This is the numpy counterpart of CmixMixtureLoss.bit_logits.
p256 = np.zeros((N, 256), np.float32)
p256[:, vocab] = p205
cs = np.zeros((N, 257), np.float64)
cs[:, 1:] = np.cumsum(p256, axis=1)
lt = np.zeros((N, 8), np.float32)
b = byt.astype(np.int64)
rows = np.arange(N)
for j in range(8):
    w = 1 << (8 - j)
    lo = (b >> (8 - j)) << (8 - j)
    mid, hi = lo + w // 2, lo + w
    num = cs[rows, hi] - cs[rows, mid]
    den = cs[rows, hi] - cs[rows, lo]
    p1 = np.clip(num / np.maximum(den, 1e-30), 1e-6, 1 - 1e-6)
    lt[:, j] = np.log(p1 / (1 - p1))

y = bits.astype(np.float64)


# Ideal code length, in bytes, of the actual bits under the given logits.
def cost_bytes(logit):
    x = np.where(y == 1, logit, -logit)
    return np.logaddexp(0, -x).sum() / np.log(2) / 8


print(f"tokens {N}")
print(f"cmix without transformer (dump)   {cost_bytes(lc):10.0f}")
print(f"transformer alone, bit-level      {cost_bytes(lt):10.0f}")
print(f"real cmix with transformer        {131548:10d}")


def fit_mix(ctx, nctx, feats, iters=30):
    """Static logistic mix per context (Newton), returns mixed logits."""
    F = feats.shape[-1]
    W = np.zeros((nctx, F))
    W[:, 0] = 1.0
    for _ in range(iters):
        z = np.einsum('nkf,nkf->nk', feats, W[ctx])
        p = 1 / (1 + np.exp(-np.clip(z, -30, 30)))
        g = (p - y)[..., None] * feats
        h = (p * (1 - p))[..., None, None] * feats[..., :, None] * feats[..., None, :]
        G = np.zeros((nctx, F))
        H = np.zeros((nctx, F, F))
        np.add.at(G, ctx.ravel(), g.reshape(-1, F))
        np.add.at(H, ctx.ravel(), h.reshape(-1, F, F))
        H += 1.0 * np.eye(F)
        step = np.linalg.solve(H, G[..., None])[..., 0]
        # damped: rare, nearly separable contexts otherwise diverge
        norm = np.linalg.norm(step, axis=1, keepdims=True)
        W -= step * np.minimum(1.0, 1.0 / np.maximum(norm, 1e-12))
    return np.einsum('nkf,nkf->nk', feats, W[ctx])


# The stand-in mixers: inputs are (cmix logit, transformer logit, 1), weights chosen per
# context. The second one (bit position x cmix confidence, 64 contexts) is the one training
# uses by default.
ones = np.ones_like(lc)
feats = np.stack([lc, lt, ones], -1).astype(np.float64)
pos = np.broadcast_to(np.arange(8), (N, 8))
print(f"mix, weights per bit position     {cost_bytes(fit_mix(pos, 8, feats)):10.0f}")
conf = np.minimum((np.abs(lc) / 2).astype(int), 7)
ctx = pos * 8 + conf
print(f"mix, per position x cmix conf     {cost_bytes(fit_mix(ctx, 64, feats)):10.0f}")



# richer contexts for variant 1a (2026-11-08): which context set brings the
# stand-in closest to the real cmix?
tconf = np.minimum((np.abs(lt) / 2).astype(int), 3)
agree = (np.sign(lc) == np.sign(lt)).astype(int)
conf16 = np.minimum(np.abs(lc).astype(int), 15)
variants = {
    "pos x cmix conf x tf conf (256)": (ctx * 4 + tconf, 256),
    "pos x cmix conf x agree (128)": (ctx * 2 + agree, 128),
    "pos x cmix conf16 (128)": (pos * 16 + conf16, 128),
    "pos x cmix conf x tf conf x agree (512)": ((ctx * 4 + tconf) * 2 + agree, 512),
}
for name, (c, n) in variants.items():
    print(f"mix, {name:38s}{cost_bytes(fit_mix(c, n, feats)):10.0f}")
