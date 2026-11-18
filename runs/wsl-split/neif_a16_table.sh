#!/bin/bash
# neif_a16_table.sh: the result table of the 16-bit activation experiment from
# /root/noble/work/a16_results.txt (kept bits per window and mask against mask 0 of the window).
R=/root/noble/work/a16_results.txt
python3 - "$R" <<'EOF'
import sys
rows = []
for ln in open(sys.argv[1]):
    f = ln.split()
    d = {f[i]: f[i + 1] for i in range(1, len(f) - 1) if f[i] in ('start', 'end', 'mask', 'kept_bits', 'total_bits', 'model_s', 'build', 'sha', 'warm_from')}
    d['name'] = f[0]
    rows.append(d)
base = {}
for d in rows:
    if d['mask'] == '0': base[(d['start'], d['end'])] = d
print('%-14s %10s %6s %14s %14s %10s %9s %9s' % ('run', 'start', 'mask', 'kept bits', 'off', 'diff', 'percent', 'tot %'))
for d in rows:
    b = base.get((d['start'], d['end']))
    if not b or d['build'].endswith('p'): continue
    k, k0 = float(d['kept_bits']), float(b['kept_bits'])
    t, t0 = float(d['total_bits']), float(b['total_bits'])
    print('%-14s %10s %6s %14.1f %14.1f %10.1f %8.4f%% %8.4f%%' % (d['name'], d['start'], d['mask'], k, k0, k - k0, 100 * (k - k0) / k0, 100 * (t - t0) / t0))
EOF
grep -ah "mlp.down calls" /root/noble/work/chunks/a16_*_2/log | sort -t' ' -k4 -n | tail -n 6
