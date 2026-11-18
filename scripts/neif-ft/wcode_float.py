#!/usr/bin/env python3
# wcode_float.py: testing tool, not part of any submitted program.
#
# Bounds for the non-integer tensors of the cmix-neif 2.0 weight container (row scales in
# bf16, f32 tensors rounded to bf16):   wcode_float.py <shipped.raw> <breakdown.tsv>
# Every value is 16 bits: sign, 8 exponent bits, 7 mantissa bits.  Per tensor kind
# (blocks.<n> -> blocks.#) it prints what NP2 spends (from breakdown.tsv) next to static
# two-pass entropies (tables NOT counted, so they are optimistic):
#   Hse   entropy of (sign, exponent) with one distribution per kind
#   Hm    entropy of the 7 mantissa bits with one distribution per kind (7.0 = noise)
#   Hm|e  mantissa given the exponent
# and the count of distinct mantissas.  Also the correlation of log2(row scale) with
# log2(mean |q| of the row), which says whether one could predict the other.
# numpy only, one core, seconds.
import os
import re
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from wcode_stats import load  # noqa: E402


def H(x):
    _, c = np.unique(x, return_counts=True)
    p = c / c.sum()
    return float(-(p * np.log2(p)).sum())


def Hcond(x, y):
    """H(x | y) static"""
    tot = 0.0
    for v in np.unique(y):
        s = x[y == v]
        tot += H(s) * len(s)
    return tot / len(x)


def main():
    ts = load(sys.argv[1])
    spent = {}
    for ln in open(sys.argv[2]).read().split("\n")[1:]:
        f = ln.split("\t")
        if len(f) > 8:
            spent[f[0]] = (float(f[8]), f[4])
    byname = {n: a for n, c, a in ts}
    kinds = {}
    for name, code, a in ts:
        if code == 1:
            u = a.reshape(-1).astype(np.uint32)
        elif code == 2 and name not in ("rope.sin", "rope.cos") and not (a.view(np.uint32) & 0xFFFF).any():
            u = (a.view(np.uint32).reshape(-1) >> 16)
        else:
            continue
        kind = re.sub(r"^blocks\.\d+\.", "blocks.#.", name)
        k = kinds.setdefault(kind, [[], 0.0, 0, code])
        k[0].append(u)
        k[1] += spent[name][0]
        k[2] += 1
    print("%-58s %3s %6s %9s %7s %6s %6s %6s %5s %9s" % ("kind", "n", "values", "NP2 B", "bits/v", "Hse", "Hm", "Hm|e", "mant", "bound B"))
    tot = {1: [0, 0.0, 0.0], 2: [0, 0.0, 0.0]}
    for kind, (us, bits, cnt, code) in sorted(kinds.items(), key=lambda kv: -kv[1][1]):
        u = np.concatenate(us)
        se = u >> 7
        m = u & 127
        hse, hm = H(se), H(m)
        hme = Hcond(m, se)
        bound = (hse + min(hm, 7.0)) * len(u) / 8
        t = tot[code]
        t[0] += len(u)
        t[1] += bits / 8
        t[2] += bound
        if bits / 8 > 300:
            print("%-58s %3d %6d %9.1f %7.3f %6.3f %6.3f %6.3f %5d %9.1f" % (
                kind, cnt, len(u), bits / 8, bits / len(u), hse, hm, hme, len(np.unique(m)), bound))
    for code, nm in ((1, "all bf16 (row scales and activation scales)"), (2, "all f32 rounded to bf16")):
        t = tot[code]
        print("%-58s     %6d %9.1f %7.3f %33s %9.1f  (%+.0f B)" % (nm, t[0], t[1], 8 * t[1] / t[0], "", t[2], t[2] - t[1]))
    # row scale against the row's mean |q|
    xs, ys, zs = [], [], []
    for name, code, a in ts:
        if code == 1 and name.endswith(".weight.scale") and name[:-5] + "q" in byname:
            q = byname[name[:-5] + "q"].astype(np.float64)
            if q.ndim != 2 or q.shape[0] != a.size:
                continue
            s = (a.astype(np.uint32) << 16).view(np.float32).astype(np.float64)
            mq = np.abs(q).mean(1)
            ok = (mq > 0) & (s > 0)
            if ok.sum() < 8:
                continue
            ls, lm = np.log2(s[ok]), np.log2(mq[ok])
            xs.append(ls - ls.mean())
            ys.append(lm - lm.mean())
            zs.append(np.corrcoef(ls, lm)[0, 1])
    x, y = np.concatenate(xs), np.concatenate(ys)
    print("row scale against mean |q| of its row, both log2 and centred per tensor: %d rows, correlation %.3f; "
          "std of log2 scale %.3f, of log2 mean|q| %.3f; median per-tensor correlation %.3f"
          % (len(x), np.corrcoef(x, y)[0, 1], x.std(), y.std(), float(np.median(zs))))
    b = [v[0] / 8 for k, v in spent.items() if v[1] == "B"]
    print("stream B: %d tensors, %.0f B of values in all" % (len(b), sum(b)))


if __name__ == "__main__":
    main()
