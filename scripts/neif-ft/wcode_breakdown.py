#!/usr/bin/env python3
# wcode_breakdown.py: testing tool, not part of any submitted program.
#
# Size breakdown of the cmix-neif 2.0 weight container (format NP2) per tensor.
#
#   wcode_breakdown.py <shipped NP2 container> <out dir>
#
# 1. reads the container with the authors' reader (np2_container.read_container);
# 2. writes the decoded tensors, in the stored order, as <out dir>/shipped.raw (FX2TFW01
#    layout: the input of wcode_exp.c);
# 3. runs the authors' writer functions (code_head / code_values) over the same tensors
#    with the NP2 stream structure (stream A, model resets, stream B) but with a "cost
#    encoder" in place of the range coder: it sums -log2 of the 11-bit probability the
#    coder is given for every coded bit.  The sum per stream is compared with the real
#    stream lengths in the container header, so the per-tensor numbers are the real ones
#    up to the range coder's rounding;
# 4. writes <out dir>/breakdown.tsv (one line per tensor) and prints the totals per class.
#
# numpy only, one core, idle priority (set below on Windows).  About 3 minutes.
import math
import os
import struct
import sys

if os.name == "nt":  # idle priority: another job on this PC is being timed
    import ctypes
    ctypes.windll.kernel32.SetPriorityClass(ctypes.windll.kernel32.GetCurrentProcess(), 0x40)

HERE = os.path.dirname(os.path.abspath(__file__))
NEIF2 = os.environ.get("NEIF2", os.path.join(HERE, "..", "..", "reference", "neif2", "dev"))
sys.path.insert(0, os.path.join(NEIF2, "training", "tf", "3_train", "export", "np2"))
import np2_container as npc  # noqa: E402

wc = npc.wc
C0 = [0.0] + [-math.log2(p / 2048.0) for p in range(1, 2048)]
C1 = [0.0] + [-math.log2(1.0 - p / 2048.0) for p in range(1, 2048)]


class CostEncoder:
    """same interface as BinEncoder, same model updates, sums the ideal code length"""

    def __init__(self):
        self.bits = 0.0

    def encode_tree(self, probs, nbits, symbol):
        node = 1
        b = 0.0
        for k in range(nbits - 1, -1, -1):
            bit = (symbol >> k) & 1
            p = probs[node]
            if bit:
                b += C1[p]
                probs[node] = p - (p >> 5)
            else:
                b += C0[p]
                probs[node] = p + ((2048 - p) >> 5)
            node = (node << 1) | bit
        self.bits += b

    def encode_ctree(self, tree, nbits, symbol, limit):
        t0, t1 = tree
        node = 1
        b = 0.0
        for k in range(nbits - 1, -1, -1):
            bit = (symbol >> k) & 1
            n0 = t0[node]
            n1 = t1[node]
            p = (2048 * n0) // (n0 + n1)
            if p < 1:
                p = 1
            elif p > 2047:
                p = 2047
            if bit:
                b += C1[p]
                n1 += 1
            else:
                b += C0[p]
                n0 += 1
            if n0 + n1 > limit:
                n0 = (n0 >> 1) or 1
                n1 = (n1 >> 1) or 1
            t0[node] = n0
            t1[node] = n1
            node = (node << 1) | bit
        self.bits += b


def klass(name, code, enc):
    """tensor class for the report"""
    if enc in (wc.ENC_ROPE_SIN, wc.ENC_ROPE_COS):
        return "rope (recomputed)"
    if name.endswith(".weight.q") or enc == wc.ENC_INT4W:
        cn = wc._canon_name(name)[0]
        if ".mlp.up." in cn:
            return "q mlp.up"
        if ".mlp.down." in cn:
            return "q mlp.down"
        if ".attention." in cn:
            if "gate_projection" in cn:
                return "q attn gates"
            return "q attn q/k/v/out"
        return "q embeddings/other"
    if name.endswith(".weight.scale"):
        return "row scales (bf16)"
    if code == wc.DTYPE_BF16_BITS:
        return "other bf16"
    if code == wc.DTYPE_FLOAT32:
        return "f32 (conv, bias, norm, mix)"
    return "config / int32 / raw"


