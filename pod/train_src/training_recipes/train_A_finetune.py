# Run A of docs/NEW_TRANSFORMER_PLAN.md: fine-tune the existing quantized 6M
# model (QAT, bf16) with the cmix mixture loss (pysrc/cmix_loss.py) on the
# training data of OUR build. Derived from quantize.py; differences: starts
# from models/6m-q4.tch (scales already initialized), reads
# data/cmix-bits.float16, trains against the stand-in cmix mixer.
# Environment: A_EPOCHS (default 24), A_LR (base lr, default 2.5e-6; the
# schedule starts at 10x and decays to 1x like quantize.py), A_CE_WEIGHT
# (plain cross-entropy share, default 0.1), A_INIT (start checkpoint).
from torch.nn.parallel import DistributedDataParallel as DDP
from dataclasses import replace as _dc_replace
import torch.distributed as dist
import torch
from os import makedirs
import os
from math import cos, pi
from dotenv import load_dotenv

from pysrc.model import Transformer, TransformerConfig, MatmulQuantization
from pysrc.quantization import Quantization
from pysrc.train import train, TrainingConfig
from pysrc.cmix_loss import MixtureLossConfig
from pysrc.optimizer import AdamWConfig, MuonConfig, OptimizerConfig
from pysrc.data import CollatedArticlesDataLoader
from pysrc.save_outputs import save_transformer_outputs
from pysrc.logger import LoggerConfig


def main() -> None:
    dist.init_process_group(backend="nccl")
    rank = int(os.environ["LOCAL_RANK"])
    world_size = int(os.environ["WORLD_SIZE"])
    main_process: bool = rank == 0
    torch.cuda.set_device(rank)
    device = torch.device("cuda", rank)

    # same effective batch as upstream (2**20 tokens per step) on any GPU
    # count: 2**17-token micro batches, accumulated over 8 / world_size steps
    # TRAIN_MICRO_TOKENS: tokens per micro batch (a power of two, default
    # 2**17); the step stays 2**20 tokens, so accumulation shrinks to match.
    # Larger micro batches need more GPU memory (2026-11-07, run A speedups)
    micro_batch_tokens: int = int(os.environ.get("TRAIN_MICRO_TOKENS", str(2**17)))
    assert micro_batch_tokens & (micro_batch_tokens - 1) == 0
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
    from pysrc.bits_map import apply_bits_map
    apply_bits_map(raw_model)
    # A_INIT_SCALES=N: the start checkpoint has no quantization scales (run B,
    # stage 1 output, 2026-11-09): load non-strictly and fit the scales over
    # N steps first, like upstream quantize.py (256)
    init_scales = int(os.environ.get("A_INIT_SCALES", "0")) or None
    raw_model.load_state_dict(
        torch.load(os.environ.get("A_INIT", "models/6m-q4.tch")), strict=init_scales is None
    )
    model: DDP = DDP(raw_model)
    # important: do not torch compile the model as it removes the .to(torch.bfloat16).to(torch.float32) conversion applied to the quantization scales

    learning_rate: float = float(os.environ.get("A_LR", "2.5e-6"))
    epochs: int = int(os.environ.get("A_EPOCHS", "24"))
    warmup_epochs: int = epochs
    warmup_learning_rate_multiplier: int = 10
    final_learning_rate_multiplier: float = 0.0

    data = CollatedArticlesDataLoader(
        tokens_filename="data/ppmd-bytes.uint8",
        priors_filename="data/ppmd-probs.float16",
        article_boundaries_filename="data/article-boundaries.int32",
        cmix_bits_filename="data/cmix-bits.float16",
        mmap=True,
        epochs=epochs,
        micro_batch_tokens=micro_batch_tokens,
        gradient_accumulation_steps=max(1, 2**20 // (micro_batch_tokens * world_size)),
        max_article_tokens=max_article_tokens,
        max_merge_tokens=None,
        device=device,
        rank=rank,
        world_size=world_size,
    )

    # if main_process:
    #     model.load_state_dict(torch.load("models/6m.tch"))
    #     save_transformer_outputs(model, data, "data/transformer-probs-6m.float16")
    #     return

    def learning_rate_multiplier_schedule(fraction_done: float) -> float:
        fraction_warmup = warmup_epochs / epochs
        # the last batch has fraction_done == 1.0 exactly: with warmup over the
        # whole run the cosine branch below would divide by zero (this crashed
        # run A on its final step, 2026-11-07)
        if fraction_warmup >= 1 or fraction_done < fraction_warmup:
            s = min(fraction_done / fraction_warmup, 1.0)
            t = (cos(s * pi) + 1) / 2
            return t * warmup_learning_rate_multiplier + (1 - t)

        s = (fraction_done - fraction_warmup) / (1 - fraction_warmup)
        t = (cos(s * pi) + 1) / 2
        return t + (1 - t) * final_learning_rate_multiplier

    training_config = TrainingConfig(
        initialize_scales_steps=init_scales,
        initialize_weight_scales_first=True,
        optimizer_config=OptimizerConfig(
            learning_rate_multiplier_schedule=learning_rate_multiplier_schedule,
            second_order_config=MuonConfig(
                base_learning_rate=learning_rate,
                weight_decay=0.1,
                momentum=0.95,
                adjust_lr_fn="match_rms_adamw",
            ),
            # second_order_config=SOAPConfig(
            #     base_learning_rate=3e-3,
            #     weight_decay=1e-2,
            #     betas=(0.95, 0.95),
            #     max_precondition_dim=10_000,
            # ),
            adamw_config=AdamWConfig(
                base_learning_rate=learning_rate,
                weight_decay=0.01,
                betas=(0.95, 0.99),
            ),
        ),
        window_size_schedule=None,
        mixture_loss=MixtureLossConfig(
            cross_entropy_weight=float(os.environ.get("A_CE_WEIGHT", "0.1")),
            # A_MIXER=rich: 512 stand-in mixer contexts (variant 1a)
            rich_contexts=os.environ.get("A_MIXER", "plain") == "rich",
        ),
        logger_config=LoggerConfig(
            wandb_project="fx2-cmix-transformer", wandb_run_name="6m-q4-A"
        ),
    )

    mixture = train(raw_model=raw_model, model=model, data=data, cfg=training_config)

    if main_process:
        makedirs("models", exist_ok=True)
        torch.save(raw_model.state_dict(), "models/6m-q4-A.tch")
        torch.save(mixture.state_dict(), "models/6m-q4-A.mixer.tch")

    dist.destroy_process_group()


if __name__ == "__main__":
    load_dotenv()
    main()
