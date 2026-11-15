"""P2 (2026-11-12): differentiable coded size of the quantized weight ints.
Per tensor: x = latent / scale (clamped to the int range), linear soft assignment to the two
nearest ints (= the hard histogram when x is an int), counts c_k, KT-smoothed p_k =
(c_k + 1/2) / (N + K/2), cost = -sum_k c_k ln p_k nats (~ N * order-0 entropy).
Penalty per token (nats) = lambda * 2 * sum_t cost_t / 593,343,776 (2 copies of the weights in S;
archive bytes = nats/token * 593.3M tokens / (8 ln 2)). Gradients reach latents and scales."""
import os, re, math, torch
N_TOKENS = 593_343_776

def weight_pairs(model):
    from pysrc.quantization import Quantize
    params = dict(model.named_parameters()); out = []
    for n, m in model.named_modules():
        if isinstance(m, Quantize) and n.endswith("quantize_weight"):
            w = params.get(n[: -len("quantize_weight")] + "weight"); s = params.get(n + ".scale")
            if w is not None and s is not None: out.append((n, w, s, m.quant.qmin, m.quant.qmax))
    return out

def coded_nats(pairs, hard=False):
    tot = 0.0
    for n, w, s, qmin, qmax in pairs:
        x = (w.float() / s.float().reshape(-1, *([1] * (w.dim() - 1)))).clamp(qmin, qmax).reshape(-1)
        K = qmax - qmin + 1
        if hard:
            c = torch.bincount((x.detach().round() - qmin).long(), minlength=K).float()
        else:
            f = x.detach().floor().clamp(max=qmax - 1); fr = x - f; i = (f - qmin).long()
            c = torch.zeros(K, device=x.device).index_add(0, i, 1 - fr).index_add(0, i + 1, fr)
        p = (c + 0.5) / (x.numel() + 0.5 * K)
        tot = tot - (c * p.log()).sum()
    return tot

def penalty_per_token(model, lam):
    return lam * 2 * coded_nats(weight_pairs(model)) / N_TOKENS
