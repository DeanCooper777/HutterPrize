# sw_fit.py: two-term reading of the byte-step prose runs.
#   saved(P, data) = a(P) * C + m(P)      C = cost of the data with cmix alone (bytes)
# a(P): share saved that scales with the data (what the model learned about the text in general)
# m(P): bytes saved that do not scale (memorised content of the slice)
# Solved per size from the 16 MB and 64 MB runs; then the size where one more parameter stops
# paying is estimated for a larger C.   python sw_fit.py DIR [BITS_PER_PARAM=3.5] [C_FULL_MB=126]
# Testing tool; not part of the submitted programs.
import json, glob, sys, math
d = sys.argv[1]; bpp = float(sys.argv[2]) if len(sys.argv) > 2 else 3.5
cfull = float(sys.argv[3]) * 1e6 if len(sys.argv) > 3 else 126e6
R = {r["name"]: r for r in (json.load(open(f)) for f in glob.glob(d + "/*.json"))}
sv = lambda r: (r["cmix_bits"] - r["mix_bits"]) / 8
C16 = R["a16_s2"]["cmix_bits"] / 8; C64 = R["a64_s2"]["cmix_bits"] / 8
print("C16 %.0f  C64 %.0f" % (C16, C64))
pts = []
for s in ("s2", "s3", "s4"):
    p = R["a16_" + s]["params"]; s16 = sv(R["a16_" + s]); s64 = sv(R["a64_" + s])
    a = (s64 - s16) / (C64 - C16); m = s16 - a * C16
    pts.append((p, a, m))
    print("P %8d  saved16 %8.0f  saved64 %8.0f  a %.4f  m %8.0f B (%.2f bits/param)" % (p, s16, s64, a, m, 8 * m / p))
cost = 2 * bpp / 8
for (p0, a0, m0), (p1, a1, m1) in zip(pts, pts[1:]):
    da = (a1 - a0) / math.log(p1 / p0); dm = (m1 - m0) / (p1 - p0)
    print("between %d and %d: a rises %.4f per e-fold; m rises %.3f B/param" % (p0, p1, da, dm))
    for name, C in (("16 MB", C16), ("64 MB", C64), ("full stream", cfull)):
        for label, eff in (("no memorisation term", cost), ("with it", max(cost - dm, 1e-9))):
            print("    %-11s optimum P ~ %10.0f  (%s)" % (name, C * da / eff, label))
