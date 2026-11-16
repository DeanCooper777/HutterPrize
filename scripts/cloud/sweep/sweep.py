# sweep.py: one point of the model-size sweep. Trains a transformer of a given size from
# scratch (bf16, no quantization, cmix mixture loss, as training_recipes/train_B.py) on one data
# slice, then scores the slice in file order and writes a JSON with
#   tf_bits     cross-entropy of the transformer alone
#   cmix_bits   cost of cmix without the transformer (from the saved bit predictions)
#   mix_bits    cost of the stand-in mixer over cmix + transformer (the number that matters)
#   params      parameter count, so the weight cost can be added outside
# Copy to <training tree>/training_recipes/ and run from the tree with PYTHONPATH=. :
#   S_NAME=a16_s2 S_DATA=/root/slices/A16 S_LAYERS=4 S_DMODEL=96 S_HEADS=3 S_DMLP=192 \
#   S_EPOCHS=200 python -m training_recipes.sweep
# Other env: S_WINDOW (1024), S_LR (5e-4), S_BATCH (optimizer batch tokens, 2**17),
# S_MICRO (2**17), S_OUT (/workspace/sweep/out), S_COMPILE (1), S_WARMUP (epochs/5).
# Testing tool for rented cloud machines; not part of the submitted programs.
import json, os, time
from math import cos, pi, log

import torch
from torch.nn.functional import binary_cross_entropy_with_logits, log_softmax

from pysrc.model import Transformer, TransformerConfig
from pysrc.train import train, TrainingConfig
from pysrc.optimizer import AdamWConfig, MuonConfig, OptimizerConfig
from pysrc.data import CollatedArticlesDataLoader
from pysrc.cmix_loss import MixtureLossConfig, CmixMixtureLoss
from pysrc.logger import LoggerConfig

E = os.environ.get


def make_model(layers: int, d_model: int, heads: int, d_mlp: int, window: int, max_len: int) -> Transformer:
    pattern = ([True, True, True, False] * layers)[:layers]
    pattern[-1] = False  # the last layer is a window-attention layer, as in the 12-layer model
    return Transformer(
        TransformerConfig(
            vocabulary_size=205, prior_embedding=True, prior_logit_mixing=False,
            max_variable_sequence_length=max_len, n_layers=layers,
            attention_weight_sharing_pattern=list(range(layers)),
            mlp_weight_sharing_pattern=list(range(layers)),
            d_model=d_model, kimi_linear=pattern, window_size=window, window_size_multipliers=None,
            n_query_heads=heads, n_key_value_heads=heads, d_head=d_model // heads, d_mla=None,
            rope_base=10_000, half_truncate_rope=False, query_key_norm=True, query_key_norm_gain=False,
            kimi_linear_d_head=d_model // heads, kimi_linear_n_heads=heads, kimi_linear_convolution_size=4,
            value_embedding_pattern=None, prior_value_embedding=False, attention_scale=None,
            d_mlp=d_mlp, activation_function="relu_squared", embedding_norm=True, prior_embedding_norm=True,
            skip_connections=True, token_embedding_connections=True, prior_embedding_connections=False,
            dropout=0.0, logit_softcap=15.0, prior_logprob_cap=-12.0, prior_embedding_on_logprobs=False,
            gradient_checkpointing=False, embedding_init="normal", prior_embedding_init="normal",
            up_init="kaiming_uniform", down_init="kaiming_uniform", unembedding_init="kaiming_uniform",
            convolution_init="kaiming_uniform", logit_mixing_head_init="zero",
            activation_dtype=torch.bfloat16, attention_dtype=torch.bfloat16, logit_dtype=torch.float32,
            weight_dtype=torch.float32, mlp_quantization=None, attention_full_rank_quantization=None,
            attention_low_rank_quantization=None, qkv_quantization=None,
            kimi_linear_full_rank_quantization=None, kimi_linear_low_rank_quantization=None,
            kimi_linear_beta_projection_quantization=None, kimi_linear_convolution_quantization=None,
            embedding_quantization=None, prior_embedding_quantization=None, unembedding_quantization=None,
            logit_mixing_head_quantization=None, adamw_quantization_scales=True,
            attention_implementation="flash_attention_2",
        )
    )


