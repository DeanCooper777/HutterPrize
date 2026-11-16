# Gate 0 of the "bigger tokens" idea: how many transformer steps would a coarser tokenisation of the
# cmix-neif 2.0 coder stream save?  The transformer now takes one step per stream byte.
# Dictionary codes (src/preprocess/dictionary.cpp): prefix bytes 0xD0..0xFF, last byte 0x80..0xCF.
#   python3 neif_tokcount.py STREAM [TEXT_START=16500000]
import re, sys
f = sys.argv[1]; t0 = int(sys.argv[2]) if len(sys.argv) > 2 else 16500000
d = open(f, 'rb').read(); n = len(d)
print('stream bytes', n, ' distinct values', len(set(d[:50000000])))
def cnt(pat, s):
    return sum(1 for _ in re.finditer(pat, s, re.S))
for name, s in (('head [0,%d)' % t0, d[:t0]), ('text [%d,end)' % t0, d[t0:])):
    m = len(s)
    hist = [s.count(bytes([v])) for v in range(256)]
    pre = sum(hist[0xD0:]); last = sum(hist[0x80:0xD0]); sp = hist[32]
    lets = sum(hist[97:123]) + sum(hist[65:91]); digs = sum(hist[48:58])
    print('---', name, m, 'bytes')
    print(' code prefix bytes %d (%.2f%%)  code end bytes %d (%.2f%%)  spaces %d (%.2f%%)  letters %d (%.2f%%)  digits %d (%.2f%%)'
          % (pre, 100.0 * pre / m, last, 100.0 * last / m, sp, 100.0 * sp / m, lets, 100.0 * lets / m, digs, 100.0 * digs / m))
    # A: one token per dictionary code (saves the prefix bytes)
    a = m - pre
    # B: A, and a space directly behind a code joins the code's token
    cs = cnt(rb'[\x80-\xcf] ', s); b = a - cs
    # C: B, and each run of plain letters / of digits is one token (upper bound for a sub-word vocabulary)
    lr = cnt(rb'[A-Za-z]+', s); dr = cnt(rb'[0-9]+', s)
    c = b - (lets - lr) - (digs - dr)
    for k, v in (('A code = 1 token', a), ('B + space behind a code', b), ('C + letter runs, digit runs (upper bound)', c)):
        print(' %-44s %11d tokens  %.3f of the bytes  (-%.1f%% steps)' % (k, v, v / m, 100.0 * (m - v) / m))
