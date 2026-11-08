"""cmix-aware training loss ("mixture loss").

At compression time the transformer's byte distribution is one input among
many: cmix codes each byte as 8 binary decisions and mixes the transformer's
bit predictions with those of its other models. This loss trains the
transformer for that use. For every predicted token it

  1. converts the transformer's 205-way distribution into the probabilities of
     the 8 bits along the path of the actual byte, exactly the way cmix's
     ByteModel::Predict does (subtree sums over the 256-leaf byte tree, bytes
     outside the vocabulary have probability 0, vocabulary probabilities are
     floored at 1e-6 as Predictor::TransformerByteUpdate does);
  2. mixes each bit with cmix's own prediction for that bit made WITHOUT the
     transformer (dumped by `cmix --no-transformer --save-cmix-bits`, a
     float16 logit per bit) through a small logistic mixer, a stand-in for
     cmix's mixer network: z = w0 * st(p_cmix) + w1 * st(p_tf) + w2, with one
     weight set per (bit position, cmix-confidence bucket);
  3. returns the binary cross-entropy of the mixed predictions (nats, summed
     over the 8 bits and the unmasked tokens), optionally blended with the
     plain cross-entropy of the transformer.

On enwik6 a static fit of this stand-in reaches 133,656 bytes against the
real cmix's 131,548 (scripts/analysis/standin_mixer.py), so it is a close
proxy for what the transformer contributes inside cmix.

The mixer's weights are deliberately NOT part of the Transformer module: they
must not be exported with the transformer's weights, and they are trained by
their own small AdamW (see MixtureLossConfig / make_mixture in train.py).
"""

from dataclasses import dataclass
from math import log

import torch
from torch import Tensor, nn
from torch.nn.functional import binary_cross_entropy_with_logits, log_softmax

