"""Start checkpoints for the probes. usage: python make_start_pr.py IN.tch OUT.tch MODE
MODE: none (copy) | act16:G1,G2 (activation scales of those groups /256, as tier0/n4.py) |
up31 (all weight groups at 31 levels, q31 = 2*q4, via up/make_start_up.py)"""
import sys, subprocess, torch
sys.path.insert(0, "/workspace/agent/pr")
from act16 import agroup
src, dst, mode = sys.argv[1:4]
if mode == "up31":
    sys.exit(subprocess.call([sys.executable, "/workspace/agent/up/make_start_up.py", src, dst, "ALL=31"]))
sd = torch.load(src, map_location="cpu"); out = dict(sd)
if mode.startswith("act16:"):
    gs = set(mode[6:].split(",")); n = 0
    for k in sd:
        if k.endswith(".scale") and not k.endswith("quantize_weight.scale") and agroup(k[:-6]) in gs:
            out[k] = sd[k] / 256; n += 1
    print("act16 scales /256:", n)
else:
    assert mode == "none"
torch.save(out, dst); print("saved", dst)
