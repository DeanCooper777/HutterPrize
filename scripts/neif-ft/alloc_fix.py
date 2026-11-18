#!/usr/bin/env python3
# alloc_fix.py: testing tool (not part of any submitted program).
#
#   alloc_fix.py <alloc.npz from container_to_tch.py --qrow> <out.npz> [expected number of rows]
#
# container_to_tch.py --qrow rebuilds the per-row weight ranges (qmax 1, 3 or 7) of the
# cmix-neif 2.0 transformer from the largest integer of each row of the shipped container.
# The authors' allocation has no 3-bit rows (chain/results/fisher_alloc_summary.json), so a
# row labelled qmax 3 is a 4-bit row whose integers happen to stay within +-3.  This tool sets
# those rows back to qmax 7 (the forward pass is unchanged: the same integers, a wider clamp)
# and prints what it changed.  Rows labelled qmax 1 are left as they are.
import sys

import numpy as np

src, dst = sys.argv[1], sys.argv[2]
expect = int(sys.argv[3]) if len(sys.argv) > 3 else None
z = np.load(src)
out, n, count = {}, 0, {}
for k in z.files:
    a = z[k].copy()
    idx = np.flatnonzero(a == 3)
    if len(idx):
        print("%s: rows %s qmax 3 -> 7" % (k, idx.tolist()))
        a[idx] = 7
        n += len(idx)
    for v, c in zip(*np.unique(a, return_counts=True)):
        count[int(v)] = count.get(int(v), 0) + int(c)
    out[k] = a
assert expect is None or n == expect, "%d rows changed, expected %d" % (n, expect)
np.savez(dst, **out)
print("%d rows changed; %d modules, rows per qmax %s -> %s" % (n, len(out), count, dst))
