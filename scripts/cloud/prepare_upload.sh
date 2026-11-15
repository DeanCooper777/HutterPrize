#!/bin/bash
# prepare_upload.sh: assemble what the data-generation machine needs (datagen.sh): the
# compressor sources, the preprocessed stream with hashes, the article boundaries, and
# reference outputs of the local build on a prefix of the stream. The reference outputs let
# datagen.sh check that the Linux build produces the same PPMD priors as the build the stream
# came from.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Assemble runs/upload/ for the cloud data pod (scripts/cloud/datagen.sh).
# Runs on Windows (Git Bash) with the build/cmix_dump.exe of the current source.
set -euo pipefail
R=$(cd "$(dirname "$0")/../.." && pwd)
T=$R/runs/tokens9b
O=$R/runs/upload
PREFIX=${PREFIX:-4000000}
mkdir -p "$O/ref"

# sources (only what the Linux makefile needs)
tar czf "$O/src.tar.gz" -C "$R" \
    cmix-T-dwc/makefile cmix-T-dwc/src cmix-T-dwc/cpp_infer/src

# the coded stream, its hash, and the token hash under the output's name
gzip -1 -c "$T/stream.bin" > "$O/stream.bin.gz"
(cd "$T" && sha256sum -b stream.bin) > "$O/stream.sha256"
(cd "$T" && sha256sum -b tokens.uint8) | sed 's/\*tokens.uint8$/*ppmd-bytes.uint8/' > "$O/tokens.sha256"
cp "$T/article-boundaries.int32" "$O/"

# Windows reference outputs on a prefix, with the default model settings
# (ppmd_ws_mb only caps this machine's working set; it does not change output)
head -c "$PREFIX" "$T/stream.bin" > "$O/ref/stream.prefix"
d=$(mktemp -d)
echo "ppmd_ws_mb 1500" > "$d/ws.tune"
export CMIX_TUNE="$d/ws.tune"
(cd "$d" && "$R/build/cmix_dump.exe" -n "$O/ref/stream.prefix" p.cmix --raw-stream \
    --ppmd-only --official-vocab --save-ppmd-probs "$O/ref/probs.prefix" > ppmd.log 2>&1) &
(cd "$d" && mkdir b && cd b && "$R/build/cmix_dump.exe" -n "$O/ref/stream.prefix" b.cmix \
    --raw-stream --no-transformer --official-vocab --save-cmix-bits "$O/ref/bits.prefix" > bits.log 2>&1) &
wait
rm -rf "$d"
ls -la "$O" "$O/ref"
