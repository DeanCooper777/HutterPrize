#!/bin/bash -x

# build_and_construct_comp.sh -- builds the submission.
#
# Output: ./run/cmix, the compressor package ("comp9" in the contest's score
# S = size(comp9) + size(archive9)). Run as `./run/cmix -e enwik9 OUT`, it
# compresses enwik9 and writes the self-extracting ./archive9; archive9, run
# without arguments, restores the file.
#
# Steps, in order:
#   1. check that dictionary/english.dic is the one the decompressor expects;
#   2. profile-guided build of ./cmix (makefile targets prof_gen, prof_use);
#   3. disassemble ./cmix and refuse it if it contains anything beyond AVX2,
#      or any reciprocal-estimate instruction (see the two checks below);
#   4. pack the executable (our packer, or UPX);
#   5. append the compressed dictionary, the compressed article order, the
#      transformer weights and a 16-byte trailer -> ./run/cmix.
#
# Environment switches:
#   OFFICIAL=1         [this entry] compile with -DCMIX_OFFICIAL: the minimal
#                      binary for an official run. It keeps only what comp9
#                      and archive9 need (-e, self-extraction, plain -c / -d,
#                      -h) and drops the LSTM and all tuning, profiling and
#                      dump options. Smaller executable, same compression.
#   PACKER=pk | upx    [this entry] pk (default) = our context-mixing packer
#                      in packer/; upx = upx-ucl --lzma, as the previous entry
#                      did (it used "upx-ucl -9").
#   PACK_KEEP_DEBUG=1  [this entry] read by packer/pack.sh: keep the debug
#                      sections and the section table in the packed stub. A
#                      little larger, same code; for hosts that reject a
#                      section-less executable. Not for the submission.
#   PACK_KEEP_ELF=FILE [this entry] read by packer/pack.sh: also save the
#                      unpacked executable to FILE (for work on the packer's
#                      model).
#   NATIVE=1, COREI7=1, ZEN2=1  are makefile variables, not read here. make
#                      also takes variables from the environment, so exporting
#                      one of them changes the instruction set; the AVX2 check
#                      below exists to catch exactly that.
#
# Not here on purpose: CMIX_PIPE (the multi-core compress-only experiment).
# ../scripts/cloud/full_pipe_*.sh add -DCMIX_PIPE by patching this file and
# the makefile with sed. Such a binary is never submitted.
#
# Needs clang++-17, llvm-profdata-17, make, md5sum, objdump (binutils; the two
# checks are SKIPPED with a warning if it is missing), and for PACKER=pk also
# clang-17, llvm-objcopy-17, ld and readelf; for PACKER=upx, upx-ucl.
#
# Testing: the script is itself the gate for portability (steps 1 and 3), and
# packer/pack.sh verifies that its stub decoder reproduces the executable.
# The end-to-end test is to compress enwik9 with ./run/cmix and compare the
# output of ./archive9 with the original.
#
# Changes from the previous winning entry (fx2-cmix-transformer-v1):
# OFFICIAL=1 and the PACKER choice (both for size: the executable is stored
# in comp9 and in archive9, so each byte saved counts twice).

set -euo pipefail

#SEED="$1"
#UPDATE_LIMIT="$2"

# Compile-time constants. SEED seeds the pseudo-random initialisation
# (srand(SEED) in src/runner.cpp); compressor and decompressor must be built
# with the same value. UPDATE_LIMIT is still passed as -DUPDATE_LIMIT, but
# nothing under src/ reads it any more.
SEED="923"
UPDATE_LIMIT="3000"

# The decompressor verifies the dictionary it recovers from the archive against
# the size and hash hard-coded in src/readalike_prepr/self_extract.h. Keep the
# two in sync: if the dictionary is ever replaced, that check has to be updated
# or every decompression run will abort.
EXPECTED_DICT_MD5=b3a9cf9fac570b2dc9a0375534792980
actual_dict_md5=$(md5sum dictionary/english.dic | awk '{print $1}')
if [ "$actual_dict_md5" != "$EXPECTED_DICT_MD5" ]; then
  echo "ERROR: dictionary/english.dic has changed (md5 $actual_dict_md5," >&2
  echo "expected $EXPECTED_DICT_MD5). Update kExpectedDictSize and" >&2
  echo "kExpectedDictHash in src/readalike_prepr/self_extract.h (FNV-1a 64) and" >&2
  echo "EXPECTED_DICT_MD5 here." >&2
  exit 1
fi

# [this entry] FROM_ASM=DIR: build from the assembly sources in DIR (the ./asm directory that an
# earlier build left, see step 2c) instead of compiling the C++: step 2 is skipped and the
# makefile's asm_build target assembles and links. No C++ compiler takes part in building cmix.
if [ -n "${FROM_ASM:-}" ]; then
  RELINK="ASM_DIR=$FROM_ASM asm_build"
  CFLAGS_DEFINES=
  make KEEP_OBJS=1 $RELINK
