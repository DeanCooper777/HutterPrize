// test_act16.cpp — the packed 16-bit-activation kernels (spmv16p_add,
// gemv16p_add, relu2_quant16p) against the int8 reference kernels of
// act16.cpp: results must be bitwise identical. Also prints a rough timing
// (rdtsc ticks per call) with 12 layers' worth of weights, cold (a 64 MB
// buffer is swept between calls) and warm.
//
//   clang++ -O3 -march=x86-64-v3 -std=c++17 test_act16.cpp act16.cpp -o test_act16
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
constexpr int D = 192, NL = 12;

void* amalloc(size_t n) {
#ifdef _WIN32
  return _aligned_malloc(n, 64);
#else
  return aligned_alloc(64, (n + 63) / 64 * 64);
#endif
}

int run(int DMLP, int iters, bool timing) {
  std::mt19937 rng(12345 + DMLP);
  std::uniform_int_distribution<int> wd(-7, 7);
  std::uniform_real_distribution<float> ud(0.0f, 1.0f);
  // weights: [NL] down (D x DMLP) and op (D x D), row-major int8
  std::vector<int8_t> wdown(size_t(NL) * D * DMLP), wop(size_t(NL) * D * D);
  for (auto& w : wdown) w = static_cast<int8_t>(wd(rng));
  for (auto& w : wop) w = static_cast<int8_t>(wd(rng));
  // reference layouts: down as int8 columns, op as int8 rows
  int8_t* cols8 = static_cast<int8_t*>(amalloc(size_t(NL) * DMLP * D + 4096));
  int8_t* rows8 = static_cast<int8_t*>(amalloc(size_t(NL) * D * D + 4096));
  uint8_t* colsp = static_cast<uint8_t*>(amalloc(size_t(NL) * DMLP * 96 + 4096));
  uint8_t* rowsp = static_cast<uint8_t*>(amalloc(size_t(NL) * D * 96 + 4096));
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
  alignas(64) float fold[D], out0[D], out1[D], base[D];
  for (int r = 0; r < D; r++) {
    fold[r] = 1e-4f * (0.5f + ud(rng));
    base[r] = ud(rng) - 0.5f;
  }
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
    const int n0 = relu2_quant16(h.data(), s, DMLP, a0.data(), i0.data());
    int nh = 0;
    int32_t suma = 0;
    const int n1 = relu2_quant16p(h.data(), s, DMLP, a1.data(), i1.data(),
                                  ih.data(), &nh, &suma);
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
    for (int k = 0; k < nh; k++)
      if (a1[ih[k]] < 256 || (k && ih[k] <= ih[k - 1])) {
        if (bad++ < 5) std::printf("idxh wrong it %d\n", it);
        break;
      }
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
}  // namespace

int main() {
  int bad = 0;
  bad += run(768, 20000, false);
  bad += run(784, 4000, false);
  bad += run(832, 4000, false);
  bad += run(768, 600, true);
  std::printf(bad ? "FAILED\n" : "ALL OK\n");
  return bad != 0;
}
