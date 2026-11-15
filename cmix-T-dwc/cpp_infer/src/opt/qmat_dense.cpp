// qmat_dense.cpp - the dense quantized matrix x vector kernels for 8-bit
// activations and 4-bit weights (contract in qmat_dense.h, arena format in
// qmat.h), and the builders of all qmat.h arenas.
//
// What a kernel does: for each output row, the exact int32 dot product of
// the u8 activation vector with the row's weights, minus a per-row integer
// correction (the +128 input bias), then an fp32 "epilogue" (scale, add to
// the residual, or re-quantize for the next matmul). Because the dots are
// exact integers, every variant below (AVX2, AVX-VNNI, AVX512-VNNI, packed
// or unpacked weights) returns the same bits; they differ only in speed.
//
// How it fits: called by model_opt.cpp for the matmuls that keep 8-bit
// inputs: the Kimi gate projections and the unembedding always, and the
// q/k/v, output and mlp.up projections when CMIX_ACT16 clears their bit
// (act16.h serves them by default). Transformer byte model -> mixers -> SSE
// -> arithmetic coder.
//
// Testing: test_qmat (int32 dots against a scalar reference), bench_qmat.
// Environment switches, speed only: CMIX_NO_VNNI=1 (force the AVX2 kernels),
// CMIX_QMAT_UNPACKED=1 (keep one byte per weight), CMIX_QMAT_PF_NTA=1
// (non-temporal prefetch hint).
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
// - [this entry] AVX-VNNI and AVX512-VNNI kernels (vpdpbusd), chosen at run
//   time by CPUID, and a nibble-packed arena for them that halves the weight
//   bytes read per symbol. Speed only: bit-identical output. They are used
//   by development builds; the submitted Linux binary is built with
//   -DFX2_NO_VNNI, which compiles them out and leaves the previous winner's
//   AVX2 kernels (run_g8 / run_g4_768).
// - [this entry] MSVC-compatible CPUID include (Windows development build).
#include "qmat_dense.h"

#include <immintrin.h>

#include <cstdio>
#include <cstdlib>
#include <cstring>
#ifdef _MSC_VER
#include <intrin.h>
#else
#include <cpuid.h>
#endif

