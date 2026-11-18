#!/bin/bash
# neif_par_run.sh [BUILD_DIR] [CPU] [LEN] [WARM] [WINDOW_MB ...]: the NEIF_PAR measurement on the
# standard windows (default 60 250 420: stream bytes W M .. W M + LEN, LEN default 1000000, with
# WARM = 1000000 bytes of warm-up in front), one process per window, pinned to logical CPU number
# CPU (default 2; a fast core, see neif_a16_cores.sh), one after the other.
# About 12 minutes per window with the defaults (2 MB of model bytes at 2.8 kB/s).
# Per window NAME = par_<W>:
#   /root/noble/work/chunks/NAME/score.json   the chunk result (kept_bits must equal the reference
#                                              test build's on the same window: the measurement
#                                              changes no value)
#   /root/noble/work/chunks/NAME/par.json     the measurement (src/neif_test.h, par::Json)
#   /root/noble/work/chunks/NAME/log          neif_prof table and, in an FX2_PROF build, the
#                                              per-site table of the transformer (kept bytes only)
# At the end neif_par_bounds.py turns the three measurements into the bounds per mechanism and
# thread count: runs/neif-par/summary.json and a text table on stdout (copied to
# runs/neif-par/summary.txt).  Environment passed on: NEIF_PAR_H, NEIF_PAR_COMMIT (ticks);
# PAR_CORES, PAR_HANDOFF_US, PAR_L2_BONUS go to neif_par_bounds.py (--cores, --handoff-us,
# --l2-bonus).
# neif_local_chunk.sh refuses to start while another cmix/comp9 runs.  Run in WSL as root.
set -u
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
OUT=/mnt/c/Dean/Projects/HutterPrize/runs/neif-par
B=${1:-/work/tbpar}; CPU=${2:-2}; LEN=${3:-1000000}; WARM=${4:-1000000}
shift 4 2> /dev/null || shift $#
[ $# -gt 0 ] || set -- 60 250 420
CH=/root/noble/work/chunks
ARGS=""
for w in "$@"; do
  S=$((w * 1000000)); E=$((S + LEN)); NAME=par_$w
  export NEIF_PAR=1 NEIF_PAR_JSON=/work/chunks/$NAME/par.json
  taskset -c $CPU bash $W/neif_local_chunk.sh $S $E $WARM $NAME $B 0 1 0 1 > /dev/null 2>&1
  rc=$?
  if [ $rc -ne 0 ] || [ ! -f $CH/$NAME/score.json ] || [ ! -f $CH/$NAME/par.json ]; then
    echo "$NAME rc $rc FAILED"; tail -n 5 $CH/$NAME/log 2> /dev/null; continue
  fi
  sha=$(sha256sum $CH/$NAME/run/out.cmix | cut -c1-16); rm -f $CH/$NAME/run/out.cmix
  python3 -c "
import json
j=json.load(open('$CH/$NAME/score.json'))
print('$NAME start %d end %d warm_from %d kept_bits %.3f total_bits %.3f coded_bytes %d model_s %.1f sha $sha' % (j['start'],j['end'],j['warm_from'],j['kept_bits'],j['total_bits'],j['coded_bytes'],j['model_seconds']))
"
  # the same window of the plain test build, if it was run (16-bit experiment, mask 0): kept_bits must agree
  grep -h "start $S end $E " /root/noble/work/a16_results.txt 2> /dev/null | grep " mask 0 " | tail -n 1 | cut -c1-200
  grep -a "neif_prof single" $CH/$NAME/log | head -n 20
  ARGS="$ARGS $NAME=$CH/$NAME/par.json,$CH/$NAME/log"
done
[ -n "$ARGS" ] || { echo "no window ran"; exit 1; }
mkdir -p $OUT
python3 $W/neif_par_bounds.py ${PAR_CORES:+--cores $PAR_CORES} ${PAR_HANDOFF_US:+--handoff-us $PAR_HANDOFF_US} \
  ${PAR_L2_BONUS:+--l2-bonus $PAR_L2_BONUS} --out $OUT/summary.json $ARGS | tee $OUT/summary.txt
for w in "$@"; do cp $CH/par_$w/par.json $OUT/par_$w.json 2> /dev/null; done
echo "par run done"
