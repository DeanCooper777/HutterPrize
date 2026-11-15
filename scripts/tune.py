# tune.py: search harness for the compressor's numeric constants (mixer learning rates, the
# learning-rate decay schedule, SSE constants, the online-adaptation rate, ...).
#
# How it works: the development build reads overrides "name value" from the file named by the
# environment variable CMIX_TUNE (fx2-cmix-T/src/tune.h, tune::Get(name, default)). This
# script writes such a file, runs a compress-only job on a test prefix, and records the
# compressed size; results are cached by (file, executable hash, parameters).
#
# Testing: an experiment tool only. The constants it found were then written into the source
# as the defaults of tune::Get; the submitted build (-DCMIX_OFFICIAL) ignores CMIX_TUNE and
# uses those defaults. The DEFAULTS table below is only a starting point for searches and for
# reporting, and it may lag behind the source; the defaults in the C++ are authoritative.
#
# Changes from the previous winning entry (fx2-cmix-transformer-v1): New in this entry.
"""Parameter tuning harness for fx2-cmix-T (runtime overrides via CMIX_TUNE).

Each evaluation compresses a test file with build/cmix_tune.exe (compress
only) using a parameter file, and the score is the compressed size. Runs are
cached in runs/tune/cache.json by (file, exe hash, params), so repeated or
resumed searches cost nothing.

Modes:
  eval        evaluate one parameter set:   --set lr0_0=0.004 decay_d3=0.25
  sweep       try each value for one param: --param lr1_0 --values 0.0002 0.0004
  batch       evaluate several sets:        --sets "a=1 b=2" "c=3"
  descent     coordinate descent over --params (multiplicative steps)

Scores: by default the compressed bytes for the second half of the input
(--score tail, from progress.log), a better proxy for enwik9's steady state
than the whole size of a short prefix; --score full uses the whole size.

PPMD memory is reduced with ppmd_mb (default here 2500) so several runs fit in
RAM at once; check with `eval --set ppmd_mb=14000` that the size is identical.

Examples:
  python -I scripts/tune.py eval --file data/enwik6
  python -I scripts/tune.py descent --file data/enwik6 --params lr1_0 lr0_0 lr0_1 --jobs 3
"""
import argparse
import concurrent.futures as cf
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
import threading
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DICT = os.path.join(ROOT, "fx2-cmix-T", "dictionary", "english.dic")
WEIGHTS = os.path.join(ROOT, "fx2-cmix-T", "models", "6m-q4-fp32.tfwc2")
WORK = os.path.join(ROOT, "runs", "tune")
CACHE = os.path.join(WORK, "cache.json")
LOG = os.path.join(ROOT, "tune_results.csv")

# current source defaults of the tunables (tuned 2026-11-06 on enwik7;
# upstream had lr1_0 3e-4, input_eps 1e-4, decay_d3 0.2, dyn off) (for reporting / descent starting points)
DEFAULTS = {
    **{f"lr0_{i}": v for i, v in enumerate(
        [0.005, 0.0005, 0.005, 0.0005, 0.005, 0.001, 0.002, 0.0007, 0.0005,
         0.002, 0.0005, 0.001, 0.001, 0.005, 0.001, 0.001, 0.005, 0.001,
         0.001, 0.005, 0.005, 0.005, 0.005])},
    "lr1_0": 0.00015,
    "input_eps": 5e-5,
    "decay_t1": 1e6, "decay_t2": 5e6, "decay_t3": 25e6,
    "decay_d0": 1.0, "decay_d1": 0.7, "decay_d2": 0.3, "decay_d3": 0.05,
    "tf_mixer_buckets": 0, "tf_mixer_mode": 0, "tf_mixer_lr": 0.002,
    "tf_mixer_l0": 1, "l1_ctx": 0, "prefetch_mixers": 1, "attn_f32": 0,
    # final SSE stage (src/mixer/sse.cpp)
    "sse_f0C": 10240, "sse_f1C": 7935, "sse_f2C": 9592, "sse_sm6wrA": 0,
    "sse_sm6wrB": 106, "sse_sm6mw": 0, "sse_sm6C1": 8092, "sse_x1W0": 7649,
    "sse_x1wr": 6202, "sse_f3C": 8200, "sse_f4C": 7677, "sse_sm7wrB": 127,
    "sse_sm7mw": 8192, "sse_sm7C1": 8202, "sse_x2W0": 2561, "sse_x2wr": 8320,
    # online adaptation of the transformer head (build/cmix_dyn.exe)
    "dyn_lr": 3e-4, "dyn_blr": 0, "dyn_decay": 0, "dyn_mode": 1, "dyn_l1": 1,
}
BASE = {"ppmd_mb": 2500}

