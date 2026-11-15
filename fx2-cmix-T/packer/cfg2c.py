#!/usr/bin/env python3
"""cfg2c.py: copy the context list of model.cfg into the stub decoder pkdec.c (development tool,
new in this entry).

The packer model lives in two places that must agree bit for bit: model.cfg, read by the packer
tool pk.cpp at build time, and the tables compiled into the decoder pkdec.c (NCTX and cfg[]).
After search.py / retune.sh has produced a new model.cfg, run
    python3 cfg2c.py            (in this directory)
to rewrite NCTX and cfg[] in pkdec.c. It refuses a context that uses an atom for which pkdec.c's
byte_update() computes no value. Then regenerate the stub's assembly (pack.sh with
PACK_STUB_REGEN=1); pack.sh checks on every build that pkdec.c decodes what pk.cpp coded.
"""
# Header notes (comments, so that the docstring above stays as it is).
# Place in the whole: development tool of the packer that replaces UPX (see pk.cpp); not run
# by the build. It copies the contexts only. The "set" parameters of model.cfg are constants in
# pkdec.c's code (see its header) and must be changed there by hand.
import os, re, sys
here = os.path.dirname(os.path.abspath(__file__))
# atom names of model.cfg (pk.cpp ATOMS) -> enumerator names in pkdec.c
ren = {"F": "AF", "O": "AO", "M": "AM", "X": "AX", "I": "AI", "R": "AR", "S": "AS", "T": "AT", "E": "AE", "L": "AL",
       "N": "AN", "W": "AW", "Z": "AZ", "K": "AK"}
# contexts of model.cfg, each a list of atom names
ctxs = [l.split()[1].split(",") for l in open(os.path.join(here, "model.cfg")) if l.startswith("ctx ")]
p = os.path.join(here, "pkdec.c")
s = open(p, newline="").read()
# atoms that pkdec.c can supply: those assigned in its byte_update(), plus b1..b8, which it
# fills in a loop
bu = s[s.index("static void byte_update(void)"):s.index("static void mm_predict")]
have = set(re.findall(r"av\[(\w+)\]\s*=", bu)) | {"b%d" % i for i in range(1, 9)}
# the new cfg[] body: enumerator names, each context ended by 255, wrapped at 118 columns
items = []
for c in ctxs:
    for a in c:
        e = ren.get(a, a)
        if e not in have: sys.exit("cfg2c.py: atom %s (%s) is not computed in pkdec.c byte_update()" % (a, e))
        items.append(e)
    items.append("255")
lines, cur = [], " "
for it in items:
    if len(cur) + len(it) + 2 > 118: lines.append(cur.rstrip()); cur = " "
    cur += " " + it + ","
lines.append(cur.rstrip().rstrip(","))
# replace the cfg[] initialiser and the NCTX define in place, keeping pkdec.c's line endings
i = s.index("static const u8 cfg[] = {"); j = s.index("};", i) + 2
nl = "\r\n" if "\r\n" in s else "\n"
s = s[:i] + "static const u8 cfg[] = {" + nl + nl.join(lines) + " };" + s[j:]
s, n = re.subn(r"#define NCTX \d+", "#define NCTX %d" % len(ctxs), s)
assert n == 1
open(p, "w", newline="").write(s)
print("cfg2c.py: %d contexts written to pkdec.c" % len(ctxs))
