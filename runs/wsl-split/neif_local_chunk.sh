#!/bin/bash
# neif_local_chunk.sh START END WARM NAME [BUILD_DIR] [TRACE] [KEEP] [PIPE] [PROF] [SPLIT]: one chunk run on this PC,
# inside the chroot /root/noble (stream /work/bed/stream.bin, results /work/chunks/NAME).
# TRACE=n logs bits and coder output every n stream bytes ("neif_trace" lines in the log);
# KEEP=1 keeps the coder output (/work/chunks/NAME/run/out.cmix).
# PIPE=n sets NEIF_PIPE (multi-process pipeline, 0 = single thread); PROF=1 sets NEIF_PROF (time
# table "neif_prof" in the log); SPLIT sets NEIF_PIPE_SPLIT (first transformer layer of the second
# stage for PIPE=3, default 8).
# Refuses to start while another cmix/comp9 runs (one such process fits this machine).
# Run in WSL as root.
set -eu
C=/root/noble
START=${1:?}; END=${2:?}; WARM=${3:?}; NAME=${4:?}; B=${5:-/work/tbp}; TRACE=${6:-0}; KEEP=${7:-0}; PIPE=${8:-0}; PROF=${9:-0}; SPLIT=${10:-8}
if pgrep -x cmix > /dev/null || pgrep -x comp9 > /dev/null; then echo "another cmix/comp9 is running"; exit 1; fi
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
cp /mnt/c/Dean/Projects/HutterPrize/runs/wsl-split/neif_run_chunk.sh $C/work/neif_run_chunk.sh
rm -rf $C/work/chunks/$NAME
chroot $C /usr/bin/env KEEP_OUT=$KEEP NEIF_T_TRACE=$TRACE NEIF_PIPE=$PIPE NEIF_PROF=$PROF NEIF_PIPE_SPLIT=$SPLIT /bin/bash /work/neif_run_chunk.sh $B /work/bed/stream.bin $START $END $WARM /work/chunks/$NAME
