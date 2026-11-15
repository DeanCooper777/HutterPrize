# makefile -- builds ./cmix, the single executable that is the compressor and,
# appended to its data, the decompressor of this Hutter Prize entry.
#
# Where it fits: this file only compiles and links. The submission is made by
# build_and_construct_comp.sh, which calls `make prof_gen` and `make prof_use`
# (profile-guided build), checks the binary, packs it and appends the
# dictionary, article order and transformer weights to form the compressor
# package (comp9). ../build.ps1 is the Windows development twin of both files.
#
# Three groups of objects, each with its own flags:
#   fast  cmix proper (context models, PPMD, mixers, SSE, arithmetic coder,
#         predictor, runner): -O3, -ffp-model=fast, PGO + LTO
#   slow  preprocessor and dictionary: -Os (run once, size matters more)
#   tf_*  the transformer byte model (cpp_infer/): -O3, strict IEEE floating
#         point, no PGO/LTO
#
# Targets:
#   make cmix       plain optimized build (no PGO)
#   make prof_gen   instrumented build writing profiles to ./pgo_data
#   make prof_use   final build using ./pgo_data/default.profdata, with LTO
#   make remap      helper that renumbers the article order file (not shipped)
#   make clean / all / data/enwik9 (downloads the test file)
#
# Variables (command line):
#   CFLAGS_DEFINES="-D..."  extra macros for the fast and slow groups. The
#       build script passes -DSEED, -DUPDATE_LIMIT and, with OFFICIAL=1,
#       -DCMIX_OFFICIAL. It does NOT reach the tf_* objects.
#   NATIVE=1 / COREI7=1 / ZEN2=1   development-only instruction sets (below).
#
# Testing: none here; the transformer objects have their own test makefiles
# under cpp_infer/, built with the same floating-point rules.
#
# Changes from the previous winning entry (fx2-cmix-transformer-v1), each
# marked [this entry] below:
#   - size: no unwind tables, leaner link flags, -fno-exceptions -fno-rtti and
#     -Os for the load-time arena builder. The executable is stored in both
#     comp9 and archive9, so every byte saved counts twice in the score.
#   - portability: -DFX2_NO_VNNI compiles out the VNNI matmul kernels that the
#     development machine uses, so the submitted binary is AVX2-only.
#   - new object tf_act16.o (16-bit activation kernels).
#
# Experiments, not part of the submission: the multi-core compress-only mode
# is compiled with -DCMIX_PIPE in BOTH CFLAGS_DEFINES and CPPFLAGS_TRANSFORMER
# plus -pthread in CPPFLAGS_TRANSFORMER and LFLAGS. There is no switch for it
# here on purpose; ../scripts/cloud/full_pipe_*.sh patch the lines beginning
# "CPPFLAGS_TRANSFORMER := " and "LFLAGS := " with sed, so keep those two
# lines starting exactly like that.

CC = clang++-17

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# Flags of the "fast" group; the "slow" group is derived from it further down.
# -ffp-model=fast only changes how the compiler arranges the arithmetic.
# Compressor and decompressor are the same binary, so both still compute the
# same bits, provided no instruction with CPU-dependent results is chosen;
# -mrecip=none below takes care of that.
CPPFLAGS_PART-THAT-SHOULD-BE-FAST := $(CFLAGS_DEFINES) -m64 -Wall -std=c++17 -ffp-model=fast -fno-exceptions -fno-threadsafe-statics -Wno-unknown-escape-sequence -Wno-unused-variable -ffp-model=fast -fno-exceptions -fno-threadsafe-statics -Wno-unneeded-internal-declaration -Wno-unused-but-set-variable -Wno-format 

