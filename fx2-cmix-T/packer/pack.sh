#!/bin/bash
# Packs an x86-64 Linux ELF with the pk context-mixing packer (replaces upx):
#   pack.sh IN_ELF OUT
# OUT = small freestanding stub (pkdec.c) + packed image; at start it decodes the image into a
# memfd and executes it with the same arguments. Decoding takes a few seconds and ~230 MB.
# PACK_KEEP_DEBUG=1 keeps debug sections and the section table (about 19 KB larger, same code):
# some hosting providers kill the stripped form on sight, the contest machines do not.
set -euo pipefail
IN=$(realpath "$1"); OUT=$(realpath -m "$2"); HERE=$(cd "$(dirname "$0")" && pwd)
CXX=${CXX:-clang++-17}; CC=${CC:-clang-17}; OBJCOPY=${OBJCOPY:-llvm-objcopy-17}
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT; cd "$T"

# code range: file offsets of .text .. end of .fini (the x86 parser and address transform run there)
sec() { readelf -SW "$IN" | sed 's/\[ *[0-9]*\]//' | awk -v n="$1" '$1 == n { print $4, $5 }'; }
read o s < <(sec .text); LO=$((16#$o)); HI=$((16#$o + 16#$s))
if read o s < <(sec .fini) && [ -n "${o:-}" ]; then HI=$((16#$o + 16#$s)); fi
[ "${LO:-0}" -gt 0 ] && [ "$HI" -gt "$LO" ] || { echo "pack.sh: cannot find .text in $IN" >&2; exit 1; }
{ echo "text $LO $HI"; cat "$HERE/model.cfg"; } > cfg
[ -n "${PACK_KEEP_ELF:-}" ] && cp "$IN" "$PACK_KEEP_ELF"   # unpacked input, for model work

$CXX -O2 -w -std=c++17 "$HERE/pk.cpp" -o pk
./pk c cfg "$IN" image.pk
# the stub decoder must reproduce the input exactly (also catches pkdec.c / model.cfg drift)
$CC -O2 -w -DTEST -DTEXT_LO=${LO}u -DTEXT_HI=${HI}u "$HERE/pkdec.c" -o pkdec_test
./pkdec_test image.pk check.elf && cmp check.elf "$IN" || { echo "pack.sh: stub decoder check FAILED" >&2; exit 1; }

DBG=; [ "${PACK_KEEP_DEBUG:-0}" = 1 ] && DBG=-g
$CC -Oz $DBG -w -ffreestanding -fno-stack-protector -fno-asynchronous-unwind-tables -fno-unwind-tables -fno-pic \
    -mcmodel=small -fno-builtin -fno-ident -DTEXT_LO=${LO}u -DTEXT_HI=${HI}u -c "$HERE/pkdec.c" -o pkdec.o
printf '.section .packed,"a"\n.globl packed\npacked:\n.incbin "image.pk"\n.section .note.GNU-stack,"",@progbits\n' > blob.S
$CC -c blob.S -o blob.o
ld -static -nostdlib -T "$HERE/stub.ld" --build-id=none -z noseparate-code --no-warn-rwx-segments pkdec.o blob.o -o stub.full
if [ -n "$DBG" ]; then cp stub.full "$OUT"; else $OBJCOPY --strip-sections stub.full "$OUT"; fi
chmod +x "$OUT"
echo "pack.sh: $(stat -c %s "$IN") -> $(stat -c %s "$OUT") bytes (image $(stat -c %s image.pk), code range $LO..$HI)"
