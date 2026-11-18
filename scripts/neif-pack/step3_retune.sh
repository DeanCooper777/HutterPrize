#!/bin/bash
# step3_retune.sh: runs one bounded step of retune_neif.py on the cmix-neif image inside the chroot,
# or "check": decodes our model's stream of the cmix-neif image with pk's own decoder and with the
# test build of the stub decoder (cmix-T-dwc/packer/pkdec.c -DTEST), full and cut.
# Testing tool for the packer trial; not part of any submitted program.
#   step3_retune.sh check
#   step3_retune.sh init n_asis.cfg | sweep | drop N | rank FILE [LIMIT] | greedy TOPK ROUNDS MINGAIN
# One core (taskset), nice 19, one pkx at a time (about 250 MB).
set -eu
C=/root/noble; CORE=${CORE:-7}; P=/mnt/c/Dean/Projects/HutterPrize; W=$C/work/pk_trial
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
cp $P/scripts/neif-pack/*.py $W/scr/; cp $P/packer/off_pool.txt $W/ours/pool70.txt
if [ "$1" = check ]; then
cat > $W/in3.sh <<'EOF'
set -eu
cd /work/pk_trial
NF=619918; ND=538880
# (a) pk's own decoder, config with the skip range
./pkx c n_asis.cfg cmix.ss n_asis.pk; CUT=$(./pkx e n_asis.cfg cmix.ss | grep -o 'cut [0-9]*' | cut -d' ' -f2)
./pkx d n_asis.cfg n_asis.pk n_asis.out && cmp n_asis.out cmix.ss && echo "pkx d full: identical"
head -c $CUT n_asis.pk > n_asis_d.pk; ./pkx d n_asis.cfg n_asis_d.pk n_asis_d.out $ND
cmp <(head -c $ND n_asis_d.out) <(head -c $ND cmix.ss) && echo "pkx d cut ($CUT B): prefix identical"
# (b) the stub decoder's C source as a test program; it has no skip range, so the no-skip config
./pkx c n_noskip.cfg cmix.ss n_noskip.pk | tee n_noskip.rep; CUT=$(grep -o 'cut [0-9]*' n_noskip.rep | cut -d' ' -f2)
clang-18 -O2 -w -DTEST -DTEXT_LO=80368u -DTEXT_HI=${NF}u -DHOLE_LO=${ND}u -DHOLE_LEN=$((NF - ND))u ours/pkdec.c -o pkdec_test
s=$(date +%s%N); /usr/bin/time -v -o pkdec.time ./pkdec_test n_noskip.pk pkdec.out; echo "pkdec_test full: $(( ($(date +%s%N) - s) / 1000000 )) ms"
grep -E "Maximum resident" pkdec.time
cmp pkdec.out cmix.ss && echo "pkdec_test full: identical to the cmix-neif image"
head -c $CUT n_noskip.pk > n_noskip_d.pk
s=$(date +%s%N); ./pkdec_test n_noskip_d.pk pkdec_d.out x; echo "pkdec_test cut: $(( ($(date +%s%N) - s) / 1000000 )) ms"
{ head -c $ND cmix.ss; head -c $((NF - ND)) /dev/zero; } > want_d.ss
cmp pkdec_d.out want_d.ss && echo "pkdec_test cut ($CUT B): identical to the image with the compress-only segment zeroed"
EOF
nice -n 19 taskset -c $CORE chroot $C /bin/bash /work/pk_trial/in3.sh 2>&1 | tee $P/runs/neif-pack/step3_check.log
else
nice -n 19 taskset -c $CORE chroot $C /bin/bash -c "cd /work/pk_trial && python3 scr/retune_neif.py $*" 2>&1 | tail -n 40
cp $W/rt/log.txt $P/runs/neif-pack/retune_log.txt; cp $W/rt/cur.cfg $P/runs/neif-pack/retuned.cfg
[ -f $W/rt/rank.txt ] && cp $W/rt/rank.txt $P/runs/neif-pack/retune_rank.txt
fi
exit 0
