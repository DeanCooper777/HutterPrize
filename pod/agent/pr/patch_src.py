"""Patch a copy of /workspace/mp's pysrc in RUN_DIR: act16 hook in bits_map, entropy penalty in train."""
import sys, shutil
D = sys.argv[1]
shutil.copy("/workspace/agent/pr/act16.py", f"{D}/pysrc/act16.py")
shutil.copy("/workspace/agent/pr/entpen.py", f"{D}/pysrc/entpen.py")
p = f"{D}/pysrc/bits_map.py"; s = open(p).read()
old = "    return changed\n"; assert s.count(old) == 1
s = s.replace(old, "    from pysrc.act16 import apply_act16\n    apply_act16(model)\n" + old); open(p, "w").write(s)
p = f"{D}/pysrc/train.py"; s = open(p).read()
old = "            loss = loss / data.gradient_accumulation_steps\n"; assert s.count(old) == 1
new = """            if _ENT_LAM > 0 and mixture is not None:
                _pen = penalty_per_token(raw_model, _ENT_LAM)
                loss = loss + (1 - mixture.cfg.cross_entropy_weight) * micro_batch.loss_mask.sum() * _pen
"""
s = s.replace(old, new + old)
old = "        optimizers.step()\n"; assert s.count(old) == 1
new = """        _ent_step[0] += 1
        if _ENT_LAM > 0 and (_ent_step[0] % 50 == 1 or batch.is_last):
            with torch.no_grad():
                _pp = weight_pairs(raw_model)
                print(f"ENT step {_ent_step[0]} soft {float(coded_nats(_pp)) / 8 / math.log(2):,.0f} B hard {float(coded_nats(_pp, hard=True)) / 8 / math.log(2):,.0f} B (per copy, KT)", flush=True)
"""
s = s.replace(old, new + old)
s = s.replace("def train(\n", """import math as math
from pysrc.entpen import penalty_per_token, weight_pairs, coded_nats
_ENT_LAM = float(os.environ.get("A_ENT_LAMBDA", "0"))
_ent_step = [0]
if _ENT_LAM > 0: print(f"A_ENT_LAMBDA {_ENT_LAM}: entropy penalty on", flush=True)


def train(\n""", 1)
old = "        mixture = CmixMixtureLoss(cfg.mixture_loss).to(data.device)\n"; assert s.count(old) == 1
s = s.replace(old, old + """        if os.environ.get("A_MIXER_INIT"):
            mixture.load_state_dict(torch.load(os.environ["A_MIXER_INIT"], map_location=data.device))
            print("A_MIXER_INIT: loaded", os.environ["A_MIXER_INIT"], flush=True)
""")
old = '            torch.save(raw_model.state_dict(), f"{checkpoint_prefix}.epoch.tch")\n'; assert s.count(old) == 1
s = s.replace(old, old + """            if os.environ.get("A_KEEP_EPOCHS"):
                torch.save(raw_model.state_dict(), f"{checkpoint_prefix}.e{int(batch.epoch)}.tch")
""")
open(p, "w").write(s); print("patched", D)
