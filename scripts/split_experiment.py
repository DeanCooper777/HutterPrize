"""Block-interleave split experiment.

Split scheme (as proposed): the file is cut into consecutive blocks
  N1 blocks of J1 bytes, then N2 blocks of J2 bytes, ..., and the last level's
  block size repeats until EOF.
Blocks alternate between file A and file B (block 0 -> A, 1 -> B, 2 -> A, ...,
counting continues across levels). The schedule itself is the side information
the decoder needs (a few bytes, counted in the result).

Steps:
  1. search schedules that make A and B "most different" (Jensen-Shannon
     divergence of their byte-bigram distributions); also score each with an
     lzma proxy  (lzma(A) + lzma(B) - lzma(whole))
  2. write A and B, verify join(A, B) == original
  3. compress whole, A and B with cmix (each a fresh run = model trained on
     that file only), for the requested model modes
  4. report sizes; split total = |cmix(A)| + |cmix(B)| + schedule bytes

Usage:
  python -I scripts/split_experiment.py --file data/enwik6 --modes lstm transformer
"""
import argparse
import datetime
import itertools
import json
import lzma
import os
import subprocess
import sys
import time

import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
EXE = os.path.join(ROOT, "build", "cmix_orig.exe")
DICT = os.path.join(ROOT, "fx2-cmix-T", "dictionary", "english.dic")
WEIGHTS = os.path.join(ROOT, "fx2-cmix-T", "models", "6m-q4-fp32.tfwc2")


# ---------------------------------------------------------------- split / join
def block_bounds(schedule, n):
    """schedule: [(N1,J1), ..., (None,Jk)] -> list of (start, end, piece)."""
    out, pos, k = [], 0, 0
    for count, size in schedule:
        reps = itertools.count() if count is None else range(count)
        for _ in reps:
            if pos >= n:
                return out
            end = min(pos + size, n)
            out.append((pos, end, k & 1))
            pos, k = end, k + 1
    if pos < n:  # schedule exhausted without an open-ended level
        out.append((pos, n, k & 1))
    return out


def split(data, schedule):
    a, b = bytearray(), bytearray()
    for s, e, p in block_bounds(schedule, len(data)):
        (a if p == 0 else b).extend(data[s:e])
    return bytes(a), bytes(b)


def join(a, b, schedule, n):
    out, ia, ib = bytearray(), 0, 0
    for s, e, p in block_bounds(schedule, n):
        ln = e - s
        if p == 0:
            out += a[ia:ia + ln]; ia += ln
        else:
            out += b[ib:ib + ln]; ib += ln
    return bytes(out)


def varint(x):
    out = bytearray()
    while True:
        out.append((x & 0x7F) | (0x80 if x > 0x7F else 0))
        x >>= 7
        if not x:
            return bytes(out)


def schedule_bytes(schedule):
    """Side information: level count, then (N, J) pairs as varints."""
    enc = bytearray(varint(len(schedule)))
    for count, size in schedule:
        enc += varint(0 if count is None else count) + varint(size)
    return bytes(enc)


def fmt(schedule):
    return " + ".join(f"{'rest' if c is None else c}x{j}" for c, j in schedule)


# ---------------------------------------------------------------- scoring
def bigram_hist(buf):
    x = np.frombuffer(buf, dtype=np.uint8).astype(np.int64)
    return np.bincount(x[:-1] * 256 + x[1:], minlength=65536).astype(np.float64)


def js_divergence(a, b):
    p, q = bigram_hist(a) + 0.01, bigram_hist(b) + 0.01
    p /= p.sum(); q /= q.sum()
    m = 0.5 * (p + q)
    return 0.5 * (p * np.log2(p / m)).sum() + 0.5 * (q * np.log2(q / m)).sum()


def lz(buf):
    return len(lzma.compress(buf, preset=6))