# Instruction set. The default is the portable AVX2 baseline x86-64-v3
# (SSE*, AVX, AVX2, FMA, F16C, BMI1/2, LZCNT, MOVBE, POPCNT) -- exactly what
# the kernels are written against, and the largest set both Hutter Prize test
# machines have: the Intel Core i7-1165G7 (Tiger Lake) and the AMD Ryzen 7
# (Zen 2). The other three settings are for development only -- a submission
# must use the default. NATIVE=1 in particular bakes in whatever the *build*
# machine happens to support, and anything a test machine lacks is an illegal
# instruction (SIGILL) there: Zen 2 has no AVX-512 at all, and Tiger Lake has
# no AVX-VNNI -- and clang does fold the transformer's
# _mm256_add_epi32(_mm256_madd_epi16(..)) into an AVX-VNNI vpdpwssd whenever
# the build machine offers it. (ZEN2=1 is likewise AMD-only: znver2 enables
# SSE4A, which Tiger Lake does not have.)
ifdef NATIVE
$(info NATIVE defined -- development only, the binary is NOT portable)
ARCHFLAGS := -march=native -mtune=native
else
ifdef COREI7
$(info COREI7 defined)
ARCHFLAGS := -march=corei7 -mavx2 -mfma -mf16c -mbmi2
else
ifdef ZEN2
$(info ZEN2 defined)
ARCHFLAGS := -march=znver2
else
ARCHFLAGS := -march=x86-64-v3 -mtune=generic
$(info portable AVX2 baseline (x86-64-v3) used)
endif
endif
endif

# Bit-reproducibility across CPU vendors. -ffp-model=fast lets clang compute
# x/y and 1/sqrt(x) with the RCPPS/RCPSS/RSQRTPS/RSQRTSS *estimate*
# instructions plus a Newton-Raphson step. Those instructions are only
# specified to a relative error bound (1.5*2^-12); the bits they actually
# return come from a vendor-specific lookup table, so the same binary gives
# different low-order bits on Intel and on AMD. Every one of those bits feeds
# a model prediction, so an archive compressed on one vendor's CPU cannot be
# decompressed on the other's: the arithmetic coder desynchronises and the
# output is garbage. -mrecip=none forces true IEEE divides and square roots,
# which are exactly specified and therefore identical on every x86-64 CPU.
# Do not remove this; build_and_construct_comp.sh re-checks the built binary.
ARCHFLAGS += -mrecip=none
# [this entry]
# Size: nothing in cmix catches exceptions, so the unwind tables are dead weight.
ARCHFLAGS += -fno-asynchronous-unwind-tables -fno-unwind-tables
# [this entry]
# Size: a fixed-address (non-PIE) executable. The position-independent default
# costs a relocation entry for every stored pointer (about 8 KB of .rela.dyn)
# and longer address computations; fixed addresses take 1.4 KB off the packed
# binary. Nothing here relies on address randomisation. See -no-pie in LFLAGS.
ARCHFLAGS += -fno-pie

CPPFLAGS_PART-THAT-SHOULD-BE-FAST += $(ARCHFLAGS)

# slow = the same flags with -Os, fast = with -O3. -fdata-sections and
# -ffunction-sections put every function and object in its own section so the
# linker's --gc-sections can drop what is never referenced.
CPPFLAGS_PART-THAT-CAN-BE-SLOW    := $(CPPFLAGS_PART-THAT-SHOULD-BE-FAST)
CPPFLAGS_PART-THAT-CAN-BE-SLOW    += -Os -fdata-sections -ffunction-sections
CPPFLAGS_PART-THAT-SHOULD-BE-FAST += -O3 -fdata-sections -ffunction-sections

# Link flags. --gc-sections removes unreferenced sections.
# [this entry] Four more flags, all to make the file smaller: no build-id
# note, no RELRO segment, only the GNU symbol hash table, and no page-aligned
# separation of code from read-only data (-z noseparate-code).
# [this entry] -no-pie: fixed-address executable (see -fno-pie above).
LFLAGS := -m64 -no-pie -Wl,--gc-sections -std=c++17 -Wl,--build-id=none -Wl,-z,norelro -Wl,--hash-style=gnu -Wl,-z,noseparate-code

# Transformer inference objects (cpp_infer). Compiled with the exact flag set
# of cpp_infer/Makefile: NO -ffp-model=fast (bit-exact IEEE arithmetic keeps
# the compressor and the decompressor's probability streams identical and
# matches the validated cpp_infer build), and NO PGO/LTO (the profiling run
# never exercises this code, and excluding it keeps its code generation
# identical to the hand-optimized, benchmarked cpp_infer objects).
# The kernels require AVX2/FMA/F16C, which every ARCHFLAGS variant provides.
# [this entry] -DFX2_NO_VNNI: qmat_dense.cpp has AVX-VNNI and AVX512-VNNI
# variants of the matmul kernels, selected at run time from the CPU. Their
# results are bit-identical to the AVX2 kernels, but the submission must not
# contain instructions past AVX2 (build_and_construct_comp.sh disassembles the
# binary and refuses it), so they are compiled out here. The Windows
# development build (../build.ps1) keeps them.
# [this entry] -fno-exceptions -fno-rtti: size; this code uses neither.
# CFLAGS_DEFINES is deliberately not part of these flags (-DSEED and the like
# are not used here), with one exception:
# [this entry] -DCMIX_OFFICIAL is passed on, so that the official build does
# not read the CMIX_ACT16 experiment switch from the environment
# (opt/arena_build.cpp): a stray variable on the test machine must not be able
# to change the predictions.
CPPFLAGS_TRANSFORMER := -m64 -O3 -std=c++17 -Wall -Wextra -fno-math-errno -fdata-sections -ffunction-sections -DFX2_NO_VNNI
CPPFLAGS_TRANSFORMER += $(ARCHFLAGS) -fno-exceptions -fno-rtti $(filter -DCMIX_OFFICIAL,$(CFLAGS_DEFINES))

