#!/bin/bash
# neif_par_one.sh NAME START END WARM BUILD_DIR PAR [CPU]: one single-process chunk run of a NEIF_PAR build
# (neif_par_build.sh), pinned to logical CPU number CPU (default 2), with NEIF_PAR=PAR (1: the
# measurement, result /root/noble/work/chunks/NAME/par.json, profile on; 0: the plain path, no
# profile).  Prints one line: bits, coded bytes, model seconds, bytes per second and the first 16
# hex digits of the sha256 of the coder output (the output itself is removed).
# Used for the identity check of the instrumentation on the reference chunk and for its overhead.
# Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
NAME=${1:?}; S=${2:?}; E=${3:?}; WM=${4:?}; B=${5:?}; PAR=${6:?}; CPU=${7:-2}
CH=/root/noble/work/chunks
export NEIF_PAR=$PAR NEIF_PAR_JSON=/work/chunks/$NAME/par.json
taskset -c $CPU bash $W/neif_local_chunk.sh $S $E $WM $NAME $B 0 1 0 $PAR > /dev/null 2>&1
rc=$?
if [ $rc -ne 0 ] || [ ! -f $CH/$NAME/score.json ]; then echo "$NAME rc $rc FAILED"; tail -n 5 $CH/$NAME/log; exit 1; fi
sha=$(sha256sum $CH/$NAME/run/out.cmix | cut -c1-16); rm -f $CH/$NAME/run/out.cmix
python3 -c "
import json
j=json.load(open('$CH/$NAME/score.json'))
print('$NAME build $B par $PAR start %d end %d warm_from %d total_bits %.3f kept_bits %.3f coded_bytes %d model_s %.1f bytes_per_s %.1f sha $sha' % (j['start'],j['end'],j['warm_from'],j['total_bits'],j['kept_bits'],j['coded_bytes'],j['model_seconds'],j['model_bytes_per_second']))
" | tee -a /root/noble/work/par_results.txt