namespace fx2 {
namespace opt {

namespace {

[[noreturn]] void die(const char* msg) {
  std::fprintf(stderr, "qmat: %s\n", msg);
  std::exit(1);
}

// Lookup table for the nonzero index list built by qgemv_relu2q.
// positions of set bits per 8-bit mask; unset slots hold 0 (an in-range row
// index) so the 16 B slack writes of the index list stay harmless.
struct IdxLut {
  alignas(64) uint8_t t[256][8];
  IdxLut() {
    for (int m = 0; m < 256; m++) {
      int k = 0;
      for (int b = 0; b < 8; b++)
        if (m & (1 << b)) t[m][k++] = static_cast<uint8_t>(b);
      for (; k < 8; k++) t[m][k] = 0;
    }
  }
};
const IdxLut g_idxlut;

// default software-prefetch lines per 256 B chunk iteration (distance 2 KB,
// MACHINE.md section 2: +2-6% at L3). 4 lines/chunk = ~full coverage.
constexpr int PFN_DEFAULT = 4;

// ---------------------------------------------------------------------------
// epilogue functors: operator()(g, sums8, scl) for 8-row groups,
//                    g4(g, sums4, scl) for 4-row groups
// ---------------------------------------------------------------------------
// out = float(dot) * scale: a fresh fp32 vector
struct EpiF32 {
  float* out;
  inline void operator()(int g, __m256i sums, const float* scl) {
    _mm256_storeu_ps(out + 8 * g, _mm256_mul_ps(_mm256_cvtepi32_ps(sums),
                                                _mm256_load_ps(scl)));
  }
  inline void g4(int g, __m128i sums, const float* scl) {
    _mm_storeu_ps(out + 4 * g,
                  _mm_mul_ps(_mm_cvtepi32_ps(sums), _mm_load_ps(scl)));
  }
};

// out += float(dot) * scale: the product is rounded first, then added (two
// IEEE operations, never one fused multiply-add), as the reference model does
struct EpiAdd {
  float* out;
  inline void operator()(int g, __m256i sums, const float* scl) {
    __m256 t = _mm256_mul_ps(_mm256_cvtepi32_ps(sums), _mm256_load_ps(scl));
    _mm256_storeu_ps(out + 8 * g, _mm256_add_ps(_mm256_loadu_ps(out + 8 * g), t));
  }
  inline void g4(int g, __m128i sums, const float* scl) {
    __m128 t = _mm_mul_ps(_mm_cvtepi32_ps(sums), _mm_load_ps(scl));
    _mm_storeu_ps(out + 4 * g, _mm_add_ps(_mm_loadu_ps(out + 4 * g), t));
  }
};

// the raw int32 dots (tests)
struct EpiI32 {
  int32_t* out;
  inline void operator()(int g, __m256i sums, const float*) {
    _mm256_storeu_si256(reinterpret_cast<__m256i*>(out + 8 * g), sums);
  }
  inline void g4(int g, __m128i sums, const float*) {
    _mm_storeu_si128(reinterpret_cast<__m128i*>(out + 4 * g), sums);
  }
};

// ---------------------------------------------------------------------------
// core: 8-row groups, d_in <= 256 (NC chunks of 32 columns)
// ---------------------------------------------------------------------------
// The previous winner's AVX2 kernel and the one the submitted binary runs.
// Eight rows at a time. vpmaddubsw multiplies 32 u8 activations by 32 s8
// weights and adds neighbouring products into 16 int16 lanes; the lanes of at
// most 8 chunks are added in int16 (bound in qmat.h: no saturation), widened
// with vpmaddwd by 1, and reduced to one int32 per row.
template <int NC, int PFN, class Epi>
inline void run_g8(const QDense& m, const uint8_t* act, Epi& epi) {
  const __m256i ones = _mm256_set1_epi16(1);
  const uint8_t* gp = m.arena;
  constexpr ptrdiff_t GB = 64 + NC * 256;
  const int ng = m.ngroups;
  for (int g = 0; g < ng; g++, gp += GB) {
    const __m256i* w = reinterpret_cast<const __m256i*>(gp + 64);
    __m256i av = _mm256_load_si256(reinterpret_cast<const __m256i*>(act));
    __m256i s0 = _mm256_maddubs_epi16(av, w[0]);
    __m256i s1 = _mm256_maddubs_epi16(av, w[1]);
    __m256i s2 = _mm256_maddubs_epi16(av, w[2]);
    __m256i s3 = _mm256_maddubs_epi16(av, w[3]);
    __m256i s4 = _mm256_maddubs_epi16(av, w[4]);
    __m256i s5 = _mm256_maddubs_epi16(av, w[5]);
    __m256i s6 = _mm256_maddubs_epi16(av, w[6]);
    __m256i s7 = _mm256_maddubs_epi16(av, w[7]);
    for (int k = 0; k < PFN; k++)
      _mm_prefetch(reinterpret_cast<const char*>(gp) + 2048 + 64 * k,
                   _MM_HINT_T0);
    // keep the chunk loop rolled: full unroll makes clang spill 3 of the 8
    // int16 accumulators (measured slower); the rolled body is load-balanced
#if defined(__clang__)
#pragma clang loop unroll(disable)
#else
#pragma GCC unroll 1
#endif
    for (int c = 1; c < NC; c++) {
      const __m256i* wc = w + c * 8;
      for (int k = 0; k < PFN; k++)
        _mm_prefetch(reinterpret_cast<const char*>(gp) + c * 256 + 2048 +
                         64 * k,
                     _MM_HINT_T0);
      av = _mm256_load_si256(
          reinterpret_cast<const __m256i*>(act + 32 * c));
      s0 = _mm256_add_epi16(s0, _mm256_maddubs_epi16(av, wc[0]));
      s1 = _mm256_add_epi16(s1, _mm256_maddubs_epi16(av, wc[1]));
      s2 = _mm256_add_epi16(s2, _mm256_maddubs_epi16(av, wc[2]));
      s3 = _mm256_add_epi16(s3, _mm256_maddubs_epi16(av, wc[3]));
      s4 = _mm256_add_epi16(s4, _mm256_maddubs_epi16(av, wc[4]));
      s5 = _mm256_add_epi16(s5, _mm256_maddubs_epi16(av, wc[5]));
      s6 = _mm256_add_epi16(s6, _mm256_maddubs_epi16(av, wc[6]));
      s7 = _mm256_add_epi16(s7, _mm256_maddubs_epi16(av, wc[7]));
    }
    // widen to int32 and sum each row's lanes; then subtract the row's
    // correction (first 32 bytes of the group block) and run the epilogue
    __m256i p01 = _mm256_hadd_epi32(_mm256_madd_epi16(s0, ones),
                                    _mm256_madd_epi16(s1, ones));
    __m256i p23 = _mm256_hadd_epi32(_mm256_madd_epi16(s2, ones),
                                    _mm256_madd_epi16(s3, ones));
    __m256i p45 = _mm256_hadd_epi32(_mm256_madd_epi16(s4, ones),
                                    _mm256_madd_epi16(s5, ones));
    __m256i p67 = _mm256_hadd_epi32(_mm256_madd_epi16(s6, ones),
                                    _mm256_madd_epi16(s7, ones));
    __m256i q0 = _mm256_hadd_epi32(p01, p23);  // [r0..r3 lo | r0..r3 hi]
    __m256i q1 = _mm256_hadd_epi32(p45, p67);  // [r4..r7 lo | r4..r7 hi]
    __m256i sums = _mm256_add_epi32(_mm256_permute2x128_si256(q0, q1, 0x20),
                                    _mm256_permute2x128_si256(q0, q1, 0x31));
    sums = _mm256_sub_epi32(
        sums, _mm256_load_si256(reinterpret_cast<const __m256i*>(gp)));
    epi(g, sums, reinterpret_cast<const float*>(gp + 32));
  }
}

// ---------------------------------------------------------------------------
// core: 4-row groups, d_in == 768 (24 chunks; widen to int32 every 8 chunks)
// ---------------------------------------------------------------------------
template <int PFN, class Epi>
inline void run_g4_768(const QDense& m, const uint8_t* act, Epi& epi) {
  const __m256i ones = _mm256_set1_epi16(1);
  const uint8_t* gp = m.arena;
  constexpr ptrdiff_t GB = 32 + 24 * 128;  // 3104
  const int ng = m.ngroups;
  for (int g = 0; g < ng; g++, gp += GB) {
    const __m256i* w = reinterpret_cast<const __m256i*>(gp + 32);
    __m256i d0 = _mm256_setzero_si256(), d1 = d0, d2 = d0, d3 = d0;
    for (int b = 0; b < 3; b++) {
      const __m256i* wb = w + b * 32;
      const uint8_t* ab = act + b * 256;
      __m256i av = _mm256_load_si256(reinterpret_cast<const __m256i*>(ab));
      __m256i s0 = _mm256_maddubs_epi16(av, wb[0]);
      __m256i s1 = _mm256_maddubs_epi16(av, wb[1]);
      __m256i s2 = _mm256_maddubs_epi16(av, wb[2]);
      __m256i s3 = _mm256_maddubs_epi16(av, wb[3]);
      for (int c = 1; c < 8; c++) {
        if (PFN) {
          _mm_prefetch(reinterpret_cast<const char*>(wb) + c * 128 + 2048,
                       _MM_HINT_T0);
          if (PFN > 1)
            _mm_prefetch(reinterpret_cast<const char*>(wb) + c * 128 + 2112,
                         _MM_HINT_T0);
        }
        av = _mm256_load_si256(reinterpret_cast<const __m256i*>(ab + 32 * c));
        s0 = _mm256_add_epi16(s0, _mm256_maddubs_epi16(av, wb[c * 4 + 0]));
        s1 = _mm256_add_epi16(s1, _mm256_maddubs_epi16(av, wb[c * 4 + 1]));
        s2 = _mm256_add_epi16(s2, _mm256_maddubs_epi16(av, wb[c * 4 + 2]));
        s3 = _mm256_add_epi16(s3, _mm256_maddubs_epi16(av, wb[c * 4 + 3]));
      }
      d0 = _mm256_add_epi32(d0, _mm256_madd_epi16(s0, ones));
      d1 = _mm256_add_epi32(d1, _mm256_madd_epi16(s1, ones));
      d2 = _mm256_add_epi32(d2, _mm256_madd_epi16(s2, ones));
      d3 = _mm256_add_epi32(d3, _mm256_madd_epi16(s3, ones));
    }
    __m256i h = _mm256_hadd_epi32(_mm256_hadd_epi32(d0, d1),
                                  _mm256_hadd_epi32(d2, d3));
    __m128i sums = _mm_add_epi32(_mm256_castsi256_si128(h),
                                 _mm256_extracti128_si256(h, 1));
    sums = _mm_sub_epi32(
        sums, _mm_load_si128(reinterpret_cast<const __m128i*>(gp)));
    epi.g4(g, sums, reinterpret_cast<const float*>(gp + 16));
  }
}

// ---------------------------------------------------------------------------
// [this entry] Everything from here to dispatch() is new: faster kernels for
// CPUs with VNNI. None of it is in the submitted binary (FX2_NO_VNNI).
// AVX-VNNI variants (vpdpbusd: u8 x s8 -> int32, accumulated). Bit-identical
// to the vpmaddubsw kernels above: the activations/weights and therefore the
// exact int32 dot products are the same (the AVX2 path never saturates, see
// qmat.h), only the partition of the integer sum differs. Selected at run
// time when the CPU supports AVX-VNNI; CMIX_NO_VNNI=1 forces the AVX2 path.
// ---------------------------------------------------------------------------
// CPUID leaf 7 subleaf 1, EAX bit 4 = AVX-VNNI
bool detect_vnni() {
  if (const char* e = std::getenv("CMIX_NO_VNNI"))
    if (*e && *e != '0') return false;
#ifdef _MSC_VER
  int r[4];
  __cpuidex(r, 0, 0);
  if (r[0] < 7) return false;
  __cpuidex(r, 7, 1);
  return (r[0] >> 4) & 1;
#else
  unsigned a, b, c, d;
  if (!__get_cpuid_count(7, 1, &a, &b, &c, &d)) return false;
  return (a >> 4) & 1;
#endif
}
// FX2_NO_VNNI (set by the Linux submission makefile) compiles the VNNI
// kernels out, so the binary holds nothing past AVX2 (checked by
// build_and_construct_comp.sh); the results are identical either way.
#ifdef FX2_NO_VNNI
const bool g_vnni = false;
#else
const bool g_vnni = detect_vnni();
#endif

// AVX512-VNNI (Ice Lake / Tiger Lake, e.g. the contest's i7-1165G7): the same
// vpdpbusd on ymm registers in its EVEX encoding (needs AVX512VL), for CPUs
// without the VEX-encoded AVX-VNNI. CMIX_NO_VNNI=1 disables it as well.
bool detect_vnni512() {
  if (const char* e = std::getenv("CMIX_NO_VNNI"))
    if (*e && *e != '0') return false;
#ifdef _MSC_VER
  int r[4];
  __cpuidex(r, 0, 0);
  if (r[0] < 7) return false;
  __cpuidex(r, 1, 0);
  if (!((r[2] >> 27) & 1)) return false;  // OSXSAVE
  __cpuidex(r, 7, 0);
  const unsigned b = r[1], c = r[2];
#else
  unsigned a, b0, c0, d;
  if (!__get_cpuid(1, &a, &b0, &c0, &d) || !((c0 >> 27) & 1)) return false;
  unsigned b, c;
  if (!__get_cpuid_count(7, 0, &a, &b, &c, &d)) return false;
#endif
  const bool f = (b >> 16) & 1;    // AVX512F
  const bool vl = (b >> 31) & 1;   // AVX512VL
  const bool vnni = (c >> 11) & 1; // AVX512_VNNI
  if (!(f && vl && vnni)) return false;
  // XCR0: SSE, AVX, opmask, ZMM_Hi256, Hi16_ZMM state enabled by the OS
  const unsigned long long xcr0 = _xgetbv(0);
  return (xcr0 & 0xE6) == 0xE6;
}
#ifdef FX2_NO_VNNI
const bool g_vnni512 = false;
#else
const bool g_vnni512 = !g_vnni && detect_vnni512();
#endif

#ifndef FX2_NO_VNNI
// run_g8 with vpdpbusd: the products go straight into int32 accumulators, so
// there is no int16 stage and no widening step. Same unpacked arena.
template <int NC, int PFN, class Epi>
__attribute__((target("avxvnni"), noinline)) void run_g8_vnni(
    const QDense& m, const uint8_t* act, Epi& epi) {
  const uint8_t* gp = m.arena;
  constexpr ptrdiff_t GB = 64 + NC * 256;
  const int ng = m.ngroups;
  for (int g = 0; g < ng; g++, gp += GB) {
    const __m256i* w = reinterpret_cast<const __m256i*>(gp + 64);
    const __m256i z = _mm256_setzero_si256();
    __m256i av = _mm256_load_si256(reinterpret_cast<const __m256i*>(act));
    __m256i s0 = _mm256_dpbusd_avx_epi32(z, av, w[0]);
    __m256i s1 = _mm256_dpbusd_avx_epi32(z, av, w[1]);
    __m256i s2 = _mm256_dpbusd_avx_epi32(z, av, w[2]);
    __m256i s3 = _mm256_dpbusd_avx_epi32(z, av, w[3]);
    __m256i s4 = _mm256_dpbusd_avx_epi32(z, av, w[4]);
    __m256i s5 = _mm256_dpbusd_avx_epi32(z, av, w[5]);
    __m256i s6 = _mm256_dpbusd_avx_epi32(z, av, w[6]);
    __m256i s7 = _mm256_dpbusd_avx_epi32(z, av, w[7]);
    for (int k = 0; k < PFN; k++)
      _mm_prefetch(reinterpret_cast<const char*>(gp) + 2048 + 64 * k,
                   _MM_HINT_T0);
#if defined(__clang__)
#pragma clang loop unroll(disable)
#endif
    for (int c = 1; c < NC; c++) {
      const __m256i* wc = w + c * 8;
      for (int k = 0; k < PFN; k++)
        _mm_prefetch(reinterpret_cast<const char*>(gp) + c * 256 + 2048 +
                         64 * k,
                     _MM_HINT_T0);
      av = _mm256_load_si256(reinterpret_cast<const __m256i*>(act + 32 * c));
      s0 = _mm256_dpbusd_avx_epi32(s0, av, wc[0]);
      s1 = _mm256_dpbusd_avx_epi32(s1, av, wc[1]);
      s2 = _mm256_dpbusd_avx_epi32(s2, av, wc[2]);
      s3 = _mm256_dpbusd_avx_epi32(s3, av, wc[3]);
      s4 = _mm256_dpbusd_avx_epi32(s4, av, wc[4]);
      s5 = _mm256_dpbusd_avx_epi32(s5, av, wc[5]);
      s6 = _mm256_dpbusd_avx_epi32(s6, av, wc[6]);
      s7 = _mm256_dpbusd_avx_epi32(s7, av, wc[7]);
    }
    __m256i p01 = _mm256_hadd_epi32(s0, s1);
    __m256i p23 = _mm256_hadd_epi32(s2, s3);
    __m256i p45 = _mm256_hadd_epi32(s4, s5);
    __m256i p67 = _mm256_hadd_epi32(s6, s7);
    __m256i q0 = _mm256_hadd_epi32(p01, p23);
    __m256i q1 = _mm256_hadd_epi32(p45, p67);
    __m256i sums = _mm256_add_epi32(_mm256_permute2x128_si256(q0, q1, 0x20),
                                    _mm256_permute2x128_si256(q0, q1, 0x31));
    sums = _mm256_sub_epi32(
        sums, _mm256_load_si256(reinterpret_cast<const __m256i*>(gp)));
    epi(g, sums, reinterpret_cast<const float*>(gp + 32));
  }
}

// run_g4_768 with vpdpbusd
template <int PFN, class Epi>
__attribute__((target("avxvnni"), noinline)) void run_g4_768_vnni(
    const QDense& m, const uint8_t* act, Epi& epi) {
  const uint8_t* gp = m.arena;
  constexpr ptrdiff_t GB = 32 + 24 * 128;
  const int ng = m.ngroups;
  for (int g = 0; g < ng; g++, gp += GB) {
    const __m256i* w = reinterpret_cast<const __m256i*>(gp + 32);
    __m256i d0 = _mm256_setzero_si256(), d1 = d0, d2 = d0, d3 = d0;
    for (int c = 0; c < 24; c++) {
      if (PFN) {
        _mm_prefetch(reinterpret_cast<const char*>(w) + c * 128 + 2048,
                     _MM_HINT_T0);
        if (PFN > 1)
          _mm_prefetch(reinterpret_cast<const char*>(w) + c * 128 + 2112,
                       _MM_HINT_T0);
      }
      __m256i av = _mm256_load_si256(reinterpret_cast<const __m256i*>(act + 32 * c));
      d0 = _mm256_dpbusd_avx_epi32(d0, av, w[c * 4 + 0]);
      d1 = _mm256_dpbusd_avx_epi32(d1, av, w[c * 4 + 1]);
      d2 = _mm256_dpbusd_avx_epi32(d2, av, w[c * 4 + 2]);
      d3 = _mm256_dpbusd_avx_epi32(d3, av, w[c * 4 + 3]);
    }
    __m256i h = _mm256_hadd_epi32(_mm256_hadd_epi32(d0, d1),
                                  _mm256_hadd_epi32(d2, d3));
    __m128i sums = _mm_add_epi32(_mm256_castsi256_si128(h),
                                 _mm256_extracti128_si256(h, 1));
    sums = _mm_sub_epi32(
        sums, _mm_load_si128(reinterpret_cast<const __m128i*>(gp)));
    epi.g4(g, sums, reinterpret_cast<const float*>(gp + 16));
  }
}

#endif  // FX2_NO_VNNI
// ---------------------------------------------------------------------------
// VNNI + packed nibbles (QDense::packed). Halves the weight bytes streamed per
// token (the matmuls are L3-bandwidth-bound on recent Intel cores, where the
// int8 dot units are no longer the limit). Weight vector j of a chunk holds
// rows 2j / 2j+1 in the low / high nibbles as u = w+7 in [0,14]; vpdpbusd
// takes u as its signed operand, so each dot is sum act*(w+7) =
// sum act*w + 7*sum(act). The exact correction 7*sum(act) over the zero-padded
// stride is subtracted with the row's corr: the int32 dots, and everything
// after them, are bit-identical to the unpacked kernels.
// CMIX_QMAT_UNPACKED=1 keeps the unpacked arenas (A/B comparison).
// ---------------------------------------------------------------------------
bool detect_packed() {
  if (!g_vnni && !g_vnni512) return false;
  if (const char* e = std::getenv("CMIX_QMAT_UNPACKED"))
    if (*e && *e != '0') return false;
  return true;
}
const bool g_packed = detect_packed();

// 7 * sum of the n (multiple of 32) activation bytes
inline int32_t act_corr7(const uint8_t* act, int n) {
  __m256i acc = _mm256_setzero_si256();
  const __m256i z = _mm256_setzero_si256();
  for (int i = 0; i < n; i += 32)
    acc = _mm256_add_epi64(acc, _mm256_sad_epu8(
        _mm256_load_si256(reinterpret_cast<const __m256i*>(act + i)), z));
  __m128i t = _mm_add_epi64(_mm256_castsi256_si128(acc),
                            _mm256_extracti128_si256(acc, 1));
  t = _mm_add_epi64(t, _mm_unpackhi_epi64(t, t));
  return 7 * static_cast<int32_t>(_mm_cvtsi128_si64(t));
}

// Weight-stream prefetch hint. CMIX_QMAT_PF_NTA=1: non-temporal (the streamed
// weights then displace less of L2, where the KV caches and KDA states live).
// A hint only: the results are identical either way.
bool detect_pf_nta() {
  const char* e = std::getenv("CMIX_QMAT_PF_NTA");
  return e && *e && *e != '0';
}
const bool g_pf_nta = detect_pf_nta();
inline void qm_pf(const char* p) {
  if (g_pf_nta) _mm_prefetch(p, _MM_HINT_NTA);
  else _mm_prefetch(p, _MM_HINT_T0);
}

// The packed kernels, written once as a macro and instantiated for the two
// encodings of vpdpbusd (DP): run_g8_vnni4* for 8-row groups (d_in <= 256)
// and run_g4_768_vnni4* for 4-row groups (d_in = 768). Each 32-byte load
// holds two rows (low and high nibbles), which are split with a mask and a
// shift and accumulated separately; the epilogue subtracts 7 * sum(act) and
// the row correction.
#ifndef FX2_NO_VNNI
#define QM_PACKED_KERNELS(SUF, TGT, DP) \
template <int NC, int PFN, class Epi>                                             \
__attribute__((target(TGT), noinline)) void run_g8_vnni4##SUF(                    \
    const QDense& m, const uint8_t* act, Epi& epi) {                              \
  const __m256i corr7 = _mm256_set1_epi32(act_corr7(act, NC * 32));               \
  const __m256i m0F = _mm256_set1_epi8(0x0F);                                     \
  const uint8_t* gp = m.arena;                                                    \
  constexpr ptrdiff_t GB = 64 + NC * 128;                                         \
  const int ng = m.ngroups;                                                       \
  for (int g = 0; g < ng; g++, gp += GB) {                                        \
    const __m256i* w = reinterpret_cast<const __m256i*>(gp + 64);                 \
    __m256i s0 = _mm256_setzero_si256(), s1 = s0, s2 = s0, s3 = s0,               \
            s4 = s0, s5 = s0, s6 = s0, s7 = s0;                                   \
_Pragma("clang loop unroll(disable)")                                             \
    for (int c = 0; c < NC; c++) {                                                \
      const __m256i* wc = w + c * 4;                                              \
      if (PFN) {                                                                  \
        qm_pf(reinterpret_cast<const char*>(wc) + 2048);                          \
        qm_pf(reinterpret_cast<const char*>(wc) + 2048 + 64);                     \
      }                                                                           \
      const __m256i av =                                                          \
          _mm256_load_si256(reinterpret_cast<const __m256i*>(act + 32 * c));      \
      { const __m256i wv = _mm256_load_si256(wc + 0);                             \
        s0 = DP(s0, av, _mm256_and_si256(wv, m0F));                               \
        s1 = DP(s1, av, _mm256_and_si256(_mm256_srli_epi16(wv, 4), m0F)); }       \
      { const __m256i wv = _mm256_load_si256(wc + 1);                             \
        s2 = DP(s2, av, _mm256_and_si256(wv, m0F));                               \
        s3 = DP(s3, av, _mm256_and_si256(_mm256_srli_epi16(wv, 4), m0F)); }       \
      { const __m256i wv = _mm256_load_si256(wc + 2);                             \
        s4 = DP(s4, av, _mm256_and_si256(wv, m0F));                               \
        s5 = DP(s5, av, _mm256_and_si256(_mm256_srli_epi16(wv, 4), m0F)); }       \
      { const __m256i wv = _mm256_load_si256(wc + 3);                             \
        s6 = DP(s6, av, _mm256_and_si256(wv, m0F));                               \
        s7 = DP(s7, av, _mm256_and_si256(_mm256_srli_epi16(wv, 4), m0F)); }       \
    }                                                                             \
    __m256i p01 = _mm256_hadd_epi32(s0, s1);                                      \
    __m256i p23 = _mm256_hadd_epi32(s2, s3);                                      \
    __m256i p45 = _mm256_hadd_epi32(s4, s5);                                      \
    __m256i p67 = _mm256_hadd_epi32(s6, s7);                                      \
    __m256i q0 = _mm256_hadd_epi32(p01, p23);                                     \
    __m256i q1 = _mm256_hadd_epi32(p45, p67);                                     \
    __m256i sums = _mm256_add_epi32(_mm256_permute2x128_si256(q0, q1, 0x20),      \
                                    _mm256_permute2x128_si256(q0, q1, 0x31));     \
    sums = _mm256_sub_epi32(                                                      \
        _mm256_sub_epi32(sums, corr7),                                            \
        _mm256_load_si256(reinterpret_cast<const __m256i*>(gp)));                 \
    epi(g, sums, reinterpret_cast<const float*>(gp + 32));                        \
  }                                                                               \
}                                                                                 \
                                                                                  \
template <int PFN, class Epi>                                                     \
__attribute__((target(TGT), noinline)) void run_g4_768_vnni4##SUF(                \
    const QDense& m, const uint8_t* act, Epi& epi) {                              \
  const __m128i corr7 = _mm_set1_epi32(act_corr7(act, 768));                      \
  const __m256i m0F = _mm256_set1_epi8(0x0F);                                     \
  const uint8_t* gp = m.arena;                                                    \
  constexpr ptrdiff_t GB = 32 + 24 * 64;                                          \
  const int ng = m.ngroups;                                                       \
  for (int g = 0; g < ng; g++, gp += GB) {                                        \
    const __m256i* w = reinterpret_cast<const __m256i*>(gp + 32);                 \
    __m256i d0 = _mm256_setzero_si256(), d1 = d0, d2 = d0, d3 = d0;               \
    for (int c = 0; c < 24; c++) {                                                \
      if (PFN && (c & 1) == 0)                                                    \
        qm_pf(reinterpret_cast<const char*>(w + c * 2) + 2048);                    \
      const __m256i av =                                                          \
          _mm256_load_si256(reinterpret_cast<const __m256i*>(act + 32 * c));      \
      const __m256i w01 = _mm256_load_si256(w + c * 2);                           \
      const __m256i w23 = _mm256_load_si256(w + c * 2 + 1);                       \
      d0 = DP(d0, av, _mm256_and_si256(w01, m0F));                                \
      d1 = DP(                                                                    \
          d1, av, _mm256_and_si256(_mm256_srli_epi16(w01, 4), m0F));              \
      d2 = DP(d2, av, _mm256_and_si256(w23, m0F));                                \
      d3 = DP(                                                                    \
          d3, av, _mm256_and_si256(_mm256_srli_epi16(w23, 4), m0F));              \
    }                                                                             \
    __m256i h = _mm256_hadd_epi32(_mm256_hadd_epi32(d0, d1),                      \
                                  _mm256_hadd_epi32(d2, d3));                     \
    __m128i sums = _mm_add_epi32(_mm256_castsi256_si128(h),                       \
                                 _mm256_extracti128_si256(h, 1));                 \
    sums = _mm_sub_epi32(                                                         \
        _mm_sub_epi32(sums, corr7),                                               \
        _mm_load_si128(reinterpret_cast<const __m128i*>(gp)));                    \
    epi.g4(g, sums, reinterpret_cast<const float*>(gp + 16));                     \
  }                                                                               \
}

QM_PACKED_KERNELS(, "avxvnni", _mm256_dpbusd_avx_epi32)
// EVEX encoding on ymm: AVX512-VNNI + AVX512VL (no zmm registers are used)
QM_PACKED_KERNELS(_512, "avx512vnni,avx512vl,avx512f", _mm256_dpbusd_epi32)
#undef QM_PACKED_KERNELS
#endif  // FX2_NO_VNNI

// [this entry] Kernel selection for 8-row groups: packed arena -> a VNNI
// packed kernel; else VNNI unpacked; else (and always in the submission
// build) the AVX2 kernel. All return the same int32 dots.
template <int NC, int PFN, class Epi>
inline void run_g8_any(const QDense& m, const uint8_t* act, Epi& epi) {
#ifdef FX2_NO_VNNI
  run_g8<NC, PFN>(m, act, epi);
#else
  if (m.packed) {
    if (g_vnni) run_g8_vnni4<NC, PFN>(m, act, epi);
    else run_g8_vnni4_512<NC, PFN>(m, act, epi);
  }
  else if (g_vnni) run_g8_vnni<NC, PFN>(m, act, epi);
  else run_g8<NC, PFN>(m, act, epi);
#endif
}

// [this entry] the same selection for the 4-row-group (d_in = 768) kernels
template <int PFN, class Epi>
inline void run_g4_768_any(const QDense& m, const uint8_t* act, Epi& epi) {
#ifdef FX2_NO_VNNI
  run_g4_768<PFN>(m, act, epi);
#else
  if (m.packed) {
    if (g_vnni) run_g4_768_vnni4<PFN>(m, act, epi);
    else run_g4_768_vnni4_512<PFN>(m, act, epi);
  }
  else if (g_vnni) run_g4_768_vnni<PFN>(m, act, epi);
  else run_g4_768<PFN>(m, act, epi);
#endif
}

// Picks the kernel instantiation by input width: 64 (gate down), 192 (most
// matmuls), 205/224 (a dense prior), 768.
template <int PFN, class Epi>
inline void dispatch(const QDense& m, const uint8_t* act, Epi& epi) {
  switch (m.d_in) {
    case 64:
      run_g8_any<2, PFN>(m, act, epi);
      break;
    case 192:
      run_g8_any<6, PFN>(m, act, epi);
      break;
    case 205:
    case 224:
      run_g8_any<7, PFN>(m, act, epi);
      break;
    case 768:
      run_g4_768_any<(PFN > 0 ? 2 : 0)>(m, act, epi);
      break;
    default:
      die("unsupported d_in");
  }
}

// ---------------------------------------------------------------------------
// packed int4 core (4-row groups; unsigned nibbles w+7, signed act)
// The previous winner's AVX2 comparison format (QPacked in qmat.h); used by
// test_qmat / bench_qmat only, not by the model.
// ---------------------------------------------------------------------------
template <int NPAIR, class Epi>
inline void run_packed(const QPacked& m, const int8_t* act, int32_t corr7,
                       Epi& epi) {
  const __m256i ones = _mm256_set1_epi16(1);
  const __m256i m0F = _mm256_set1_epi8(0x0F);
  const __m128i corr = _mm_set1_epi32(corr7);
  const uint8_t* gp = m.arena;
  const ptrdiff_t GB = 32 + static_cast<ptrdiff_t>(NPAIR) * 128;
  const int ng = m.ngroups;
  constexpr int NB = (NPAIR + 3) / 4;  // blocks of <=4 pairs (s16-safe: 8 madd)
  for (int g = 0; g < ng; g++, gp += GB) {
    const __m256i* w = reinterpret_cast<const __m256i*>(gp + 32);
    __m256i d0 = _mm256_setzero_si256(), d1 = d0, d2 = d0, d3 = d0;
    for (int b = 0; b < NB; b++) {
      constexpr int P0 = 0;  // per-block pair count
      const int np = (b + 1) * 4 <= NPAIR ? 4 : NPAIR - b * 4;
      (void)P0;
      __m256i s0 = _mm256_setzero_si256(), s1 = s0, s2 = s0, s3 = s0;
      for (int p = 0; p < np; p++) {
        if (p == 0)
          _mm_prefetch(reinterpret_cast<const char*>(gp) + b * 512 + 2048,
                       _MM_HINT_T0);
        const int pp = b * 4 + p;
        __m256i a0 = _mm256_load_si256(
            reinterpret_cast<const __m256i*>(act + 64 * pp));
        __m256i a1 = _mm256_load_si256(
            reinterpret_cast<const __m256i*>(act + 64 * pp + 32));
#define QM_PSTEP(r)                                                        \
  {                                                                        \
    __m256i wv = _mm256_load_si256(w + pp * 4 + (r));                      \
    __m256i lo = _mm256_and_si256(wv, m0F);                                \
    __m256i hi = _mm256_and_si256(_mm256_srli_epi16(wv, 4), m0F);          \
    s##r = _mm256_add_epi16(s##r, _mm256_maddubs_epi16(lo, a0));           \
    s##r = _mm256_add_epi16(s##r, _mm256_maddubs_epi16(hi, a1));           \
  }
        QM_PSTEP(0) QM_PSTEP(1) QM_PSTEP(2) QM_PSTEP(3)
#undef QM_PSTEP
      }
      d0 = _mm256_add_epi32(d0, _mm256_madd_epi16(s0, ones));
      d1 = _mm256_add_epi32(d1, _mm256_madd_epi16(s1, ones));
      d2 = _mm256_add_epi32(d2, _mm256_madd_epi16(s2, ones));
      d3 = _mm256_add_epi32(d3, _mm256_madd_epi16(s3, ones));
    }
    __m256i h = _mm256_hadd_epi32(_mm256_hadd_epi32(d0, d1),
                                  _mm256_hadd_epi32(d2, d3));
    __m128i sums = _mm_add_epi32(_mm256_castsi256_si128(h),
                                 _mm256_extracti128_si256(h, 1));
    sums = _mm_sub_epi32(sums, corr);
    epi.g4(g, sums, reinterpret_cast<const float*>(gp));
  }
}

template <class Epi>
inline void dispatch_packed(const QPacked& m, const int8_t* act, int32_t corr7,
                            Epi& epi) {
  switch (m.npair) {
    case 1:
      run_packed<1>(m, act, corr7, epi);
      break;
    case 3:
      run_packed<3>(m, act, corr7, epi);
      break;
    case 4:
      run_packed<4>(m, act, corr7, epi);
      break;
    case 12:
      run_packed<12>(m, act, corr7, epi);
      break;
    default:
      die("unsupported packed npair");
  }
}

}  // namespace

