"""Per-group weight precision (mixed-precision sweep, 2026-11-11).
A_BITS_MAP="L03.mlp=7,L05.attn=7,embedding=7": quantized weight matrices of the
named groups get that many levels (7 = 3-bit, 3 = ternary) instead of 15. Groups:
LNN.mlp / LNN.attn (blocks.NN.mlp.* / blocks.NN.attention.*), embedding,
prior_embedding, unembedding. The C++ side is unchanged (ints stay within int4);
the weight coder (weights_compress v2, adaptive) gives the size saving."""
import os, re
from dataclasses import replace
from pysrc.quantization import Quantize


def group_of(name: str) -> str:
    m = re.match(r"blocks\.(\d+)\.(attention|mlp)\.", name)
    if m:
        return f"L{int(m.group(1)):02d}.{'attn' if m.group(2) == 'attention' else 'mlp'}"
    return name.split(".")[0]


def apply_bits_map(model, spec: str | None = None) -> list[str]:
    spec = os.environ.get("A_BITS_MAP", "") if spec is None else spec
    levels = {}
    for item in filter(None, (s.strip() for s in spec.split(","))):
        g, n = item.split("="); levels[g] = int(n)
    changed = []
    for name, mod in model.named_modules():
        if isinstance(mod, Quantize) and name.endswith("quantize_weight"):
            g = group_of(name)
            if g in levels:
                mod.quant = replace(mod.quant, buckets=levels[g])
                changed.append(name)
    missing = set(levels) - {group_of(n) for n in changed}
    assert not missing, f"A_BITS_MAP groups not found: {missing}"
    if changed:
        print(f"A_BITS_MAP: {len(changed)} weight quantizers changed: {spec}")
    from pysrc.act16 import apply_act16
    apply_act16(model)
    return changed