# [this entry] tf_act16.o added: the 16-bit activation kernels
# (cpp_infer/src/opt/act16.cpp, tested by test_act16.cpp).
TRANSFORMER_OBJS := tf_weights_io.o tf_weights_io_compressed.o tf_qmat_dense.o tf_qmat_sparse.o tf_attn.o tf_kda.o tf_glue.o tf_arena_build.o tf_act16.o tf_model_opt.o

# [this entry] Every object of the final program is made in two steps: the
# compiler writes x86-64 assembly into $(ASM_DIR), and the assembler turns
# that file into the object. The assembly files are therefore the exact source
# of the shipped binary: "make asm_build" (or FROM_ASM=DIR with
# build_and_construct_comp.sh) rebuilds the identical cmix from them with no
# C++ compiler, and a routine can be hand-tuned there. $(ARCHFLAGS) goes to
# the assembler because the target CPU decides which multi-byte NOPs pad the
# code.
ASM_DIR ?= asm
AS_CMD = $(CC) $(ARCHFLAGS) -c
$(shell mkdir -p $(ASM_DIR))

tf_weights_io.o: cpp_infer/src/weights_io.cpp cpp_infer/src/weights_io.h
	$(CC) $(CPPFLAGS_TRANSFORMER) -S cpp_infer/src/weights_io.cpp -o $(ASM_DIR)/$(@:.o=.s)
	$(AS_CMD) $(ASM_DIR)/$(@:.o=.s) -o $@

# load-time only: -Os keeps the range decoder at ~5KB of code (see
# cpp_infer/Makefile)
tf_weights_io_compressed.o: cpp_infer/src/weights_io_compressed.cpp cpp_infer/src/weights_io.h
	$(CC) $(filter-out -O3,$(CPPFLAGS_TRANSFORMER)) -Os -S cpp_infer/src/weights_io_compressed.cpp -o $(ASM_DIR)/$(@:.o=.s)
	$(AS_CMD) $(ASM_DIR)/$(@:.o=.s) -o $@

