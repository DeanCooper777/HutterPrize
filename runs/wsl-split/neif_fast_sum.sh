#!/bin/bash
# neif_fast_sum.sh [PREFIX]: short view of the lines of /root/noble/work/mt_results.txt whose run
# name starts with PREFIX (default f_): name, mode, threads, seconds, sha or wrong bytes, pipe.
python3 - "${1:-f_}" <<'EOF'
import sys
seen = {}
for ln in open('/root/noble/work/mt_results.txt', errors='replace'):
    f = ln.split()
    if len(f) < 4 or not f[0].startswith(sys.argv[1]): continue
    seen[f[0]] = f
for name, f in seen.items():
    def g(k):
        return f[f.index(k) + 1] if k in f else '-'
    print('%-12s %s mt %s cpus %-8s model_s %7s  %s' % (name, f[1], g('mt'), g('cpus'), g('model_s'),
          ('sha ' + g('sha')) if f[1] == 't' else ('decoded %s wrong %s pipe %s cpu_s %s pss_mb %s' % (g('decoded'), g('wrong'), g('pipe'), g('cpu_s'), g('pss_mb')))))
EOF
