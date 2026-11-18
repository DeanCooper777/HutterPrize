# fx2-cmix transformer C++ inference (SPEC.md section 6)
# default compiler clang++-17; alternative: make CXX=g++-13
#
# What this builds: the stand-alone test and benchmark programs of the
# transformer byte model, in bin/. Two groups:
#   - the naive reference (src/model.cpp + src/kernels.cpp): test_components,
#     test_e2e, bench, and test_weights_compressed for the weights decoder;
#   - "opt", the optimized model that cmix runs (src/opt/): test_e2e_opt,
#     test_xcheck, bench_opt, bench_opt_prof.
# How it fits: this Makefile does NOT build the compressor. The cmix binary is
# built by ../makefile, which compiles the same src/opt sources (plus
# weights_io*.cpp) into its tf_*.o objects with the same floating-point rules
# as here. This file is the development and validation build.
#
# Changes from the previous winning entry (fx2-cmix-transformer-v1):
# [this entry] act16.o (src/opt/act16.cpp, the 16-bit activation kernels that
# model_opt.cpp and arena_build.cpp call) added to OPT_COBJS. Note that the
# optimized model uses 16-bit activations at four sites by default while the
# naive reference model is 8-bit, so test_xcheck and test_e2e_opt compare like
# with like only when run with CMIX_ACT16=0. src/opt/test_act16.cpp (the test
# of those kernels) has its own compile line in its header comment.

ifeq ($(origin CXX),default)
CXX := clang++-17
endif

CXXFLAGS ?= -O3 -march=znver2 -std=c++17 -Wall -Wextra -fno-math-errno -mrecip=none
# -mrecip=none: never let the compiler substitute RCPPS/RSQRTPS estimates for
# a divide or a square root. Their results are only specified to a relative
# error bound and differ between Intel and AMD, which would make the
# compressor and the decompressor disagree on a CPU of the other vendor.
# NO -ffast-math anywhere (SPEC forbids it)

# Directories; objects are kept per compiler so clang and gcc builds coexist.
SRC := src
BIN := bin
OBJ := $(BIN)/obj-$(notdir $(CXX))

# The naive reference model and both weights readers.
CORE_SRCS := $(SRC)/weights_io.cpp $(SRC)/weights_io_compressed.cpp $(SRC)/kernels.cpp $(SRC)/model.cpp
CORE_OBJS := $(patsubst $(SRC)/%.cpp,$(OBJ)/%.o,$(CORE_SRCS))
HDRS := $(SRC)/weights_io.h $(SRC)/kernels.h $(SRC)/model.h $(SRC)/npy.h $(SRC)/testdata.h

# marker forcing a relink when CXX changes between invocations
CXXMARK := $(BIN)/.built-with-$(notdir $(CXX))

all: $(BIN)/test_components $(BIN)/test_e2e $(BIN)/bench opt

$(OBJ):
	mkdir -p $(OBJ)

$(CXXMARK): | $(OBJ)
	rm -f $(BIN)/.built-with-*
	touch $@

$(OBJ)/%.o: $(SRC)/%.cpp $(HDRS) | $(OBJ)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# load-time only, so optimize the decompressor for size (4.9 KB vs 20.7 KB
# of code at -O3; decode speed is irrelevant next to inference)
$(OBJ)/weights_io_compressed.o: $(SRC)/weights_io_compressed.cpp $(HDRS) | $(OBJ)
	$(CXX) $(filter-out -O3,$(CXXFLAGS)) -Os -c $< -o $@

# Programs of the naive reference model.
$(BIN)/test_components: $(OBJ)/test_components.o $(CORE_OBJS) $(CXXMARK)
	$(CXX) $(CXXFLAGS) $(filter %.o,$^) -o $@ -lm

$(BIN)/test_e2e: $(OBJ)/test_e2e.o $(CORE_OBJS) $(CXXMARK)
	$(CXX) $(CXXFLAGS) $(filter %.o,$^) -o $@ -lm

$(BIN)/bench: $(OBJ)/bench.o $(CORE_OBJS) $(CXXMARK)
	$(CXX) $(CXXFLAGS) $(filter %.o,$^) -o $@ -lm

$(BIN)/test_weights_compressed: $(OBJ)/test_weights_compressed.o $(OBJ)/weights_io.o $(OBJ)/weights_io_compressed.o $(CXXMARK)
	$(CXX) $(CXXFLAGS) $(filter %.o,$^) -o $@ -lm

test_weights_compressed: $(BIN)/test_weights_compressed