// ---------------------------------------------------------------------------
// public kernels
// ---------------------------------------------------------------------------
// (a) y = W q: the gate-down projections and the unembedding; also q/k/v and
// mlp.up when their inputs are 8-bit
void qgemv_f32(const QDense& m, const uint8_t* act, float* out) {
  EpiF32 e{out};
  dispatch<PFN_DEFAULT>(m, act, e);
}

void qgemv_f32_nopf(const QDense& m, const uint8_t* act, float* out) {
  EpiF32 e{out};
  dispatch<0>(m, act, e);
}

// (b) x += W q: the attention output projection on the 8-bit path
void qgemv_add(const QDense& m, const uint8_t* act, float* out) {
  EpiAdd e{out};
  dispatch<PFN_DEFAULT>(m, act, e);
}

// (c)/(d) are two-phase: the streaming loop stores y = scale*float(dot) into
// an L1-resident stack buffer (bitwise identical to epilogue (a)), then a
// second 8-wide pass does the quantize work. Fusing the div/round/pack chain
// into the group loop was measured ~20 cyc/group slower: the ~40-cycle
// dependency tail (incl. the 12-cycle vdivps) serializes at the ROB boundary,
// while the split phase-2 pass pipelines with no cross-iteration deps.
// Results are bit-identical either way (fp32 store/reload is lossless).
int qgemv_relu2q(const QDense& m, const uint8_t* act, float s_next,
                 uint8_t* q_out, uint16_t* idx_out) {
  if (m.d_in != 192) die("relu2q epilogue requires d_in==192");
  if (m.rows_padded > 768) die("relu2q epilogue requires d_out<=768");
  alignas(64) float y[768];
  EpiF32 e{y};
  run_g8_any<6, PFN_DEFAULT>(m, act, e);
  // phase 2a: relu^2 + quantize, two groups (16 outputs) per iteration
  const __m256 vs = _mm256_set1_ps(s_next);
  const __m256 v127 = _mm256_set1_ps(127.0f);
  const __m256 vz = _mm256_setzero_ps();
  const int ng2 = m.ngroups & ~1;
  for (int g = 0; g < ng2; g += 2) {
    __m256 y0 = _mm256_max_ps(_mm256_load_ps(y + 8 * g), vz);  // relu
    __m256 y1 = _mm256_max_ps(_mm256_load_ps(y + 8 * g + 8), vz);
    __m256 t0 = _mm256_div_ps(_mm256_mul_ps(y0, y0), vs);  // IEEE div
    __m256 t1 = _mm256_div_ps(_mm256_mul_ps(y1, y1), vs);
    __m256i q0 = _mm256_cvtps_epi32(_mm256_min_ps(t0, v127));  // rte
    __m256i q1 = _mm256_cvtps_epi32(_mm256_min_ps(t1, v127));
    __m256i q16 = _mm256_packs_epi32(q0, q1);  // lanes [q0lo q1lo|q0hi q1hi]
    q16 = _mm256_permute4x64_epi64(q16, _MM_SHUFFLE(3, 1, 2, 0));
    __m128i q8v = _mm_packus_epi16(_mm256_castsi256_si128(q16),
                                   _mm256_extracti128_si256(q16, 1));
    _mm_storeu_si128(reinterpret_cast<__m128i*>(q_out + 8 * g), q8v);
  }
  if (m.ngroups & 1) {
    const int g = m.ngroups - 1;
    __m256 yv = _mm256_max_ps(_mm256_load_ps(y + 8 * g), vz);
    __m256 t = _mm256_div_ps(_mm256_mul_ps(yv, yv), vs);
    __m256i q = _mm256_cvtps_epi32(_mm256_min_ps(t, v127));
    __m128i q16 = _mm_packs_epi32(_mm256_castsi256_si128(q),
                                  _mm256_extracti128_si256(q, 1));
    _mm_storel_epi64(reinterpret_cast<__m128i*>(q_out + 8 * g),
                     _mm_packus_epi16(q16, q16));
  }
  // phase 2b: 32-wide nonzero index scan over the packed bytes
  int nnz = 0;
  const int nblk = m.rows_padded / 32;
  for (int b = 0; b < nblk; b++) {
    __m256i v = _mm256_load_si256(
        reinterpret_cast<const __m256i*>(q_out + 32 * b));
    uint32_t mz = static_cast<uint32_t>(_mm256_movemask_epi8(
        _mm256_cmpeq_epi8(v, _mm256_setzero_si256())));
    uint32_t mk = ~mz;
    for (int k = 0; k < 4; k++) {
      const uint32_t m8 = (mk >> (8 * k)) & 0xFF;
      __m128i lut = _mm_loadl_epi64(
          reinterpret_cast<const __m128i*>(g_idxlut.t[m8]));
      __m128i i16 = _mm_add_epi16(
          _mm_cvtepu8_epi16(lut),
          _mm_set1_epi16(static_cast<short>(32 * b + 8 * k)));
      _mm_storeu_si128(reinterpret_cast<__m128i*>(idx_out + nnz), i16);
      nnz += __builtin_popcount(m8);
    }
  }
  for (int r = m.rows_padded & ~31; r < m.rows_padded; r++)  // tail (unused
    if (q_out[r]) idx_out[nnz++] = static_cast<uint16_t>(r);  // for 768)
  return nnz;
}

