"""Token-step ("patch") variant of the byte transformer, for the bigger-tokens experiment.

The byte model runs all its layers once per stream byte. Here the layers (the "trunk") run once
per TOKEN, a group of 1 to 4 bytes, and a small head predicts the bytes inside a token. The
model still delivers one distribution per byte, so losses are directly comparable with the byte
model and cmix would use it unchanged.

Tokens. A token ends at a byte that is neither a space nor a prefix byte of a dictionary code
(0xD0..0xFF), or when it has 4 bytes. So a space joins the word behind it, and a 2- or 3-byte
dictionary code is one token: "[space][prefix][prefix]last". The rule looks only at bytes
already coded, so a decoder can apply it.

Trunk step for token t: input = sum of the embeddings of its bytes (one table per position in
the token) + the embedding of the PPMd prior for the byte that follows the token. Its output
predicts the FIRST byte of the next token exactly as the byte model does.

Head, for every further byte of a token: input = trunk output of the last finished token +
embeddings of the token's bytes so far + embedding of the PPMd prior of this byte; one small
MLP; own output matrix.

Testing tool for rented cloud machines; not part of the submitted programs.
"""

import torch
from torch import Tensor, nn
from torch.nn.functional import cross_entropy, embedding

from pysrc.model import Transformer, rms_norm
from pysrc.cmix_loss import VOCAB_BYTES

MAX_LEN = 4