def main() -> None:
    name = E("S_NAME", "run"); out_dir = E("S_OUT", "/workspace/sweep/out"); os.makedirs(out_dir, exist_ok=True)
    data_dir = E("S_DATA"); assert data_dir
    layers = int(E("S_LAYERS", "12")); d_model = int(E("S_DMODEL", "192")); heads = int(E("S_HEADS", "3"))
    d_mlp = int(E("S_DMLP", "384")); window = int(E("S_WINDOW", "1024"))
    epochs = int(E("S_EPOCHS", "200")); lr = float(E("S_LR", "5e-4"))
    micro = int(E("S_MICRO", str(2**17))); batch_tokens = int(E("S_BATCH", str(2**17)))
    warmup_epochs = int(E("S_WARMUP", str(max(1, epochs // 5))))
    device = torch.device("cuda", 0)

    raw_model = make_model(layers, d_model, heads, d_mlp, window, 2**17).to(device)
    patch = E("S_PATCH", "0") != "0"
    if patch:
        # token-step variant (pysrc/patch.py): the layers run once per token of 1 to 4 bytes
        import pysrc.train as train_module
        from pysrc.patch import PatchModel
        from pysrc.optimizer import make_optimizers as make_trunk_optimizers
        from pysrc.logger import Logger as TrunkLogger
        raw_model = PatchModel(raw_model, int(E("S_HEAD_MLP", str(d_mlp)))).to(device)

        def make_optimizers(model, cfg):
            o = make_trunk_optimizers(model.trunk, cfg)
            a = cfg.adamw_config
            o.adamw.add_param_group({"params": model.extra_parameters(), "lr": a.base_learning_rate,
                                     "weight_decay": a.weight_decay, "betas": a.betas})
            return o

        train_module.make_optimizers = make_optimizers
        train_module.Logger = lambda model, **kw: TrunkLogger(model=model.trunk, **kw)
    params = sum(p.numel() for p in raw_model.parameters())
    print(f"SWEEP {name}: layers {layers} d_model {d_model} heads {heads} d_mlp {d_mlp} params {params:,} "
          f"patch {int(patch)} epochs {epochs} data {data_dir}", flush=True)
    if E("S_COUNT_ONLY"):
        return
    model = torch.compile(raw_model) if E("S_COMPILE", "0" if patch else "1") != "0" else raw_model

    data = CollatedArticlesDataLoader(
        tokens_filename=f"{data_dir}/ppmd-bytes.uint8", priors_filename=f"{data_dir}/ppmd-probs.float16",
        article_boundaries_filename=f"{data_dir}/article-boundaries.int32",
        cmix_bits_filename=f"{data_dir}/cmix-bits.float16", mmap=True, epochs=epochs,
        micro_batch_tokens=micro, gradient_accumulation_steps=max(1, batch_tokens // micro),
        max_article_tokens=2**17, max_merge_tokens=None, device=device, rank=0, world_size=1,
    )

    def schedule(fraction_done: float) -> float:
        fw = warmup_epochs / epochs
        if fraction_done < fw:
            t = (cos(fraction_done / fw * pi) + 1) / 2
            return t * 8 + (1 - t)
        t = (cos((fraction_done - fw) / max(1 - fw, 1e-9) * pi) + 1) / 2
        return t + (1 - t) * 0.025

    cfg = TrainingConfig(
        initialize_scales_steps=None, initialize_weight_scales_first=True,
        optimizer_config=OptimizerConfig(
            learning_rate_multiplier_schedule=schedule,
            second_order_config=MuonConfig(base_learning_rate=lr, weight_decay=0.1, momentum=0.95,
                                           adjust_lr_fn="match_rms_adamw"),
            adamw_config=AdamWConfig(base_learning_rate=lr, weight_decay=0.01, betas=(0.95, 0.99)),
        ),
        window_size_schedule=None,
        mixture_loss=MixtureLossConfig(cross_entropy_weight=float(E("A_CE_WEIGHT", "0.1")), rich_contexts=False),
        logger_config=LoggerConfig(wandb_project="sweep", wandb_run_name=name),
    )
    t0 = time.time()
    mixture = train(raw_model=raw_model, model=model, data=data, cfg=cfg)
    train_s = time.time() - t0
    torch.save(raw_model.state_dict(), f"{out_dir}/{name}.tch")
    torch.save(mixture.state_dict(), f"{out_dir}/{name}.mixer.tch")

    # score the slice in file order with the trained model and the trained stand-in mixer
    pure = CmixMixtureLoss(MixtureLossConfig(cross_entropy_weight=0.0, rich_contexts=False)).to(device)
    pure.load_state_dict(mixture.state_dict())
    raw_model.eval()
    tf = mix = cm = 0.0; n = 0; steps = 0
    with torch.no_grad():
        for _, mb in data.iter_ordered_micro_batches():
            if patch:
                logits, n_tok = raw_model.compute_logits(mb.input_tokens, mb.priors, mb.cumulative_sequence_lengths)
                steps += n_tok  # includes the padding of the last micro batch
            else:
                logits = model(input_tokens=mb.input_tokens, priors=mb.priors, loss_mask=mb.loss_mask,
                               output_tokens=mb.output_tokens,
                               cumulative_sequence_lengths=mb.cumulative_sequence_lengths, return_logits=True)
                steps += mb.input_tokens.numel()
            mask = mb.loss_mask.reshape(-1); tg = mb.output_tokens.reshape(-1)
            logp = log_softmax(logits.reshape(-1, logits.shape[-1]).float(), dim=-1)
            tf += float(torch.where(mask, -logp.gather(1, tg[:, None]).squeeze(1), 0.0).sum())
            mix += float(pure(logits, mb.output_tokens, mb.cmix_bit_logits, mb.loss_mask))
            lc = mb.cmix_bit_logits.reshape(-1, 8).float().clamp(-12, 12)
            y = pure.path_bits[tg]
            cm += float(torch.where(mask, binary_cross_entropy_with_logits(lc, y, reduction="none").sum(1), 0.0).sum())
            n += int(mask.sum())
    r = {"name": name, "data": data_dir, "layers": layers, "d_model": d_model, "heads": heads, "d_mlp": d_mlp,
         "window": window, "params": params, "patch": int(patch), "trunk_steps": steps, "epochs": epochs, "lr": lr, "batch_tokens": batch_tokens,
         "scored_tokens": n, "tf_bits": tf / log(2), "cmix_bits": cm / log(2), "mix_bits": mix / log(2),
         "tf_bpc": tf / log(2) / n, "cmix_bpc": cm / log(2) / n, "mix_bpc": mix / log(2) / n,
         "train_seconds": train_s}
    json.dump(r, open(f"{out_dir}/{name}.json", "w"), indent=1)
    print("RESULT", json.dumps(r), flush=True)


if __name__ == "__main__":
    main()
