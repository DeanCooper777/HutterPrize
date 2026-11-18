#!/usr/bin/env python3
# np2_roundtrip.py: testing tool (not part of any submitted program).
#
# Container-level part of the weight identity round trip for the cmix-neif 2.0 transformer.
#
#   np2_roundtrip.py tov5 <shipped NP2> <out v5>
#       read the shipped NP2 container with the authors' reader (np2_container.read_container)
#       and write its tensors, unchanged and in the stored (permuted) order, as a plain v5
#       container (np2_container.encode_plain).  Then read the v5 back and check that every
#       tensor is bit-identical.  Also writes <out v5>.tensors.txt (name, dtype code, shape,
#       sha256 of each tensor) and prints the summary hash of all tensors.
#   np2_roundtrip.py cmp <container A> <container B>
#       compare two containers (v5, NP or NP2) tensor by tensor: first in the stored order,
#       then with every free neuron group put into a canonical order (sorted by the bytes of
#       its key rows), so that two containers that differ only in the order NP2 is free to
#       choose compare equal.  Prints the count of differing tensors and elements.
#
# Needs numpy only.  One core.  NEIF2 = path of the cmix-neif 2.0 tree (default: the dev tree).
import hashlib
import os
import sys

import numpy as np

NEIF2 = os.environ.get("NEIF2", "/mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev")
sys.path.insert(0, os.path.join(NEIF2, "training", "tf", "3_train", "export", "np2"))
import np2_container as npc  # noqa: E402
wc = npc.wc


def sha(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest()


def listing(es, path):
    with open(path, "w") as f:
        for e in es:
            f.write("%s\t%d\t%s\t%s\n" % (e.name, e.code, "x".join(map(str, e.a.shape)), sha(e.a.tobytes())))


def canon(es):
    """every free group sorted by the bytes of its key rows (the order NP2 does not fix)"""
    es = [npc.Ent(e.name, e.code, e.a) for e in es]
    gs = npc.np_groups(es, True, True)
    for g in gs:
        kr = npc.key_rows(es, g.key, g.r0, g.n)
        idx = sorted(range(g.n), key=lambda x: kr[x])
        npc.apply_perm(es, g, idx)
    return es, gs


def diff(a, b, label):
    na = {e.name: e for e in a}
    nb = {e.name: e for e in b}
    only_a = [n for n in na if n not in nb]
    only_b = [n for n in nb if n not in na]
    order_same = [e.name for e in a] == [e.name for e in b]
    nt = ne = 0
    lines = []
    for n, x in na.items():
        y = nb.get(n)
        if y is None:
            continue
        if x.code != y.code or x.a.shape != y.a.shape:
            nt += 1
            lines.append("  %s: dtype/shape %d %s vs %d %s" % (n, x.code, x.a.shape, y.code, y.a.shape))
            continue
        xb = x.a.reshape(-1).view(np.uint8 if x.a.dtype.itemsize == 1 else "u%d" % x.a.dtype.itemsize)
        yb = y.a.reshape(-1).view(xb.dtype)
        d = int((xb != yb).sum())
        if d:
            nt += 1
            ne += d
            rows = x.a.shape[0] if x.a.ndim > 1 else x.a.size
            dr = int((x.a.reshape(rows, -1).view(xb.dtype) != y.a.reshape(rows, -1).view(xb.dtype)).any(1).sum())
            lines.append("  %s: %d of %d elements differ (%d of %d rows)" % (n, d, xb.size, dr, rows))
    print("%s: %d tensors vs %d; only in A %d, only in B %d; same tensor order %s; differing tensors %d, "
          "differing elements %d" % (label, len(a), len(b), len(only_a), len(only_b), order_same, nt, ne))
    for s in lines[:60]:
        print(s)
    if len(lines) > 60:
        print("  ... %d more" % (len(lines) - 60))
    return nt + len(only_a) + len(only_b) + (0 if order_same else 1)


def main():
    av = sys.argv[1:]
    if len(av) == 3 and av[0] == "tov5":
        src, out = av[1], av[2]
        raw = open(src, "rb").read()
        print("in  %s: %d B, magic %r, sha256 %s" % (src, len(raw), raw[:8], sha(raw)))
        es = npc.read_container(src)
        print("read: %d tensors, tensors sha256 %s" % (len(es), npc.tensors_sha(es)))
        # which form of the bf16-rounded f32 tensors (k = ENC_F32HC) does not matter for the values; use k
        blob = npc.encode_plain(es, True)
        open(out, "wb").write(blob)
        print("out %s: %d B, sha256 %s" % (out, len(blob), sha(blob)))
        back = npc.read_container(out)
        same = len(back) == len(es) and all(b.same(e) for b, e in zip(back, es))
        print("v5 read back against the NP2 tensors: %s (%d tensors, tensors sha256 %s)"
              % ("BIT IDENTICAL" if same else "DIFFERENT", len(back), npc.tensors_sha(back)))
        listing(es, out + ".tensors.txt")
        sys.exit(0 if same else 1)
    if len(av) == 3 and av[0] == "cmp":
        a = npc.read_container(av[1])
        b = npc.read_container(av[2])
        print("A %s: tensors sha256 %s" % (av[1], npc.tensors_sha(a)))
        print("B %s: tensors sha256 %s" % (av[2], npc.tensors_sha(b)))
        r1 = diff(a, b, "stored order")
        ca, _ = canon(a)
        cb, gs = canon(b)
        print("canonical: %d groups; A %s, B %s" % (len(gs), npc.tensors_sha(ca), npc.tensors_sha(cb)))
        r2 = diff(ca, cb, "canonical group order")
        sys.exit(0 if r1 == 0 else (3 if r2 == 0 else 1))
    sys.exit(__doc__ or "usage: see the head comment")


if __name__ == "__main__":
    main()
