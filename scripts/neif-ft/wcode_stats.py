#!/usr/bin/env python3
# wcode_stats.py: testing tool, not part of any submitted program.
#
# Static statistics of the int4 weight tensors of the cmix-neif 2.0 container, from
# runs/neif-ft/wcode/shipped.raw (written by wcode_breakdown.py):
#   wcode_stats.py <shipped.raw> [alloc.npz]
# Per tensor kind (blocks.<n> -> blocks.#): the static (two-pass, table not counted)
# entropies  H0 = one distribution per tensor,  Hrow = one distribution per row,
# Hcol = one per column, and Miller-Madow corrected versions (Hrow and Hcol are biased low
# by about (k-1)/(2 n ln 2) bit per value, k = symbols seen, n = values in the row).
# These bound what a model of "the row/column has its own distribution" can reach; they
# are not code lengths of a decodable coder.  Also the histogram of max |q| per row.
# numpy only, one core, seconds.
import os
import re
import struct
import sys

import numpy as np

if os.name == "nt":
    import ctypes
    ctypes.windll.kernel32.SetPriorityClass(ctypes.windll.kernel32.GetCurrentProcess(), 0x40)


def load(path):
    d = open(path, "rb").read()
    assert d[:8] == b"FX2TFW01"
    n = struct.unpack_from("<I", d, 8)[0]
    p = 12
    out = []
    dts = {0: np.int8, 1: np.uint16, 2: np.float32, 3: np.int32}
    for _ in range(n):
        nl = struct.unpack_from("<I", d, p)[0]
        p += 4
        name = d[p:p + nl].decode()
        p += nl
        code = d[p]
        p += 1
        nd = struct.unpack_from("<I", d, p)[0]
        p += 4
        shape = struct.unpack_from("<%dI" % nd, d, p)
        p += 4 * nd
        cnt = int(np.prod(shape)) if nd else 1
        a = np.frombuffer(d, dtype=dts[code], count=cnt, offset=p).reshape(shape)
        p += a.nbytes
        out.append((name, code, a))
    return out


def ent_rows(m):
    """sum over rows of n * H(row) in bits, and the Miller-Madow correction in bits"""
    R, C = m.shape
    h = np.zeros((R, 15))
    for v in range(15):
        h[:, v] = (m == v - 7).sum(1)
    p = h / C
    with np.errstate(divide="ignore", invalid="ignore"):
        e = -(np.where(h > 0, p * np.log2(p), 0)).sum(1) * C
    k = (h > 0).sum(1)
    mm = (k - 1) / (2 * np.log(2))
    nz = h[:, 7] < C
    return e[nz].sum(), mm[nz].sum()


def main():
    ts = load(sys.argv[1])
    agg = {}
    mx = {}
    for name, code, a in ts:
        if code != 0 or a.ndim != 2:
            continue
        m = a.astype(np.int32)
        if np.abs(m).max() > 7:
            continue
        kind = re.sub(r"^blocks\.\d+\.", "blocks.#.", name) + " %dx%d" % a.shape
        nzr = np.abs(m).sum(1) > 0
        mm = m[nzr]
        h0, _ = ent_rows(mm.reshape(1, -1))
        hr, cr = ent_rows(mm)
        hc, cc = ent_rows(mm.T.copy())
        t = agg.setdefault(kind, np.zeros(7))
        t += [mm.size, h0, hr, cr, hc, cc, 1]
        rm = np.abs(mm).max(1)
        x = mx.setdefault(kind, np.zeros(8, dtype=np.int64))
        x += np.bincount(rm, minlength=8)
    print("%-62s %3s %9s %8s %8s %8s %8s %8s   bytes: H0, Hrow+MM, Hcol+MM" % ("kind", "n", "weights", "H0", "Hrow", "Hrow+MM", "Hcol", "Hcol+MM"))
    tot = np.zeros(7)
    for k, t in sorted(agg.items()):
        tot += t
        print("%-62s %3d %9d %8.4f %8.4f %8.4f %8.4f %8.4f   %9.0f %9.0f %9.0f" % (
            k, t[6], t[0], t[1] / t[0], t[2] / t[0], (t[2] + t[3]) / t[0], t[4] / t[0], (t[4] + t[5]) / t[0],
            t[1] / 8, (t[2] + t[3]) / 8, (t[4] + t[5]) / 8))
    t = tot
    print("%-62s %3d %9d %8.4f %8.4f %8.4f %8.4f %8.4f   %9.0f %9.0f %9.0f" % (
        "TOTAL", t[6], t[0], t[1] / t[0], t[2] / t[0], (t[2] + t[3]) / t[0], t[4] / t[0], (t[4] + t[5]) / t[0],
        t[1] / 8, (t[2] + t[3]) / 8, (t[4] + t[5]) / 8))
    print("\nrows by max |q| (0 = zero rows are left out):")
    for k, x in sorted(mx.items()):
        print("%-62s %s" % (k, " ".join("%d:%d" % (i, c) for i, c in enumerate(x) if c)))
    if len(sys.argv) > 2:
        z = np.load(sys.argv[2])
        print("\n%s: %d arrays" % (sys.argv[2], len(z.files)))
        for f in z.files[:12]:
            a = z[f]
            print("  %s %s %s %s" % (f, a.dtype, a.shape, np.unique(a)[:12] if a.size else ""))


if __name__ == "__main__":
    main()