# [this entry]
# load-time only (builds the arena from the weights file once): -Os, about 29 KB of code at -O3
# This explicit rule takes precedence over the tf_%.o pattern rule below.
tf_arena_build.o: cpp_infer/src/opt/arena_build.cpp $(wildcard cpp_infer/src/opt/*.h) cpp_infer/src/weights_io.h
	$(CC) $(filter-out -O3,$(CPPFLAGS_TRANSFORMER)) -Os -S $< -o $(ASM_DIR)/$(@:.o=.s)
	$(AS_CMD) $(ASM_DIR)/$(@:.o=.s) -o $@

# every other transformer object: tf_<name>.o from cpp_infer/src/opt/<name>.cpp
tf_%.o: cpp_infer/src/opt/%.cpp $(wildcard cpp_infer/src/opt/*.h) cpp_infer/src/weights_io.h
	$(CC) $(CPPFLAGS_TRANSFORMER) -S $< -o $(ASM_DIR)/$(@:.o=.s)
	$(AS_CMD) $(ASM_DIR)/$(@:.o=.s) -o $@


# Profile-guided optimization, in two builds (driven by
# build_and_construct_comp.sh):
#   prof_gen  builds an instrumented cmix. The script runs it once on
#             prof_input/input; that writes raw profiles into ./pgo_data,
#             which llvm-profdata merges into pgo_data/default.profdata.
#   prof_use  rebuilds from scratch using that profile, with link-time
#             optimization (-flto) across the fast and slow groups.
# Both use target-specific variables, so only the fast/slow flags and the
# link change; the tf_* objects are compiled exactly as in a plain build.
prof_gen: CPPFLAGS_PART-THAT-CAN-BE-SLOW    += -fprofile-generate=$(ROOT_DIR)/pgo_data
prof_gen: CPPFLAGS_PART-THAT-SHOULD-BE-FAST += -fprofile-generate=$(ROOT_DIR)/pgo_data
prof_gen: LFLAGS                            += -fprofile-generate=$(ROOT_DIR)/pgo_data
prof_gen: clean cmix

prof_use: CPPFLAGS_PART-THAT-CAN-BE-SLOW    += -fprofile-use=$(ROOT_DIR)/pgo_data -flto
prof_use: CPPFLAGS_PART-THAT-SHOULD-BE-FAST += -fprofile-use=$(ROOT_DIR)/pgo_data -flto
prof_use: LFLAGS                            += -fprofile-use=$(ROOT_DIR)/pgo_data -flto
prof_use: LTO_NATIVE := 1
prof_use: clean cmix
# [this entry] second link (see the relink target): used by
# build_and_construct_comp.sh to move the compress-only functions to the end
# of .text.
prof_relink: relink


# "slow" group: text preprocessor and dictionary coder, compiled for size.
slow: src/preprocess/preprocessor.cpp src/preprocess/preprocessor.h src/preprocess/dictionary.cpp src/preprocess/dictionary.h
	$(CC) $(CPPFLAGS_PART-THAT-CAN-BE-SLOW) src/preprocess/preprocessor.cpp src/preprocess/dictionary.cpp -c 

# "fast" group: everything on the per-bit path, compiled in one clang call.
fast: src/coder/decoder.cpp src/coder/decoder.h src/coder/encoder.cpp src/coder/encoder.h src/context-manager.cpp src/context-manager.h src/contexts/bit-context.cpp src/contexts/bit-context.h src/contexts/bracket-context.cpp src/contexts/bracket-context.h src/contexts/combined-context.cpp src/contexts/combined-context.h src/contexts/context-hash.cpp src/contexts/context-hash.h src/contexts/context.h src/contexts/indirect-hash.cpp src/contexts/indirect-hash.h src/contexts/interval-hash.cpp src/contexts/interval-hash.h src/contexts/interval.cpp src/contexts/interval.h src/contexts/sparse.cpp src/contexts/sparse.h  src/models/bracket.cpp src/models/bracket.h src/models/byte-model.cpp src/models/byte-model.h src/models/direct-hash.cpp src/models/direct-hash.h src/models/direct.cpp src/models/direct.h src/models/indirect.cpp src/models/indirect.h src/models/match.cpp src/models/match.h src/models/model.h src/models/fxcmv1.h src/models/ppmd.cpp src/models/ppmd.h src/states/nonstationary.cpp src/states/nonstationary.h src/states/run-map.cpp src/states/run-map.h src/states/state.h src/mixer/byte-mixer.cpp src/mixer/byte-mixer.h src/mixer/lstm-layer.h src/mixer/lstm.h src/mixer/mixer-input.cpp src/mixer/mixer-input.h src/mixer/mixer.cpp src/mixer/mixer.h src/mixer/sigmoid.cpp src/mixer/sigmoid.h src/mixer/sse.cpp src/mixer/sse.h src/predictor.h src/predictor.cpp src/runner.cpp
	$(CC) $(CPPFLAGS_PART-THAT-SHOULD-BE-FAST) src/coder/decoder.cpp src/coder/encoder.cpp src/context-manager.cpp src/contexts/bit-context.cpp src/contexts/bracket-context.cpp src/contexts/combined-context.cpp src/contexts/context-hash.cpp src/contexts/indirect-hash.cpp src/contexts/interval-hash.cpp src/contexts/interval.cpp src/contexts/sparse.cpp src/models/bracket.cpp src/models/byte-model.cpp src/models/direct-hash.cpp src/models/direct.cpp src/models/indirect.cpp src/models/match.cpp src/models/fxcmv1.cpp src/models/ppmd.cpp src/states/nonstationary.cpp src/states/run-map.cpp src/mixer/byte-mixer.cpp src/mixer/mixer-input.cpp src/mixer/mixer.cpp src/mixer/sigmoid.cpp src/mixer/sse.cpp -c src/predictor.cpp src/runner.cpp

# Link. The objects are deleted afterwards (the fast and slow targets
# recompile everything on every build anyway) unless KEEP_OBJS is set.
# [this entry] The link writes cmix.sym (with symbols) and a link map, and
# cmix is the stripped copy; before, the link itself stripped (-s). The
# symbols and the map are what packer/enc_only.py needs to find the functions
# that only compression uses. build_and_construct_comp.sh then runs
# "make relink" with LINK_EXTRA=-Wl,--section-ordering-file=..., which links
# the same objects again with those functions placed last in .text, so that
# the packer can leave them out of the decompressor (packer/pk.cpp, "hole").
CMIX_OBJS := bit-context.o bracket-context.o bracket.o byte-mixer.o byte-model.o combined-context.o context-hash.o context-manager.o decoder.o dictionary.o direct-hash.o direct.o encoder.o indirect-hash.o indirect.o interval-hash.o interval.o match.o mixer-input.o mixer.o nonstationary.o fxcmv1.o ppmd.o predictor.o preprocessor.o run-map.o runner.o sigmoid.o sparse.o sse.o
# [this entry] With link-time optimization (LTO_NATIVE, set by prof_use) the
# link is done in two steps: first the optimizer runs over the fast and slow
# groups and writes its result as assembly, $(ASM_DIR)/cmix_lto.s
# (-plugin-opt=emit-asm), which is assembled to cmix_lto.o; then cmix_lto.o
# and the transformer objects are linked like any other objects. The second
# step can be repeated with a different section order (relink).
STRIP ?= strip
comma := ,
cmix: fast slow $(TRANSFORMER_OBJS)
	$(if $(LTO_NATIVE),$(CC) $(LFLAGS) $(CMIX_OBJS) $(TRANSFORMER_OBJS) -Wl$(comma)-plugin-opt=emit-asm -o $(ASM_DIR)/cmix_lto.s && $(AS_CMD) $(ASM_DIR)/cmix_lto.s -o cmix_lto.o)
	$(CC) $(LFLAGS) $(if $(LTO_NATIVE),cmix_lto.o,$(CMIX_OBJS)) $(TRANSFORMER_OBJS) $(LINK_EXTRA) -Wl,-Map=cmix.map -o cmix.sym
	$(STRIP) -s cmix.sym -o cmix
	$(if $(KEEP_OBJS),,rm -f *.o)

# [this entry] Second link of cmix_lto.o and the transformer objects kept by
# KEEP_OBJS=1 (see above).
relink:
	$(CC) $(LFLAGS) cmix_lto.o $(TRANSFORMER_OBJS) $(LINK_EXTRA) -Wl,-Map=cmix.map -o cmix.sym
	$(STRIP) -s cmix.sym -o cmix
	$(if $(KEEP_OBJS),,rm -f *.o)

# [this entry] Build from the assembly in $(ASM_DIR) alone (see the note above
# the transformer objects): assembles cmix_lto.s and tf_*.s and links cmix.sym
# / cmix exactly as the cmix target does (same LFLAGS, same LINK_EXTRA).
asm_build:
	$(AS_CMD) $(ASM_DIR)/cmix_lto.s -o cmix_lto.o
	for f in $(TRANSFORMER_OBJS); do $(AS_CMD) $(ASM_DIR)/$${f%.o}.s -o $$f || exit 1; done
	$(CC) $(LFLAGS) cmix_lto.o $(TRANSFORMER_OBJS) $(LINK_EXTRA) -Wl,-Map=cmix.map -o cmix.sym
	$(STRIP) -s cmix.sym -o cmix
	$(if $(KEEP_OBJS),,rm -f *.o)

# Development helper: renumbers the article order file (skipping redirect
# articles) so that it compresses better. Its output is shipped as data,
# src/readalike_prepr/data/new_article_order; the tool itself is not shipped.
remap: src/readalike_prepr/article_remap.cpp
	$(CC) src/readalike_prepr/article_remap.cpp -o remap

clean:
	rm -f *.o
	rm -f cmix cmix.sym cmix.map cmix.ltostep
	rm -f remap

all: cmix remap

# Fetches enwik9, the file the contest compresses (used by make_training_data.sh).
data/enwik9:
	mkdir -p data/
	wget -P data/ http://mattmahoney.net/dc/enwik9.zip
	unzip data/enwik9.zip -d data/
	rm data/enwik9.zip