_lock = threading.Lock()


# Cache key part: a hash of the executable, so results never mix between builds.
def exe_hash(exe):
    h = hashlib.sha256()
    with open(exe, "rb") as f:
        h.update(f.read())
    return h.hexdigest()[:16]


def load_cache():
    if os.path.exists(CACHE):
        return json.load(open(CACHE))
    return {}


def save_cache(c):
    tmp = CACHE + ".tmp"
    json.dump(c, open(tmp, "w"), indent=0, sort_keys=True)
    os.replace(tmp, CACHE)


def key_of(file, eh, params):
    return json.dumps([os.path.basename(file), eh, sorted(params.items())])


# Score: "full" = compressed size of the whole file; "tail" = compressed bytes
# produced for the input from TAIL_FROM percent to the end (from cmix's
# progress.log). On a test prefix the early part is dominated by warm-up
# (model tables filling, the mixer decay schedule's early phases), which is a
# tiny fraction of enwik9; the tail is a better proxy for the steady state.
SCORE = "tail"
TAIL_FROM = 50.0


# Compressed bytes spent on the input from TAIL_FROM percent to the end.
def tail_bytes(progress_path, total):
    """Compressed bytes produced from TAIL_FROM percent of the input on."""
    at = None
    with open(progress_path) as f:
        for line in f:
            parts = line.split()
            if len(parts) == 2 and float(parts[0]) >= TAIL_FROM:
                at = int(parts[1])
                break
    if at is None:
        raise RuntimeError(f"no progress entry >= {TAIL_FROM}% in {progress_path}")
    return total - at


def score_of(entry):
    return entry["size"] if SCORE == "full" else entry["tail"]


# Run one configuration (or return the cached score): write the parameter file, run the
# compressor in its own work directory, read the size and the progress log.
def evaluate(exe, eh, file, params, cache):
    """Returns the score (see SCORE); the cache holds both full and tail."""
    params = {**BASE, **params}
    k = key_of(file, eh, params) + (f"|tail{TAIL_FROM:g}" if TAIL_FROM != 50.0 else "")
    with _lock:
        if isinstance(cache.get(k), dict):
            return score_of(cache[k])
    os.makedirs(WORK, exist_ok=True)
    # own directory per run: cmix writes ./progress.log (and its PPMD heap
    # file), so parallel jobs must not share a working directory
    wdir = tempfile.mkdtemp(prefix="run_", dir=WORK)
    pfile = os.path.join(wdir, "params.tune")
    with open(pfile, "w") as f:
        for n, v in sorted(params.items()):
            f.write(f"{n} {v!r}\n")
    out = os.path.join(wdir, "out.cmix")
    env = dict(os.environ, CMIX_TUNE=pfile)
    t = time.time()
    r = subprocess.run([exe, "--transformer", WEIGHTS, "-c", DICT, file, out],
                       env=env, cwd=wdir, stdout=subprocess.DEVNULL,
                       stderr=subprocess.PIPE)
    if r.returncode != 0:
        err = r.stderr.decode(errors="replace")[-800:]
        raise RuntimeError(f"cmix failed for {params}:\n{err}")
    size = os.path.getsize(out)
    tail = tail_bytes(os.path.join(wdir, "progress.log"), size)
    shutil.rmtree(wdir, ignore_errors=True)
    dt = time.time() - t
    entry = {"size": size, "tail": tail}
    with _lock:
        cache[k] = entry
        save_cache(cache)
        new = not os.path.exists(LOG)
        with open(LOG, "a") as f:
            if new:
                f.write("time,file,exe,size,seconds,params,tail\n")
            delta = {n: v for n, v in params.items() if n not in BASE}
            f.write(f"{time.strftime('%Y-%m-%d %H:%M:%S')},{os.path.basename(file)},{eh},"
                    f"{size},{dt:.0f},\"{json.dumps(delta, sort_keys=True)}\",{tail}\n")
    print(f"  {size:,} (tail {tail:,})  {json.dumps({n: v for n, v in params.items() if n not in BASE})}  ({dt:.0f}s)",
          flush=True)
    return score_of(entry)


