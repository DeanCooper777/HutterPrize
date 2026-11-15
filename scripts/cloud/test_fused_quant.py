# test_fused_quant.py: unit test and timing of the fused fake quantization against the eager
# reference (fx2-cmix-T/pysrc/quantization.py): forward results and input gradients must be
# identical, scale gradients equal to rounding. Needs a GPU. Prints ALL OK or SOME MISMATCH.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Compare pysrc.quantization's fused fake quantization with the eager
# reference (QuantizeFunction) on run A's shapes: forward must match bit for
# bit, gradients to rounding; then time both. Run from /workspace/train:
#   PYTHONPATH=. uv run python /workspace/scripts/test_fused_quant.py
import time

import torch

from pysrc.quantization import (
    FusedQuantizeFunction,
    Quantization,
    QuantizeFunction,
)

torch.manual_seed(0)
dev = "cuda"
cases = []
for buckets, scale_init in ((15, "scaled_max"), (256, "scaled_mean"), (4, "scaled_mean"), (3, "scaled_mean")):
    q = Quantization(
        buckets=buckets, block_size=None, scale_dtype=torch.bfloat16,
        arithmetic_dtype=torch.float32, scale_init=scale_init, epsilon=None,
    )
    # activation (2**17 tokens x 768, bf16, one scale) and weight (768 x 192, fp32, per row)
    cases.append((f"act b={buckets}", q, (2**17, 1, 768), torch.bfloat16, 1))
    cases.append((f"wt  b={buckets}", q, (1, 768, 192), torch.float32, 768))

ok = True
for name, q, shape, dtype, n_scales in cases:
    q = Quantization(**{**{f: getattr(q, f) for f in q.__slots__}, "block_size": shape[-1]})
    x = (torch.randn(shape, device=dev) * 0.7).to(dtype)
    scale = (torch.rand(n_scales, device=dev) * 0.05 + 0.01)
    g = torch.randn(shape, device=dev).to(dtype)
    res = {}
    for label, fn in (("eager", QuantizeFunction), ("fused", FusedQuantizeFunction)):
        xi = x.clone().requires_grad_(True)
        si = scale.clone().requires_grad_(True)
        y = fn.apply(xi, si, q, False)
        y.backward(g)
        ints = fn.apply(x, scale, q, True)
        res[label] = (y.detach(), xi.grad, si.grad, ints)
    e, f = res["eager"], res["fused"]
    fwd_exact = torch.equal(e[0], f[0]) and torch.equal(e[3], f[3])
    gin_exact = torch.equal(e[1], f[1])
    gs_rel = ((e[2] - f[2]).abs().max() / e[2].abs().max().clamp(min=1e-30)).item()
    good = fwd_exact and gin_exact and gs_rel < 1e-4
    ok &= good
    print(f"{name}: forward exact {fwd_exact}, grad input exact {gin_exact}, "
          f"grad scale max rel diff {gs_rel:.2e} {'OK' if good else 'MISMATCH'}")

    times = {}
    for label, fn in (("eager", QuantizeFunction), ("fused", FusedQuantizeFunction)):
        xi = x.clone().requires_grad_(True)
        si = scale.clone().requires_grad_(True)
        for it in range(13):
            if it == 3:
                torch.cuda.synchronize()
                t = time.time()
            fn.apply(xi, si, q, False).backward(g)
        torch.cuda.synchronize()
        times[label] = (time.time() - t) / 10 * 1e3
    print(f"    fwd+bwd: eager {times['eager']:.2f} ms, fused {times['fused']:.2f} ms "
          f"({times['eager'] / times['fused']:.1f}x)")

print("ALL OK" if ok else "SOME MISMATCH")
