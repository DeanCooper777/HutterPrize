#!/bin/bash
# neif_a16_tsum.sh [FILE]: one line per run of the raw timing file of neif_a16_time.sh:
# transformer section seconds, model seconds, user CPU seconds, rows with the network, column counts.
python3 - "${1:-/root/noble/work/a16_timing.txt}" <<'EOF'
import sys, re, json
runs = []
cur = None
for ln in open(sys.argv[1], errors='replace'):
    if ln.startswith('==='):
        f = ln.split()
        cur = {'name': f[1], 'mask': f[f.index('mask') + 1], 'bits': f[f.index('dnbits') + 1], 'js': ''}
        runs.append(cur)
    elif cur is None:
        continue
    elif ln.startswith('{') or ln.startswith(' "'):
        cur['js'] += ln
    elif 'transformer driver and network' in ln:
        cur['tf'] = float(ln.split()[3])
    elif ln.startswith('neif_rows'):
        m = re.search(r'\): (\d+), read rows (\d+)', ln)
        cur['rows'] = int(m.group(1)); cur['read'] = int(m.group(2))
    elif 'columns per call' in ln:
        cur['cols'] = ln.split('columns per call:')[1].strip()
    elif 'User time' in ln:
        cur['user'] = float(ln.split()[-1])
print('%-12s %5s %4s %9s %9s %9s %9s %10s %12s  %s' % ('run', 'mask', 'bits', 'tf s', 'model s', 'other s', 'user s', 'rows', 'tf us/row', 'columns'))
for r in runs:
    j = json.loads(r['js'])
    ms = j['model_seconds']
    print('%-12s %5s %4s %9.1f %9.1f %9.1f %9.1f %10d %12.2f  %s' % (r['name'], r['mask'], r['bits'], r.get('tf', 0), ms, ms - r.get('tf', 0), r.get('user', 0), r.get('rows', 0), 1e6 * r.get('tf', 0) / max(1, r.get('rows', 1)), r.get('cols', '')))
EOF
