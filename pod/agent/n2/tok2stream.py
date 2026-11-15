"""tokens from `-e --bytes-only --save-ppmd-bytes` (no --official-vocab: index = official index + 1)
-> stream bytes. usage: tok2stream.py TOKENS OUT [CHECK_AGAINST]"""
import sys, numpy as np
sys.path.insert(0, "/workspace/opt")
from pysrc.cmix_loss import VOCAB_BYTES
V = np.zeros(256, np.uint8); V[1:206] = VOCAB_BYTES  # index 0 = byte 0x00 (counted, should not occur)
t = np.memmap(sys.argv[1], np.uint8, mode="r"); C = 1 << 24; zeros = 0; big = 0
with open(sys.argv[2], "wb") as f:
    for i in range(0, t.size, C):
        x = np.array(t[i:i+C]); zeros += int((x == 0).sum()); big += int((x > 205).sum()); f.write(V[x].tobytes())
print("tokens", t.size, "index0", zeros, "index>205", big)
if len(sys.argv) > 3:
    a = np.memmap(sys.argv[2], np.uint8, mode="r"); b = np.memmap(sys.argv[3], np.uint8, mode="r")
    n = min(a.size, b.size); diff = 0; first = None
    for i in range(0, n, C):
        j = min(i + C, n); d = np.nonzero(a[i:j] != b[i:j])[0]
        if d.size:
            diff += d.size; first = i + d[0] if first is None else first
    print("compare: sizes", a.size, b.size, "diffs in common prefix", diff, "first", first)
