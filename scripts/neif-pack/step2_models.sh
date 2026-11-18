#!/bin/bash
# step2_models.sh: both packer models on both images, with per-byte cost files for the breakdown.
# Testing tool for the packer trial; not part of any submitted program.
# Needs step1_repro.sh to have run (the captured image cmix.ss and the rebuilt stub in
# /root/noble/work/pk_trial). One core (taskset), nice 19; the largest process is the cmix-neif model
# (about 1.5 GiB). Results are copied to runs/neif-pack/.
set -eu
C=/root/noble; CORE=${CORE:-7}; P=/mnt/c/Dean/Projects/HutterPrize; W=$C/work/pk_trial
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
mkdir -p $W/scr $W/ours
cp $P/scripts/neif-pack/*.py $P/scripts/neif-pack/*.c $W/scr/
cp $P/cmix-T-dwc/packer/pk.cpp $P/cmix-T-dwc/packer/model.cfg $P/cmix-T-dwc/packer/cands.txt $P/cmix-T-dwc/packer/pkdec.c $W/ours/
cp /root/b_fin/cmix.elf $W/ours.elf
cp $P/reference/neif2/src/src/bit_head_weights.h $W/bit_head_weights.h
cat > $W/in2.sh <<'EOF'
set -eu
cd /work/pk_trial
python3 scr/mk_pkx.py ours/pk.cpp pkx.cpp
clang++-18 -O2 -w -std=c++17 pkx.cpp -o pkx
clang++-18 -O2 -w -std=c++17 ours/pk.cpp -o pk_orig
gcc -O2 -w -Ipacker scr/neif_cost.c -o neif_cost -lm
S2T=$(cat s2text.txt)
cp ours.elf ours.ss; llvm-objcopy-18 --strip-sections ours.ss
echo "ours.elf $(stat -c %s ours.elf)  ours.ss $(stat -c %s ours.ss)  cmix.ss $(stat -c %s cmix.ss)"
# the cmix-neif image with the BITLSTM blob zeroed (README 4.9 note 5)
python3 - <<'PY'
import re
h = open("bit_head_weights.h").read(); b = h[h.index("kBlobW["):]; b = b[b.index("{") + 1:b.index("};")]
blob = bytes(int(x, 16) for x in re.findall(r"0x[0-9a-fA-F]+", b)); d = open("cmix.ss", "rb").read(); at = d.find(blob)
assert at >= 0 and d.find(blob, at + 1) < 0
open("cmix_z.ss", "wb").write(d[:at] + bytes(len(blob)) + d[at + len(blob):]); print("blob at", at, "len", len(blob))
PY
{ echo "text 80368 619918"; echo "skip 537120 538880"; echo "hole 538880 619918"; cat ours/model.cfg; } > n_asis.cfg
{ echo "text 80368 619918"; echo "hole 538880 619918"; cat ours/model.cfg; } > n_noskip.cfg
{ echo "text 13264 316973"; echo "hole 301382 316959"; cat ours/model.cfg; } > o_asis.cfg
t() { local s=$(date +%s%N); "$@"; echo "   [$(( ($(date +%s%N) - s) / 1000000 )) ms]"; }
echo "== original pk, our image (build log: 93698, cut 88650)"; t ./pk_orig e o_asis.cfg ours.elf
echo "== pkx, our image";                 PK_COST=c_pk_ours.f32 t ./pkx e o_asis.cfg ours.elf
echo "== pkx, our image, section table stripped"; PK_COST=c_pk_ourss.f32 t ./pkx e o_asis.cfg ours.ss
echo "== pkx, neif image, as is (skip)";  PK_COST=c_pk_neif.f32 t ./pkx e n_asis.cfg cmix.ss
echo "== pkx, neif image, no skip";       t ./pkx e n_noskip.cfg cmix.ss
echo "== pkx, neif image, blob zeroed";   t ./pkx e n_asis.cfg cmix_z.ss
echo "== neif model, neif image, warm (expect 203519 175966)"; t ./neif_cost cmix.ss 538880 c_nf_neif.f32 cutstub.s2.bin $S2T
echo "== neif model, neif image, no warm-up"; t ./neif_cost cmix.ss 538880 -
echo "== neif model, neif image, blob zeroed, warm (README: 188741-7919=180822, 161189-7919=153270)"; t ./neif_cost cmix_z.ss 538880 - cutstub.s2.bin $S2T
echo "== neif model, our image (stripped), their ranges, warm"; t ./neif_cost ours.ss 0 c_nf_ours.f32 cutstub.s2.bin $S2T
echo "== neif model, our image (stripped), code range .text only, warm"; CR="13264 316973 4194304" t ./neif_cost ours.ss 0 c_nf_ours_cr.f32 cutstub.s2.bin $S2T
echo; python3 scr/regions.py neif cmix.ss bit_head_weights.h pk=c_pk_neif.f32 neif=c_nf_neif.f32
echo; python3 scr/regions.py ours ours.ss pk=c_pk_ourss.f32 neif=c_nf_ours.f32 neif_cr=c_nf_ours_cr.f32
EOF
nice -n 19 taskset -c $CORE chroot $C /bin/bash /work/pk_trial/in2.sh 2>&1 | tee $P/runs/neif-pack/step2.log
cp $W/cmix.ss $W/pkx.cpp $W/*.cfg $P/runs/neif-pack/
