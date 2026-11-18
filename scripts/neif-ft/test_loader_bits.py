#!/usr/bin/env python3
# test_loader_bits.py: testing tool (not part of any submitted program).
# CPU test of the loader change of patch_ft_tree.py: builds a tiny synthetic training package
# in the format of cmix-neif 2.0 (dump v2 rows with inserted, prior0, masked and document-start
# rows; doc-rows, doc-last-ziel, priors, tokens) and a bit file whose rows encode their own
# position, then reads it through the patched PaketDumpDataLoader and checks for every scored
# row that the bit row is the one of the TARGET token (the row whose token equals
# output_tokens), next to the prior row of the position in front of it; that rows without a
# target carry NaN; and that FT_PERM_SEED moves the epoch permutation (0 = theirs).
#   TFT_TREE=<patched training tree copy> python test_loader_bits.py
import json
import os
import sys
import tempfile

import numpy as np

TFT = os.environ["TFT_TREE"]
sys.path.insert(0, TFT)
d = tempfile.mkdtemp()
os.environ.update(TFT_DATA_DIR=d, PK_DUMP_DIR=d, ZCTX_ARM="pkd", TFT_MMAP="1", TFT_MICRO_BATCH_TOKENS="64",
                  TFT_OPTIMIZER_BATCH_TOKENS="64", PK_LAST_X0ROW="0", TFT_GEOMETRY="poc8m_w2048",
                  FT_CMIX_BITS=os.path.join(d, "cmix-bits.float16"))
os.environ.pop("FT_PERM_SEED", None)

import torch  # noqa: E402
from zctx import dumpv2  # noqa: E402

rng = np.random.default_rng(3)
V, N = 208, 200
EIN, MASKE, ANFANG, PRIOR0 = dumpv2.EINGEFUEGT, dumpv2.MASKE, dumpv2.DOKANFANG, dumpv2.PRIOR0
tokens = rng.integers(0, V, N).astype(np.uint8)
doc_bounds = [0, 31, 77, 78 + 40, 160, N]        # five documents of package positions
rows, doc_rows, doc_ziel, want = [], [0], [], []   # want: per row (scored, target position)


def rec(src, tok, fl):
    rows.append((src, tok, int(rng.integers(0, V)), int(rng.integers(0, V)), 208, 0, fl, 0))


for di in range(len(doc_bounds) - 1):
    s, e = doc_bounds[di], doc_bounds[di + 1]
    first = len(rows)
    doc = []                                      # (row index, src, flags) of this document
    # a prompt block in front of the first stream row: prior0 rows, the last one predicts the stream
    for k in range(3 if di % 2 == 0 else 0):
        fl = EIN | (PRIOR0 if k < 2 else 0)
        doc.append((len(rows), -1, fl)); rec(-1, 208 + k, fl)
    for p in range(s, e - 1):                     # the last token of a document is never fed
        ins = (p - s) % 9 == 4 and p < e - 2      # two inserted rows behind this stream row
        fl = (PRIOR0 if ins else 0) | (MASKE if (p - s) % 7 == 3 else 0)
        doc.append((len(rows), p, fl)); rec(p, int(tokens[p]), fl)
        if ins:
            doc.append((len(rows), -1, EIN | PRIOR0)); rec(-1, int(rng.integers(0, V)), EIN | PRIOR0)
            doc.append((len(rows), -1, EIN)); rec(-1, int(rng.integers(0, V)), EIN)
    r0 = rows[first]
    rows[first] = r0[:6] + (r0[6] | ANFANG,) + r0[7:]
    dz = -1 if di == 3 else e - 1                 # one document without a closing token
    doc_ziel.append(dz)
    doc_rows.append(len(rows))
    # the target rule, written out independently of dumpv2: the next stream row of the document
    for j, (ri, src, fl) in enumerate(doc):
        nxt = next((s2 for (_, s2, _) in doc[j + 1:] if s2 >= 0), None)
        if j == len(doc) - 1:
            t = dz
        elif fl & PRIOR0 or nxt is None:
            t = -1
        else:
            t = nxt
        want.append((not (fl & MASKE) and t >= 0, t))