// (d) the 192 -> 64 half of a Kimi gate: matmul, then quantize the 64
// outputs to biased u8 for the 64 -> 192 half
void qgemv_quant_bias(const QDense& m, const uint8_t* act, float s_next,
                      uint8_t* q_out) {
  if (m.d_in != 192) die("quant_bias epilogue requires d_in==192");
  if (m.rows_padded > 768) die("quant_bias epilogue requires d_out<=768");
  alignas(64) float y[768];
  EpiF32 e{y};
  run_g8_any<6, PFN_DEFAULT>(m, act, e);
  const __m256 vs = _mm256_set1_ps(s_next);
  const __m256 vlo = _mm256_set1_ps(-128.0f);
  const __m256 vhi = _mm256_set1_ps(127.0f);
  const __m256i v128 = _mm256_set1_epi32(128);
  for (int g = 0; g < m.ngroups; g++) {
    __m256 t = _mm256_div_ps(_mm256_load_ps(y + 8 * g), vs);
    t = _mm256_min_ps(_mm256_max_ps(t, vlo), vhi);
    __m256i q = _mm256_add_epi32(_mm256_cvtps_epi32(t), v128);  // -> [0,255]
    __m128i q16 = _mm_packs_epi32(_mm256_castsi256_si128(q),
                                  _mm256_extracti128_si256(q, 1));
    _mm_storel_epi64(reinterpret_cast<__m128i*>(q_out + 8 * g),
                     _mm_packus_epi16(q16, q16));
  }
}

