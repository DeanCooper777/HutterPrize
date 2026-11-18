#!/bin/bash
# Packs an x86-64 Linux ELF with the pk context-mixing packer (replaces upx):
#   pack.sh IN_ELF OUT
# OUT = two-stage stub (stage0.S, hand-written assembly, decodes pkdec.c; pkdec.c decodes the
# image) + packed image; at start it decodes the image into a memfd and executes it with the
# same arguments. Decoding takes a few seconds and ~330 MB.
# PACK_KEEP_DEBUG=1 keeps debug sections and the section table (about 19 KB larger, same code):
# some hosting providers kill the stripped form on sight, the contest machines do not.
# PACK_HOLE="LO HI": file range of the compress-only functions (packer/enc_only.py). It is coded
# last; OUT.cut then holds the number of leading bytes of OUT that the decompressor's copy needs
# (that copy has byte 9 of the file set to 1 and leaves the range as zeros). Without a hole
# OUT.cut holds 0.
#
# New in this entry. The previous winning entry (fx2-cmix-transformer-v1) packed the executable
# with UPX; this script and the tools it runs replace that, because the executable is stored in
# both comp9 and archive9 and a context-mixing model of x86-64 code packs it much smaller.
# Called by build_and_construct_comp.sh as its packing step (PACKER=pk, the default).
#
# Steps, each checked:
#   1. find the code range of IN_ELF and write the packer config (text / hole lines + model.cfg);
#   2. build pk.cpp and compress IN_ELF to image.pk;
#   3. build pkdec.c as a test program and check that it decodes image.pk back to IN_ELF, and,
#      with a hole, that the cut stream decodes to IN_ELF with the hole zeroed;
#   4. build stage 1 of the stub from stage1.s (the assembly form of pkdec.c) and compress it
#      with s0pack;
#   5. assemble stage0.S, which includes the compressed stage 1 and image.pk, and link it with
#      stub.ld into OUT; write OUT.cut.
# Other environment: PACK_KEEP_ELF=FILE saves a copy of IN_ELF (input for search.py / retune.sh);
# PACK_STUB_REGEN=1 regenerates stage1.s from pkdec.c (needed after any edit of pkdec.c);
# CXX, CC, OBJCOPY choose the tools.
# Testing: step 3 and the decode check inside s0pack are run on every build. All work happens
# in a temporary directory.
set -euo pipefail
IN=$(realpath "$1"); OUT=$(realpath -m "$2"); HERE=$(cd "$(dirname "$0")" && pwd)
CXX=${CXX:-clang++-17}; CC=${CC:-clang-17}; OBJCOPY=${OBJCOPY:-llvm-objcopy-17}
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT; cd "$T"

