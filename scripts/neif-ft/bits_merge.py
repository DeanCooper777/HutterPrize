#!/usr/bin/env python3
# bits_merge.py: testing tool (not part of any submitted program).
#
#   bits_merge.py --stream <coder stream> --pkg <training package dir> --out <file>
#                 --vocab <vocab-bitmap.u8> <result.json>:<bits file> [...]
#   bits_merge.py --selftest
#
# Turns the output of the bit-dump tool of cmix-neif 2.0 (mode -t with NEIF_TF_OFF=1
# NEIF_BITS_OUT=<bits file>, see runs/neif-ft/neif_bitsout.diff) into the file the patched
# loader reads (FT_CMIX_BITS): [n_tokens, 8] float16 in PACKAGE coordinates, row p = the token
# ppmd-bytes[p] = coder stream byte c = p + cut - 6 (the package counts the 6-byte segment
# header and starts at the cut behind the metadata blocks).  One run over the whole stream
# gives one pair; runs over pieces give several, and of each the rows from its START on are
# taken (the rows of its warm-up are dropped unless nothing else covers them: pairs are
# applied in the order given, later ones overwrite, so list a warm-up-free run last).
# Rows no run covers are NaN (the loss then falls back to the cross-entropy there).
#
# Checks, each fatal:
#   1. every bits file has 16 B per model byte of its run (end - warm_from) and the row count
#      the run reported;
#   2. alignment and content per run: every bit written as +-inf carries the sign of the
#      stream bit; the number of finite bits is the run's tap_bit_count; the cost of the finite
#      bits, recomputed from the logits and the stream, is the run's own tap_total_bits
#      (within the float16 rounding, 0.2 %);
#   3. package coordinates: stream byte c is the byte of the token ppmd-bytes[c + 6 - cut],
#      and the cut derived from the file lengths is the shift stamped in dump-meta.json.
import argparse
import json
import os
import sys
import tempfile

import numpy as np

BLK = 1 << 22