else
RELINK=prof_relink

# Step 2: profile-guided build. Start from an empty profile directory.
rm -rf pgo_data 
mkdir -p pgo_data 

# building with PGO
# [this entry]
# OFFICIAL=1 builds the minimal binary for an official run (see CMIX_OFFICIAL in src/runner.cpp).
# ${OFFICIAL:+...} expands to " -DCMIX_OFFICIAL" only if OFFICIAL is set and not empty.
# First build: instrumented (-fprofile-generate), all cores.
CFLAGS_DEFINES="-DSEED=$SEED -DUPDATE_LIMIT=$UPDATE_LIMIT${OFFICIAL:+ -DCMIX_OFFICIAL}"
make CFLAGS_DEFINES="$CFLAGS_DEFINES" prof_gen -j 

# Training run: compress a small sample in the generic -c mode. This writes
# the raw profile into ./pgo_data; the compressed output is thrown away. The
# profile is then merged into the one file that prof_use reads.
./cmix -c ./prof_input/input ./prof_comp > ./prof_output
rm ./prof_comp ./prof_output 
llvm-profdata-17 merge -output=default.profdata ./pgo_data/*
mv default.profdata pgo_data/

# Second build: the real one, optimized with the profile and with LTO.
make CFLAGS_DEFINES="$CFLAGS_DEFINES" KEEP_OBJS=1 prof_use -j
fi

# Step 2b. [this entry]
# Compressor / decompressor split. The executable is stored twice: in comp9 and at the head of
# archive9. The copy in archive9 never compresses, so the functions that only compression can
# reach are dead weight there. packer/enc_only.py finds them in the linked binary (call graph from
# the disassembly); a second link places them last in .text; the packer then codes them last, so
# that the decompressor's copy is the packed file cut short, with that range left as zeros
# (packer/pk.cpp, "hole"). SPLIT=0 skips this (one identical copy in both, as before).
HOLE="0 0"
if [ "${PACKER:-pk}" != upx ] && [ "${SPLIT:-1}" = 1 ]; then
  python3 packer/enc_only.py order cmix.sym cmix.map order.ld
  LINK_EXTRA=-Wl,--section-ordering-file=order.ld
  make CFLAGS_DEFINES="$CFLAGS_DEFINES" KEEP_OBJS=1 LINK_EXTRA=$LINK_EXTRA $RELINK
  HOLE=$(python3 packer/enc_only.py hole cmix.sym | awk '{print $2, $3}')
  echo "compress-only code: file range $HOLE"
fi

# Step 2c. [this entry]
# The makefile builds every object through assembly: the compiler (for the fast and slow groups,
# the link-time optimizer) writes x86-64 assembly into ./asm and the assembler makes the objects
# from it. ./asm is therefore a complete assembly-source version of the program. As a check, cmix
# is built once more from ./asm alone (makefile target asm_build, the same thing FROM_ASM=DIR
# does) and must come out byte-identical.
if [ -z "${FROM_ASM:-}" ]; then
  cp cmix cmix.first
  rm -f *.o
  make KEEP_OBJS=1 LINK_EXTRA=${LINK_EXTRA:-} asm_build
  cmp cmix cmix.first || { echo "ERROR: the binary rebuilt from ./asm differs" >&2; exit 1; }
  echo "rebuilt from assembly: byte-identical ($(cat asm/*.s | wc -l) lines of assembly in ./asm)"
  rm -f cmix.first
fi
rm -f *.o

# Step 3a.
# Guard against a non-portable binary. The Hutter Prize test machines are an
# Intel Core i7-1165G7 (Tiger Lake: AVX-512, but no AVX-VNNI) and an AMD
# Ryzen 7 (Zen 2: no AVX-512 at all), so anything past the AVX2 baseline is an
# illegal instruction on at least one of them. This catches a stray NATIVE=1,
# a stale objects directory, or a compiler that widens the baseline on its own.
# Checked before upx-ucl, which would hide the code from objdump.
check_avx2_only() {
  local bin="$1" dis bad=0
  if ! command -v objdump > /dev/null; then
    echo "WARNING: objdump not found, skipping the AVX2-only check on $bin" >&2
    return 0
  fi
  dis=$(objdump -d --insn-width=16 "$bin")
  # AVX-512: 512-bit registers, mask registers, or an EVEX (0x62) prefix.
  # AVX-VNNI: objdump prints the VEX encoding of an EVEX-capable opcode as
  # "{vex}", and on Tiger Lake only the EVEX form of vpdpwssd is legal.
  for pat in '%zmm' '%k[0-7]' '\{vex\}' $'\t62 [0-9a-f][0-9a-f] '; do
    if grep -qE "$pat" <<< "$dis"; then
      echo "ERROR: $bin uses instructions beyond the AVX2 baseline (matched '$pat'):" >&2
      grep -E "$pat" <<< "$dis" | head -3 >&2
      bad=1
    fi
  done
  if [ "$bad" -ne 0 ]; then
    echo "Build the submission with the default -march=x86-64-v3 (no NATIVE=1)." >&2
    return 1
  fi
  echo "AVX2-only check passed for $bin"
}
check_avx2_only ./cmix

# Step 3b.
# Guard against a vendor-dependent binary. RCPPS/RCPSS/RSQRTPS/RSQRTSS are
# reciprocal *estimates*: the standards only bound their relative error
# (1.5*2^-12), the bits they return come from a vendor-specific table, and
# Intel and AMD return different ones. A single differing bit anywhere in the
# model changes a prediction and desynchronises the arithmetic coder, so an
# archive built on an AMD machine decodes to garbage on an Intel one (this is
# what broke the July 2026 submission on the prize committee's Intel laptop).
# The makefile passes -mrecip=none and cpp_infer/src/opt/vec_math.h uses true
# divides; this catches a regression in either.
check_no_recip_estimate() {
  local bin="$1" dis
  if ! command -v objdump > /dev/null; then
    echo "WARNING: objdump not found, skipping the reciprocal-estimate check on $bin" >&2
    return 0
  fi
  dis=$(objdump -d "$bin")
  if grep -qE '\b(v?rcpps|v?rcpss|v?rsqrtps|v?rsqrtss)\b' <<< "$dis"; then
    echo "ERROR: $bin uses reciprocal-estimate instructions, whose results" >&2
    echo "differ between Intel and AMD CPUs:" >&2
    grep -E '\b(v?rcpps|v?rcpss|v?rsqrtps|v?rsqrtss)\b' <<< "$dis" | head -3 >&2
    echo "Build with -mrecip=none and do not use _mm256_rcp_ps/_mm256_rsqrt_ps." >&2
    return 1
  fi
  echo "no reciprocal-estimate instructions in $bin"
}
check_no_recip_estimate ./cmix

# Step 4. [this entry]
# Pack the binary. PACKER=pk (default): our context-mixing packer (packer/pack.sh), under 100 KB
# against upx --lzma's 170 KB; the binary is stored in both comp9 and archive9. PACKER=upx: the old way.
# pack.sh writes a small stub plus the packed image; at start the stub decodes
# the image in memory and runs it with the same arguments. It reads
# PACK_KEEP_DEBUG and PACK_KEEP_ELF from the environment (see the header).
if [ "${PACKER:-pk}" = upx ]; then
  upx-ucl --lzma cmix
else
  PACK_HOLE="$HOLE" bash packer/pack.sh ./cmix ./cmix.packed
  mv ./cmix.packed ./cmix
fi
# Number of leading bytes of the packed executable that the decompressor needs (written by
# pack.sh; 0 = all of it).
DECOMP_CUT=0; [ -f ./cmix.packed.cut ] && DECOMP_CUT=$(cat ./cmix.packed.cut) && rm -f ./cmix.packed.cut

# Step 5: assemble the compressor package. Layout of ./run/cmix (= comp9):
#   packed executable | comp_dict | comp_order | comp_tfweights | header.dat
# header.dat is a 16-byte trailer holding the sizes of the appended parts, so
# the program can find them from the end of its own file. When -e compresses
# enwik9 it writes archive9 the same way: the same packed executable, the
# dictionary, the weights, the compressed data and a trailer (no article
# order: the decompressor does not need it).
# this is a directory where the compressor binary will be placed 
DIR=run
mkdir -p ./$DIR
ROOT=$(pwd)
cp ./cmix $DIR/cmix_orig
# git diff > $DIR/patch
# exit
# building a selfextracting binary 
pushd $DIR
# creating a compressed version of dictionary
./cmix_orig -c $ROOT/dictionary/english.dic ./comp_dict
# creating a compressed verions of a file with new order
./cmix_orig -c $ROOT/src/readalike_prepr/data/new_article_order ./comp_order
# the transformer weights are already losslessly compressed (FX2TFWC2, made by
# pysrc/weights_compress.py from the export of models/6m-q4-fp32.tch) and are
# loaded directly in that format, so they are appended as-is
cp $ROOT/models/6m-q4-fp32.tfwc2 ./comp_tfweights
# creating a header with size of the above files
# (arguments: dictionary size, article-order size, the third field, and the
# weights size; writes ./header.dat). The third field is the size of the
# compressed enwik9 in archive9's trailer; comp9 has no such section, and
# [this entry] its trailer carries DECOMP_CUT there instead (see step 2b and
# selfextract_comp in src/readalike_prepr/self_extract.h).
./cmix_orig -h $(wc -c ./comp_dict | awk '{print $1}') $(wc -c ./comp_order | awk '{print $1}') $DECOMP_CUT $(wc -c ./comp_tfweights | awk '{print $1}')

# merging the above files and setting permissions for the final executable file
cat ./cmix_orig ./comp_dict ./comp_order ./comp_tfweights header.dat > ./cmix
chmod +x ./cmix
