"""Tier 0 proxy: predicted enwik9 effect of a weight set, in minutes on one GPU.
Runs the QAT model (same config as train_A_finetune) over the sample dataset in
DATA (default /workspace/tier0/s64), converts its distributions to cmix's 8 bit
predictions, and mixes them with the saved cmix bits through a stand-in
logistic mixer FITTED on the sample (Newton, per context). Prints bytes scaled
to the full stream. usage: python tier0.py CKPT TAG  (env A_DMLP, A_MLP_BITS)"""
import os, sys, json, time
from dataclasses import replace as _dc_replace
import numpy as np, torch
from torch.nn.functional import log_softmax
from pysrc.model import Transformer, TransformerConfig, MatmulQuantization
from pysrc.quantization import Quantization
from pysrc.data import CollatedArticlesDataLoader
from pysrc.cmix_loss import CmixMixtureLoss, MixtureLossConfig

def build(device):
    micro_batch_tokens = 2**17
    max_article_tokens: int | None = 2**17

    quantization_block_size: int | None = None

    weight_quantization = Quantization(
        buckets=15,
        block_size=quantization_block_size,
        scale_dtype=torch.bfloat16,
        arithmetic_dtype=torch.float32,
        scale_init="scaled_max",
        epsilon=None,
    )
    activation_quantization = Quantization(
        buckets=256,
        block_size=quantization_block_size,
        scale_dtype=torch.bfloat16,
        arithmetic_dtype=torch.float32,
        scale_init="scaled_mean",
        epsilon=None,
    )
    matmul_quantization = MatmulQuantization(
        weight=weight_quantization, activation=activation_quantization
    )
    # A_MLP_BITS=3: 7-level (-3..3) MLP weights, variant 2c (2026-11-08)
    mlp_bits = int(os.environ.get("A_MLP_BITS", "4"))
    mlp_quantization = matmul_quantization if mlp_bits == 4 else MatmulQuantization(
        weight=_dc_replace(weight_quantization, buckets=2**mlp_bits - 1),
        activation=activation_quantization,
    )

    raw_model: Transformer = Transformer(
        TransformerConfig(
            vocabulary_size=205,
            prior_embedding=True,
            prior_logit_mixing=False,
            max_variable_sequence_length=max_article_tokens
            if max_article_tokens is not None
            else micro_batch_tokens,
            n_layers=12,
            attention_weight_sharing_pattern=list(range(12)),
            mlp_weight_sharing_pattern=list(range(12)),
            d_model=192,
            kimi_linear=[True, True, True, False] * 3,
            window_size=1024,
            window_size_multipliers=None,
            n_query_heads=3,
            n_key_value_heads=3,
            d_head=64,
            d_mla=None,
            rope_base=10_000,
            half_truncate_rope=False,
            query_key_norm=True,
            query_key_norm_gain=False,
            kimi_linear_d_head=64,
            kimi_linear_n_heads=3,
            kimi_linear_convolution_size=4,
            value_embedding_pattern=None,
            prior_value_embedding=False,
            attention_scale=None,
            d_mlp=int(os.environ.get("A_DMLP", "768")),
            activation_function="relu_squared",
            embedding_norm=True,
            prior_embedding_norm=True,
            skip_connections=True,
            token_embedding_connections=True,
            prior_embedding_connections=False,
            dropout=0.0,
            logit_softcap=15.0,
            prior_logprob_cap=-12.0,
            prior_embedding_on_logprobs=False,
            # TRAIN_GRAD_CKPT=0 keeps activations instead of recomputing
            # them in backward (one forward pass less per step, more memory)
            gradient_checkpointing=os.environ.get("TRAIN_GRAD_CKPT", "1") != "0",
            embedding_init="normal",
            prior_embedding_init="normal",
            up_init="kaiming_uniform",
            down_init="kaiming_uniform",
            unembedding_init="kaiming_uniform",
            convolution_init="kaiming_uniform",
            logit_mixing_head_init="zero",
            activation_dtype=torch.bfloat16,
            attention_dtype=torch.bfloat16,
            logit_dtype=torch.float32,
            weight_dtype=torch.float32,
            mlp_quantization=mlp_quantization,
            attention_full_rank_quantization=matmul_quantization,
            attention_low_rank_quantization=matmul_quantization,
            qkv_quantization=activation_quantization,
            kimi_linear_full_rank_quantization=matmul_quantization,
            kimi_linear_low_rank_quantization=matmul_quantization,
            kimi_linear_beta_projection_quantization=None,
            kimi_linear_convolution_quantization=None,
            embedding_quantization=weight_quantization,
            prior_embedding_quantization=matmul_quantization,
            unembedding_quantization=matmul_quantization,
            logit_mixing_head_quantization=None,
            adamw_quantization_scales=True,
            attention_implementation="flash_attention_2",
        )
    )

    raw_model = raw_model.to(device)
    # A_INIT_SCALES=N: the start checkpoint has no quantization scales (run B,
    try:
        from pysrc.bits_map import apply_bits_map
        apply_bits_map(raw_model)
    except ImportError:
        assert not os.environ.get("A_BITS_MAP"), "A_BITS_MAP needs /workspace/mp's pysrc"
    return raw_model.to(device)