def vocab_bytes(path):
    bm = open(path, "rb").read()
    assert len(bm) == 32
    return np.array([b for b in range(256) if (bm[b // 8] >> (b % 8)) & 1], dtype=np.uint8)


def check_run(stream, js, bits_path):
    """checks 1 and 2 for one run; returns (warm_from, start, end, memmap of its rows)"""
    r = json.load(open(js))
    wf, start, end = int(r["warm_from"]), int(r["kept_from"]), int(r["end"])
    n = end - wf
    size = os.path.getsize(bits_path)
    assert size == 16 * n, "%s: %d B, the run has %d model bytes (16 B each = %d)" % (bits_path, size, n, 16 * n)
    assert int(r.get("bits_out_rows", n)) == n, "%s: bits_out_rows %s, model bytes %d" % (js, r.get("bits_out_rows"), n)
    rows = np.memmap(bits_path, dtype=np.float16, mode="r").reshape(n, 8)
    shifts = np.arange(7, -1, -1, dtype=np.uint8)
    cost = 0.0
    finite = forced_bad = 0
    for i0 in range(0, n, BLK):
        x = np.asarray(rows[i0:i0 + BLK], dtype=np.float64)
        assert not np.isnan(x).any(), "%s: NaN in the dump" % bits_path
        c = np.asarray(stream[wf + i0:wf + i0 + len(x)])
        y = ((c[:, None] >> shifts[None, :]) & 1).astype(bool)
        fin = np.isfinite(x)
        forced_bad += int((~fin & ((x > 0) != y)).sum())
        finite += int(fin.sum())
        z = np.where(y, x, -x)[fin]                       # logit of the coded bit
        cost += float(np.logaddexp(0.0, -z).sum()) / np.log(2.0)
    assert forced_bad == 0, "%s: %d uncoded bits contradict the stream byte (misaligned dump)" % (bits_path, forced_bad)
    if "tap_bit_count" in r:
        assert finite == int(r["tap_bit_count"]), "%s: %d finite bits, the run coded %d" % (bits_path, finite, r["tap_bit_count"])
    if "tap_total_bits" in r:
        rel = abs(cost - float(r["tap_total_bits"])) / max(float(r["tap_total_bits"]), 1.0)
        assert rel < 2e-3, "%s: cost from the logits %.1f bits, the run's tap sum %.1f" % (bits_path, cost, r["tap_total_bits"])
    print("%s: bytes [%d, %d) (model from %d), %d coded bits, %.1f bits = %.4f bits/byte, tf_off %s: ok"
          % (os.path.basename(bits_path), start, end, wf, finite, cost, cost / max(n, 1), r.get("tf_off", "?")), flush=True)
    return wf, start, end, rows


def merge(stream_path, pkg, out, vocab_path, pairs):
    stream = np.memmap(stream_path, dtype=np.uint8, mode="r")
    toks = np.memmap(os.path.join(pkg, "ppmd-bytes.uint8"), dtype=np.uint8, mode="r")
    n_tok = len(toks)
    cut = len(stream) + 6 - n_tok                         # package row p <-> stream byte p + cut - 6
    meta = json.load(open(os.path.join(pkg, "dump-meta.json")))
    assert int(meta.get("shift", cut)) == cut, "cut from the lengths %d, dump-meta shift %s" % (cut, meta.get("shift"))
    # check 3: the tokens of the package are the stream bytes (the first 6 - ... rows are the
    # segment header, which lies in front of the cut on the full stream)
    vb = vocab_bytes(vocab_path)
    c0 = cut - 6
    assert c0 >= 0
    bad = 0
    for i0 in range(0, n_tok, BLK):
        t = np.asarray(toks[i0:i0 + BLK])
        bad += int((vb[t] != np.asarray(stream[c0 + i0:c0 + i0 + len(t)])).sum())
    assert bad == 0, "%d tokens of ppmd-bytes differ from the stream byte at p + cut - 6 (cut %d)" % (bad, cut)
    print("package: %d tokens, cut %d, stream %d B: tokens = stream bytes: ok" % (n_tok, cut, len(stream)), flush=True)
    o = np.memmap(out, dtype=np.float16, mode="w+", shape=(n_tok, 8))
    for i0 in range(0, n_tok, BLK):
        o[i0:i0 + BLK] = np.nan
    covered = np.zeros(n_tok, dtype=bool)
    for pair in pairs:
        js, bp = pair.split(":", 1)
        wf, start, end, rows = check_run(stream, js, bp)
        lo, hi = max(start, c0), end                      # stream range taken from this run
        if hi <= lo:
            continue
        for a in range(lo, hi, BLK):
            b = min(a + BLK, hi)
            o[a - c0:b - c0] = rows[a - wf:b - wf]
        covered[lo - c0:hi - c0] = True
    o.flush()
    n_cov = int(covered.sum())
    print("wrote %s: %d of %d rows covered (%.3f %%), %d NaN rows" % (out, n_cov, n_tok, 100.0 * n_cov / n_tok, n_tok - n_cov))
    json.dump({"n_tokens": n_tok, "cut": cut, "covered_rows": n_cov, "runs": pairs},
              open(out + ".json", "w"), indent=1)
    return n_cov


def selftest():
    rng = np.random.default_rng(1)
    d = tempfile.mkdtemp()
    vbm = bytearray(32)
    for b in list(range(1, 100)) + list(range(120, 229)):   # 208 byte values
        vbm[b // 8] |= 1 << (b % 8)
    open(os.path.join(d, "vocab.u8"), "wb").write(bytes(vbm))
    vb = vocab_bytes(os.path.join(d, "vocab.u8"))
    assert len(vb) == 208
    n_stream, cut = 5000, 1006
    tok_all = rng.integers(0, 208, n_stream)
    stream = vb[tok_all]
    stream.tofile(os.path.join(d, "stream.bin"))
    pkg = os.path.join(d, "pkg")
    os.makedirs(pkg)
    tok_all[cut - 6:].astype(np.uint8).tofile(os.path.join(pkg, "ppmd-bytes.uint8"))
    json.dump({"shift": cut}, open(os.path.join(pkg, "dump-meta.json"), "w"))

    def run(name, wf, start, end, shift_rows=0):
        c = stream[wf:end]
        y = ((c[:, None] >> np.arange(7, -1, -1)[None, :]) & 1).astype(bool)
        x = rng.normal(0, 3, (end - wf, 8)) + np.where(y, 1.5, -1.5)
        forced = rng.random((end - wf, 8)) < 0.2
        x16 = np.where(forced, np.where(y, np.inf, -np.inf), x).astype(np.float16)
        fin = np.isfinite(x16)
        z = np.where(y, x16.astype(np.float64), -x16.astype(np.float64))[fin]
        if shift_rows:
            x16 = np.roll(x16, shift_rows, axis=0)
        x16.tofile(os.path.join(d, name + ".bits"))
        json.dump({"warm_from": wf, "kept_from": start, "end": end, "bits_out_rows": end - wf, "tf_off": 1,
                   "tap_bit_count": int(fin.sum()), "tap_total_bits": float(np.logaddexp(0, -z).sum() / np.log(2))},
                  open(os.path.join(d, name + ".json"), "w"))
        return "%s:%s" % (os.path.join(d, name + ".json"), os.path.join(d, name + ".bits"))

    a = run("a", 0, 0, 3000)
    b = run("b", 2500, 3000, 5000)                        # 500 bytes of warm-up, dropped
    out = os.path.join(d, "cmix-bits.float16")
    n = merge(os.path.join(d, "stream.bin"), pkg, out, os.path.join(d, "vocab.u8"), [a, b])
    m = np.memmap(out, dtype=np.float16, mode="r").reshape(-1, 8)
    ra = np.memmap(os.path.join(d, "a.bits"), dtype=np.float16, mode="r").reshape(-1, 8)
    rb = np.memmap(os.path.join(d, "b.bits"), dtype=np.float16, mode="r").reshape(-1, 8)
    c0 = cut - 6
    ok = n == n_stream - c0 and len(m) == n_stream - c0
    ok &= np.array_equal(m[:3000 - c0], ra[c0:3000], equal_nan=True) and np.array_equal(m[3000 - c0:], rb[500:], equal_nan=True)
    print("selftest merge of two runs, package coordinates:", "ok" if ok else "FAILED")
    try:                                                  # a dump shifted by one byte must be refused
        merge(os.path.join(d, "stream.bin"), pkg, out, os.path.join(d, "vocab.u8"), [run("c", 0, 0, 5000, shift_rows=1)])
        print("selftest shifted dump refused: FAILED")
        ok = False
    except AssertionError as e:
        print("selftest shifted dump refused: ok (%s)" % str(e)[:70])
    gap = merge(os.path.join(d, "stream.bin"), pkg, out, os.path.join(d, "vocab.u8"), [b])
    m = np.memmap(out, dtype=np.float16, mode="r").reshape(-1, 8)
    ok &= gap == 2000 and bool(np.isnan(m[:3000 - c0]).all()) and not bool(np.isnan(m[3000 - c0:]).any())
    print("selftest uncovered rows are NaN:", "ok" if ok else "FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    ap = argparse.ArgumentParser()
    ap.add_argument("--stream", required=True)
    ap.add_argument("--pkg", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--vocab", required=True)
    ap.add_argument("pairs", nargs="+")
    a = ap.parse_args()
    merge(a.stream, a.pkg, a.out, a.vocab, a.pairs)


if __name__ == "__main__":
    main()