def search(data, min_frac=0.3, top=8):
    n = len(data)
    sizes = sorted({int(16 * 1.5 ** i) for i in range(40) if 16 * 1.5 ** i <= n // 2})
    cands = [[(None, j)] for j in sizes]
    for j1 in sizes:
        for frac in (0.25, 0.5, 0.75):
            n1 = max(1, int(frac * n / j1))
            for j2 in sizes:
                if j2 != j1:
                    cands.append([(n1, j1), (None, j2)])
    scored = []
    for sch in cands:
        a, b = split(data, sch)
        if min(len(a), len(b)) < min_frac * n:
            continue
        scored.append((js_divergence(a, b), sch))
    scored.sort(key=lambda t: -t[0])
    print(f"searched {len(cands)} schedules, {len(scored)} balanced")
    whole_lz = lz(data)
    # lzma proxy for the top-divergence schedules and all one-level schedules
    pool = [s for _, s in scored[:top]] + [[(None, j)] for j in sizes]
    proxy = []
    seen = set()
    for sch in pool:
        key = json.dumps(sch)
        if key in seen:
            continue
        seen.add(key)
        a, b = split(data, sch)
        if min(len(a), len(b)) < min_frac * n:
            continue
        proxy.append((lz(a) + lz(b) - whole_lz, sch))
    proxy.sort(key=lambda t: t[0])
    return scored, proxy, whole_lz


# ---------------------------------------------------------------- cmix
def cmix(path, out, mode, log):
    args = [EXE]
    if mode == "transformer":
        args += ["--transformer", WEIGHTS]
    args += ["-c", DICT, path, out]
    t = time.time()
    with open(log, "wb") as lf:
        r = subprocess.run(args, stdout=lf, stderr=subprocess.STDOUT, cwd=os.path.dirname(out))
    if r.returncode != 0:
        raise RuntimeError(f"cmix failed on {path} ({mode}), see {log}")
    return os.path.getsize(out), time.time() - t


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--file", default=os.path.join(ROOT, "data", "enwik6"))
    ap.add_argument("--modes", nargs="+", default=["lstm", "transformer"])
    ap.add_argument("--search-only", action="store_true")
    args = ap.parse_args()

    args.file = os.path.abspath(args.file)
    data = open(args.file, "rb").read()
    name = os.path.basename(args.file)
    stamp = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    work = os.path.join(ROOT, "runs", f"split-{name}-{stamp}")
    os.makedirs(work)

    scored, proxy, whole_lz = search(data)
    print(f"\nlzma(whole) = {whole_lz:,}")
    print("\nTop schedules by bigram JS divergence (the 'most different' criterion):")
    for d, s in scored[:8]:
        print(f"  JS={d:.4f}  {fmt(s)}")
    print("\nBest schedules by lzma proxy (lzma(A)+lzma(B)-lzma(whole), negative = split wins):")
    for c, s in proxy[:8]:
        print(f"  {c:+,} bytes  {fmt(s)}")

    chosen = {"most-different": scored[0][1]}
    if json.dumps(proxy[0][1]) != json.dumps(scored[0][1]):
        chosen["best-lzma-proxy"] = proxy[0][1]

    pieces = {}
    for label, sch in chosen.items():
        a, b = split(data, sch)
        assert join(a, b, sch, len(data)) == data, "split/join round trip failed"
        pa, pb = os.path.join(work, f"{label}.A"), os.path.join(work, f"{label}.B")
        open(pa, "wb").write(a); open(pb, "wb").write(b)
        pieces[label] = (sch, pa, pb)
        print(f"\n{label}: {fmt(sch)}  A={len(a):,}  B={len(b):,}  "
              f"schedule={len(schedule_bytes(sch))} bytes  (split/join verified)")
    json.dump({k: v[0] for k, v in pieces.items()}, open(os.path.join(work, "schedules.json"), "w"))
    if args.search_only:
        return 0

    rows = []
    for mode in args.modes:
        whole_size, t = cmix(args.file, os.path.join(work, f"whole.{mode}.cmix"), mode,
                             os.path.join(work, f"whole.{mode}.log"))
        rows.append((mode, "unsplit", "-", whole_size, None, None, whole_size, t))
        print(f"[{mode}] unsplit: {whole_size:,} bytes ({t:.0f} s)", flush=True)
        for label, (sch, pa, pb) in pieces.items():
            sa, ta = cmix(pa, pa + f".{mode}.cmix", mode, pa + f".{mode}.log")
            sb, tb = cmix(pb, pb + f".{mode}.cmix", mode, pb + f".{mode}.log")
            total = sa + sb + len(schedule_bytes(sch))
            rows.append((mode, label, fmt(sch), total, sa, sb, total, ta + tb))
            print(f"[{mode}] {label}: A={sa:,} + B={sb:,} + schedule = {total:,} bytes "
                  f"({total - whole_size:+,} vs unsplit, {100.0 * (total - whole_size) / whole_size:+.2f}%)",
                  flush=True)

    with open(os.path.join(ROOT, "split_results.csv"), "a") as f:
        if f.tell() == 0:
            f.write("date,file,mode,variant,schedule,cmixA,cmixB,total_bytes,seconds\n")
        for mode, label, sch, total, sa, sb, _, t in rows:
            f.write(f"{stamp},{name},{mode},{label},{sch},{sa or ''},{sb or ''},{total},{t:.0f}\n")
    print(f"\nresults appended to split_results.csv; files in {work}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