# code range: file offsets of .text .. end of .fini (the x86 parser and address transform run there)
sec() { readelf -SW "$IN" | sed 's/\[ *[0-9]*\]//' | awk -v n="$1" '$1 == n { print $4, $5 }'; }
read o s < <(sec .text); LO=$((16#$o)); HI=$((16#$o + 16#$s))
if read o s < <(sec .fini) && [ -n "${o:-}" ]; then HI=$((16#$o + 16#$s)); fi
[ "${LO:-0}" -gt 0 ] && [ "$HI" -gt "$LO" ] || { echo "pack.sh: cannot find .text in $IN" >&2; exit 1; }
# hole range (file offsets, "0 0" = none) and the config for pk: text and hole lines for this
# binary, then the model (contexts and parameters) from model.cfg
read HL HH <<< "${PACK_HOLE:-0 0}"; HLEN=$((HH - HL))
{ echo "text $LO $HI"; [ "$HLEN" -gt 0 ] && echo "hole $HL $HH"; cat "$HERE/model.cfg"; } > cfg
[ -n "${PACK_KEEP_ELF:-}" ] && cp "$IN" "$PACK_KEEP_ELF"   # unpacked input, for model work

# build the packer and compress; pk prints the stream length ("cut N") up to which the
# decompressor's copy needs the packed image
$CXX -O2 -w -std=c++17 "$HERE/pk.cpp" -o pk
./pk c cfg "$IN" image.pk | tee pk.out
SCUT=$(grep -o 'cut [0-9]*' pk.out | awk '{print $2}')
# the stub decoder must reproduce the input exactly (also catches pkdec.c / model.cfg drift)
HDEF="-DHOLE_LO=${HL}u -DHOLE_LEN=${HLEN}u"
$CC -O2 -w -DTEST -DTEXT_LO=${LO}u -DTEXT_HI=${HI}u $HDEF "$HERE/pkdec.c" -o pkdec_test
./pkdec_test image.pk check.elf && cmp check.elf "$IN" || { echo "pack.sh: stub decoder check FAILED" >&2; exit 1; }
if [ "$HLEN" -gt 0 ]; then
  # the decompressor's form: the stream cut at SCUT must decode to the input with the hole zeroed
  head -c "$SCUT" image.pk > image_d.pk; ./pkdec_test image_d.pk check_d.elf x
  { head -c "$HL" "$IN"; head -c "$HLEN" /dev/zero; tail -c +$((HH + 1)) "$IN"; } > want_d.elf
  cmp check_d.elf want_d.elf || { echo "pack.sh: decompressor-form check FAILED" >&2; exit 1; }
fi

# The stub has two stages (see stage0.S). Stage 1 is the decoder pkdec.c in assembly form,
# stage1.s, linked as a flat image for S1_BASE and compressed by s0pack; stage 0 is a small
# hand-written decoder for it. Both are assembly sources: no C compiler is needed for the stub.
# The layout of the binary being packed reaches stage 1 as link-time symbols (PK_*).
S1_BASE=0x600000; S0_HASH=0x800000
DEFSYM="--defsym=S1_BASE=$S1_BASE --defsym=PK_TEXT_LO=$LO --defsym=PK_TEXT_HI=$HI --defsym=PK_HOLE_LO=$HL --defsym=PK_HOLE_LEN=$HLEN"
$CXX -O2 -w -std=c++17 -msse4.2 "$HERE/s0pack.cpp" -o s0pack
link_s1() {    # $1 = object, $2 = tag: flat image s1_TAG.bin, compressed s1_TAG.cm + s1_TAG.inc
  ld -static -nostdlib -T "$HERE/stage1.ld" $DEFSYM --build-id=none --no-warn-rwx-segments $1 -o s1_$2.elf || return 1
  $OBJCOPY -O binary -j .text s1_$2.elf s1_$2.bin
  ./s0pack s1_$2.bin s1_$2.cm s1_$2.inc 2> /dev/null > s1_$2.out
}
# stage1.s records the md5 of the pkdec.c it was generated from; it is used only if that still
# matches, so that the stub and the decoder checked above cannot be different programs
PKMD5=$(md5sum "$HERE/pkdec.c" | cut -c1-32)
if [ "${PACK_STUB_REGEN:-0}" = 1 ]; then
  # Developer step: regenerate stage1.s from pkdec.c. It is compiled for size with clang -Oz and,
  # if installed, gcc -Oz; the output whose image compresses best becomes the new stage1.s.
  SFLAGS="-w -ffreestanding -fno-stack-protector -fno-asynchronous-unwind-tables -fno-unwind-tables -fno-pic \
      -mcmodel=small -fno-builtin -fno-ident"
  best=
  gen_s1() {   # $1 = tag, rest = compiler command
    local tag=$1; shift
    "$@" $SFLAGS -S "$HERE/pkdec.c" -o s1_$tag.s 2> /dev/null && as s1_$tag.s -o s1_$tag.o && link_s1 s1_$tag.o $tag || return 0
    echo "pack.sh: stage 1 from $*: $(stat -c %s s1_$tag.bin) -> $(stat -c %s s1_$tag.cm) bytes"
    if [ -z "$best" ] || [ "$(stat -c %s s1_$tag.cm)" -lt "$(stat -c %s s1_$best.cm)" ]; then best=$tag; bestcc="$*"; fi
  }
  gen_s1 clang $CC -Oz
  command -v gcc > /dev/null && gen_s1 gcc gcc -Oz -fno-inline -fno-pie -fcf-protection=none
  [ -n "$best" ] || { echo "pack.sh: stage 1 generation FAILED" >&2; exit 1; }
  { echo "# stage1.s: stage 1 of the unpacking stub in assembly (see stage0.S, pkdec.c, pack.sh)."
    echo "# Generated from pkdec.c by: $bestcc (pack.sh, PACK_STUB_REGEN=1)."
    echo "# pkdec.c md5 $PKMD5"
    echo "# pkdec.c is the readable reference of this code and the test decoder; if it changes,"
    echo "# regenerate this file (pack.sh refuses to use it when the md5 above no longer matches)."
    echo "# Hand edits for size are welcome: keep the behaviour and note them here."
    grep -v '^\s*\.file\b' s1_$best.s; } > "$HERE/stage1.s"
  echo "pack.sh: wrote $HERE/stage1.s"
fi
# normal path: check the md5, assemble stage1.s, link and compress stage 1
grep -q "^# pkdec.c md5 $PKMD5" "$HERE/stage1.s" || { echo "pack.sh: stage1.s was not generated from this pkdec.c; run with PACK_STUB_REGEN=1" >&2; exit 1; }
as "$HERE/stage1.s" -o s1.o && link_s1 s1.o use || { echo "pack.sh: stage 1 build FAILED" >&2; exit 1; }
echo "pack.sh: stage 1: $(stat -c %s s1_use.bin) -> $(stat -c %s s1_use.cm) bytes"
cp s1_use.cm s1.cm; cp s1_use.inc s1.inc
# stage 0: stage0.S includes s1.inc, s1.cm and image.pk from this directory; the result is one
# segment (stub.ld). Without PACK_KEEP_DEBUG the section table is removed as well.
DBG=; [ "${PACK_KEEP_DEBUG:-0}" = 1 ] && DBG=-g
$CC $DBG -c -I. -DS1_BASE=$S1_BASE -DS0_HASH=$S0_HASH "$HERE/stage0.S" -o stage0.o
ld -static -nostdlib -T "$HERE/stub.ld" --build-id=none -z noseparate-code --no-warn-rwx-segments stage0.o -o stub.full
if [ -n "$DBG" ]; then cp stub.full "$OUT"; else $OBJCOPY --strip-sections stub.full "$OUT"; fi
chmod +x "$OUT"
# file offset of the packed stream = address of `packed` minus the load address (one segment
# that starts at file offset 0)
POFF=$(( 16#$(nm stub.full | awk '$3 == "packed" { print $1 }') - 16#400000 ))
if [ "$HLEN" -gt 0 ]; then echo $((POFF + SCUT)) > "$OUT.cut"; else echo 0 > "$OUT.cut"; fi
echo "pack.sh: $(stat -c %s "$IN") -> $(stat -c %s "$OUT") bytes (image $(stat -c %s image.pk), code range $LO..$HI, hole $HL..$HH, decompressor copy $(cat "$OUT.cut"))"
