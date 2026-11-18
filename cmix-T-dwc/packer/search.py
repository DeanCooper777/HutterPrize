"""search.py: model search for the pk packer (development tool, new in this entry).

The packer's model is a list of contexts ("ctx" lines of model.cfg; each is a set of atoms such
as previous bytes or fields of the x86 instruction being parsed, see ATOMS in pk.cpp) plus a few
rates ("set" lines). This script measures configurations in parallel with `pk e CONFIG ELF`
(estimate only) and searches: drop contexts that do not pay, add the best of a candidate list
(cands.txt) greedily, sweep a parameter. retune.sh shows the sequence used for the shipped
model.cfg. The contexts chosen must then be copied into pkdec.c (cfg[] and NCTX); pack.sh
fails the build if the two disagree.

Environment: PK_ELF = the unpacked executable to model (required), PK_EXE = the pk binary
(default ./pk), PK_TMP = scratch directory.
Usage: python3 search.py MODE BASE.cfg ...   (modes: sweep, drop, add, greedy; see below)
"""
# Header notes (comments, so that the docstring above stays as it is).
# Place in the whole: used only while developing the packer that replaces UPX (see pk.cpp);
# not run by the build. The numbers it prints are pk's estimates in bytes ("est" in pk's
# output), which is the ideal code length of the model, a little below the real stream size.
# Each measurement is one full run of pk over the executable; runmany() runs several at once.
import subprocess, sys, os, re, itertools, tempfile
from concurrent.futures import ThreadPoolExecutor
HERE = os.path.dirname(os.path.abspath(__file__))
EXE = os.environ.get("PK_EXE", os.path.join(HERE, "pk")); ELF = os.environ["PK_ELF"]
TMP = os.environ.get("PK_TMP", os.path.join(HERE, "tmp")); os.makedirs(TMP, exist_ok=True)

# Read a config: the text line (with the hole line appended, if any), the list of contexts and
# the dictionary of "set" parameters.
def load(fn):
    text, ctx, sets = None, [], {}
    for l in open(fn):
        p = l.split()
        if not p: continue
        if p[0] == "text": text = l.strip()
        elif p[0] == "hole": text += chr(10) + l.strip()      # kept with the text line
        elif p[0] == "ctx": ctx.append(p[1])
        elif p[0] == "set": sets[p[1]] = int(p[2])
    return text, ctx, sets

# Write a config in the form pk reads.
def save(fn, text, ctx, sets):
    with open(fn, "w") as f:
        f.write(text + "\n"); [f.write(f"ctx {c}\n") for c in ctx]; [f.write(f"set {k} {v}\n") for k, v in sets.items()]

# Measure one configuration (text, ctx, sets): estimated size in bytes, 10**9 if pk failed.
_n = itertools.count()
def run(cfg):
    text, ctx, sets = cfg; fn = os.path.join(TMP, f"c{os.getpid()}_{next(_n)}.cfg"); save(fn, text, ctx, sets)
    out = subprocess.run([EXE, "e", fn, ELF], capture_output=True, text=True).stdout
    os.remove(fn); m = re.search(r"est (\d+)", out)
    return int(m.group(1)) if m else 10**9

# Measure many configurations in parallel; results in the same order.
def runmany(cfgs, workers=12):
    with ThreadPoolExecutor(workers) as ex: return list(ex.map(run, cfgs))

if __name__ == "__main__":
    mode, base = sys.argv[1], sys.argv[2]; text, ctx, sets = load(base)
    if mode == "sweep":   # sweep NAME v1 v2 ...
        name, vals = sys.argv[3], [int(v) for v in sys.argv[4:]]
        rs = runmany([(text, ctx, {**sets, name: v}) for v in vals])
        for v, r in zip(vals, rs): print(name, v, r)
    elif mode == "drop":  # cost of removing each context
        b = run((text, ctx, sets)); rs = runmany([(text, ctx[:i] + ctx[i + 1:], sets) for i in range(len(ctx))])
        print("base", b); [print(f"{r - b:+7d}  {c}") for r, c in sorted(zip(rs, ctx))]
    elif mode == "add":   # gain of adding each candidate from a file
        cands = [l.strip() for l in open(sys.argv[3]) if l.strip() and l.strip() not in ctx]
        b = run((text, ctx, sets)); rs = runmany([(text, ctx + [c], sets) for c in cands])
        print("base", b); [print(f"{r - b:+7d}  {c}") for r, c in sorted(zip(rs, cands))]
    elif mode == "greedy":  # greedy add from candidates until gain < MIN; writes OUT
        cands = [l.strip() for l in open(sys.argv[3]) if l.strip()]; out = sys.argv[4]; mn = int(sys.argv[5]); mx = int(sys.argv[6])
        b = run((text, ctx, sets)); print("base", b, flush=True)
        while len(ctx) < mx:
            cs = [c for c in cands if c not in ctx]; rs = runmany([(text, ctx + [c], sets) for c in cs])
            r, c = min(zip(rs, cs))
            if b - r < mn: break
            ctx.append(c); b = r; print(len(ctx), b, c, flush=True); save(out, text, ctx, sets)
        save(out, text, ctx, sets)
