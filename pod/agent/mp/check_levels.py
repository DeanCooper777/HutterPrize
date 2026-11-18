"""check an exported .tfw: groups in the map use only ints within +-(levels-1)/2, others reach beyond"""
import sys, numpy as np
sys.path.insert(0, "/workspace/agent/tier0")
from pysrc.export_weights import read_tensor_file
from pysrc.bits_map import group_of
t = read_tensor_file(sys.argv[1])
lv = {g: int(n) for g, n in (x.split("=") for x in sys.argv[2].split(",") if x)}
bad = 0; seen = set()
for name, (dt, a) in t.items():
    if a.dtype != np.int8: continue
    g = group_of(name); m = int(np.abs(a).max())
    if g in lv:
        seen.add(g)
        if m > (lv[g] - 1) // 2: print("BAD", name, m); bad += 1
assert seen == set(lv), f"groups missing in export: {set(lv) - seen}"
print("check_levels ok" if not bad else f"check_levels FAILED {bad}"); sys.exit(1 if bad else 0)
