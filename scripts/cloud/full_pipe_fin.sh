#!/bin/bash
# full_pipe_fin.sh: as full_pipe_c2.sh, but for the "fin" source tarball made by make_fin.sh,
# in which the chosen settings are already the source defaults. Full-length enwik9
# COMPRESSION-only run in the multi-core test mode (CMIX_PIPE); a size measurement, not a
# valid entry. Outputs under /workspace/sub/out_fullfin/.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Full-length multi-core COMPRESSION of enwik9 with the "fin" source (make_fin.sh): settings are
# the source defaults; the only tune key is the PPMD memory budget. Compression only: the size is
# the result. The archive is NOT a valid entry (pipe build, upx packer).
#   ssh ... 'bash -s' < full_pipe_fin.sh
# Log /workspace/logs/full_pipe_fin.txt (selfstop watches it). Results /workspace/sub/out_fullfin/.
set -u
W=/workspace
log=$W/logs/full_pipe_fin.txt
mkdir -p $W/logs $W/sub/out_fullfin
THREADS=${THREADS:-6}
nohup setsid bash -c '
  set -u
  W=/workspace; S=$W/sub; OUT=$S/out_fullfin; R=/root/sub; L=$R/logs
  t() { date -u "+%F %T"; }
  save() { cp -f $L/* $OUT/ 2> /dev/null; }
  echo "$(t) build (fin pipe), threads '$THREADS'"; cat $S/fin_src.txt
  if ! command -v clang++-17 > /dev/null || [ ! -x /usr/bin/time ]; then
    apt-get update -q && apt-get install -y -q upx-ucl make wget lsb-release \
        software-properties-common gnupg binutils time > /dev/null
    wget -q https://apt.llvm.org/llvm.sh && bash llvm.sh 17 > /dev/null && rm llvm.sh
  fi
  clang++-17 --version | head -1; upx-ucl --version | head -1
  rm -rf $R && mkdir -p $R/c9 $L && cd $R
  tar xzf $S/fin_src.tar.gz
  md5sum fx2-cmix-T/models/6m-q4-fp32.tfwc2
  cd fx2-cmix-T
  sed -i "s/^CFLAGS_DEFINES=\"-DSEED=\$SEED -DUPDATE_LIMIT=\$UPDATE_LIMIT\"/CFLAGS_DEFINES=\"-DSEED=\$SEED -DUPDATE_LIMIT=\$UPDATE_LIMIT -DCMIX_PIPE\"/" build_and_construct_comp.sh
  sed -i "s/^CPPFLAGS_TRANSFORMER := /CPPFLAGS_TRANSFORMER := -DCMIX_PIPE -pthread /; s/^LFLAGS := /LFLAGS := -pthread /" makefile
  sed -i "/unknown parameter/{n;s/exit(1);//}" src/tune.h
  grep -c "DCMIX_PIPE" build_and_construct_comp.sh makefile
  ./build_and_construct_comp.sh > $L/build.log 2>&1 || { echo "build failed"; tail -20 $L/build.log; save; echo "exit 1"; exit 1; }
  cd $R
  grep -E "check passed|no reciprocal" $L/build.log
  ls -la fx2-cmix-T/run/cmix fx2-cmix-T/run/cmix_orig; cp fx2-cmix-T/run/cmix $OUT/comp9
  gunzip -c $S/enwik9.gz > $R/c9/enwik9
  (cd $R/c9 && md5sum -c $S/enwik9.md5) || { echo "exit 1"; exit 1; }
  printf "ppmd_rss_mb 60000\n" > $R/best.tune; cp $R/best.tune $OUT/

  echo "$(t) compress"
  cd $R/c9 && cp $R/fx2-cmix-T/run/cmix . && s=$(date +%s)
  CMIX_TUNE=$R/best.tune CMIX_TF_THREADS='$THREADS' /usr/bin/time -v ./cmix -e enwik9 enwik9.comp > $L/comp.log 2> $L/comp.time
  rc=$?
  echo "$(t) compress rc $rc, $(( ($(date +%s) - s) / 60 )) min, max RSS $(grep Maximum $L/comp.time)"
  grep "tf pipeline" $L/comp.time $L/comp.log
  ls -la $R/c9 | grep -v temp
  save
  [ $rc = 0 ] && [ -s archive9 ] || { echo "exit 1"; exit 1; }
  cp archive9 $OUT/archive9
  echo "comp9 $(stat -c %s $OUT/comp9) archive9 $(stat -c %s $OUT/archive9) S $(( $(stat -c %s $OUT/comp9) + $(stat -c %s $OUT/archive9) ))"
  echo "exit 0"
' > "$log" 2>&1 < /dev/null &
nohup setsid bash $W/scripts/selfstop.sh "$log" > /dev/null 2>&1 < /dev/null &
sleep 3
cat "$log"; nproc; free -g | head -2; df -h /root | tail -1
