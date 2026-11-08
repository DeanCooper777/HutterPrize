#!/bin/bash
# Training-data generation on a Linux CPU pod (docs/NEW_TRANSFORMER_PLAN.md).
#
# Layout on the network volume (/workspace):
#   upload/src.tar.gz     fx2-cmix-T sources (scripts/cloud/pack.ps1 makes it)
#   upload/stream.bin.gz  the byte stream our Windows build codes (from
#                         runs/tokens9b/tokens.uint8; sha256 in stream.sha256)
#   upload/article-boundaries.int32
#   upload/tokens.sha256  sha256 of the Windows token file, as ppmd-bytes.uint8
#   upload/ref/           Windows reference prefixes for the bit-exactness check
#   data/                 outputs, the file names the training recipes read:
#     ppmd-bytes.uint8 ppmd-probs.float16 article-boundaries.int32
#     cmix-bits.float16
#
# All runs use -n --raw-stream: the input is coded verbatim, so PPMD sees
# exactly the bytes the -e pipeline codes (verified on Windows: identical
# priors, runs/eqtest), and --official-vocab keeps the 205 columns.
#
# The PPMD heap files are memory-mapped, so the runs work in a LOCAL directory
# (container disk), never on the network volume.
#
# usage: bash datagen.sh build | check | ppmd | bits [chunks] | all
set -euo pipefail
W=/workspace
U=$W/upload
DATA=$W/data
LOCAL=/root/run
CLANG=clang++-22
mkdir -p "$DATA" "$LOCAL" "$W/logs"

build() {
  if ! command -v $CLANG > /dev/null; then
    apt-get update
    apt-get install -y make wget lsb-release software-properties-common gnupg
    wget -q https://apt.llvm.org/llvm.sh
    bash llvm.sh 22
    rm llvm.sh
  fi
  rm -rf "$LOCAL/src" && mkdir -p "$LOCAL/src"
  tar xzf "$U/src.tar.gz" -C "$LOCAL/src"
  cd "$LOCAL/src/fx2-cmix-T"
  make CC=$CLANG CFLAGS_DEFINES="-DSEED=923 -DUPDATE_LIMIT=3000" cmix
  cp cmix "$LOCAL/cmix"
  [ -f "$U/stream.bin" ] || gunzip -k "$U/stream.bin.gz"
  (cd "$U" && sha256sum -c stream.sha256)
  echo "build ok"
}

# Bit-exactness check: the PPMD priors and cmix bits of the first part of the
# stream must equal the Windows build's (upload/ref/*.sha256, made by
# scripts/cloud/prepare_upload.sh).
check() {
  local d=$LOCAL/check
  rm -rf "$d" && mkdir -p "$d" && cd "$d"
  local n
  n=$(stat -c %s "$U/ref/stream.prefix")
  "$LOCAL/cmix" -n "$U/ref/stream.prefix" p.cmix --raw-stream --ppmd-only --official-vocab \
      --save-ppmd-probs probs.f16 > ppmd.log 2>&1
  "$LOCAL/cmix" -n "$U/ref/stream.prefix" b.cmix --raw-stream --no-transformer --official-vocab \
      --save-cmix-bits bits.f16 > bits.log 2>&1
  mv probs.f16 probs.prefix
  mv bits.f16 bits.prefix
  if sha256sum -c "$U/ref/probs.sha256"; then
    echo "PPMD priors: identical to Windows ($n bytes of stream)"
  else
    echo "PPMD priors DIFFER from Windows: stop, do not generate data" >&2
    exit 1
  fi
  if sha256sum -c "$U/ref/bits.sha256"; then
    echo "cmix bits: identical to Windows"
  else
    python3 -c "
import sys, numpy as np
a = np.fromfile('$U/ref/bits.prefix', np.float16).astype(np.float32)
b = np.fromfile('bits.prefix', np.float16).astype(np.float32)
print('cmix bits differ from Windows (training target only): max |dlogit| %.3f, mean %.5f'
      % (np.abs(a - b).max(), np.abs(a - b).mean()))"
  fi
}

