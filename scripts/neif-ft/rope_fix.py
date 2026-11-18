#!/usr/bin/env python3
# rope_fix.py: testing tool (not part of any submitted program).
#
#   rope_fix.py <reference weight file FX2TFW01 from export_v3_ar.py on CPU> <out> [<v5 container to compare with>]
#
# The authors' export computes the RoPE tables rope.sin / rope.cos on a CUDA card; their container writer
# stores no table when it equals its own bit-exact emulation of the CUDA sine/cosine
# (weights_compress_v3.cuda_rope_table) and stores 2 x 8.4 M floats otherwise.  An export on a CPU gives
# tables that differ in the last bit in places, so the container grows from 3.7 MB to 30 MB and the engine
# would get other tables.  This tool replaces the two tables of a CPU export by the authors' emulation,
# computed from the file's own rope.inv_freq, and reports how many elements changed.  Nothing else is touched.
# With a third argument rope.inv_freq (an architecture constant; one element comes out with another last
# bit on a CPU) is taken from that container (the shipped tensors) before the tables are computed.
import os
import struct
import sys

import numpy as np

NEIF2 = os.environ.get("NEIF2", "/mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev")
sys.path.insert(0, os.path.join(NEIF2, "training", "tf", "3_train", "export", "np2"))
import np2_container as npc  # noqa: E402  (brings weights_compress_v3 as npc.wc, numpy only)
wc = npc.wc

DT = {0: np.int8, 1: np.uint16, 2: np.float32, 3: np.int32}


def read_raw(path):
    out = []
    with open(path, "rb") as f:
        assert f.read(8) == b"FX2TFW01"
        (n,) = struct.unpack("<I", f.read(4))
        for _ in range(n):
            (ln,) = struct.unpack("<I", f.read(4))
            name = f.read(ln).decode()
            (code,) = struct.unpack("<B", f.read(1))
            (nd,) = struct.unpack("<I", f.read(4))
            shape = struct.unpack("<%dI" % nd, f.read(4 * nd))
            dt = np.dtype(DT[code])
            a = np.frombuffer(f.read(int(np.prod(shape)) * dt.itemsize), dtype=dt).reshape(shape).copy()
            out.append(npc.Ent(name, code, a))
        assert f.read(1) == b""
    return out


def main():
    src, dst = sys.argv[1], sys.argv[2]
    es = read_raw(src)
    by = {e.name: e for e in es}
    inv = by["rope.inv_freq"].a
    if len(sys.argv) > 3:
        # rope.inv_freq = 1 / 10000^linspace(0, 1, 32) is a constant of the architecture, not a trained
        # weight; the CPU power function gives one element another last bit than the CUDA one, so the
        # constant is taken from the reference container (the shipped tensors)
        ref = {e.name: e for e in npc.read_container(sys.argv[3])}
        rinv = ref["rope.inv_freq"].a
        assert rinv.shape == inv.shape and rinv.dtype == inv.dtype
        bad = np.flatnonzero(rinv.view(np.uint32) != inv.view(np.uint32))
        print("rope.inv_freq: %d of %d elements differ from %s (index %s: CPU %s, reference %s); reference taken"
              % (bad.size, inv.size, sys.argv[3], bad.tolist(), [float.hex(float(x)) for x in inv[bad]],
                 [float.hex(float(x)) for x in rinv[bad]]))
        by["rope.inv_freq"].a = rinv.copy()
        inv = by["rope.inv_freq"].a
    for name, cos in (("rope.sin", False), ("rope.cos", True)):
        e = by[name]
        t = wc.cuda_rope_table(inv, e.a.shape[0], cos=cos)
        assert t.shape == e.a.shape and t.dtype == e.a.dtype, name
        d = int((t.view(np.uint32) != e.a.view(np.uint32)).sum())
        mx = float(np.abs(t.astype(np.float64) - e.a.astype(np.float64)).max())
        print("%s: %d of %d elements replaced (CPU table vs the CUDA emulation), max |difference| %.3g"
              % (name, d, e.a.size, mx))
        e.a = t.copy()
    npc.write_raw(es, dst)
    print("wrote %s, %d B" % (dst, os.path.getsize(dst)))


if __name__ == "__main__":
    main()
