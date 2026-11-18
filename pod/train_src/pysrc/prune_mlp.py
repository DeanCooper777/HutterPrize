"""Shrink every MLP of a checkpoint from width 768 to a smaller width (phase 2
of docs/NEW_TRANSFORMER_PLAN.md, 2026-11-08).

    python -m pysrc.prune_mlp IN.tch OUT.tch WIDTH

Each MLP is down(relu(up x)^2). A hidden unit i contributes roughly
|up_i|^2 * |down[:, i]| to the output (relu^2 is quadratic in the up row),
so the units with the largest such score are kept, in their original order.
Sliced per unit: up.weight rows, up bias, the per-row weight scales of up,
and down.weight columns. Per-tensor activation scales and down's per-output-
row weight scales are kept as they are; the fine-tune afterwards adapts them.
"""
import re
import sys

import torch


def main() -> None:
    src, dst, width = sys.argv[1], sys.argv[2], int(sys.argv[3])
    sd = torch.load(src, map_location="cpu")
    prefixes = sorted({m.group(1) for k in sd if (m := re.match(r"(.*mlp)\.up\.weight$", k))})
    assert prefixes, "no mlp.up.weight keys found"
    out = dict(sd)
    for p in prefixes:
        up, down = sd[p + ".up.weight"], sd[p + ".down.weight"]
        d_mlp = up.shape[0]
        assert down.shape[1] == d_mlp and width < d_mlp, (p, up.shape, down.shape)
        score = up.float().pow(2).sum(1) * down.float().norm(dim=0)
        keep = score.topk(width).indices.sort().values
        out[p + ".up.weight"] = up[keep].clone()
        out[p + ".down.weight"] = down[:, keep].clone()
        for k in (p + ".up.bias", p + ".up.quantize_weight.scale"):
            if k in sd and sd[k].shape[0] == d_mlp:
                out[k] = sd[k][keep].clone()
        kept = score[keep].sum() / score.sum()
        print(f"{p}: {d_mlp} -> {width}, kept {kept:.1%} of the importance")
    # nothing in an MLP may still carry the old width
    for k, v in out.items():
        if ".mlp." in k:
            assert all(s != d_mlp for s in v.shape), (k, tuple(v.shape))
    torch.save(out, dst)
    print(f"saved {dst}")


if __name__ == "__main__":
    main()
