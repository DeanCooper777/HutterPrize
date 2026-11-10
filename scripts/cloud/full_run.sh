#!/bin/bash
# Full single-process enwik9 runs on a CPU pod (2026-11-09): code the whole
# preprocessed stream (upload/stream.bin, the Windows build's -e stream) with
# --raw-stream, one process per weight set, in parallel (one core each).
# Running the current weights too calibrates the method against the real
# Windows run (enwik9.comp 93,846,889 bytes, archive9.exe 97,816,169).
#   ssh ... "bash -s base:/workspace/split/w/6m-q4-fp32.tfwc2 ext:/workspace/split/w/6m-q4-fp32-ext.tfwc2" < full_run.sh
# Log /workspace/logs/full9.txt; results /workspace/full9/TAG.{size,log}.
set -u
W=/workspace
OUT=$W/full9
L=/root/full9
mkdir -p "$OUT" "$L" $W/logs
log=$W/logs/full9.txt
nohup setsid bash -c '
  W=/workspace OUT=$W/full9 L=/root/full9
  echo "$(date -u) full runs: $*"
  [ -f $W/upload/stream.bin ] || gunzip -k $W/upload/stream.bin.gz
  cp $W/upload/stream.bin $W/split/bin/cmix $L/
  (cd $L && sha256sum -c $W/upload/stream.sha256 2>&1 | sed "s,^,  ,")
  for spec in "$@"; do
    tag=${spec%%:*} w=${spec#*:}
    cp "$w" $L/$tag.tfwc2; md5sum $L/$tag.tfwc2
    (
      # one directory per job: cmix keeps temp files (.cmix.temp, ppm) in the
      # working directory, and two jobs sharing one crashed (bus error, 2026-11-09)
      t0=$(date +%s)
      mkdir -p $L/$tag && cd $L/$tag && ln -sf ../stream.bin ../cmix ../$tag.tfwc2 . || exit 1
      ./cmix -n stream.bin $tag.cmix --raw-stream --official-vocab \
          --transformer $tag.tfwc2 > $tag.log 2>&1
      rc=$?
      s=$(stat -c %s $tag.cmix)
      cp $tag.log $OUT/$tag.log; echo $s > $OUT/$tag.size
      echo "$(date -u) $tag rc $rc: $s bytes, $(( ($(date +%s) - t0) / 60 )) min"
    ) &
  done
  wait
  echo "exit 0"
' full9 "$@" > "$log" 2>&1 < /dev/null &
nohup setsid bash $W/scripts/selfstop.sh "$log" > /dev/null 2>&1 < /dev/null &
sleep 3
cat "$log"; nproc; free -g | head -2