arr = np.array(rows, dtype=dumpv2.SATZ)
arr.tofile(os.path.join(d, "zeilen.dump"))
np.array(doc_rows, dtype=np.int64).tofile(os.path.join(d, "doc-rows.int64"))
np.array(doc_ziel, dtype=np.int32).tofile(os.path.join(d, "doc-last-ziel.int32"))
np.array(doc_bounds, dtype=np.int32).tofile(os.path.join(d, "article-boundaries.int32"))
tokens.tofile(os.path.join(d, "ppmd-bytes.uint8"))
pri = np.full((N, V), 1.0 / 1024, dtype=np.float16)
pri[:, 0] = np.arange(N) / 1024.0                 # the prior row encodes its own position
pri.tofile(os.path.join(d, "ppmd-probs.float16"))
np.full(V, 0.5, dtype=np.float16).tofile(os.path.join(d, "z3-prior0.float16"))
bits = (np.arange(N)[:, None] * 8 + np.arange(8)[None, :]).astype(np.float16)   # row p: 8p .. 8p+7
bits.tofile(os.environ["FT_CMIX_BITS"])
json.dump({"v": V, "x": 2, "nsent": 8, "x0row": False, "fenster": 2048, "redirmerge": True, "arme": []},
          open(os.path.join(d, "dump-meta.json"), "w"))

from tft import runner as tftrun  # noqa: E402

ok_all = True


def check(name, cond, info=""):
    global ok_all
    ok_all &= bool(cond)
    print("%-66s %s %s" % (name, "ok" if cond else "FAILED", info), flush=True)


data = tftrun.make_data_loader(2, torch.device("cpu"), 0, 1)
check("patched loader built, bits mapped", data._cmix_bits is not None and data._cmix_bits.shape == (N, 8))
n_scored = n_nan_ok = 0
seen = set()
for a in range(data.n_articles):
    mb = data._make_micro_batch([a])
    L = doc_rows[a + 1] - doc_rows[a]
    cb = mb.cmix_bit_logits[0, :L].numpy().astype(np.float64)
    out = mb.output_tokens[0, :L].numpy()
    lm = mb.loss_mask[0, :L].numpy()
    pr = mb.priors[0, :L, 0].numpy().astype(np.float64)
    for j in range(L):
        scored, t = want[doc_rows[a] + j]
        if lm[j] != scored:
            check("loss_mask of row %d" % (doc_rows[a] + j), False)
        if t < 0:
            n_nan_ok += int(np.isnan(cb[j]).all())
            continue
        okrow = (cb[j] == 8 * t + np.arange(8)).all()
        if scored:
            okrow &= int(tokens[int(cb[j, 0]) // 8]) == int(out[j]) and (round(pr[j] * 1024) == t - 1 if t > 0 else pr[j] == 0.5)   # position 0 has no row in front: prior0
            n_scored += 1
            seen.add(t)
        if not okrow:
            check("bit row of row %d (target %d)" % (doc_rows[a] + j, t), False, str(cb[j]))
    rest = mb.cmix_bit_logits[0, L:]
    if rest.numel() and not bool(torch.isnan(rest).all()):
        check("padding rows carry NaN", False)
n_want = sum(1 for s, _ in want if s)
check("every scored row: bit row = row of its target token, prior = row in front", n_scored == n_want and n_want > 100,
      "%d scored rows" % n_scored)
check("scored targets are distinct positions", len(seen) == n_scored)
check("rows without a stream target carry NaN", n_nan_ok == sum(1 for _, t in want if t < 0), "%d rows" % n_nan_ok)
check("the field is float16 [1, positions, 8]", mb.cmix_bit_logits.dtype == torch.float16 and mb.cmix_bit_logits.shape == (1, 64, 8))

p0 = [p.copy() for p in data._permutations]
ref = np.random.default_rng(seed=0)
check("FT_PERM_SEED unset: the permutations of the original loader", all((ref.permutation(data.n_articles) == p).all() for p in p0))
os.environ["FT_PERM_SEED"] = "5"
data5 = tftrun.make_data_loader(2, torch.device("cpu"), 0, 1)
ref5 = np.random.default_rng(seed=5)
check("FT_PERM_SEED=5: another, reproducible order", all((ref5.permutation(data5.n_articles) == p).all() for p in data5._permutations))
del os.environ["FT_CMIX_BITS"]
data_off = tftrun.make_data_loader(1, torch.device("cpu"), 0, 1)
mb = data_off._make_micro_batch([0])
check("without FT_CMIX_BITS the field is None, the other fields unchanged", mb.cmix_bit_logits is None
      and torch.equal(mb.output_tokens, data._make_micro_batch([0]).output_tokens))
print("ALL OK" if ok_all else "SOME TESTS FAILED")
sys.exit(0 if ok_all else 1)
