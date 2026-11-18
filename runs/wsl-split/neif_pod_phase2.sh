#!/bin/bash
# neif_pod_phase2.sh: full K=16 split evaluation on one pod, three passes chained (packed build):
#   1 compress, NEIF_PIPE=3, 16 splits at once, unpinned
#   2 verification decode (NEIF_PIPE=3 -u), 16 at once, unpinned
#   3 real decode (plain -u, one process), 16 at once, one physical core each; only if its projected
#     end (1.7 x the wall time of pass 1) is before DEADLINE, else splits 0,8,15 only
# Log: out/phase2.log (start and end of every pass); monitor: out/k16/monitor.tsv; after every pass
# the small result files are packed into /root/phase2_sync.tgz.
cd /root/neif || exit 1
O=out/k16; mkdir -p $O; L=out/phase2.log
DEADLINE=${DEADLINE:-2026-11-18 13:30}
say() { echo "$(date -u +%FT%TZ) $*" >> $L; }
sync_res() { tar czf /root/phase2_sync.tmp --exclude='out.cmix*' --exclude=run --exclude=drun out/k16 out/phase2.log out/p2_*.log 2> /dev/null && mv /root/phase2_sync.tmp /root/phase2_sync.tgz; }
ev() { bash scripts/neif_split_eval.sh build/tbK stream.bin 16 4000000 $O 3; }
pass() {   # NAME LOGFILE: runs ev with the environment given; one retry of what failed (the script resumes)
  echo "$1" > $O/.pass; say "$1 START"; local t0=$(date +%s)
  ev > "$2" 2>&1; local rc=$?
  if [ $rc -ne 0 ]; then say "$1 first attempt exit $rc: $(grep -h 'failed splits\|cmix exit' "$2" | tr '\n' ' '); retrying those"; ev > "$2.retry" 2>&1; rc=$?; fi
  PASS_S=$(( $(date +%s) - t0 )); say "$1 END exit $rc wall_s $PASS_S"
  echo idle > $O/.pass; sync_res
}
say "phase 2 driver start; host load before launch (2 min, every 10 s; busy = share of all host CPUs)"
python3 - >> $L <<'PY'
import time
def h():
    v = [int(x) for x in open("/proc/stat").readline().split()[1:]]; return sum(v), v[3] + v[4]
a = h()
for i in range(12):
    time.sleep(10); b = h()
    print("  %s loadavg %s host busy %.3f" % (time.strftime("%H:%M:%S", time.gmtime()), open("/proc/loadavg").read().split()[0], 1 - (b[1] - a[1]) / (b[0] - a[0]))); a = b
PY
python3 scripts/neif_pod_monitor.py $O 10 & MON=$!
export EMIT_DIR=/root/neif_res SLOTS=16
PIN=0 STEPS=compress pass PASS1_compress out/p2_compress.log; P1=$PASS_S
PIN=0 STEPS=decode DECODE=verify pass PASS2_verify out/p2_verify.log
est=$(( P1 * 17 / 10 )); end=$(( $(date +%s) + est )); lim=$(date -u -d "$DEADLINE" +%s)
if [ $end -le $lim ]; then
  say "pass 3 on all splits: projected $est s, end $(date -u -d @$end +%T) before the deadline"
  PIN=1 PIN_W=1 STEPS=decode DECODE=plain pass PASS3_decode out/p2_decode.log
else
  say "pass 3 on splits 0,8,15 only: projected $est s for all would end $(date -u -d @$end +%T), after the deadline"
  PIN=1 PIN_W=1 SLOTS=3 DEC_SPLITS=0,8,15 STEPS=decode DECODE=plain pass PASS3_decode out/p2_decode.log
fi
bash scripts/neif_split_eval.sh --summary $O 16 > out/p2_summary.log 2>&1; say "summary: $(cat out/p2_summary.log | tr '\n' ' ')"
kill $MON; sync_res
say "PHASE2 DONE"
