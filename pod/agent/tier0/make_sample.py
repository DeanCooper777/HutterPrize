"""Extract S evenly spaced slices (~L tokens each, aligned to article boundaries)
of the full training data into a mini dataset in the same file formats.
usage: python make_sample.py OUTDIR S L"""
import sys, os, json, numpy as np
D = "/workspace/data"
out, S, L = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
os.makedirs(out, exist_ok=True)
tok = np.memmap(f"{D}/ppmd-bytes.uint8", dtype=np.uint8, mode="r")
N = len(tok)
pri = np.memmap(f"{D}/ppmd-probs.float16", dtype=np.float16, mode="r", shape=(N, 205))
cb = np.memmap(f"{D}/cmix-bits.float16", dtype=np.float16, mode="r", shape=(N, 8))
bnd = np.fromfile(f"{D}/article-boundaries.int32", dtype=np.int32).astype(np.int64)
assert bnd[0] == 0 and bnd[-1] == N
# split long articles into 2**17-token pieces like the training loader does
M = 1 << 17
pieces = [bnd[:1]]
for a, b in zip(bnd[:-1], bnd[1:]):
    pieces.append(np.arange(a + M, b, M, dtype=np.int64)); pieces.append(np.array([b]))
bnd = np.concatenate(pieces)
slices = []
for s in range(S):
    target = (2 * s + 1) * N // (2 * S)            # slice centre
    i = np.searchsorted(bnd, target - L // 2)        # first article start >= ...
    j = np.searchsorted(bnd, bnd[i] + L)             # end at an article boundary
    j = min(max(j, i + 1), len(bnd) - 1)
    slices.append((int(bnd[i]), int(bnd[j]), int(i), int(j)))
ft = open(f"{out}/ppmd-bytes.uint8", "wb"); fp = open(f"{out}/ppmd-probs.float16", "wb")
fc = open(f"{out}/cmix-bits.float16", "wb")
nb = [0]; pos = 0
for k, (a, b, i, j) in enumerate(slices):
    ft.write(np.asarray(tok[a:b]).tobytes())
    for c in range(a, b, 1 << 18):
        fp.write(np.asarray(pri[c:min(b, c + (1 << 18))]).tobytes())
    fc.write(np.asarray(cb[a:b]).tobytes())
    nb.extend((bnd[i + 1:j + 1] - a + pos).tolist()); pos += b - a
    print(k, a, b, b - a, flush=True)
for f in (ft, fp, fc): f.close()
np.array(nb, dtype=np.int32).tofile(f"{out}/article-boundaries.int32")
json.dump({"slices": slices, "n_tokens": pos, "N": int(N)}, open(f"{out}/slices.json", "w"))
print("done", pos)
