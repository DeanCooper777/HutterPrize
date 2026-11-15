#!/bin/bash
# linux_sub.sh: the end-to-end check of an entry on Linux: build the submission binary,
# compress enwik9 into the self-extracting archive, run the archive in an empty directory and
# compare its output with enwik9. Records sizes, wall times and peak memory of both programs.
# This is the procedure whose numbers go into SUBMISSION.md.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Linux Hutter Prize entry on a CPU pod (2026-11-09): build the submission
# exactly as upstream does (setup.sh toolchain, build_and_construct_comp.sh,
# PGO, clang 17, AVX2 + no-recip checks, upx), compress enwik9 with
# `./cmix -e enwik9 enwik9.comp` (writes the self-extracting archive9), then
# decompress archive9 in an empty directory and compare with enwik9.
# Inputs on the volume: /workspace/sub/{sub_src.tar.gz,enwik9.gz,enwik9.md5}
# (sub_src has models/6m-q4-fp32.tfwc2 = the extension weights).
#   ssh ... 'bash -s' < linux_sub.sh
# Log /workspace/logs/linux_sub.txt; results in /workspace/sub/out/.
set -u
W=/workspace
log=$W/logs/linux_sub.txt
mkdir -p $W/logs $W/sub/out
nohup setsid bash -c '
  set -u
  W=/workspace; S=$W/sub; OUT=$S/out; R=/root/sub
  t() { date -u "+%F %T"; }
  echo "$(t) linux submission build"
  if ! command -v clang++-17 > /dev/null; then
    apt-get update -q && apt-get install -y -q upx-ucl make wget lsb-release \
        software-properties-common gnupg binutils time > /dev/null
    wget -q https://apt.llvm.org/llvm.sh && bash llvm.sh 17 > /dev/null && rm llvm.sh
  fi
  clang++-17 --version | head -1; upx-ucl --version | head -1
  rm -rf $R && mkdir -p $R/c9 $R/d9 && cd $R
  tar xzf $S/sub_src.tar.gz
  md5sum fx2-cmix-T/models/6m-q4-fp32.tfwc2
  (cd fx2-cmix-T && ./build_and_construct_comp.sh) > $OUT/build.log 2>&1 || { echo "build failed"; tail -20 $OUT/build.log; echo "exit 1"; exit 1; }
  grep -E "check passed|no reciprocal" $OUT/build.log
  ls -la fx2-cmix-T/run/cmix; cp fx2-cmix-T/run/cmix $OUT/comp9
  gunzip -c $S/enwik9.gz > $R/c9/enwik9
  (cd $R/c9 && md5sum -c $S/enwik9.md5) || { echo "exit 1"; exit 1; }

  echo "$(t) compress"
  cd $R/c9 && cp $R/fx2-cmix-T/run/cmix . && s=$(date +%s)
  /usr/bin/time -v ./cmix -e enwik9 enwik9.comp > $OUT/comp.log 2> $OUT/comp.time
  rc=$?
  echo "$(t) compress rc $rc, $(( ($(date +%s) - s) / 60 )) min, max RSS $(grep Maximum $OUT/comp.time)"
  ls -la $R/c9 | grep -v temp
  [ $rc = 0 ] && [ -s archive9 ] || { echo "exit 1"; exit 1; }
  cp archive9 $OUT/archive9; rm -f $R/c9/enwik9 $R/c9/*.temp
  echo "comp9 $(stat -c %s $OUT/comp9) archive9 $(stat -c %s $OUT/archive9)"

  echo "$(t) decompress"
  cd $R/d9 && cp $OUT/archive9 . && s=$(date +%s)
  /usr/bin/time -v ./archive9 > $OUT/decomp.log 2> $OUT/decomp.time
  rc=$?
  echo "$(t) decompress rc $rc, $(( ($(date +%s) - s) / 60 )) min, max RSS $(grep Maximum $OUT/decomp.time)"
  md5sum enwik9_uncompressed | sed "s/enwik9_uncompressed/enwik9/" | diff - $S/enwik9.md5 > /dev/null \
    && echo "VERIFIED: enwik9_uncompressed == enwik9" || echo "MISMATCH"
  echo "exit 0"
' > "$log" 2>&1 < /dev/null &
nohup setsid bash $W/scripts/selfstop.sh "$log" > /dev/null 2>&1 < /dev/null &
sleep 3
cat "$log"; nproc; free -g | head -2; df -h /root | tail -1
