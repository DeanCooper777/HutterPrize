#!/bin/bash
# Re-tune the packer model on the official binary: drop, rank all candidates, greedy add, parameter sweeps.
cd /c/Dean/Projects/HutterPrize/packer; export PK_ELF=cmix_off.elf
python - <<'PY'
import search
t,c,s = search.load("off0.cfg"); b = search.run((t,c,s)); print("base", b, flush=True)
while True:
    rs = search.runmany([(t, c[:i]+c[i+1:], s) for i in range(len(c))]); r,i = min(zip(rs, range(len(c))))
    if r >= b: break
    print("drop", c[i], r, flush=True); b = r; c.pop(i)
search.save("off1.cfg", t, c, s)
PY
python search.py add off1.cfg cands.txt > off_add.txt 2>&1; head -8 off_add.txt
awk 'NR>1 && NR<=71 {print $2}' off_add.txt > off_pool.txt
python search.py greedy off1.cfg off_pool.txt off2.cfg 60 40
for p in "lr1 10 11 12" "lr2 11 12 13" "rateB 1 2 3" "mm1 4 5 6" "mm2 2 3" "hist 4 5 6" "apr 5 6 7" "limA 127 255"; do python search.py sweep off2.cfg $p | tr '\n' ';'; echo; done
