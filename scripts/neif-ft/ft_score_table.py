#!/usr/bin/env python3
# ft_score_table.py: testing tool (not part of any submitted program).
#
#   ft_score_table.py <out root of ft_score.sh> <reference arm, e.g. start> <arm> [...]
#   ft_score_table.py --selftest
#
# Sums the chunk results of ft_score.sh per arm and compares the arms chunk by chunk (paired):
# the full cost (kept_bytes: the coder's own probabilities, after BITLSTM, the floor stage and
# the semantic cache) and the cost at the return value of Predictor::Predict()
# (tap_kept_bytes: in front of BITLSTM, whose stamped weights were trained on the shipped
# transformer).  Only chunks present for every named arm are used; the structure hash of a
# chunk must be the same for all arms (the weights must not change what is coded).
# Per arm: sum, difference to the reference, the paired standard error over chunks, and the
# difference scaled to the scored stream (487,298,491 tokens); then the pilot's verdict:
# T below every control on both measures, and the spread of the controls.
import glob
import json
import math
import os
import sys
import tempfile

SCORED = 487298491


def load(root, arm):
    out = {}
    for p in glob.glob(os.path.join(root, arm, "c*", "score.json")):
        r = json.load(open(p))
        out[int(r["start"])] = r
    return out


def table(root, ref, arms):
    data = {a: load(root, a) for a in [ref] + arms}
    common = sorted(set.intersection(*[set(d) for d in data.values()]))
    assert common, "no chunk is present for all arms"
    kept = 0
    for st in common:
        hs = {data[a][st]["structure_hash"] for a in data}
        assert len(hs) == 1, "chunk %d: structure hash differs between arms" % st
        kept += data[ref][st]["end"] - data[ref][st]["kept_from"]
    scale = SCORED / kept
    print("%d chunks, %d kept bytes, scale to the scored stream x%.1f" % (len(common), kept, scale))
    print("%-6s %14s %12s %10s %12s | %14s %12s %10s %12s" % ("arm", "full bytes", "vs " + ref, "+-se", "x scale",
                                                           "tap bytes", "vs " + ref, "+-se", "x scale"))
    res = {}
    for a in [ref] + arms:
        row = [a]
        for key in ("kept_bytes", "tap_kept_bytes"):
            d = [data[a][st][key] - data[ref][st][key] for st in common]
            tot = sum(data[a][st][key] for st in common)
            n = len(d)
            m = sum(d) / n
            se = math.sqrt(sum((x - m) ** 2 for x in d) / max(n - 1, 1) * n) if n > 1 else float("nan")
            row += [tot, sum(d), se, sum(d) * scale]
            res[(a, key)] = (sum(d), se)
        print("%-6s %14.1f %+12.1f %10.1f %+12.0f | %14.1f %+12.1f %10.1f %+12.0f" % tuple(row))
    return res


def verdict(res, arms):
    ctl = [a for a in arms if a.startswith("C")]
    if "T" not in arms or not ctl:
        return None
    ok = True
    for key in ("kept_bytes", "tap_kept_bytes"):
        t = res[("T", key)][0]
        cs = [res[(c, key)][0] for c in ctl]
        beats = all(t < c for c in cs)
        ok &= beats
        print("%-15s T %+.1f, controls %s (spread %.1f): T %s all controls"
              % (key, t, " ".join("%+.1f" % c for c in cs), max(cs) - min(cs), "beats" if beats else "does NOT beat"))
    print("PILOT: %s (also required: the controls stay near the start, see the column 'vs' above)" % ("PASS" if ok else "FAIL"))
    return ok


def selftest():
    d = tempfile.mkdtemp()
    base = {"start": 1000.0, "C1": 1003.0, "C2": 1001.0, "C3": 1005.0, "T": 990.0}
    for a, b in base.items():
        for i in range(4):
            o = os.path.join(d, a, "c%d" % (i * 10))
            os.makedirs(o)
            json.dump({"start": i * 10, "kept_from": i * 10, "end": i * 10 + 5, "structure_hash": "h%d" % i,
                       "kept_bytes": b + i, "tap_kept_bytes": b + 2 + i}, open(os.path.join(o, "score.json"), "w"))
    res = table(d, "start", ["C1", "C2", "C3", "T"])
    ok = verdict(res, ["C1", "C2", "C3", "T"]) is True and abs(res[("T", "kept_bytes")][0] + 40.0) < 1e-9
    print("selftest:", "ok" if ok else "FAILED")
    return 0 if ok else 1


if __name__ == "__main__":
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    r = table(sys.argv[1], sys.argv[2], sys.argv[3:])
    verdict(r, sys.argv[3:])
