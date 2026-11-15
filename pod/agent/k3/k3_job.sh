#!/bin/bash
# k3 multi-core compress test (notes/pipe-2026-11-14.md). Log /workspace/logs/k3_job.txt, ends "exit 0" (selfstop).
set -u
W=/workspace; U=$W/upload; L=/root/k3; BIN=$W/split/bin_k3; OUT=$W/split/k3pipe; WT=$W/split/w/st1.tfwc2
mkdir -p $L $BIN $OUT; cd $L
t() { date -u "+%F %T"; }
echo "$(t) k3 job"; nproc; lscpu | grep -E "Model name|^CPU\(s\)|Thread|Core|Socket|L1d|L2|L3|NUMA node\(s\)"; free -g | head -2
# 1. build: split make line (st1 split: clang++-22, SEED/UPDATE_LIMIT, non-PGO) + -DCMIX_PIPE on ALL objects + -pthread
( command -v clang++-22 > /dev/null || { apt-get update -q && apt-get install -y -q make wget lsb-release software-properties-common gnupg > /dev/null && wget -q https://apt.llvm.org/llvm.sh && bash llvm.sh 22 > /dev/null && rm llvm.sh; }
  rm -rf src && mkdir src && tar xzf $W/sub/k3_src.tar.gz -C src && cd src/fx2-cmix-T
  sed -i 's/^CPPFLAGS_TRANSFORMER := \(.*\)$/CPPFLAGS_TRANSFORMER := \1 -DCMIX_PIPE -pthread/; s/^LFLAGS := \(.*\)$/LFLAGS := \1 -pthread/' makefile
  grep -n "^CPPFLAGS_TRANSFORMER :=\|^LFLAGS :=" makefile
  make CC=clang++-22 CFLAGS_DEFINES="-DSEED=923 -DUPDATE_LIMIT=3000 -DCMIX_PIPE -pthread" cmix ) > $L/build.log 2>&1 || { echo "BUILD FAILED"; tail -20 $L/build.log; echo "exit 0"; exit 0; }
n_cc=$(grep -c "clang++-22.* -c " $L/build.log); n_pipe=$(grep "clang++-22.* -c " $L/build.log | grep -c CMIX_PIPE)
echo "compile lines $n_cc, with -DCMIX_PIPE $n_pipe"; [ "$n_cc" = "$n_pipe" ] || { echo "BUILD CHECK FAILED: not all objects have -DCMIX_PIPE"; echo "exit 0"; exit 0; }
cp $L/src/fx2-cmix-T/cmix $BIN/cmix; ls -la $BIN/cmix
cp $WT $L/w.tfwc2; md5sum $L/w.tfwc2
head -c 2000000 $U/stream.bin > s2m.bin
run() { tag=$1; th=$2; s=$(date +%s.%N)
  if [ "$th" = none ]; then $BIN/cmix -n s2m.bin o_$tag.cmix --raw-stream --official-vocab --transformer w.tfwc2 > log_$tag 2>&1
  else CMIX_TF_THREADS=$th $BIN/cmix -n s2m.bin o_$tag.cmix --raw-stream --official-vocab --transformer w.tfwc2 > log_$tag 2>&1; fi
  rc=$?; e=$(python3 -c "print(round($(date +%s.%N) - $s, 1))")
  echo "RUN $tag threads=$th rc $rc size $(stat -c%s o_$tag.cmix 2>/dev/null) wall ${e}s | $(tr '\r' '\n' < log_$tag | grep -a 'tf pipeline' | tail -1)"; }
echo "=== $(t) 2. identity on 2,000,000 B"
run none none; run t8 8; run t31a 31; run t31b 31
fail=0; for x in t8 t31a t31b; do cmp o_none.cmix o_$x.cmix > cmp_$x.txt 2>&1 && echo "IDENTICAL none vs $x" || { echo "DIFFERENT none vs $x: $(cat cmp_$x.txt)"; fail=1; }; done
if [ $fail = 1 ]; then echo "IDENTITY FAILED"; ls -la o_*.cmix; echo "exit 0"; exit 0; fi
echo "IDENTITY OK"
echo "=== $(t) 3. scaling (none/8/31 above)"
for th in 2 4 16; do run t$th $th; cmp -s o_none.cmix o_t$th.cmix && echo "  identical" || echo "  DIFFERENT t$th"; done
echo "=== $(t) 4. split eval K=16 WARM 4M, CMIX_TF_THREADS=1 per chunk, st1 weights"
export CMIX_TF_THREADS=1
rm -rf $OUT
bash $W/agent/k3/split_eval_k3.sh k3pipe $WT 16 > $L/split.log 2>&1; tail -3 $L/split.log | grep -v "^exit"
python3 - <<'PY'
import json
A = "/workspace/split/k3pipe"; B = "/workspace/split/st1"; ok = True; mx = 0
for k in range(16):
    a = json.load(open(f"{A}/c{k}/score.json")); b = json.load(open(f"{B}/c{k}/score.json"))
    same = a["cmix_bytes"] == b["cmix_bytes"] and abs(a["kept_bytes_est"] - b["kept_bytes_est"]) < 0.5; ok &= same; mx = max(mx, a["seconds"])
    print(f"chunk {k:2d} k3 {a['cmix_bytes']:,} st1 {b['cmix_bytes']:,} {'same' if same else 'DIFFERENT'} k3 {a['seconds'] / 3600:.2f} h st1 {b['seconds'] / 3600:.2f} h")
ta = json.load(open(f"{A}/total.json"))["total_kept_bytes"]; print(f"total k3 {ta:,.0f} st1 96,557,895")
print(f"SPLIT {'ALL CHUNKS IDENTICAL to st1' if ok else 'MISMATCH vs st1'}; max chunk {mx / 3600:.2f} h")
PY
grep -ah "tf pipeline" $OUT/c*/log | tr '\r' '\n' | grep -a "tf pipeline" | head -16
echo "$(t) k3 done"; echo "exit 0"
