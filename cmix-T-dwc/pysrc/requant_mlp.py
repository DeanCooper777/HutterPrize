# requant_mlp.py: experiment tool that re-fits the MLP weight scales for fewer levels.
#
# Where it fits: training side, before a quantization-aware fine-tune with A_MLP_BITS < 4. A
# scale learned for 15 levels (-7..7) is a poor start for 7 levels (-3..3), so each row's scale
# is re-chosen to minimise the rounding error; the fine-tune then starts from there.
#
# Testing: this is a testing / experiment tool only. The 3-bit MLP variant was rejected (the
# archive grew more than the weights shrank, see docs/NEW_TRANSFORMER_PLAN.md); the shipped
# model uses 4-bit weights everywhere.
#
# Changes from the previous winning entry (fx2-cmix-transformer-v1): New in this entry.
"""Re-fit the MLP weight scales of a checkpoint for fewer quantization levels
(variant 2c of docs/NEW_TRANSFORMER_PLAN.md, 2026-11-08).

    python -m pysrc.requant_mlp IN.tch OUT.tch BITS

The weights are quantized per output row as round(w / s) clamped to
[-qmax, qmax], qmax = 2**(BITS-1) - 1 (3 for BITS=3). For each row of every
mlp.up / mlp.down weight this picks s = c * max|w| / qmax, with c on a grid in
[0.3, 1], minimizing the squared rounding error. Only the
*.mlp.*.quantize_weight.scale entries change. Train with A_MLP_BITS=BITS.
"""
import re
import sys

import torch


def main() -> None:
    src, dst, bits = sys.argv[1], sys.argv[2], int(sys.argv[3])
    qmax = 2 ** (bits - 1) - 1
    sd = torch.load(src, map_location="cpu")
    grid = torch.linspace(0.3, 1.0, 71)
    out = dict(sd)
    # For every MLP weight matrix: try 71 candidate scales per row, keep the one with the least
    # squared error, and report it against the error of the existing 4-bit quantization.
    for k in sorted(sd):
        m = re.match(r"(.*\.mlp\.(up|down))\.weight$", k)
        if not m:
            continue
        w = sd[k].float()
        amax = w.abs().amax(1).clamp_min(1e-12)
        # candidate scales (rows, grid), rounded to bf16 like the quantizer
        s = (grid[None, :] * amax[:, None] / qmax).to(torch.bfloat16).float()
        q = (w[:, None, :] / s[:, :, None]).round().clamp(-qmax, qmax)
        err = ((q * s[:, :, None] - w[:, None, :]) ** 2).sum(-1)
        best = err.argmin(1)
        new_s = s[torch.arange(w.shape[0]), best]
        sk = m.group(1) + ".quantize_weight.scale"
        old_s = sd[sk].float()
        q_old = (w / old_s.to(torch.bfloat16).float()[:, None]).round().clamp(-7, 7)
        e_old = ((q_old * old_s[:, None] - w) ** 2).sum()
        out[sk] = new_s.to(sd[sk].dtype)
        print(f"{m.group(1)}: mean c {grid[best].mean():.2f}, "
              f"rms error {(err.min(1).values.sum() / w.numel()).sqrt():.2e} "
              f"(4-bit {(e_old / w.numel()).sqrt():.2e})")
    torch.save(out, dst)
    print(f"saved {dst}")


if __name__ == "__main__":
    main()
