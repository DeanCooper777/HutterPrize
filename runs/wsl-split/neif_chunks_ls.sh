#!/bin/bash
# neif_chunks_ls.sh [NAME...]: one line per chunk result under /work/chunks (chroot /root/noble):
# range, times, bits, hashes, pipeline figures and the sha256 of a kept coder output.
cd /root/noble/work/chunks || exit 1
[ $# -gt 0 ] || set -- $(ls -d */ | tr -d /)
for d in "$@"; do
  [ -f $d/score.json ] || { echo "$d: no score.json"; continue; }
  python3 - $d <<'EOF'
import json, sys, os, hashlib, re
d = sys.argv[1]
r = json.load(open(d + "/score.json"))
t = open(d + "/time.txt").read() if os.path.exists(d + "/time.txt") else ""
def g(pat):
    m = re.search(pat, t)
    return m.group(1) if m else "?"
o = d + "/run/out.cmix"
sha = hashlib.sha256(open(o, "rb").read()).hexdigest()[:16] if os.path.exists(o) else "-"
print(f"{d}: [{r['start']},{r['end']}) warm_from {r['warm_from']} pipe {r.get('pipe', 0)} split {r.get('tf_split', 0)} | "
      f"bits {r['total_bits']:.3f} kept {r['kept_bits']:.3f} nbits {r['coded_bit_count']} hash {r['structure_hash']} "
      f"out {r['coded_bytes']} sha {sha} | wall {g('Elapsed.*: ([0-9:.]+)')} user {g('User time.*: ([0-9.]+)')} "
      f"sys {g('System time.*: ([0-9.]+)')} | skip {r['skip_seconds']} s model {r['model_seconds']} s "
      f"model_cpu {r.get('model_cpu_seconds', '?')} s | maxrss {r['peak_rss_kb']} kB pss {r.get('pipe_peak_pss_kb', 0)} kB")
EOF
done