void qgemv_i32(const QDense& m, const uint8_t* act, int32_t* out) {
  EpiI32 e{out};
  dispatch<PFN_DEFAULT>(m, act, e);
}

void qgemv_packed_f32(const QPacked& m, const int8_t* act, int32_t corr7,
                      float* out) {
  EpiF32 e{out};
  dispatch_packed(m, act, corr7, e);
}

void qgemv_packed_i32(const QPacked& m, const int8_t* act, int32_t corr7,
                      int32_t* out) {
  EpiI32 e{out};
  dispatch_packed(m, act, corr7, e);
}

// ---------------------------------------------------------------------------
// builders
// ---------------------------------------------------------------------------
// [this entry] the packed arena stores two weights per byte (g_packed)
size_t qdense_bytes(int d_out, int d_in) {
  const int gr = qmat_group_rows(d_in);
  const int stride = qmat_round_up(d_in, 32);
  const int ng = qmat_round_up(d_out, gr) / gr;
  const size_t gb = (gr == 8 ? 64 : 32) +
                    static_cast<size_t>(stride) * gr / (g_packed ? 2 : 1);
  return static_cast<size_t>(ng) * gb;
}

QDense qdense_build(uint8_t* dst, const int8_t* qw, const float* fold,
                    int d_out, int d_in, bool biased_input) {
  if (reinterpret_cast<uintptr_t>(dst) & 63) die("arena not 64B-aligned");
  QDense m;
  m.arena = dst;
  m.d_out = d_out;
  m.d_in = d_in;
  m.stride = qmat_round_up(d_in, 32);
  m.nchunk = m.stride / 32;
  m.group_rows = qmat_group_rows(d_in);
  m.rows_padded = qmat_round_up(d_out, m.group_rows);
  m.ngroups = m.rows_padded / m.group_rows;
  m.bytes = qdense_bytes(d_out, d_in);
  m.packed = g_packed;
  const int G = m.group_rows;
  const size_t meta = G == 8 ? 64 : 32;
  const size_t gb =
      meta + static_cast<size_t>(m.stride) * G / (m.packed ? 2 : 1);
  for (int g = 0; g < m.ngroups; g++) {
    uint8_t* gp = dst + g * gb;
    int32_t* corr = reinterpret_cast<int32_t*>(gp);
    float* scl = reinterpret_cast<float*>(gp + meta / 2);
    for (int r = 0; r < G; r++) {
      const int row = g * G + r;
      int32_t s = 0;
      if (row < d_out && biased_input)
        for (int i = 0; i < d_in; i++) s += qw[static_cast<size_t>(row) * d_in + i];
      corr[r] = 128 * s;
      scl[r] = row < d_out ? fold[row] : 0.0f;
    }
    // [this entry] packed layout: byte b of vector j of chunk c = row 2j in
    // the low nibble, row 2j+1 in the high nibble, both as w + 7. Padding
    // weights are 0, stored as 7, and are cancelled by the 7 * sum(act)
    // correction like every other weight.
    if (m.packed) {
      auto wt = [&](int row, int col) -> int {
        if (row >= d_out || col >= d_in) return 0;
        const int v = qw[static_cast<size_t>(row) * d_in + col];
        if (v < -7 || v > 7) die("weight out of [-7,7]");
        return v;
      };
      uint8_t* wp = gp + meta;
      for (int c = 0; c < m.nchunk; c++)
        for (int j = 0; j < G / 2; j++) {
          const int r0 = g * G + 2 * j;
          for (int b = 0; b < 32; b++)
            *wp++ = static_cast<uint8_t>(((wt(r0 + 1, 32 * c + b) + 7) << 4) |
                                         (wt(r0, 32 * c + b) + 7));
        }
      continue;
    }
    // unpacked layout (the previous winner's; the submission build's)
    int8_t* w = reinterpret_cast<int8_t*>(gp + meta);
    for (int c = 0; c < m.nchunk; c++)
      for (int r = 0; r < G; r++) {
        const int row = g * G + r;
        for (int j = 0; j < 32; j++) {
          const int col = 32 * c + j;
          int8_t v = 0;
          if (row < d_out && col < d_in) {
            v = qw[static_cast<size_t>(row) * d_in + col];
            if (v < -7 || v > 7) die("weight out of [-7,7]");
          }
          *w++ = v;
        }
      }
  }
  return m;
}

