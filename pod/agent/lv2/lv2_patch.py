"""Lever 2 patch of RUN_DIR (after pr/patch_src.py): (1) cooldown_A.py base rate from env COOLDOWN_LR (default 1e-7, as
before); (2) train.py saves snapshots {prefix}.snap{N}.tch when env A_SNAP_FROM (fraction of the run, e.g. 0.9167) is set:
every A_SNAP_EVERY steps once fraction_done >= A_SNAP_FROM, and on the last step. Failures to save are logged, not fatal."""
import sys
D = sys.argv[1]
p = f"{D}/training_recipes/cooldown_A.py"; s = open(p).read()
old = "    learning_rate: float = 1e-7\n"; assert s.count(old) == 1
s = s.replace(old, '    learning_rate: float = float(os.environ.get("COOLDOWN_LR", "1e-7"))\n    print("COOLDOWN_LR", learning_rate, flush=True)\n')
open(p, "w").write(s)
p = f"{D}/pysrc/train.py"; s = open(p).read()
old = "        optimizers.step()\n"; assert s.count(old) == 1
s = s.replace(old, old + """        _snap[0] += 1
        if _SNAP_FROM > 0 and (not dist.is_initialized() or dist.get_rank() == 0):
            _fd = float(batch.epoch) / max(1e-9, float(_SNAP_EPOCHS))
            if (_fd >= _SNAP_FROM and _snap[0] % _SNAP_EVERY == 0) or batch.is_last:
                try:
                    torch.save(raw_model.state_dict(), f"{os.environ.get('CHECKPOINT_PREFIX', 'models/x')}.snap{_snap[0]}.tch")
                    print(f"SNAP step {_snap[0]} epoch {float(batch.epoch):.4f}", flush=True)
                except Exception as _e:
                    print("SNAP save failed", _e, flush=True)
""")
s = s.replace("def train(\n", '''_SNAP_FROM = float(os.environ.get("A_SNAP_FROM", "0"))
_SNAP_EVERY = int(os.environ.get("A_SNAP_EVERY", "38"))
_SNAP_EPOCHS = float(os.environ.get("COOLDOWN_EPOCHS", "1"))
_snap = [0]


def train(\n''', 1)
open(p, "w").write(s); print("lv2-patched", D)
