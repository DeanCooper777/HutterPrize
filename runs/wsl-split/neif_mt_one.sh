#!/bin/bash
# neif_mt_one.sh NAME MODE START END WARM BUILD_DIR MT [CPUS] [CHUNK_NAME]: one chunk run of a NEIF_MT build
# (neif_mt_build.sh) inside the chroot /root/noble, results in /work/chunks/NAME.
#   MODE t  code stream bytes [warm_from, END) (`cmix -t`); the coder output stays in
#           /work/chunks/NAME/run/out.cmix
#   MODE u  decode the coder output of the `t` run CHUNK_NAME (same START END WARM) with `cmix -u`
#           and compare every byte with the stream
#   MT      NEIF_MT: threads of the transformer step (0 = the single-thread path)
#   CPUS    NEIF_MT_CPUS, the logical CPUs of the threads (default 0,1,2,3); the process itself is
#           started on the first of them
# Environment passed on: NEIF_MT_PIN, NEIF_MT_TEST, NEIF_MT_SPEC, NEIF_MT_FAULT, NEIF_PROF, NEIF_PIPE.
# NEIF_PIPE=2|3 with MODE u is the validation decode (the front stages of the pipeline walk the stream, the
# coder stage decodes and compares); its processes are not bound to a CPU.
# MT_STREAM names another expected stream (default /work/bed/stream.bin), for the negative tests.
# One line per run on stdout and in /root/noble/work/mt_results.txt.
# Refuses to start while another cmix/comp9 runs.  Run in WSL as root.
set -u
C=/root/noble
NAME=${1:?}; MODE=${2:?}; S=${3:?}; E=${4:?}; WM=${5:?}; B=${6:?}; MT=${7:?}; CPUS=${8:-0,1,2,3}; CN=${9:-}
if pgrep -x cmix > /dev/null || pgrep -x comp9 > /dev/null; then echo "another cmix/comp9 is running"; exit 1; fi
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
O=/work/chunks/$NAME
ST=${MT_STREAM:-/work/bed/stream.bin}
PIPE=${NEIF_PIPE:-0}
rm -rf $C$O
cat > $C/work/mt_one_in.sh <<EOF
mkdir -p $O/run && cd $O/run || exit 1
ln -sf $B/weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5 .
export NEIF_T_START=$S NEIF_T_END=$E NEIF_T_WARM=$WM NEIF_T_JSON=$O/score.json NEIF_MT=$MT NEIF_MT_CPUS=$CPUS
if [ $MODE = t ]; then
  /usr/bin/time -v -o $O/time.txt $B/cmix -t $ST $O/run/out.cmix > $O/log 2>&1
else
  /usr/bin/time -v -o $O/time.txt $B/cmix -u $ST /work/chunks/$CN/run/out.cmix > $O/log 2>&1
fi
echo \$? > $O/rc
rm -f $O/run/ppm.page $O/run/.dict $O/run/.dict.ta
EOF
if [ "$PIPE" -gt 1 ]; then chroot $C /bin/bash /work/mt_one_in.sh
else taskset -c ${CPUS%%,*} chroot $C /bin/bash /work/mt_one_in.sh; fi
rc=$(cat $C$O/rc 2> /dev/null || echo 99)
if [ ! -f $C$O/score.json ]; then
  echo "$NAME $MODE pipe $PIPE rc $rc NO RESULT FILE: $(tr '\r' '\n' < $C$O/log | grep -a 'neif_sv\|neif_pipe: ' | tr '\n' ' ' | cut -c1-300)" | tee -a $C/work/mt_results.txt
  [ "$rc" -ne 0 ] && exit $rc
  exit 1
fi
sha=-; [ $MODE = t ] && sha=$(sha256sum $C$O/run/out.cmix | cut -c1-16)
python3 -c "
import json
j=json.load(open('$C$O/score.json'))
if '$MODE'=='t':
    print('$NAME t mt $MT cpus $CPUS rc $rc start %d end %d warm_from %d total_bits %.3f model_s %.1f bytes_per_s %.1f sha $sha' % (j['start'],j['end'],j['warm_from'],j['total_bits'],j['model_seconds'],j['model_bytes_per_second']))
else:
    print('$NAME u mt $MT cpus $CPUS rc $rc start %d end %d warm_from %d decoded %d wrong %d first_wrong %d model_s %.1f bytes_per_s %.1f pipe %d cpu_s %.1f pss_mb %.0f rss_mb %.0f' % (j['start'],j['end'],j['warm_from'],j['decoded_bytes'],j['wrong_bytes'],j['first_wrong_byte'],j['model_seconds'],j['model_bytes_per_second'],j.get('pipe',0),j.get('model_cpu_seconds',0),j.get('pipe_peak_pss_kb',0)/1024.0,j['peak_rss_kb']/1024.0))
" | tee -a $C/work/mt_results.txt
tr '\r' '\n' < $C$O/log | grep -a "neif_mt\|neif_sv: " | tail -n 3
exit $rc   # the exit code of cmix: 0 pass; 4 a wrong byte; 3 the pipeline broke; 5 the stream could not be read