class PatchModel(nn.Module):
    def __init__(self, trunk: Transformer, d_head_mlp: int) -> None:
        super().__init__()
        self.trunk = trunk
        self.cfg = trunk.cfg
        v, d = trunk.cfg.vocabulary_size, trunk.cfg.d_model
        self.v = v
        # trunk input: byte embeddings for positions 1..3 of a token (position 0 is trunk.embedding)
        self.slot_emb = nn.Parameter(torch.randn((MAX_LEN - 1) * v, d))
        # head
        self.h_emb = nn.Parameter(torch.randn(MAX_LEN * v, d) * 0.5)
        self.h_prior = nn.Parameter(torch.randn(d, v) * 0.5)
        self.h_up = nn.Parameter(torch.empty(d_head_mlp, d).uniform_(-1, 1) * (3 / d) ** 0.5)
        self.h_down = nn.Parameter(torch.zeros(d, d_head_mlp))
        self.h_unemb = nn.Parameter(torch.empty(v, d).uniform_(-1, 1) * (3 / d) ** 0.5)
        b = torch.tensor(VOCAB_BYTES, dtype=torch.int64)
        self.register_buffer("nonend_tab", (b == 0x20) | (b >= 0xD0), persistent=False)

    def extra_parameters(self) -> list[nn.Parameter]:
        return [self.slot_emb, self.h_emb, self.h_prior, self.h_up, self.h_down, self.h_unemb]

    def segment(self, x: Tensor, cs_cpu: Tensor):
        """x: (P,) vocabulary indices; cs_cpu: article boundaries in positions (0 ... P).
        Returns e (token ends here), s (position of the byte in its token), ce (ends up to
        and including here), ts (start position of the byte's token), ast (start of its article)."""
        p = x.numel(); dev = x.device
        idx = torch.arange(p, device=dev)
        st = torch.zeros(p, dtype=torch.bool, device=dev)
        st[cs_cpu[:-1].to(dev)] = True
        ast = torch.cummax(torch.where(st, idx, -1), 0).values
        nonend = self.nonend_tab[x]
        last_break = torch.cummax(torch.where(~nonend, idx, -1), 0).values
        c = idx - torch.maximum(last_break, ast - 1)  # run length of space / prefix bytes
        e = (~nonend) | (c % MAX_LEN == 0)
        e[(cs_cpu[1:] - 1).to(dev)] = True  # every article ends with a token end
        ev = st.clone()
        ev[1:] |= e[:-1]
        ts = torch.cummax(torch.where(ev, idx, -1), 0).values
        s = idx - ts
        ce = torch.cumsum(e.long(), 0)
        return e, s, ce, ts, ast

    def compute_logits(self, input_tokens, priors, cumulative_sequence_lengths, override_window_size=None):
        assert input_tokens.shape[0] == 1
        x = input_tokens[0]; p = x.numel(); dev = x.device; v = self.v
        adt = self.cfg.activation_dtype
        cs_cpu = cumulative_sequence_lengths.cpu_values[0].long()
        e, s, ce, ts, ast = self.segment(x, cs_cpu)
        tid = ce - e.long()
        n_tok = int(ce[-1])

        # trunk over tokens
        # The token count differs per micro batch; the GPU kernels are compiled per sequence
        # length, so the token sequence is padded to a multiple of PAD (the padding is a
        # document of its own).
        PAD = 8192
        n_pad = -(-n_tok // PAD) * PAD
        table = torch.cat([self.trunk.embedding.weight, self.slot_emb]).to(adt)
        tok_emb = torch.zeros((n_pad, table.shape[1]), dtype=adt, device=dev).index_add_(
            0, tid, embedding(s * v + x, table))
        end_idx = torch.nonzero(e)[:, 0]
        tok_prior = torch.zeros((n_pad, v), dtype=priors.dtype, device=dev)
        tok_prior[:n_tok] = priors[0][end_idx]
        cs_dev = cs_cpu.to(dev)
        tb = torch.where(cs_dev > 0, ce[(cs_dev - 1).clamp(min=0)], 0).to(torch.int32)
        if n_pad > n_tok:
            tb = torch.cat([tb, torch.tensor([n_pad], dtype=torch.int32, device=dev)])
        tb = tb[None]
        tb_cpu = tb.cpu()
        tb.cpu_values = tb_cpu  # type: ignore[attr-defined]
        self.trunk._patch_embed = tok_emb[None]
        try:
            h = self.trunk.compute_last_activation(
                input_tokens=torch.zeros((1, n_pad), dtype=torch.int64, device=dev),
                priors=tok_prior[None], cumulative_sequence_lengths=tb,
                override_window_size=override_window_size)
        finally:
            self.trunk._patch_embed = None
        first = self.trunk.last_activation_to_logits(h, priors=tok_prior[None])[0]  # (n_tok, v)

        # head for the bytes inside a token
        pid = ce - 1
        aft = torch.where(ast > 0, ce[(ast - 1).clamp(min=0)], 0)
        valid = (pid >= aft)[:, None]
        hb = torch.where(valid, h[0][pid.clamp(min=0)], 0)
        eh = embedding(s * v + x, self.h_emb.to(adt))
        insum = eh
        for k in range(1, MAX_LEN):
            shifted = torch.zeros_like(eh)
            shifted[k:] = eh[:-k]
            insum = insum + torch.where((s >= k)[:, None], shifted, 0)
        pr = torch.nn.functional.linear(priors[0].to(adt), self.h_prior.to(adt))
        z = rms_norm(hb) + rms_norm(insum) + rms_norm(pr)
        u = torch.nn.functional.linear(rms_norm(z), self.h_up.to(adt)).relu().square()
        z = z + torch.nn.functional.linear(u, self.h_down.to(adt))
        lh = torch.nn.functional.linear(rms_norm(z), self.h_unemb.to(adt))
        cap = self.cfg.logit_softcap
        if cap is not None:
            lh = cap * (lh / cap).tanh()
        lh = lh.to(self.cfg.logit_dtype)
        logits = torch.where(e[:, None], first[pid.clamp(min=0)], lh)
        return logits[None], n_tok

    def forward(self, input_tokens, priors, loss_mask, output_tokens, cumulative_sequence_lengths,
                override_window_size=None, initialize_scales=None, return_logits: bool = False):
        logits, _ = self.compute_logits(input_tokens, priors, cumulative_sequence_lengths, override_window_size)
        if return_logits:
            return logits
        loss = cross_entropy(logits.view(-1, logits.size(-1)), output_tokens.flatten(), reduction="none")
        return torch.where(loss_mask.flatten(), loss.to(torch.float32), 0.0).sum()


def apply_model_hook(path: str) -> None:
    """one-line hook in pysrc/model.py: the trunk takes ready-made token embeddings"""
    src = open(path).read()
    old = ("        token_embeddings = self.embedding(\n"
           "            input_tokens, initialize_scales=initialize_scales\n"
           "        )\n")
    new = ("        token_embeddings = (\n"
           "            self._patch_embed\n"
           "            if getattr(self, \"_patch_embed\", None) is not None\n"
           "            else self.embedding(input_tokens, initialize_scales=initialize_scales)\n"
           "        )\n")
    if "_patch_embed" in src:
        return
    assert src.count(old) == 1
    open(path, "w").write(src.replace(old, new))


if __name__ == "__main__":
    import sys
    apply_model_hook(sys.argv[1])
    print("hook applied")