def fit(lc, lt, y, ctx, n_ctx, iters=15, C=1 << 25):
    """Damped Newton fit of z = w0*lc + w1*lt + w2 per context (chunked, per-context
    backtracking over step sizes so the loss of every context never increases);
    returns per-bit nats"""
    dev = lc.device
    steps = torch.tensor([1.0, 0.5, 0.25, 0.1, 0.03, 0.0], device=dev)
    w = torch.tensor([0.3, 0.8, 0.0], device=dev).repeat(n_ctx, 1)
    def X_(i): return torch.stack([lc[i:i+C], lt[i:i+C], torch.ones_like(lc[i:i+C])], 1)
    for _ in range(iters):
        g = torch.zeros(n_ctx, 3, device=dev); h = torch.zeros(n_ctx, 9, device=dev)
        for i in range(0, lc.numel(), C):
            X = X_(i); c = ctx[i:i+C]
            p = torch.sigmoid((X * w[c]).sum(1))
            g.index_add_(0, c, X * (p - y[i:i+C])[:, None])
            h.index_add_(0, c, (X[:, :, None] * X[:, None, :]).reshape(-1, 9) * (p * (1 - p))[:, None])
        h = h.view(n_ctx, 3, 3) + 1e-2 * torch.eye(3, device=dev)
        d = -torch.linalg.solve(h, g.unsqueeze(-1)).squeeze(-1)
        L = torch.zeros(len(steps), n_ctx, device=dev)
        for i in range(0, lc.numel(), C):
            X = X_(i); c = ctx[i:i+C]; yy = y[i:i+C]
            for k, st in enumerate(steps):
                z = (X * (w + st * d)[c]).sum(1)
                L[k].index_add_(0, c, torch.nn.functional.binary_cross_entropy_with_logits(z, yy, reduction="none"))
        best = L.argmin(0)
        w = w + steps[best][:, None] * d
    out = torch.empty_like(lc)
    for i in range(0, lc.numel(), C):
        X = X_(i)
        out[i:i+C] = torch.nn.functional.binary_cross_entropy_with_logits(
            (X * w[ctx[i:i+C]]).sum(1), y[i:i+C], reduction="none")
    return out

def load_data(dev):
    DATA = os.environ.get("DATA", "/workspace/tier0/s64")
    return CollatedArticlesDataLoader(
        tokens_filename=f"{DATA}/ppmd-bytes.uint8", priors_filename=f"{DATA}/ppmd-probs.float16",
        article_boundaries_filename=f"{DATA}/article-boundaries.int32",
        cmix_bits_filename=f"{DATA}/cmix-bits.float16", mmap=False, epochs=1,
        micro_batch_tokens=2**17, gradient_accumulation_steps=1, max_article_tokens=2**17,
        max_merge_tokens=None, device=dev, rank=0, world_size=1)

