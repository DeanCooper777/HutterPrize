# sw_regions.py: cost profile of the training stream along its length, to choose contrasting
# slices for the model-size sweep. Per window of WIN tokens: cmix's own cost without the
# transformer (from cmix-bits.float16), the PPMd prior's cost, and the share of dictionary codes.
#   python3 sw_regions.py [DATA=/workspace/data] [WIN=4000000]
# Testing tool for rented cloud machines; not part of the submitted programs.
import sys, numpy as np
D = sys.argv[1] if len(sys.argv) > 1 else "/workspace/data"
WIN = int(sys.argv[2]) if len(sys.argv) > 2 else 4_000_000
MASK = bytes([0xE8, 0x16, 0x04, 0x00, 0xFF, 0xFF, 0xFF, 0x03, 0x01, 0xFC, 0x0F, 0xF9, 0xFE, 0xFF, 0xFF, 0x07] + [0xFF] * 16)
VOCAB = np.array([i for i in range(256) if (MASK[i // 8] >> (i % 8)) & 1], dtype=np.int64)
tok = np.fromfile(D + "/ppmd-bytes.uint8", dtype=np.uint8); n = len(tok)
bits = np.memmap(D + "/cmix-bits.float16", dtype=np.float16, mode="r", shape=(n, 8))
V = 205
pri = np.memmap(D + "/ppmd-probs.float16", dtype=np.float16, mode="r", shape=(n, V))
bnd = np.fromfile(D + "/article-boundaries.int32", dtype=np.int32)
print("tokens", n, "articles", len(bnd) - 1, flush=True)
print("start_M  cmix_bpc  ppmd_bpc  code_end%  prefix%  articles")
j = np.arange(8)
for s in range(0, n - WIN + 1, WIN):
    t = tok[s:s + WIN].astype(np.int64); b = VOCAB[t]
    y = ((b[:, None] >> (7 - j)[None, :]) & 1).astype(np.float32)
    z = np.clip(np.asarray(bits[s:s + WIN], dtype=np.float32), -12, 12)
    cm = np.logaddexp(0, -(2 * y - 1) * z).sum() / np.log(2) / WIN
    # prior row i is the distribution of token i + 1; sample every 16th to keep reads small
    idx = np.arange(s, min(s + WIN, n - 1), 16)
    p = np.asarray(pri[idx, tok[idx + 1].astype(np.int64)], dtype=np.float32)
    pp = -np.log2(np.maximum(p, 1e-6)).mean()
    na = int(np.searchsorted(bnd, s + WIN) - np.searchsorted(bnd, s))
    print("%7.0f  %8.4f  %8.4f  %8.2f  %7.2f  %8d" % (s / 1e6, cm, pp, 100 * ((b >= 0x80) & (b < 0xD0)).mean(), 100 * (b >= 0xD0).mean(), na), flush=True)