// column-major int8 arena (one byte per weight) for the sparse kernels
size_t qsparse_bytes(int d_in) { return static_cast<size_t>(d_in) * 192; }

QSparse qsparse_build(int8_t* dst_cols, float* dst_fold, const int8_t* qw,
                      const float* fold, int d_out, int d_in) {
  if (d_out != 192) die("sparse arena requires d_out==192");
  if (reinterpret_cast<uintptr_t>(dst_cols) & 63) die("cols not 64B-aligned");
  for (int c = 0; c < d_in; c++)
    for (int r = 0; r < 192; r++) {
      int8_t v = qw[static_cast<size_t>(r) * d_in + c];
      if (v < -7 || v > 7) die("weight out of [-7,7]");
      dst_cols[static_cast<size_t>(c) * 192 + r] = v;
    }
  std::memcpy(dst_fold, fold, sizeof(float) * 192);
  QSparse s;
  s.cols = dst_cols;
  s.fold = dst_fold;
  s.d_in = d_in;
  s.d_out = 192;
  return s;
}

// column-major nibble arena (QSparse4): the prior embedding, and mlp.down on
// the 8-bit path
size_t qsparse4_bytes(int d_in) { return static_cast<size_t>(d_in) * 128; }

QSparse4 qsparse4_build(uint8_t* dst_cols, float* dst_fold, const int8_t* qw,
                        const float* fold, int d_out, int d_in) {
  if (d_out != 192) die("sparse4 arena requires d_out==192");
  if (reinterpret_cast<uintptr_t>(dst_cols) & 63) die("cols not 64B-aligned");
  for (int c = 0; c < d_in; c++) {
    uint8_t* col = dst_cols + static_cast<size_t>(c) * 128;
    for (int b = 0; b < 96; b++) {
      int lo = qw[static_cast<size_t>(b) * d_in + c] + 7;
      int hi = qw[static_cast<size_t>(96 + b) * d_in + c] + 7;
      if (lo < 0 || lo > 14 || hi < 0 || hi > 14) die("weight out of [-7,7]");
      col[b] = static_cast<uint8_t>((hi << 4) | lo);
    }
    std::memset(col + 96, 0, 32);
  }
  std::memcpy(dst_fold, fold, sizeof(float) * 192);
  QSparse4 s;
  s.cols = dst_cols;
  s.fold = dst_fold;
  s.d_in = d_in;
  s.d_out = 192;
  return s;
}