ppmd() {
  local d=$LOCAL/ppmd
  rm -rf "$d" && mkdir -p "$d" && cd "$d"
  "$LOCAL/cmix" -n "$U/stream.bin" p.cmix --raw-stream --ppmd-only --official-vocab \
      --save-ppmd-probs "$DATA/ppmd-probs.float16" \
      --save-ppmd-bytes "$DATA/ppmd-bytes.uint8" > "$W/logs/ppmd.log" 2>&1
  cp "$U/article-boundaries.int32" "$DATA/"
  # the tokens this run read back must be exactly our Windows build's
  (cd "$DATA" && sha256sum -c "$U/tokens.sha256")
  python3 - <<EOF
import os
n = os.path.getsize("$DATA/ppmd-bytes.uint8")
assert os.path.getsize("$DATA/ppmd-probs.float16") == n * 205 * 2, "priors size"
print("ppmd ok:", n, "tokens")
EOF
}

# cmix bits in K chunks run in parallel: chunk k codes stream[s_k - warm, e_k)
# and its first `warm` tokens of output are dropped. A chunk's models start
# cold, so the warm-up prefix (default 4M tokens) lets them adapt before the
# kept part; contexts further back than that are lost, a small bias in a
# training target that is approximate anyway.
#
# Resumable: a finished chunk has c$k/done and is not rerun. ONLY="0 3" limits
# the run to those chunks. (Slicing uses dd: `tail | head` fails under
# pipefail when head closes the pipe.)
bits() {
  local K=${1:-4} warm=${WARM:-4000000}
  local d=$LOCAL/bits
  mkdir -p "$d" && cd "$d"
  local N
  N=$(stat -c %s "$U/stream.bin")
  for ((k = 0; k < K; k++)); do
    [ -f "c$k/done" ] && continue
    if [ -n "${ONLY:-}" ] && [[ " $ONLY " != *" $k "* ]]; then continue; fi
    local s=$((N * k / K)) e=$((N * (k + 1) / K))
    local from=$((s > warm ? s - warm : 0))
    rm -rf "c$k" && mkdir -p "c$k"
    (cd "c$k" && dd if="$U/stream.bin" of=in.bin iflag=skip_bytes,count_bytes \
           skip=$from count=$((e - from)) bs=4M status=none \
      && echo "$from $s $e" > range \
      && "$LOCAL/cmix" -n in.bin x.cmix --raw-stream --no-transformer --official-vocab \
           --save-cmix-bits bits.f16 > log 2>&1 \
      && test "$(stat -c %s bits.f16)" -eq $(((e - from) * 16)) \
      && touch done) &
  done
  wait
  [ -n "${ONLY:-}" ] || bits_concat "$K"
}

bits_concat() {
  local K=${1:-4} d=$LOCAL/bits N
  N=$(stat -c %s "$U/stream.bin")
  for ((k = 0; k < K; k++)); do
    [ -f "$d/c$k/done" ] || { echo "chunk $k not done" >&2; exit 1; }
  done
  rm -f "$DATA/cmix-bits.float16.part"
  for ((k = 0; k < K; k++)); do
    read -r from s e < "$d/c$k/range"
    tail -c +$(((s - from) * 16 + 1)) "$d/c$k/bits.f16" >> "$DATA/cmix-bits.float16.part"
  done
  mv "$DATA/cmix-bits.float16.part" "$DATA/cmix-bits.float16"
  test "$(stat -c %s "$DATA/cmix-bits.float16")" -eq $((N * 16)) && echo "bits ok"
}

case "${1:-all}" in
  build) build ;;
  check) check ;;
  ppmd) ppmd ;;
  bits) bits "${2:-4}" ;;
  concat) bits_concat "${2:-4}" ;;
  all) build; check; (ppmd) & (bits "${2:-4}") & wait ;;
esac
