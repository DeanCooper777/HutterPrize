# sw_cut.py: cut a slice of the training data (whole articles) into its own directory, in the
# layout the trainer's data loader reads.
#   python3 sw_cut.py NAME START_TOKEN N_TOKENS [DATA=/workspace/data] [OUT=/workspace/slices]
# Testing tool for rented cloud machines; not part of the submitted programs.
import sys, os, json, numpy as np
name, start, ntok = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])
D = sys.argv[4] if len(sys.argv) > 4 else "/workspace/data"
O = (sys.argv[5] if len(sys.argv) > 5 else "/workspace/slices") + "/" + name
os.makedirs(O, exist_ok=True)
tok = np.fromfile(D + "/ppmd-bytes.uint8", dtype=np.uint8); n = len(tok)
bnd = np.fromfile(D + "/article-boundaries.int32", dtype=np.int32).astype(np.int64)
i0 = int(np.searchsorted(bnd, start)); i1 = int(np.searchsorted(bnd, start + ntok))
a, b = int(bnd[i0]), int(bnd[i1]); m = b - a
tok[a:b].tofile(O + "/ppmd-bytes.uint8")
(bnd[i0:i1 + 1] - a).astype(np.int32).tofile(O + "/article-boundaries.int32")
def copy(fn, row):
    with open(D + "/" + fn, "rb") as f, open(O + "/" + fn, "wb") as g:
        f.seek(a * row); left = m * row
        while left:
            buf = f.read(min(left, 1 << 26)); assert buf; g.write(buf); left -= len(buf)
copy("cmix-bits.float16", 16)
copy("ppmd-probs.float16", 410)
json.dump({"name": name, "first_token": a, "end_token": b, "tokens": m, "articles": i1 - i0}, open(O + "/info.json", "w"))
print(name, "tokens", m, "articles", i1 - i0, "from", a, "to", b)
