"""Patch RUN_DIR/pysrc/train.py (after pr/patch_src.py): per-entry learning-rate boost for the
grown MLP entries. Env A_GROW_OLD (old width, e.g. 768) and A_GROW_LR_MULT (e.g. 10). After each
optimizer step, the update of new entries (up rows >= OLD, their up scales, down columns >= OLD)
is multiplied by MULT (p += (MULT-1) * (p - p_before)): works for Muon and AdamW alike.
Also logs "GROW step" stats of the new entries every 50 steps and at the end."""
import sys
D = sys.argv[1]; p = f"{D}/pysrc/train.py"; s = open(p).read()
old = "        optimizers.step()\n"; assert s.count(old) == 1
s = s.replace(old, """        _gp = _grow_params(raw_model)
        _gb = [t.detach().clone() for t, _ in _gp]
""" + old + """        with torch.no_grad():
            for (t, sl), b in zip(_gp, _gb):
                t[sl] += (_GROW_MULT - 1) * (t[sl] - b[sl])
        _grow_step[0] += 1
        if _GROW_OLD and (_grow_step[0] % 50 == 1 or batch.is_last):
            _grow_log(raw_model, _grow_step[0])
""")
s = s.replace("def train(\n", '''_GROW_OLD = int(os.environ.get("A_GROW_OLD", "0"))
_GROW_MULT = float(os.environ.get("A_GROW_LR_MULT", "1"))
_grow_step = [0]
_grow_cache = []
print(f"A_GROW_OLD {_GROW_OLD} A_GROW_LR_MULT {_GROW_MULT}", flush=True)


def _grow_params(m):
    if not _GROW_OLD or _GROW_MULT == 1:
        return []
    if not _grow_cache:
        P = dict(m.named_parameters())
        for k, t in P.items():
            if k.endswith("mlp.up.weight") or k.endswith("mlp.up.quantize_weight.scale"):
                _grow_cache.append((t, (slice(_GROW_OLD, None),)))
            elif k.endswith("mlp.down.weight"):
                _grow_cache.append((t, (slice(None), slice(_GROW_OLD, None))))
        assert len(_grow_cache) == 36, len(_grow_cache)
        print("GROW boosting", len(_grow_cache), "tensors", flush=True)
    return _grow_cache


def _grow_log(m, step):
    with torch.no_grad():
        P = dict(m.named_parameters()); nz = tot = 0; rn = ro = 0.0
        for k, t in P.items():
            if k.endswith("mlp.down.weight"):
                s = P[k.replace(".weight", ".quantize_weight.scale")].float()
                q = (t.float() / s[:, None]).round().clamp(-7, 7)
                qn = q[:, _GROW_OLD:]; nz += int((qn != 0).sum()); tot += qn.numel()
                rn += float(t[:, _GROW_OLD:].float().abs().mean()); ro += float(t[:, :_GROW_OLD].float().abs().mean())
        print(f"GROW step {step} new-down nonzero ints {nz}/{tot} ({nz / max(tot, 1):.1%}) mean|w| new {rn / 12:.3g} old {ro / 12:.3g}", flush=True)


def train(\n''', 1)
open(p, "w").write(s); print("grow-patched", D)
