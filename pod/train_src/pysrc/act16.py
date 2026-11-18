"""P1 (2026-11-12): A_ACT16="mlp_down_in,attn_out_in" gives those activation quantizers 65,536
levels (the checkpoint's scales must already be /256, see make_start_pr.py). Same group names
as tier0/n4.py. Called from bits_map.apply_bits_map, so training, cooldown and Tier 0 all apply it."""
import os, re
from dataclasses import replace

def agroup(name):
    if name.endswith("quantize_weight"): return None
    for pat, g in [(r"mlp\.down\.", "mlp_down_in"), (r"mlp\.up\.", "mlp_up_in"),
                   (r"(query|key|value)_projection\.", "qkv_proj_in"), (r"output_projection\.", "attn_out_in"),
                   (r"gate_projection\.", "gates_in"), (r"quantize_(queries|keys|values)$", "qkv_quant"),
                   (r"^unembedding\.", "unemb_in"), (r"^prior_embedding\.", "prior_in")]:
        if re.search(pat, name): return g
    return "other"

def apply_act16(model, spec=None):
    from pysrc.quantization import Quantize
    spec = os.environ.get("A_ACT16", "") if spec is None else spec
    gs = {g for g in spec.split(",") if g}
    if not gs: return []
    ch = [n for n, m in model.named_modules() if isinstance(m, Quantize) and agroup(n) in gs]
    for n, m in model.named_modules():
        if n in ch:
            m.quant = replace(m.quant, buckets=65536)
            # A_ACT16_FREEZE=1: keep those scales fixed (P1 run 1: AdamW's absolute-size steps
            # on scales 256x smaller made them drift up to 8x and flip sign)
            if os.environ.get("A_ACT16_FREEZE") == "1":
                for p in m.parameters(recurse=False): p.requires_grad_(False)
    assert gs <= {agroup(n) for n in ch}, f"A_ACT16 groups not found: {gs}"
    print(f"A_ACT16: {len(ch)} activation quantizers -> 65536 levels: {sorted(gs)}", flush=True)
    return ch
