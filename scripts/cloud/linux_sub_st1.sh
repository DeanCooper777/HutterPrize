#!/bin/bash
# linux_sub_st1.sh: variant of linux_sub.sh (build, compress enwik9, decompress, compare) for
# one particular source snapshot; see the notes below for which one. It differs from
# linux_sub.sh only in the tarball it builds, the result directory, and in keeping its logs on
# local disk.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Full compress + decompress check of the "st1" stacked entry (2026-11-13).
# Same as linux_sub.sh, with: source /workspace/sub/st1_src.tar.gz, results in
# /workspace/sub/out_st1/, and all big/long-lived logs on the pod's LOCAL disk
# (/root/sub/logs), copied to the volume after each phase, so a full volume
# cannot lose the time/RSS numbers.
#   ssh ... 'bash -s' < linux_sub_st1.sh
# Log /workspace/logs/linux_sub_st1.txt (small; selfstop watches it).
set -u
W=/workspace
log=$W/logs/linux_sub_st1.txt
mkdir -p $W/logs $W/sub/out_st1
nohup setsid bash -c '
  set -u
  W=/workspace; S=$W/sub; OUT=$S/out_st1; R=/root/sub; L=$R/logs
  t() { date -u "+%F %T"; }
  save() { cp -f $L/* $OUT/ 2> /dev/null; }
  echo "$(t) linux submission build (st1)"
  if ! command -v clang++-17 > /dev/null || [ ! -x /usr/bin/time ]; then
    apt-get update -q && apt-get install -y -q upx-ucl make wget lsb-release \
        software-properties-common gnupg binutils time > /dev/null
    wget -q https://apt.llvm.org/llvm.sh && bash llvm.sh 17 > /dev/null && rm llvm.sh
  fi
  clang++-17 --version | head -1; upx-ucl --version | head -1
  rm -rf $R && mkdir -p $R/c9 $R/d9 $L && cd $R
  tar xzf $S/st1_src.tar.gz
  md5sum fx2-cmix-T/models/6m-q4-fp32.tfwc2
  (cd fx2-cmix-T && ./build_and_construct_comp.sh) > $L/build.log 2>&1 || { echo "build failed"; tail -20 $L/build.log; save; echo "exit 1"; exit 1; }
  grep -E "check passed|no reciprocal" $L/build.log
  ls -la fx2-cmix-T/run/cmix fx2-cmix-T/run/cmix_orig; cp fx2-cmix-T/run/cmix $OUT/comp9
  gunzip -c $S/enwik9.gz > $R/c9/enwik9
  (cd $R/c9 && md5sum -c $S/enwik9.md5) || { echo "exit 1"; exit 1; }

  echo "$(t) compress"
  cd $R/c9 && cp $R/fx2-cmix-T/run/cmix . && s=$(date +%s)
  /usr/bin/time -v ./cmix -e enwik9 enwik9.comp > $L/comp.log 2> $L/comp.time
  rc=$?
  echo "$(t) compress rc $rc, $(( ($(date +%s) - s) / 60 )) min, max RSS $(grep Maximum $L/comp.time)"
  ls -la $R/c9 | grep -v temp
  save
  [ $rc = 0 ] && [ -s archive9 ] || { echo "exit 1"; exit 1; }
  cp archive9 $OUT/archive9; rm -f $R/c9/enwik9 $R/c9/*.temp
  echo "comp9 $(stat -c %s $OUT/comp9) archive9 $(stat -c %s $OUT/archive9) S $(( $(stat -c %s $OUT/comp9) + $(stat -c %s $OUT/archive9) ))"

  echo "$(t) decompress"
  cd $R/d9 && cp $R/c9/archive9 . && s=$(date +%s)
  /usr/bin/time -v ./archive9 > $L/decomp.log 2> $L/decomp.time
  rc=$?
  echo "$(t) decompress rc $rc, $(( ($(date +%s) - s) / 60 )) min, max RSS $(grep Maximum $L/decomp.time)"
  save
  md5sum enwik9_uncompressed | sed "s/enwik9_uncompressed/enwik9/" | diff - $S/enwik9.md5 > /dev/null \
    && echo "VERIFIED: enwik9_uncompressed == enwik9" || echo "MISMATCH"
  echo "exit 0"
' > "$log" 2>&1 < /dev/null &
nohup setsid bash $W/scripts/selfstop.sh "$log" > /dev/null 2>&1 < /dev/null &
sleep 3
cat "$log"; nproc; free -g | head -2; df -h /root | tail -1
