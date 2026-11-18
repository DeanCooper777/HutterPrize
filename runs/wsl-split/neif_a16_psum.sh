#!/bin/bash
# neif_a16_psum.sh [FILE]: per-site ticks per transformer row of the FX2_PROF runs in a raw
# timing file (neif_a16_time2.sh), every run next to the first "off" run. The time-stamp ticks
# of the sites a variant does not touch give the speed ratio of the two runs (machine drift);
# the difference of the touched sites is given raw and with that ratio taken out.
python3 - "${1:-/root/noble/work/a16_timing_pf.txt}" <<'EOF'
import sys, re
runs = []; cur = None; intab = False
for ln in open(sys.argv[1], errors='replace'):
    if ln.startswith('==='):
        cur = {'name': ln.split()[1], 'sites': {}, 'rows': 1, 'tf': 0.0}; runs.append(cur); intab = False
    elif cur is None: continue
    elif ln.startswith('neif_rows'):
        cur['rows'] = int(re.search(r'\): (\d+), read rows', ln).group(1))
    elif 'transformer driver and network' in ln:
        cur['tf'] = float(ln.split()[3])
    elif ln.startswith('  site'): intab = True
    elif intab and ln.startswith('  ') and not ln.startswith('  --'):
        m = re.match(r'  (.{32}) +(\d+) +([\d.]+)% +([\d.]+)', ln)
        if m: cur['sites'][m.group(1).strip()] = float(m.group(2))
touched = ['kimi out proj (9)', 'van out proj (3)', 'mlp up + relu2q (12)', 'mlp down spmv (12)', 'attnout quant (12)', 'norm+quant mlp (12)']
skip = ['zblock run (spans sites)']
base = runs[0]
for r in runs:
    rows = r['rows']
    tot = sum(v for k, v in r['sites'].items() if k not in skip)
    un = sum(v for k, v in r['sites'].items() if k not in skip and k not in touched)
    un0 = sum(v for k, v in base['sites'].items() if k not in skip and k not in touched)
    tot0 = sum(v for k, v in base['sites'].items() if k not in skip)
    ratio = un / un0
    print('%s: rows %d, transformer %.1f s, ticks/row all sites %.0f (off %.0f), untouched sites %.0f (ratio to off %.4f), ticks per second of transformer time %.3e' % (r['name'], rows, r['tf'], tot / rows, tot0 / base['rows'], un / rows, ratio, tot / max(r['tf'], 1e-9)))
    dsum = 0.0
    for k in touched:
        a = r['sites'].get(k, 0) / rows; b = base['sites'].get(k, 0) / base['rows']
        d = a / ratio - b
        dsum += d
        print('   %-24s %9.0f  off %9.0f  diff raw %8.0f  drift-corrected %8.0f ticks/row' % (k, a, b, a - b, d))
    print('   touched sites together: drift-corrected %+.0f ticks/row = %+.2f %% of all sites' % (dsum, 100 * dsum / (tot0 / base['rows'])))
EOF
