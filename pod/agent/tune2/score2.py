"""Score tune2 results vs ref (bytes from ref; timing vs the ref on the same pod). usage: python3 score2.py [ROUNDFILE ...]"""
import json, os, sys, glob
R = "/workspace/tune2/res"; CH = [3, 7, 11, 15]
pod = {}
for rf in (sys.argv[1:] or sorted(glob.glob("/workspace/tune2/round*_*.txt"))):
    rf = rf if rf.startswith("/") else f"/workspace/tune2/{rf}"
    names = open(rf).read().split(); r0 = names[0] if names[0].startswith("ref") else None
    for n in names: pod[n] = r0
def load(n):
    d = {}
    for k in CH:
        f = f"{R}/{n}/c{k}.json"
        if os.path.exists(f):
            j = json.load(open(f))
            if j.get("skipped"): return "skipped"
            d[k] = j
    return d
ref = load("ref"); rows = []
for n, r0 in pod.items():
    d = load(n)
    if d == "skipped": rows.append((n, None, None, None, -1)); continue
    if len(d) < 4 or len(ref) < 4: rows.append((n, None, None, None, len(d))); continue
    tr = load(r0) if r0 else ref
    db = sum(d[k]["kept_bytes"] - ref[k]["kept_bytes"] for k in CH)
    ts = sum(d[k]["seconds"] for k in CH); tref = sum(tr[k]["seconds"] for k in CH) if len(tr) == 4 else None
    rows.append((n, db, db * 17.7, (ts / tref - 1) * 100 if tref else None, 4))
rows.sort(key=lambda r: (r[1] is None, r[1] if r[1] is not None else 0))
print(f"{'setting':22s} {'d 4 chunks':>11s} {'x17.7':>10s} {'time %':>7s}")
for n, db, fs, tp, c in rows:
    if db is None: print(f"{n:22s} " + ("skipped (cost cap)" if c == -1 else f"pending ({c}/4)"))
    else: print(f"{n:22s} {db:+11,.0f} {fs:+10,.0f} {tp:+7.1f}" if tp is not None else f"{n:22s} {db:+11,.0f} {fs:+10,.0f}     n/a")