def parse_set(items):
    out = {}
    for it in items or []:
        n, v = it.split("=", 1)
        out[n] = float(v)
    return out


# Command line: eval / sweep / batch / descent, see the docstring at the top.
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("mode", choices=["eval", "sweep", "descent", "batch"])
    ap.add_argument("--file", default=os.path.join(ROOT, "data", "enwik6"))
    ap.add_argument("--exe", default=os.path.join(ROOT, "build", "cmix_tune.exe"))
    ap.add_argument("--set", nargs="*", help="fixed overrides name=value")
    ap.add_argument("--param")
    ap.add_argument("--sets", nargs="*", help="batch: each item is a space-separated list of name=value")
    ap.add_argument("--values", nargs="*", type=float)
    ap.add_argument("--params", nargs="*")
    ap.add_argument("--factors", nargs="*", type=float, default=[0.5, 2.0])
    ap.add_argument("--rounds", type=int, default=2)
    ap.add_argument("--jobs", type=int, default=3)
    ap.add_argument("--score", choices=["full", "tail"], default="tail",
                    help="objective: whole compressed size, or the bytes for the input "
                         "from --tail-from percent on (steady-state proxy, default)")
    ap.add_argument("--tail-from", type=float, default=50.0)
    args = ap.parse_args()
    global SCORE, TAIL_FROM
    SCORE, TAIL_FROM = args.score, args.tail_from

    file = os.path.abspath(args.file)
    exe = os.path.abspath(args.exe)
    eh = exe_hash(exe)
    cache = load_cache()
    fixed = parse_set(args.set)
    pool = cf.ThreadPoolExecutor(args.jobs)

    if args.mode == "eval":
        print(evaluate(exe, eh, file, fixed, cache))
        return 0

    if args.mode == "batch":
        sets = [{**fixed, **parse_set(x.split())} for x in args.sets]
        futs = [pool.submit(evaluate, exe, eh, file, st, cache) for st in [fixed] + sets]
        base = futs[0].result()
        print(f"base {base:,}")
        for st, f in zip(sets, futs[1:]):
            sz = f.result()
            print(f"  {sz:,} ({sz - base:+,})  {json.dumps(st, sort_keys=True)}")
        return 0

    if args.mode == "sweep":
        futs = {v: pool.submit(evaluate, exe, eh, file, {**fixed, args.param: v}, cache)
                for v in args.values}
        base = evaluate(exe, eh, file, fixed, cache)
        print(f"base {base:,}")
        for v, f in futs.items():
            s = f.result()
            print(f"  {args.param}={v:g}: {s:,} ({s - base:+,})")
        return 0

    # coordinate descent with multiplicative steps
    cur = dict(fixed)
    best = evaluate(exe, eh, file, cur, cache)
    print(f"start {best:,}")
    factors = list(args.factors)
    for rnd in range(args.rounds):
        improved = False
        for name in args.params:
            v0 = cur.get(name, DEFAULTS[name])
            cands = [v0 * f for f in factors]
            futs = [pool.submit(evaluate, exe, eh, file, {**cur, name: v}, cache) for v in cands]
            res = [(f.result(), v) for f, v in zip(futs, cands)]
            s, v = min(res)
            if s < best:
                print(f"[round {rnd}] {name}: {v0:g} -> {v:g}  {best:,} -> {s:,} ({s - best:+,})", flush=True)
                best, cur[name] = s, v
                improved = True
            else:
                print(f"[round {rnd}] {name}: keep {v0:g} (best alt {s:,})", flush=True)
        factors = [f ** 0.5 for f in factors]  # finer steps next round
        if not improved and rnd > 0:
            break
    print(f"\nbest {best:,} with {json.dumps(cur, sort_keys=True)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
