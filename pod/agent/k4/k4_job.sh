#!/bin/bash
# k4 (notes/k4-act16-2026-11-14.md): k4_job.sh build|wait ACT TAG. build: k3 src + k4 overlay, same make line as bin_k3
# (clang++-22, -DCMIX_PIPE -pthread on all objects), test_act16, 1 MB identity vs bin_k3 (ACT16 unset), sizes at 7/15,
# then split TAG with CMIX_ACT16=ACT. wait: wait for /workspace/split/bin_k4/IDENTITY_OK, then split. Ends "exit 0".
MODE=$1; ACT=$2; TAG=$3; W=/workspace; U=$W/upload; B=$W/split/bin_k4; L=/root/k4
mkdir -p $L $B; cd $L; echo "=== $(date -u) k4 $MODE ACT16=$ACT TAG=$TAG"; nproc; lscpu | grep "Model name"
if [ "$MODE" = build ] || [ "$MODE" = resume ]; then
  rm -f $B/IDENTITY_OK $B/FAILED
  if [ "$MODE" = build ]; then
  ( command -v clang++-22 > /dev/null || { apt-get update -q && apt-get install -y -q make wget lsb-release software-properties-common gnupg > /dev/null && wget -q https://apt.llvm.org/llvm.sh && bash llvm.sh 22 > /dev/null && rm llvm.sh; }
    rm -rf src && mkdir src && tar xzf $W/sub/k3_src.tar.gz -C src && tar xzf $W/sub/k4_overlay.tar.gz -C src/fx2-cmix-T && cd src/fx2-cmix-T
    sed -i 's/^CPPFLAGS_TRANSFORMER := \(.*\)$/CPPFLAGS_TRANSFORMER := \1 -DCMIX_PIPE -pthread/; s/^LFLAGS := \(.*\)$/LFLAGS := \1 -pthread/' makefile
    make CC=clang++-22 CFLAGS_DEFINES="-DSEED=923 -DUPDATE_LIMIT=3000 -DCMIX_PIPE -pthread" cmix ) > build.log 2>&1 || { echo "BUILD FAILED"; tail -20 build.log; touch $B/FAILED; echo "exit 0"; exit 0; }
  n=$(grep -c "clang++-22.* -c " build.log); np=$(grep "clang++-22.* -c " build.log | grep -c CMIX_PIPE); echo "compile lines $n, with CMIX_PIPE $np"
  [ "$n" = "$np" ] || { echo "BUILD CHECK FAILED"; touch $B/FAILED; echo "exit 0"; exit 0; }
  T=src/fx2-cmix-T/cpp_infer/src/opt; grep -m3 -i "clang\|build" $T/test_act16.cpp | head -3
  (cd $T && clang++-22 -O3 -march=x86-64-v3 -std=c++17 test_act16.cpp act16.cpp -o test_act16 && ./test_act16) > test.log 2>&1; echo "test rc $?"; grep -i -e "ALL OK" -e mismatch -e "ticks" -e FAIL test.log | head -20
  grep -q "ALL OK" test.log || { echo "KERNEL TEST FAILED"; tail -20 test.log; touch $B/FAILED; echo "exit 0"; exit 0; }
  cp src/fx2-cmix-T/cmix $B/cmix.part && mv $B/cmix.part $B/cmix; ls -la $B/cmix $W/split/bin_k3/cmix
  fi
  head -c 1000000 $U/stream.bin > s1m.bin; cp $W/split/w/c2.tfwc2 w.tfwc2
  # each run in its OWN directory: cmix's Linux PPMD heap file is ./ppm.temp (fixed name); a shared cwd corrupts all runs
  r1() { mkdir -p d_$1 && cd d_$1 && env $2 $3 -n ../s1m.bin o.cmix --raw-stream --official-vocab --transformer ../w.tfwc2 > log 2>&1; }
  ( r1 k3 X=0 $W/split/bin_k3/cmix ) & ( r1 k4 X=0 $B/cmix ) & ( r1 a7 CMIX_ACT16=7 $B/cmix ) & ( r1 a15 CMIX_ACT16=15 $B/cmix ) & wait
  sz() { stat -c%s d_$1/o.cmix 2>/dev/null || echo 0; }
  echo "1 MB: k3 $(sz k3) k4(unset) $(sz k4) k4 ACT16=7 $(sz a7) ACT16=15 $(sz a15)"
  if [ "$(sz k3)" -gt 1000 ] && cmp d_k3/o.cmix d_k4/o.cmix; then echo "IDENTITY OK (k4 unset == k3)"; touch $B/IDENTITY_OK; else echo "IDENTITY FAILED: $(cmp d_k3/o.cmix d_k4/o.cmix 2>&1)"; touch $B/FAILED; echo "exit 0"; exit 0; fi
else
  until [ -f $B/IDENTITY_OK ] || [ -f $B/FAILED ]; do sleep 30; done
  [ -f $B/FAILED ] && { echo "build pod failed: not running"; echo "exit 0"; exit 0; }
fi
echo "=== $(date -u) split $TAG CMIX_ACT16=$ACT"
export CMIX_TF_THREADS=1 CMIX_ACT16=$ACT
sed 's#BIN=$W/split/bin_k3#BIN=$W/split/bin_k4#' $W/agent/k3/split_eval_k3.sh > $L/split_eval_k4.sh
rm -rf $W/split/$TAG; bash $L/split_eval_k4.sh $TAG $W/split/w/c2.tfwc2 16 > $L/split.log 2>&1; grep -v "^exit" $L/split.log | tail -3
python3 - $TAG <<'PY'
import json, sys
t = sys.argv[1]; A = f"/workspace/split/{t}"; B = "/workspace/split/c2"; neg = 0; ra = []
ta = json.load(open(f"{A}/total.json"))["total_kept_bytes"]; tb = json.load(open(f"{B}/total.json"))["total_kept_bytes"]
for k in range(16):
    a = json.load(open(f"{A}/c{k}/score.json")); b = json.load(open(f"{B}/c{k}/score.json")); d = a["kept_bytes_est"] - b["kept_bytes_est"]; neg += d < 0; ra.append(a["seconds"] / b["seconds"])
    print(f"chunk {k:2d} d {d:+8,.0f}  secs {a['seconds']} (c2 {b['seconds']}, x{a['seconds'] / b['seconds']:.3f})")
print(f"SPLIT {t} {ta:,.0f} vs c2 {tb:,.0f}: delta {ta - tb:+,.0f}, {neg}/16 chunks better, time ratio mean x{sum(ra) / 16:.3f} max x{max(ra):.3f}")
PY
echo "$(date -u) k4 $TAG done"; echo "exit 0"
