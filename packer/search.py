"""Parallel evaluation helpers for pk model search.  python search.py MODE ..."""
import subprocess, sys, os, re, itertools, tempfile
from concurrent.futures import ThreadPoolExecutor
HERE = os.path.dirname(os.path.abspath(__file__)); EXE = os.path.join(HERE, "pk.exe"); ELF = os.path.join(HERE, os.environ.get("PK_ELF", "cmix_st2.elf"))
TMP = os.path.join(HERE, "tmp"); os.makedirs(TMP, exist_ok=True)

def load(fn):
    text, ctx, sets = None, [], {}
    for l in open(fn):
        p = l.split()
        if not p: continue
        if p[0] == "text": text = l.strip()
        elif p[0] == "ctx": ctx.append(p[1])
        elif p[0] == "set": sets[p[1]] = int(p[2])
    return text, ctx, sets

def save(fn, text, ctx, sets):
    with open(fn, "w") as f:
        f.write(text + "\n"); [f.write(f"ctx {c}\n") for c in ctx]; [f.write(f"set {k} {v}\n") for k, v in sets.items()]

_n = itertools.count()
def run(cfg):
    text, ctx, sets = cfg; fn = os.path.join(TMP, f"c{os.getpid()}_{next(_n)}.cfg"); save(fn, text, ctx, sets)
    out = subprocess.run([EXE, "e", fn, ELF], capture_output=True, text=True).stdout
    os.remove(fn); m = re.search(r"est (\d+)", out)
    return int(m.group(1)) if m else 10**9

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