test_components: $(BIN)/test_components
test_e2e: $(BIN)/test_e2e
bench: $(BIN)/bench

# ---------------- optimized integration (src/opt) ----------------
OPT := $(SRC)/opt
OBJOPT := $(OBJ)/opt

# K = kernel workstreams (qmat, attn, kda, glue); I / C = integration (the
# weight arena builder and the model).
OPT_KHDRS := $(OPT)/qmat.h $(OPT)/qmat_dense.h $(OPT)/qmat_sparse.h \
             $(OPT)/attn.h $(OPT)/kda.h $(OPT)/kda_math.h $(OPT)/vec_math.h \
             $(OPT)/glue.h $(OPT)/sparse_acts.h
OPT_IHDRS := $(OPT)/arena_build.h $(OPT)/model_opt.h
OPT_KOBJS := $(OBJOPT)/qmat_dense.o $(OBJOPT)/qmat_sparse.o $(OBJOPT)/attn.o \
             $(OBJOPT)/kda.o $(OBJOPT)/glue.o
# [this entry] act16.o: the 16-bit activation kernels that model_opt.cpp and arena_build.cpp call
OPT_COBJS := $(OBJOPT)/arena_build.o $(OBJOPT)/model_opt.o $(OBJOPT)/act16.o

$(OBJOPT):
	mkdir -p $(OBJOPT)

$(OBJOPT)/%.o: $(OPT)/%.cpp $(OPT_KHDRS) $(OPT_IHDRS) $(HDRS) | $(OBJOPT)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# instrumented variants (-DFX2_PROF), same sources
$(OBJOPT)/model_opt_prof.o: $(OPT)/model_opt.cpp $(OPT_KHDRS) $(OPT_IHDRS) | $(OBJOPT)
	$(CXX) $(CXXFLAGS) -DFX2_PROF -c $< -o $@
$(OBJOPT)/bench_opt_prof.o: $(OPT)/bench_opt.cpp $(OPT_KHDRS) $(OPT_IHDRS) $(HDRS) bench/bench_common.h | $(OBJOPT)
	$(CXX) $(CXXFLAGS) -DFX2_PROF -c $< -o $@
$(OBJOPT)/bench_opt.o: $(OPT)/bench_opt.cpp $(OPT_KHDRS) $(OPT_IHDRS) $(HDRS) bench/bench_common.h | $(OBJOPT)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Programs of the optimized model: loss test, naive-vs-optimized cross-check,
# throughput benchmark without and with the per-part profile.
$(BIN)/test_e2e_opt: $(OBJOPT)/test_e2e_opt.o $(OPT_COBJS) $(OPT_KOBJS) $(OBJ)/weights_io.o $(OBJ)/weights_io_compressed.o $(OBJ)/kernels.o $(CXXMARK)
	$(CXX) $(CXXFLAGS) $(filter %.o,$^) -o $@ -lm

$(BIN)/test_xcheck: $(OBJOPT)/test_xcheck.o $(OPT_COBJS) $(OPT_KOBJS) $(CORE_OBJS) $(CXXMARK)
	$(CXX) $(CXXFLAGS) $(filter %.o,$^) -o $@ -lm

$(BIN)/bench_opt: $(OBJOPT)/bench_opt.o $(OPT_COBJS) $(OPT_KOBJS) $(OBJ)/weights_io.o $(OBJ)/weights_io_compressed.o $(CXXMARK)
	$(CXX) $(CXXFLAGS) $(filter %.o,$^) -o $@ -lm

$(BIN)/bench_opt_prof: $(OBJOPT)/bench_opt_prof.o $(OBJOPT)/model_opt_prof.o $(OBJOPT)/arena_build.o $(OPT_KOBJS) $(OBJ)/weights_io.o $(OBJ)/weights_io_compressed.o $(CXXMARK)
	$(CXX) $(CXXFLAGS) $(filter %.o,$^) -o $@ -lm

opt: $(BIN)/test_e2e_opt $(BIN)/test_xcheck $(BIN)/bench_opt $(BIN)/bench_opt_prof
test_e2e_opt: $(BIN)/test_e2e_opt
test_xcheck: $(BIN)/test_xcheck
bench_opt: $(BIN)/bench_opt
bench_opt_prof: $(BIN)/bench_opt_prof

clean:
	rm -rf $(BIN)

.PHONY: all clean test_components test_e2e bench opt test_e2e_opt test_xcheck bench_opt bench_opt_prof test_weights_compressed
