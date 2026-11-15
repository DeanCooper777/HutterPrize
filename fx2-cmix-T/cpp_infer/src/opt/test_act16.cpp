// test_act16.cpp — the packed 16-bit-activation kernels (spmv16p_add,
// gemv16p_add, relu2_quant16p) against the int8 reference kernels of
// act16.cpp: results must be bitwise identical. Also prints a rough timing
// (rdtsc ticks per call) with 12 layers' worth of weights, cold (a 64 MB
// buffer is swept between calls) and warm.
//
//   clang++ -O3 -march=x86-64-v3 -std=c++17 test_act16.cpp act16.cpp -o test_act16
//   ./test_act16          (no arguments, no data files; run from any directory)
//
// New in this entry. This is the proof that the 16-bit activation kernels are
// exact.
//
// Background: the transformer byte model multiplies 4-bit weights by quantized
// activations. [this entry] quantizes the activations at selected matmul
// inputs to 16 bits instead of 8 (switch CMIX_ACT16, see act16.h and
// arena_build.h), which needs new kernels. The kernels the model calls are
// the "packed" ones: weights stored as nibbles u = w + 7 (half the bytes of
// int8), activations split into two bytes so that vpmaddubsw can be used,
// with correction terms (the sum of the activations, 128 * a row's weight
// sum) that turn the biased byte products back into the true dot product.
// That algebra, and the 16-bit partial sums that must be widened before they
// wrap, are where a mistake could hide. Compressor and decompressor both run
// these kernels, and a single wrong bit in one output would desynchronise the
// arithmetic coder, so "close" is not good enough.
//
// What "exact" means here: every kernel computes an integer dot product in
// int32 (it cannot overflow: fewer than 1000 terms of at most 32767 * 7),
// converts it to float once and multiplies by a per-row float (fold). If the
// int32 dot is right, the float result is determined, so all comparisons are
// bitwise (memcmp), never with a tolerance.
//
// References:
//   - spmv16_add / gemv16_add / relu2_quant16 (act16.cpp): the plain versions
//     with int8 weights and a direct vpmaddwd (int16 x int16 -> int32)
//     accumulation, no packing and no correction terms;
//   - for gemv16p_set, a scalar loop in this file (run_set). gemv16p_set and
//     gemv16p_add are one template in act16.cpp, so this also ties the packed
//     dense kernel, and through run() the int8 dense kernel, to plain C.
//
// Pass: every line reports "0 mismatches", the last line is "ALL OK" and the
// exit code is 0. Any mismatch prints which kernel, iteration and input mode,
// then "FAILED" and exit code 1. The ticks/call figures are information only.
//
// Protects: act16.cpp / act16.h, used by model_opt.cpp (per-token inference)
// with the layouts prepared by arena_build.cpp.
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <random>
#include <vector>

#ifdef _MSC_VER
#include <intrin.h>
#else
#include <x86intrin.h>
#endif

#include "act16.h"

using namespace fx2::opt;

