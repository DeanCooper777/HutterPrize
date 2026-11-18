#!/usr/bin/env python3
"""mk_pkx.py: writes pkx.cpp, a measuring copy of our packer model cmix-T-dwc/packer/pk.cpp.
Testing tool for the packer trial on the cmix-neif 2.0 image; not part of any submitted program.

    python3 mk_pkx.py PK_CPP OUT_CPP

pkx is pk with three additions, none of which changes what pk computes when they are unused:
  * config line "skip LO HI": a file range inside the code range that is data (the cmix-neif
    image has a 1,760 B writable segment between its two code segments); the x86 parser and the
    address transform leave it alone;
  * the code range may end at the end of the file with the hole as its last part (the cmix-neif
    layout: compress-only code is the last load segment);
  * environment PK_COST=FILE: writes the ideal code length of every input byte (float32, bits,
    indexed by FILE offset), for the per-region breakdown (regions.py).
Each edit is an exact string replacement that must match once, so a changed pk.cpp is noticed.
"""
import sys
src = open(sys.argv[1], newline="").read().replace("\r\n", "\n")
def rep(old, new):
    global src
    assert src.count(old) == 1, "pattern not found exactly once: " + old[:60]
    src = src.replace(old, new)
rep("static size_t hole_lo = 0, hole_hi = 0;\n",
    "static size_t hole_lo = 0, hole_hi = 0;\n"
    "static size_t skip_lo = 0, skip_hi = 0;   // TRIAL: data range inside the code range\n")
rep("static bool in_text(size_t i) { return (i >= text_lo",
    "static bool in_text(size_t i) { if (i >= skip_lo && i < skip_hi) return false; return (i >= text_lo")
rep("  if (!H) { xform(t, text_lo, text_hi, fwd); return; }\n"
    "  xform(t, text_lo, hole_lo, fwd, 0);                 // code before the hole\n",
    "  size_t e1 = H ? hole_lo : text_hi;                  // TRIAL: split the first piece at skip\n"
    "  if (skip_hi > skip_lo) { xform(t, text_lo, skip_lo, fwd, 0); xform(t, skip_hi, e1, fwd, 0); }\n"
    "  else xform(t, text_lo, e1, fwd, 0);\n"
    "  if (!H) return;\n")
rep("if (pos - 1 == t2_lo || pos - 1 == hole_lo) x = X86();",
    "if (pos - 1 == t2_lo || pos - 1 == hole_lo || (skip_hi > skip_lo && pos - 1 == skip_hi)) x = X86();")
rep('    else if (sscanf(line, "hole %lld %lld", &v, &v2) == 2) { hole_lo = v; hole_hi = v2; }\n',
    '    else if (sscanf(line, "hole %lld %lld", &v, &v2) == 2) { hole_lo = v; hole_hi = v2; }\n'
    '    else if (sscanf(line, "skip %lld %lld", &v, &v2) == 2) { skip_lo = v; skip_hi = v2; }\n')
rep("  Enc e; e.out = &out; double bits = 0, tb = 0, ob = 0, hb = 0; size_t cut = 0;\n",
    "  Enc e; e.out = &out; double bits = 0, tb = 0, ob = 0, hb = 0; size_t cut = 0;\n"
    "  std::vector<float> costv(n, 0.f); size_t Hh = hole_hi - hole_lo;   // TRIAL: cost per file byte\n")
rep("      double c = -log2((y ? p : 4096 - p) / 4096.0); bits += c;",
    "      double c = -log2((y ? p : 4096 - p) / 4096.0); bits += c;\n"
    "      costv[!Hh || i < hole_lo ? i : (i < n - Hh ? i + Hh : i - (n - Hh) + hole_lo)] += (float)c;\n     ")
rep("  e.flush();\n",
    "  e.flush();\n"
    '  if (getenv("PK_COST")) { FILE* f = fopen(getenv("PK_COST"), "wb"); fwrite(costv.data(), 4, n, f); fclose(f); }\n')
open(sys.argv[2], "w", newline="\n").write("// pkx.cpp: TRIAL copy of pk.cpp made by scripts/neif-pack/mk_pkx.py (testing tool only).\n" + src)
print("mk_pkx.py: wrote", sys.argv[2])