# The 205 bytes of the enwik9 vocabulary (the same bitmask as kOfficialVocab
# in src/runner.cpp); vocabulary index i is the i-th smallest byte.
_OFFICIAL_VOCAB_MASK: bytes = bytes(
    [0xE8, 0x16, 0x04, 0x00, 0xFF, 0xFF, 0xFF, 0x03, 0x01, 0xFC, 0x0F,
     0xF9, 0xFE, 0xFF, 0xFF, 0x07] + [0xFF] * 16
)
VOCAB_BYTES: list[int] = [
    i for i in range(256) if (_OFFICIAL_VOCAB_MASK[i // 8] >> (i % 8)) & 1
]
assert len(VOCAB_BYTES) == 205

# Predictor::TransformerByteUpdate floors every vocabulary probability at 1e-6
_LOG_PROB_FLOOR: float = log(1e-6)
# bytes outside the vocabulary: probability 0 in cmix; a large finite negative
# number keeps logsumexp's gradient finite
_LOG_ZERO: float = -80.0
# bit logits are clamped like cmix's mixer inputs (p within ~[6e-6, 1-6e-6])
_LOGIT_CLAMP: float = 12.0


@dataclass(frozen=True, slots=True)
class MixtureLossConfig:
    # weight of the plain cross-entropy in the blend (0 = pure mixture loss)
    cross_entropy_weight: float = 0.0
    # mixer weight sets per bit position, selected by |cmix logit| / 2
    confidence_buckets: int = 8
    # "rich": the weight sets are further split by transformer confidence
    # (|transformer bit logit| / 2, 4 buckets) and by whether the two agree
    # on the bit (sign), 8 x 8 x 4 x 2 = 512 sets. On enwik6 a static fit
    # reaches 133,098 bytes vs 133,656 for the plain 64 sets (real cmix:
    # 131,548; scripts/analysis/standin_mixer.py, 2026-11-08)
    rich_contexts: bool = False
    # AdamW learning rate of the mixer weights
    mixer_learning_rate: float = 1e-3
    # initial weights (cmix, transformer, bias)
    initial_weights: tuple[float, float, float] = (0.3, 0.8, 0.0)


class CmixMixtureLoss(nn.Module):
    def __init__(self, cfg: MixtureLossConfig, vocabulary_size: int = 205) -> None:
        super().__init__()
        assert vocabulary_size == 205, "the byte tree assumes the enwik9 vocabulary"
        self.cfg = cfg
        n_contexts = 8 * cfg.confidence_buckets * (8 if cfg.rich_contexts else 1)
        self.weights = nn.Parameter(
            torch.tensor([list(cfg.initial_weights)] * n_contexts, dtype=torch.float32)
        )

        vocab = torch.tensor(VOCAB_BYTES, dtype=torch.int64)
        self.register_buffer("vocab_bytes", vocab, persistent=False)
        j = torch.arange(8, dtype=torch.int64)
        # for target token v (byte b): the node at depth j on b's path is
        # b >> (8 - j); its children at depth j + 1 are 2n and 2n + 1; the
        # actual bit is (b >> (7 - j)) & 1
        node = vocab[:, None] >> (8 - j)[None, :]  # 205 x 8
        bits = (vocab[:, None] >> (7 - j)[None, :]) & 1  # 205 x 8
        self.register_buffer("path_nodes", node, persistent=False)
        self.register_buffer("path_bits", bits.to(torch.float32), persistent=False)

    def bit_logits(self, logp: Tensor, targets: Tensor) -> Tensor:
        """transformer log probabilities (N, 205, log_softmax of the logits)
        and target tokens (N,) -> logits of P(bit = 1) for the 8 bits along
        each target byte's path (N, 8)"""
        n = logp.shape[0]
        logp = logp.clamp(min=_LOG_PROB_FLOOR)
        logp256 = logp.new_full((n, 256), _LOG_ZERO)
        logp256 = logp256.index_copy(1, self.vocab_bytes, logp)
        # levels[d]: (N, 2^d) log of the probability mass under each node at
        # depth d (levels[8] = leaves)
        levels: list[Tensor] = [logp256]
        for d in range(7, 0, -1):
            levels.append(torch.logsumexp(levels[-1].view(n, 1 << d, 2), dim=-1))
        levels.reverse()  # now levels[k] has depth k + 1, k = 0..7
        nodes = self.path_nodes[targets]  # N x 8
        out = []
        for jj in range(8):
            level = levels[jj]  # depth jj + 1
            child0 = level.gather(1, (2 * nodes[:, jj : jj + 1]))
            child1 = level.gather(1, (2 * nodes[:, jj : jj + 1] + 1))
            out.append(child1 - child0)
        return torch.cat(out, dim=1).clamp(-_LOGIT_CLAMP, _LOGIT_CLAMP)

    def forward(
        self,
        logits: Tensor,  # (..., 205)
        output_tokens: Tensor,  # (...)
        cmix_bit_logits: Tensor,  # (..., 8) float16 logits from --save-cmix-bits
        loss_mask: Tensor,  # (...) bool
    ) -> Tensor:
        """summed loss in nats over the unmasked tokens"""
        # every position is computed and the masked ones are zeroed with
        # torch.where: boolean-mask indexing (x[mask]) makes the GPU report
        # the row count to the host, a full stream sync per call (3 per micro
        # batch, 2026-11-07); padding positions are cheap, the model
        # computes them anyway
        mask = loss_mask.reshape(-1)
        logits = logits.reshape(-1, logits.shape[-1])
        targets = output_tokens.reshape(-1)
        lc = cmix_bit_logits.reshape(-1, 8).float()
        lc = lc.clamp(-_LOGIT_CLAMP, _LOGIT_CLAMP)

        logp = log_softmax(logits.float(), dim=-1)
        lt = self.bit_logits(logp, targets)
        buckets = (lc.abs() / 2).long().clamp(max=self.cfg.confidence_buckets - 1)
        context = torch.arange(8, device=lc.device)[None, :] * self.cfg.confidence_buckets + buckets
        if self.cfg.rich_contexts:
            # contexts are discrete: no gradient flows through their choice
            tconf = (lt.detach().abs() / 2).long().clamp(max=3)
            agree = ((lc > 0) == (lt.detach() > 0)).long()
            context = (context * 4 + tconf) * 2 + agree
        w = self.weights[context]  # N x 8 x 3
        z = w[..., 0] * lc + w[..., 1] * lt + w[..., 2]
        y = self.path_bits[targets]
        bit_losses = binary_cross_entropy_with_logits(z, y, reduction="none").sum(1)
        mixture = torch.where(mask, bit_losses, 0.0).sum()

        a = self.cfg.cross_entropy_weight
        if a == 0.0:
            return mixture
        token_losses = -logp.gather(1, targets[:, None]).squeeze(1)
        cross_entropy = torch.where(mask, token_losses, 0.0).sum()
        return (1 - a) * mixture + a * cross_entropy


# ruff: noqa: F722