namespace {
// D = model width (rows of mlp.down / the output projection, and the inputs
// of every row-packed matmul); NL = number of layers. Weights for all NL
// layers are generated so that the timing sees a realistic working set.
constexpr int D = 192, NL = 12;

// 64-byte aligned allocation (cache-line aligned, as the model's arena is)
void* amalloc(size_t n) {
#ifdef _WIN32
  return _aligned_malloc(n, 64);
#else
  return aligned_alloc(64, (n + 63) / 64 * 64);
#endif
}

// Packed kernels against the int8 reference kernels, for an MLP width DMLP.
// Each iteration checks three things on fresh random data:
//   1. relu2_quant16p == relu2_quant16 (the quantizer of the mlp.down input,
//      relu(h)^2 / s rounded and clamped to [0, 32767]), plus the three extra
//      outputs of the packed version (idxh, nh, suma) against direct counts;
//   2. spmv16p_add == spmv16_add: sparse 192 x DMLP product over the nonzero
//      activations (the mlp.down matmul);
//   3. gemv16p_add == gemv16_add: dense 192 x 192 product with a signed
//      16-bit input (the attention output projection).
// timing = true additionally sweeps a 64 MB buffer before each timed call so
// the weights are read from memory, not from cache, as in real inference.
// Returns the number of mismatches.
int run(int DMLP, int iters, bool timing) {
  std::mt19937 rng(12345 + DMLP);
  std::uniform_int_distribution<int> wd(-7, 7);
  std::uniform_real_distribution<float> ud(0.0f, 1.0f);
  // weights cover the whole 4-bit range [-7, 7], i.e. nibbles 0..14
  // weights: [NL] down (D x DMLP) and op (D x D), row-major int8
  std::vector<int8_t> wdown(size_t(NL) * D * DMLP), wop(size_t(NL) * D * D);
  for (auto& w : wdown) w = static_cast<int8_t>(wd(rng));
  for (auto& w : wop) w = static_cast<int8_t>(wd(rng));
  // reference layouts: down as int8 columns, op as int8 rows
  int8_t* cols8 = static_cast<int8_t*>(amalloc(size_t(NL) * DMLP * D + 4096));
  int8_t* rows8 = static_cast<int8_t*>(amalloc(size_t(NL) * D * D + 4096));
  uint8_t* colsp = static_cast<uint8_t*>(amalloc(size_t(NL) * DMLP * 96 + 4096));
  uint8_t* rowsp = static_cast<uint8_t*>(amalloc(size_t(NL) * D * 96 + 4096));
  // cols8 / rows8: int8 layouts for the reference kernels. colsp / rowsp: the
  // same weights nibble-packed by pack16_nibbles (96 bytes per 192 weights).
  // krow[r] = 128 * (sum of row r's weights): the constant gemv16p needs to
  // undo the re-centring of the activation's low byte (see act16.cpp).
  std::vector<int32_t> krow(size_t(NL) * D);
  std::vector<int8_t> col(D);
  for (int l = 0; l < NL; l++) {
    for (int c = 0; c < DMLP; c++) {
      for (int r = 0; r < D; r++)
        col[r] = cols8[(size_t(l) * DMLP + c) * D + r] =
            wdown[(size_t(l) * D + r) * DMLP + c];
      pack16_nibbles(col.data(), D, colsp + (size_t(l) * DMLP + c) * 96);
    }
    for (int r = 0; r < D; r++) {
      const int8_t* w = &wop[(size_t(l) * D + r) * D];
      std::memcpy(rows8 + (size_t(l) * D + r) * D, w, D);
      pack16_nibbles(w, D, rowsp + (size_t(l) * D + r) * 96);
      int s = 0;
      for (int c = 0; c < D; c++) s += w[c];
      krow[size_t(l) * D + r] = 128 * s;
    }
  }
  // fold = per-row float scale; base = the value already in the output vector
  // (the kernels ADD to it, so a nonzero start checks the add as well)
  alignas(64) float fold[D], out0[D], out1[D], base[D];
  for (int r = 0; r < D; r++) {
    fold[r] = 1e-4f * (0.5f + ud(rng));
    base[r] = ud(rng) - 0.5f;
  }
  // h = pre-activation; a0/i0 = reference quantizer output (values, nonzero
  // positions); a1/i1/ih = packed quantizer output (ih = positions >= 256)
  std::vector<float> h(DMLP);
  std::vector<int16_t> a0(DMLP), a1(DMLP);
  std::vector<uint16_t> i0(DMLP + 16), i1(DMLP + 16), ih(DMLP + 16);
  alignas(64) int16_t a192[D];
  alignas(64) float x192[D];
  int bad = 0;
  uint64_t t_old_s = 0, t_new_s = 0, t_old_g = 0, t_new_g = 0;
  const size_t SW = size_t(64) << 20;
  volatile uint8_t* sweep = timing ? static_cast<uint8_t*>(amalloc(SW)) : nullptr;
  if (timing) std::memset(const_cast<uint8_t*>(sweep), 1, SW);
  for (int it = 0; it < iters; it++) {
    const int l = it % NL;
    // activation shapes: mostly realistic (about half negative pre-relu, most
    // of the rest small), plus saturating and edge cases
    // (with s = 1e-3 the quantized value is 1000 * v^2 for v > 0)
    //   mode 0, 6, 7: realistic mix of zeros, small and large values
    //   mode 1: many values clamp at 32767 (largest products and partial sums)
    //   mode 2: almost all zero, the few nonzeros clamped (short index lists,
    //           odd counts, the kernels' read-ahead past the end of idx)
    //   mode 3: every value 32767 (worst case for the 16-bit partial sums and
    //           for the int32 total)
    //   mode 4: every value 0 (nnz = 0: the output must stay equal to base)
    //   mode 5: every value below 256 (high byte always 0, so idxh is empty
    //           and only the low-byte pass contributes)
    const int mode = it % 8;
    const float s = 1e-3f;
    for (int i = 0; i < DMLP; i++) {
      float v = ud(rng) * 2.0f - 1.2f;          // ~40% positive
      if (mode == 1) v *= 8.0f;                 // many saturate at 32767
      if (mode == 2) v = ud(rng) < 0.02f ? 9.0f : -1.0f;  // very sparse
      if (mode == 3) v = 6.0f;                  // all saturated
      if (mode == 4) v = -1.0f;                 // all zero
      if (mode == 5) v = 0.3f * ud(rng);        // all small (< 256 mostly)
      h[i] = v;
    }
    // check 1: the two quantizers agree on count, values and index list ...
    const int n0 = relu2_quant16(h.data(), s, DMLP, a0.data(), i0.data());
    int nh = 0;
    int32_t suma = 0;
    const int n1 = relu2_quant16p(h.data(), s, DMLP, a1.data(), i1.data(),
                                  ih.data(), &nh, &suma);
    // ... and the extra outputs are right: suma = sum of all activations
    // (used for the -7 * sum(a) correction of the u = w + 7 bias), nh = number
    // of activations >= 256 (those with a nonzero high byte)
    int32_t sref = 0;
    int nhref = 0;
    for (int i = 0; i < DMLP; i++) {
      sref += a0[i];
      nhref += a0[i] >= 256;
    }
    if (n0 != n1 || nh != nhref || suma != sref ||
        std::memcmp(a0.data(), a1.data(), sizeof(int16_t) * DMLP) ||
        std::memcmp(i0.data(), i1.data(), sizeof(uint16_t) * n0)) {
      if (bad++ < 5) std::printf("relu2_quant16p mismatch it %d\n", it);
    }
    // idxh must list exactly those positions, in ascending order
    for (int k = 0; k < nh; k++)
      if (a1[ih[k]] < 256 || (k && ih[k] <= ih[k - 1])) {
        if (bad++ < 5) std::printf("idxh wrong it %d\n", it);
        break;
      }
    // Signed 16-bit input for the dense kernel, quantized by quant192_i16
    // with scale 1 (round and clamp to [-32768, 32767]):
    //   mode 0-2: uniform over slightly more than the int16 range (some clamp)
    //   mode 3: alternating +32767 / -32768     mode 4: all zero
    //   mode 5: small values (high byte 0 or -1)
    //   mode 6: all +32767                      mode 7: all -32768
    // The extremes are the cases where a signed/unsigned byte-split error or a
    // 16-bit lane overflow would show.
    for (int i = 0; i < D; i++) {
      float v = (ud(rng) - 0.5f) * 70000.0f;
      if (mode == 3) v = (i & 1) ? 32767.0f : -32768.0f;
      if (mode == 4) v = 0.0f;
      if (mode == 5) v = (ud(rng) - 0.5f) * 300.0f;
      if (mode == 6) v = 32767.0f;
      if (mode == 7) v = -32768.0f;
      x192[i] = v;
    }
    quant192_i16(x192, 1.0f, a192);
    if (timing)
      for (size_t q = 0; q < SW; q += 64) (void)sweep[q];

    // check 2: sparse product, reference (int8 columns) vs packed columns,
    // both starting from the same base; the 192 floats must be bit-identical
    std::memcpy(out0, base, sizeof(out0));
    std::memcpy(out1, base, sizeof(out1));
    uint64_t t0 = __rdtsc();
    spmv16_add(cols8 + size_t(l) * DMLP * D, fold, a0.data(), i0.data(), n0, out0);
    uint64_t t1 = __rdtsc();
    if (timing)
      for (size_t q = 0; q < SW; q += 64) (void)sweep[q];
    uint64_t t2 = __rdtsc();
    spmv16p_add(colsp + size_t(l) * DMLP * 96, fold, a1.data(), i1.data(), n1,
                ih.data(), nh, suma, out1);
    uint64_t t3 = __rdtsc();
    t_old_s += t1 - t0;
    t_new_s += t3 - t2;
    if (std::memcmp(out0, out1, sizeof(out0))) {
      if (bad++ < 5) std::printf("spmv16p mismatch it %d mode %d nnz %d\n", it, mode, n0);
    }
    if (timing)
      for (size_t q = 0; q < SW; q += 64) (void)sweep[q];
    // check 3: dense product, reference (int8 rows) vs packed rows + krow
    std::memcpy(out0, base, sizeof(out0));
    std::memcpy(out1, base, sizeof(out1));
    t0 = __rdtsc();
    gemv16_add(rows8 + size_t(l) * D * D, fold, a192, out0);
    t1 = __rdtsc();
    if (timing)
      for (size_t q = 0; q < SW; q += 64) (void)sweep[q];
    t2 = __rdtsc();
    gemv16p_add(rowsp + size_t(l) * D * 96, fold, &krow[size_t(l) * D], a192, out1);
    t3 = __rdtsc();
    t_old_g += t1 - t0;
    t_new_g += t3 - t2;
    if (std::memcmp(out0, out1, sizeof(out0))) {
      if (bad++ < 5) std::printf("gemv16p mismatch it %d mode %d\n", it, mode);
    }
  }
  std::printf("DMLP %d, %d iterations%s: %d mismatches\n", DMLP, iters,
              timing ? " (cold)" : "", bad);
  std::printf("  ticks/call  spmv16 %7.0f -> packed %7.0f    gemv16 %7.0f -> packed %7.0f\n",
              double(t_old_s) / iters, double(t_new_s) / iters,
              double(t_old_g) / iters, double(t_new_g) / iters);
  return bad;
}

// gemv16p_set (nrows packed rows of 192) against a scalar reference; also
// ticks per call over 12 layers' worth of rows.
// This is the kernel for the matmuls whose INPUT is the 192-wide residual
// stream quantized to 16 bits (mlp.up and the q/k/v projections); it stores
// its result instead of adding. The reference is the definition itself:
// dot = sum_c a[c] * w[c] in int32, out = fold * float(dot).
// Input modes: 0 = full int16 range, 1 = small values, 2 = only +32767 and
// -32768, 3 = mostly zeros (every 7th element nonzero).
int run_set(int nrows, int iters) {
  std::mt19937 rng(77 + nrows);
  std::vector<int8_t> w(size_t(NL) * nrows * D);
  for (auto& v : w) v = static_cast<int8_t>(int(rng() % 15) - 7);
  std::vector<uint8_t> rowsp(size_t(NL) * nrows * 96 + 64);
  std::vector<int32_t> krow(size_t(NL) * nrows);
  std::vector<float> fold(nrows), out0(nrows), out1(nrows);
  for (auto& f : fold) f = 1e-4f * float(1 + rng() % 1000);
  for (int l = 0; l < NL; l++)
    for (int r = 0; r < nrows; r++) {
      const int8_t* row = &w[(size_t(l) * nrows + r) * D];
      int32_t sum = 0;
      for (int c = 0; c < D; c++) sum += row[c];
      krow[size_t(l) * nrows + r] = 128 * sum;
      pack16_nibbles(row, D, &rowsp[(size_t(l) * nrows + r) * 96]);
    }
  alignas(32) int16_t a[D];
  int bad = 0;
  uint64_t ticks = 0;
  for (int it = 0; it < iters; it++) {
    const int l = it % NL, mode = it % 4;
    for (int c = 0; c < D; c++) {
      int v = int(rng() & 0xFFFF) - 32768;
      if (mode == 1) v /= 64;
      if (mode == 2) v = (rng() & 1) ? 32767 : -32768;
      if (mode == 3) v = (c % 7 == 0) ? v : 0;
      a[c] = static_cast<int16_t>(v);
    }
    for (int r = 0; r < nrows; r++) {
      const int8_t* row = &w[(size_t(l) * nrows + r) * D];
      int32_t dot = 0;
      for (int c = 0; c < D; c++) dot += int32_t(a[c]) * row[c];
      // volatile: forces the product to be rounded to a float and stored,
      // so the compiler cannot keep extra precision or fuse it
      volatile float f = fold[r] * float(dot);
      out0[r] = f;
    }
    const uint64_t t0 = __rdtsc();
    gemv16p_set(&rowsp[size_t(l) * nrows * 96], fold.data(),
                &krow[size_t(l) * nrows], a, nrows, out1.data());
    ticks += __rdtsc() - t0;
    if (std::memcmp(out0.data(), out1.data(), sizeof(float) * nrows)) {
      if (bad++ < 5) std::printf("gemv16p_set mismatch it %d mode %d\n", it, mode);
    }
  }
  std::printf("gemv16p_set %d rows, %d iterations: %d mismatches, %.0f ticks/call\n",
              nrows, iters, bad, double(ticks) / iters);
  return bad;
}
}  // namespace

// The cases. The model has D = 192 and an MLP width of 768.
//   run(768, 20000)       the model's own shape, the main case
//   run(784), run(832)    other MLP widths: 784 is not a multiple of 32 and
//                         832 is larger than the model's, so the loop tails,
//                         index lists and accumulator widening are not right
//                         only by accident of 768
//   run(768, 600, timing) the same comparison with caches flushed between
//                         calls; gives the cold ticks/call figures
//   run_set(192)          192 rows of 192 inputs (a q/k/v-sized projection)
//   run_set(768)          768 rows of 192 inputs (mlp.up)
//   run_set(832)          a row count other than the model's
int main() {
  int bad = 0;
  bad += run(768, 20000, false);
  bad += run(784, 4000, false);
  bad += run(832, 4000, false);
  bad += run(768, 600, true);
  bad += run_set(192, 20000);
  bad += run_set(768, 20000);
  bad += run_set(832, 4000);
  std::printf(bad ? "FAILED\n" : "ALL OK\n");
  return bad != 0;
}
