#!/bin/bash
# neif_a16_show.sh PREFIX: short view of the result lines whose run name starts with PREFIX.
python3 - "${1:?prefix}" <<'EOF'
import sys
for ln in open('/root/noble/work/a16_results.txt'):
    f = ln.split()
    if not f or not f[0].startswith(sys.argv[1]): continue
    d = {f[i]: f[i + 1] for i in range(1, len(f) - 1)}
    print('%-16s start %s mask %-4s kept %s total %s model_s %s cpu %s sha %s' % (f[0], d['start'], d['mask'], d['kept_bits'], d['total_bits'], d['model_s'], d['model_cpu_s'], d['sha']))
EOF
