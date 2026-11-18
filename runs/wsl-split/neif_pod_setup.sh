#!/bin/bash
# neif_pod_setup.sh (pod_setup.sh of the bundle): prepare a rented Linux machine for the tests of
# the fast flavour of cmix-neif 2.0 (NEIF_FAST.md). Run as root inside the unpacked bundle:
#     tar xf neif_pod_bundle.tar -C /root && bash /root/neif/scripts/neif_pod_setup.sh
# What it does (each step is skipped when its result is there; STEPS="deps stream build check"):
#   deps    the compiler. The entry is built with clang-18 / lld-18 (NOT gcc; gcc only supplies
#           libstdc++ 13 headers), profile-guided with LTO. Its own install.sh pins every package
#           to the Ubuntu 24.04 archive as of 2026-09-27 (clang 18.1.3-1ubuntu1) through the
#           Ubuntu snapshot service, so the machine must run UBUNTU 24.04 (apt 2.7 or later).
#           Whether another clang 18 point release gives the same model output is NOT known: the
#           float code of most files is compiled with -ffp-contract=off and explicit intrinsics,
#           but a plain (non-PGO) build of this source already differs from the entry. Hence the
#           self-check below; if it fails, do not trust any number from that machine.
#   stream  unpack stream.bin.zst (the coder stream of `-e enwik9`: 501,062,281 B) and check its
#           sha256
#   build   three PGO test builds in $NEIF_ROOT/build, each as the entry is compiled
#           (make prof_use: the entry's shipped profile and LTO) with extra macros:
#             tbN   -DNEIF_TEST=1                              the original test build
#             tbK   -DNEIF_TEST=1 -DNEIF_PACKED=1              packed dense kernels (the fast flavour)
#             tbKM  -DNEIF_TEST=1 -DNEIF_MT=1 -DNEIF_PACKED=1  packed + threads (speculative step)
#           about 2 min each with 8 cores
#   check   self-check, all three builds: the chunk 60.00-60.03 M must code to sha256
#           9e925d7846f34983...; then with the packed build and the 3-process pipeline:
#           60.0-60.5 M (100 k warm-up) -> e3c7340dce4cef65, the reference chunk 250.0-250.3 M
#           (1.2 M warm-up) -> 727e97767d69fb56, and the verification decode of the first chunk.
#           (CHECK=quick: only the 36 k chunk, 3 min.) Prints SELF-CHECK PASSED or FAILED.
# NEIF_ROOT (default: the directory above this script's directory) must be on a LOCAL disk with
# 40 GB free (every running cmix makes a sparse 14.7 GB paging file in its run directory).
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
export NEIF_ROOT=${NEIF_ROOT:-$(cd "$HERE/.." && pwd)}
R=$NEIF_ROOT
STEPS=${STEPS:-deps stream build check}
WF=weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5
STREAM_SHA=c35d3073eeba70f22a2e08a50202b53eb95466e3e9f1f2702f6f9b3f96fd8718
say() { echo "$(date -u +%T) $*"; }
for step in $STEPS; do
  case $step in
    deps)
      . /etc/os-release
      [ "${VERSION_ID:-}" = 24.04 ] || say "WARNING: this is ${PRETTY_NAME:-unknown}, not Ubuntu 24.04: install.sh expects 24.04 (apt snapshot); the self-check decides"
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -q > "$R/apt.log" 2>&1
      apt-get install -y -q --no-install-recommends ca-certificates time file zstd patch procps util-linux python3 >> "$R/apt.log" 2>&1
      if command -v clang++-18 > /dev/null && command -v ld.lld-18 > /dev/null; then say "clang-18 is there: $(clang++-18 --version | head -n 1)"
      else (cd "$R/dev" && bash install.sh > "$R/install.log" 2>&1) || { say "install.sh failed, see $R/install.log"; tail -n 5 "$R/install.log"; exit 1; }
      fi
      say "compiler: $(clang++-18 --version | head -n 1); $(dpkg-query -W -f='${Package}=${Version} ' clang-18 lld-18 libstdc++-13-dev libc6 2> /dev/null)" ;;
    stream)
      if [ ! -f "$R/stream.bin" ]; then
        [ -f "$R/stream.bin.zst" ] || { say "no $R/stream.bin and no stream.bin.zst"; exit 1; }
        zstd -d -q --long=27 "$R/stream.bin.zst" -o "$R/stream.bin" || exit 1
      fi
      n=$(stat -c %s "$R/stream.bin"); h=$(sha256sum "$R/stream.bin" | cut -c1-64)
      if [ "$n" = 501062281 ] && [ "$h" = "$STREAM_SHA" ]; then say "stream.bin: $n bytes, sha256 ok"
      else say "stream.bin: $n bytes sha256 $h, EXPECTED 501062281 bytes $STREAM_SHA"; exit 1; fi ;;
    build)
      mkdir -p "$R/build"
      for f in "tbN:orig:" "tbK:packed:-DNEIF_PACKED=1" "tbKM:packed+mt:-DNEIF_MT=1 -DNEIF_PACKED=1"; do
        d=${f%%:*}; rest=${f#*:}; flav=${rest%%:*}; x=${rest#*:}
        B=$R/build/$d
        if [ -x "$B/cmix" ] && [ -f "$B/FLAVOUR" ]; then say "$d: already built"; continue; fi
        rm -rf "$B"; mkdir -p "$B"
        (cd "$R/dev" && cp -a src makefile encoder_split.lds runtime_exports.map pgo_data $WF "$B/")
        if ! (cd "$B" && make -j"$(nproc)" prof_use CC="clang++-18 -DNEIF_TEST=1 $x" > build.log 2>&1); then
          say "$d: build failed"; grep -n "error" "$B/build.log" | head -n 20; exit 1
        fi
        echo "$flav" > "$B/FLAVOUR"
        say "$d ($flav): $(sha256sum "$B/cmix" | cut -c1-64), PGO profile entries discarded: $(grep -c 'hash mismatch' "$B/build.log")"
        # informational: the binaries of the PC the bundle was made on (same source, same pinned compiler)
        case $d in tbN) ref=66236cc0b68a1f62 ;; tbK) ref=02579d85ebda3008 ;; *) ref=77d65f2e4e8b63bd ;; esac
        say "   (built on the bundle's PC: $ref...; a different binary is not an error, the self-check decides)"
      done ;;
    check)
      export STREAM=$R/stream.bin OUT=$R/out/selfcheck
      ok=1
      chk() {   # NAME EXPECTED_SHA16 line
        local got; got=$(awk -F'\t' -v n="$1" '$3 == n {s = $20} END {print s}' "$OUT/results.tsv")
        if [ "$got" = "$2" ]; then say "  $1: sha $got ok"; else say "  $1: sha $got, EXPECTED $2  ** MISMATCH"; ok=0; fi
      }
      for d in tbN tbK tbKM; do
        bash "$HERE/neif_pod_run.sh" q_$d t 60000000 60030000 10000 "$R/build/$d" > /dev/null; chk q_$d 9e925d7846f34983
      done
      NEIF_PIPE=3 bash "$HERE/neif_pod_run.sh" q_tbK_p3 t 60000000 60030000 10000 "$R/build/tbK" > /dev/null; chk q_tbK_p3 9e925d7846f34983
      NEIF_PIPE=3 bash "$HERE/neif_pod_run.sh" q_tbK_v3 u 60000000 60030000 10000 "$R/build/tbK" q_tbK > /dev/null \
        && say "  q_tbK_v3: verification decode PASS" || { say "  q_tbK_v3: verification decode FAILED"; ok=0; }
      NEIF_MT=2 NEIF_MT_SPEC=2 NEIF_MT_FAULT=200 bash "$HERE/neif_pod_run.sh" q_tbKM_s2f u 60000000 60030000 10000 "$R/build/tbKM" q_tbK > /dev/null \
        && say "  q_tbKM_s2f: threaded decode test with 20 % forced wrong guesses PASS" || { say "  q_tbKM_s2f: FAILED"; ok=0; }
      if [ "${CHECK:-full}" = full ]; then
        NEIF_PIPE=3 bash "$HERE/neif_pod_run.sh" c60_tbK_p3 t 60000000 60500000 100000 "$R/build/tbK" > /dev/null; chk c60_tbK_p3 e3c7340dce4cef65
        NEIF_PIPE=3 bash "$HERE/neif_pod_run.sh" ref_tbK_p3 t 250000000 250300000 1200000 "$R/build/tbK" > /dev/null; chk ref_tbK_p3 727e97767d69fb56
      fi
      if [ $ok = 1 ]; then say "SELF-CHECK PASSED"; else say "SELF-CHECK FAILED (results in $OUT/results.tsv)"; exit 1; fi ;;
  esac
done
