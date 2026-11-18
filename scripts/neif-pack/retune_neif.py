#!/usr/bin/env python3
"""retune_neif.py: bounded re-tune of our packer model (pkx) on one image, ONE process at a time.
Testing tool for the packer trial on the cmix-neif 2.0 image; not part of any submitted program.

    python3 retune_neif.py STEP ...        (run in the work directory; state in ./rt/)
The objective is what counts in S: full stream + cut stream (both copies of the executable), read
from pkx's report line. Steps, each bounded and resumable (rt/cur.cfg is the current best):
    init BASE.cfg                 start from BASE.cfg
    sweep                         one pass of coordinate descent over the numeric parameters
    drop ROUNDS                   remove the context whose removal helps most, up to ROUNDS times
    rank CANDS.txt [LIMIT]        measure each candidate context added alone -> rt/rank.txt
    greedy TOPK ROUNDS MINGAIN    add the best of the TOPK ranked candidates, up to ROUNDS times
Environment: PKX (default ./pkx), IMG (default cmix.ss).
Unlike cmix-T-dwc/packer/search.py this runs one pkx at a time (the PC is shared with timing runs).
"""
import os, re, subprocess, sys, time
PKX = os.environ.get("PKX", "./pkx"); IMG = os.environ.get("IMG", "cmix.ss"); RT = "rt"
os.makedirs(RT, exist_ok=True)

def load(fn):
    head, ctx, sets = [], [], {}
    for l in open(fn):
        p = l.split()
        if not p: continue
        if p[0] in ("text", "hole", "skip"): head.append(l.strip())
        elif p[0] == "ctx": ctx.append(p[1])
        elif p[0] == "set": sets[p[1]] = int(p[2])
    return head, ctx, sets

def save(fn, cfg):
    head, ctx, sets = cfg
    with open(fn, "w") as f:
        f.write("\n".join(head) + "\n"); [f.write("ctx %s\n" % c) for c in ctx]; [f.write("set %s %d\n" % kv) for kv in sets.items()]

def run(cfg):
    """(full + cut, full, cut) in bytes for one configuration."""
    save(RT + "/try.cfg", cfg)
    out = subprocess.run([PKX, "e", RT + "/try.cfg", IMG], capture_output=True, text=True).stdout
    m = re.search(r"-> (\d+) bytes.* cut (\d+)", out)
    if not m: return (10**9, 0, 0)
    a, b = int(m.group(1)), int(m.group(2)); return (a + b, a, b)

def log(*a):
    s = " ".join(str(x) for x in a); print(s, flush=True); open(RT + "/log.txt", "a").write(s + "\n")

step = sys.argv[1]; t0 = time.time()
if step == "init":
    cfg = load(sys.argv[2]); r = run(cfg); save(RT + "/cur.cfg", cfg); log("init", r, "ctx", len(cfg[1])); sys.exit(0)
cfg = load(RT + "/cur.cfg"); head, ctx, sets = cfg; best = run(cfg); log(step, "start", best, "ctx", len(ctx))
if step == "sweep":
    grid = {"lr1": [10, 11, 12], "lr2": [11, 12, 13], "rateB": [7, 8, 9], "mm1": [3, 4, 5, 6], "mm2": [2, 3],
            "hist": [4, 5, 6], "apr": [5, 6, 7], "tbits": [20, 21, 22], "limA": [127, 255]}
    dflt = {"limA": 255}
    for name, vals in grid.items():
        cur = sets.get(name, dflt.get(name))
        for v in vals:
            if v == cur: continue
            r = run((head, ctx, {**sets, name: v})); log("  ", name, v, r)
            if r < best: best = r; sets[name] = v; save(RT + "/cur.cfg", (head, ctx, sets))
    log("sweep done", best, sets)
elif step == "drop":
    for _ in range(int(sys.argv[2])):
        rs = [(run((head, ctx[:i] + ctx[i + 1:], sets)), i) for i in range(len(ctx))]
        r, i = min(rs)
        if r >= best: log("  no drop helps"); break
        log("  drop", ctx[i], r); best = r; ctx.pop(i); save(RT + "/cur.cfg", (head, ctx, sets))
elif step == "rank":
    cands = [l.strip() for l in open(sys.argv[2]) if l.strip() and l.strip() not in ctx]
    if len(sys.argv) > 3: cands = cands[:int(sys.argv[3])]
    rs = sorted((run((head, ctx + [c], sets)), c) for c in cands)
    with open(RT + "/rank.txt", "w") as f:
        for r, c in rs: f.write("%d %s\n" % (r[0] - best[0], c))
    log("  rank: best 8:", [(r[0] - best[0], c) for r, c in rs[:8]])
elif step == "greedy":
    topk, rounds, mingain = int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
    pool = [l.split()[1] for l in open(RT + "/rank.txt")][:topk]
    for _ in range(rounds):
        cs = [c for c in pool if c not in ctx]
        if not cs or len(ctx) >= 38: break       # pkdec.c / pk.cpp: MAXIN = 160 inputs = 38 contexts
        r, c = min((run((head, ctx + [c], sets)), c) for c in cs)
        if best[0] - r[0] < mingain: log("  best gain below", mingain, c, r); break
        ctx.append(c); best = r; log("  add", c, r, "ctx", len(ctx)); save(RT + "/cur.cfg", (head, ctx, sets))
log(step, "end", best, "ctx", len(ctx), "%.0f s" % (time.time() - t0))