def main():
    src, outdir = sys.argv[1], sys.argv[2]
    os.makedirs(outdir, exist_ok=True)
    data = open(src, "rb").read()
    magic = data[:8]
    n, nA, lenA, K = struct.unpack("<4I", data[8:24])
    lenB_stored = len(data) - 24 - lenA
    print("container %d B, magic %r: header 24 B, %d tensors, %d in stream A; stream A %d B, "
          "stream B stored %d B + carried K = %d B" % (len(data), magic, n, nA, lenA, lenB_stored, K))
    es = npc.read_container(src)
    npc.write_raw(es, os.path.join(outdir, "shipped.raw"))
    np2 = magic == npc.MAGIC_NP2
    gs = npc.np_groups(es, True, np2)
    keyflag = [0] * len(es)
    for g in gs:
        keyflag[g.key] = g.flag
    enc = npc.encodings(es, True)
    ce, models, tmpl = CostEncoder(), wc._ModelsV3(v4=True, v5=True), wc._Template()
    rows = []
    stream_bits = [0.0, 0.0]
    for i, e in enumerate(es):
        if i == nA:
            npc.reset_for_b(models, np2)
        s = 0 if i < nA else 1
        b0 = ce.bits
        cn = npc.code_head(ce, models, tmpl, e, enc[i] | (keyflag[i] if s == 0 else 0))
        b1 = ce.bits
        npc.code_values(ce, models, e, enc[i], cn)
        b2 = ce.bits
        stream_bits[s] += b2 - b0
        rows.append((e.name, e.code, "x".join(map(str, e.a.shape)), enc[i], "AB"[s],
                     klass(e.name, e.code, enc[i]), e.a.size, b1 - b0, b2 - b1))
    with open(os.path.join(outdir, "breakdown.tsv"), "w") as f:
        f.write("name\tdtype\tshape\tenc\tstream\tclass\telements\thead_bits\tvalue_bits\n")
        for r in rows:
            f.write("%s\t%d\t%s\t%d\t%s\t%s\t%d\t%.2f\t%.2f\n" % r)
    print("ideal length stream A %.1f B (real %d B), stream B %.1f B (real %d B incl. the K carried)"
          % (stream_bits[0] / 8, lenA, stream_bits[1] / 8, lenB_stored + K))
    tot = {}
    for r in rows:
        t = tot.setdefault(r[5], [0, 0, 0.0])
        t[0] += 1
        t[1] += r[6]
        t[2] += r[8]
    head = sum(r[7] for r in rows)
    print("%-30s %7s %10s %12s %9s" % ("class", "tensors", "elements", "bytes", "bits/el"))
    for k, t in sorted(tot.items(), key=lambda kv: -kv[1][2]):
        print("%-30s %7d %10d %12.1f %9.4f" % (k, t[0], t[1], t[2] / 8, t[2] / max(t[1], 1)))
    print("%-30s %7d %10s %12.1f" % ("names + metadata (all tensors)", len(rows), "", head / 8))
    print("%-30s %7s %10s %12d" % ("container header", "", "", 24))
    print("%-30s %7s %10s %12d" % ("carried by the orders (-K)", "", "", -K))
    print("groups %d, capacity K %d B" % (len(gs), npc.capacity_bytes(gs)))
    with open(os.path.join(outdir, "groups.tsv"), "w") as f:
        f.write("group\tkey_tensor\tflag\tr0\tn\trows_at\telem_at\tcols_at\n")
        for g in gs:
            f.write("%s\t%s\t0x%02x\t%d\t%d\t%s\t%s\t%s\n" % (
                g.name, es[g.key].name, g.flag, g.r0, g.n,
                ",".join("%s@%d" % (es[t].name, o) for t, o in g.rows_at),
                ",".join("%s@%d" % (es[t].name, o) for t, o in g.elem_at),
                ",".join("%s@%d" % (es[t].name, o) for t, o in g.cols_at)))


if __name__ == "__main__":
    main()
