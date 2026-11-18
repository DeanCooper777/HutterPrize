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