@torch.inference_mode()
def main():
    ckpt, tag = sys.argv[1], sys.argv[2]
    dev = torch.device("cuda")
    model = build(dev)
    model.load_state_dict(torch.load(ckpt, map_location=dev)); model.eval()
    data = load_data(dev)
    res = score(model, data, tag, save_lt=os.environ.get("TIER0_SAVE_LT", "0") == "1")
    res["ckpt"] = ckpt
    os.makedirs("/workspace/tier0/results", exist_ok=True)
    json.dump(res, open(f"/workspace/tier0/results/{tag}.json", "w"))

@torch.inference_mode()
def score(model, data, tag, save_lt=False):
    dev = torch.device("cuda")
    DATA = os.environ.get("DATA", "/workspace/tier0/s64")
    conv = CmixMixtureLoss(MixtureLossConfig()).to(dev)
    LC, LT, Y, CE, POS = [], [], [], [], []
    t0 = time.time()
    for arts, mb in data.iter_ordered_micro_batches():
        logits = model.compute_logits(input_tokens=mb.input_tokens, priors=mb.priors,
                                      cumulative_sequence_lengths=mb.cumulative_sequence_lengths)
        m = mb.loss_mask.reshape(-1)
        tg = mb.output_tokens.reshape(-1)[m]
        logp = log_softmax(logits.reshape(-1, 205).float()[m], -1)
        LT.append(conv.bit_logits(logp, tg).half())
        LC.append(mb.cmix_bit_logits.reshape(-1, 8)[m].float().clamp(-12, 12).half())
        Y.append(conv.path_bits[tg].bool())
        CE.append(-logp.gather(1, tg[:, None]).squeeze(1))
        POS.append(torch.full((int(m.sum()),), int(data.article_starts[arts[0]]), device=dev))
    print(f"forward {time.time()-t0:.0f}s", flush=True)
    lt = torch.cat(LT).float().reshape(-1); lc = torch.cat(LC).float().reshape(-1)
    y = torch.cat(Y).float().reshape(-1); ce = torch.cat(CE)
    if save_lt:
      os.makedirs("/workspace/tier0/lt", exist_ok=True)
      lt.half().cpu().numpy().tofile(f"/workspace/tier0/lt/{tag}.f16")
    if save_lt and not os.path.exists("/workspace/tier0/lt/_common.npz"):
        np.savez("/workspace/tier0/lt/_common.npz", lc=lc.half().cpu().numpy(),
                 y=y.bool().cpu().numpy(), pos=torch.cat(POS).cpu().numpy())
    n_tok = ce.numel(); scale = 593343776 / data.n_tokens / 8 / np.log(2)
    bitpos = torch.arange(8, device=dev).repeat(n_tok)
    b8 = (lc.abs() / 2).long().clamp(max=7)
    ctx64 = bitpos * 8 + b8
    ctx512 = (ctx64 * 4 + (lt.abs() / 2).long().clamp(max=3)) * 2 + ((lc > 0) == (lt > 0)).long()
    res = {"tag": tag, "n_tokens": n_tok}
    res["tf_only"] = float(ce.sum()) * scale
    res["cmix_only"] = float(torch.nn.functional.binary_cross_entropy_with_logits(lc, y, reduction="sum")) * scale
    l64 = fit(lc, lt, y, ctx64, 64); res["mix64"] = float(l64.sum()) * scale
    l512 = fit(lc, lt, y, ctx512, 512); res["mix512"] = float(l512.sum()) * scale
    # per-slice totals (raw bytes) of the 512 mixer for paired noise estimates
    sl = json.load(open(f"{DATA}/slices.json"))["slices"]
    ends = np.cumsum([b - a for a, b, _, _ in sl])
    pos = torch.cat(POS).cpu().numpy()
    sid = np.searchsorted(ends, pos, side="right")
    tok_loss = (l512.view(-1, 8).sum(1) / np.log(2) / 8).cpu().numpy()
    res["per_slice512"] = np.bincount(sid, weights=tok_loss, minlength=len(sl)).tolist()
    print(json.dumps({k: v for k, v in res.items() if k != "per_slice512"}), flush=True)
    return res

if __name__ == "__main__":
    main()
