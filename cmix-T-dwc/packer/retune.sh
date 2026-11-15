#!/bin/bash
# retune.sh: re-tune the packer model (model.cfg) for one unpacked executable (development tool,
# new in this entry).   retune.sh ELF "HOLE_LO HOLE_HI" OUTDIR
# Steps: drop contexts that do not pay; rank all candidates (cands.txt); greedy add; parameter
# sweeps. Writes OUTDIR/tuned.cfg (contexts and settings only, the form of model.cfg) and a log.
# The result is only an estimate of the packed size; pack.sh is the real check. If the contexts
# change, cfg[] and NCTX in pkdec.c must be changed to match (pack.sh fails otherwise).
# Place in the whole: not run by the build; the packer it tunes replaces UPX (see pk.cpp).
# ELF is the unpacked executable (pack.sh saves one with PACK_KEEP_ELF=FILE); the hole range is
# what enc_only.py printed for it. After tuning: copy tuned.cfg to model.cfg, run cfg2c.py,
# regenerate stage1.s (pack.sh with PACK_STUB_REGEN=1).
set -eu
HERE=$(cd "$(dirname "$0")" && pwd); IN=$(realpath "$1"); read HL HH <<< "${2:-0 0}"; O=$(realpath -m "$3"); mkdir -p "$O"; cd "$O"
# code range of the executable, as in pack.sh
sec() { readelf -SW "$IN" | sed 's/\[ *[0-9]*\]//' | awk -v n="$1" '$1 == n { print $4, $5 }'; }
read o s < <(sec .text); LO=$((16#$o)); HI=$((16#$o + 16#$s))
if read o s < <(sec .fini) && [ -n "${o:-}" ]; then HI=$((16#$o + 16#$s)); fi
# build pk and the starting config: text / hole lines + the present model.cfg
${CXX:-clang++-17} -O2 -w -std=c++17 "$HERE/pk.cpp" -o pk
{ echo "text $LO $HI"; [ "$HH" -gt "$HL" ] && echo "hole $HL $HH"; cat "$HERE/model.cfg"; } > base.cfg
export PK_ELF=$IN PK_EXE=$O/pk PK_TMP=$O/tmp
# step 1 (the Python lines up to PY): repeatedly drop the context whose removal lowers the
# estimate most, until no removal helps -> t1.cfg
python3 - "$HERE" <<'PY'
import sys; sys.path.insert(0, sys.argv[1]); import search
t, c, s = search.load("base.cfg"); b = search.run((t, c, s)); print("base", b, flush=True)
while True:
    rs = search.runmany([(t, c[:i] + c[i + 1:], s) for i in range(len(c))]); r, i = min(zip(rs, range(len(c))))
    if r >= b: break
    print("drop", c[i], r, flush=True); b = r; c.pop(i)
search.save("t1.cfg", t, c, s)
PY
# step 2: measure every candidate context of cands.txt added alone to t1.cfg; keep the 70 best
# as the pool
python3 "$HERE/search.py" add t1.cfg "$HERE/cands.txt" > add.txt 2>&1; head -n 6 add.txt
awk 'NR > 1 && NR <= 71 { print $2 }' add.txt > pool.txt
# step 3: greedy additions from the pool while one gains at least 40 bytes, up to 40 contexts
# (note: pk.cpp and pkdec.c hold at most MAXIN = 160 mixer inputs, i.e. 38 contexts)
python3 "$HERE/search.py" greedy t1.cfg pool.txt t2.cfg 40 38
# step 4: sweep each parameter around its present value and print the estimates (the sweeps
# only report; they do not change t2.cfg)
for p in "lr1 10 11 12" "lr2 11 12 13" "rateB 7 8 9" "mm1 3 4 5 6" "mm2 2 3" "hist 4 5 6" "apr 5 6 7"; do
  python3 "$HERE/search.py" sweep t2.cfg $p | tr '\n' ';'; echo; done
grep -v "^text\|^hole" t2.cfg > tuned.cfg
echo "retune.sh: done; tuned.cfg has $(grep -c '^ctx' tuned.cfg) contexts"
