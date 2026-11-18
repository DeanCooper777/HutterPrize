#!/usr/bin/env python3
"""regions.py: sums per-byte code lengths (float32 files written by pkx PK_COST / neif_cost) over the
regions of an image and prints one table for several models side by side.
Testing tool for the packer trial; not part of any submitted program.

    python3 regions.py neif IMAGE WEIGHTS_H LABEL=COSTFILE ...
    python3 regions.py ours IMAGE LABEL=COSTFILE ...
neif: regions of the stripped cmix-neif 2.0 image (program headers; the BITLSTM blob is found by
searching for the bytes of kBlobW from src/bit_head_weights.h).  ours: regions of our official image.
"""
import re, struct, sys
kind, img = sys.argv[1], open(sys.argv[2], "rb").read()
args = sys.argv[3:]
if kind == "neif":
    h = open(args[0]).read(); args = args[1:]
    body = h[h.index("kBlobW["):]; body = body[body.index("{") + 1:body.index("};")]
    blob = bytes(int(x, 16) for x in re.findall(r"0x[0-9a-fA-F]+", body))
    at = img.find(blob); assert at >= 0 and len(blob) == 49158, "BITLSTM blob not found"
    half = len(blob) // 2
    R = [("headers + dynamic tables + .rodata before the blob", 0, at),
         ("BITLSTM blob: exponent bytes", at, at + half),
         ("BITLSTM blob: sign/mantissa bytes", at + half, at + len(blob)),
         (".rodata etc. after the blob", at + len(blob), 0x139f0),
         ("code, decompressor part", 0x139f0, 0x83220),
         ("writable data segment", 0x83220, 0x83900),
         ("code, compress-only (last 81,038 B)", 0x83900, len(img))]
else:
    R = [("headers + dynamic tables", 0, 0x2c10), (".init/.plt", 0x2c10, 0x33d0),
         (".text before the hole", 0x33d0, 301382), ("hole (compress-only code)", 301382, 316959),
         (".text tail + .fini", 316959, 0x4d640), (".rodata", 0x4d640, 0x52c20),
         ("eh_frame, notes, padding", 0x52c20, 0x53000), ("data segment", 0x53000, 0x53b74),
         ("after the segments (section table, strings)", 0x53b74, len(img))]
cols = []
for a in args:
    lab, fn = a.split("=", 1); d = open(fn, "rb").read(); n = len(d) // 4
    assert n == len(img), "%s: %d costs for %d bytes" % (fn, n, len(img))
    cols.append((lab, struct.unpack("<%df" % n, d)))
print("%-52s %9s" % ("region", "raw B") + "".join(" %12s" % l for l, _ in cols))
tot = [0.0] * len(cols)
for name, lo, hi in R:
    if hi <= lo: continue
    s = [sum(c[lo:hi]) / 8 for _, c in cols]
    tot = [t + x for t, x in zip(tot, s)]
    print("%-52s %9d" % (name, hi - lo) + "".join(" %12.0f" % x for x in s))
print("%-52s %9d" % ("total", len(img)) + "".join(" %12.0f" % x for x in tot))