// the AVX2 packed comparison format (tests / benchmarks only)
size_t qpacked_bytes(int d_out, int d_in) {
  const int stride4 = qmat_round_up(d_in, 64);
  const int ng = qmat_round_up(d_out, 4) / 4;
  return static_cast<size_t>(ng) * (32 + static_cast<size_t>(stride4) * 2);
}

QPacked qpacked_build(uint8_t* dst, const int8_t* qw, const float* fold,
                      int d_out, int d_in) {
  if (reinterpret_cast<uintptr_t>(dst) & 63) die("arena not 64B-aligned");
  QPacked m;
  m.arena = dst;
  m.d_out = d_out;
  m.d_in = d_in;
  m.stride4 = qmat_round_up(d_in, 64);
  m.npair = m.stride4 / 64;
  m.rows_padded = qmat_round_up(d_out, 4);
  m.ngroups = m.rows_padded / 4;
  m.bytes = qpacked_bytes(d_out, d_in);
  const size_t gb = 32 + static_cast<size_t>(m.stride4) * 2;
  for (int g = 0; g < m.ngroups; g++) {
    uint8_t* gp = dst + g * gb;
    float* scl = reinterpret_cast<float*>(gp);
    for (int r = 0; r < 4; r++) {
      const int row = g * 4 + r;
      scl[r] = row < d_out ? fold[row] : 0.0f;
    }
    std::memset(gp + 16, 0, 16);
    uint8_t* w = gp + 32;
    for (int p = 0; p < m.npair; p++)
      for (int r = 0; r < 4; r++) {
        const int row = g * 4 + r;
        for (int j = 0; j < 32; j++) {
          auto nib = [&](int col) -> int {
            if (row >= d_out || col >= d_in) return 7;  // qw=0 -> 0+7
            return qw[static_cast<size_t>(row) * d_in + col] + 7;
          };
          *w++ = static_cast<uint8_t>((nib(64 * p + 32 + j) << 4) |
                                      nib(64 * p + j));
        }
      }
  }
  return m;
}

}  // namespace opt
}  // namespace fx2
