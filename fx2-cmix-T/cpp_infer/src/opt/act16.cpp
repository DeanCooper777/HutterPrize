// act16.cpp — see act16.h. AVX2 only; every operation is an explicit
// intrinsic (no fast-math), so results are the same on every x86-64 CPU.
#include "act16.h"

#include <immintrin.h>

namespace fx2 {
namespace opt {

namespace {
// t[m] = the bit positions set in m, one per byte, lowest first
struct PosTable {
  uint64_t t[256];
  constexpr PosTable() : t() {
    for (int m = 0; m < 256; m++) {
      uint64_t v = 0;
      int k = 0;
      for (int b = 0; b < 8; b++)
        if ((m >> b) & 1) v |= static_cast<uint64_t>(b) << (8 * k++);
      t[m] = v;
    }
  }
};
constexpr PosTable kPos;
}  // namespace

int relu2_quant16(const float* h, float s, int n, int16_t* a, uint16_t* idx) {
  const __m256 vs = _mm256_set1_ps(s);
  const __m256 vhi = _mm256_set1_ps(32767.0f);
  const __m256 vz = _mm256_setzero_ps();
  const __m256i iz = _mm256_setzero_si256();
  int nnz = 0;
  for (int i = 0; i < n; i += 8) {
    __m256 v = _mm256_max_ps(_mm256_loadu_ps(h + i), vz);
    v = _mm256_mul_ps(v, v);
    v = _mm256_min_ps(_mm256_div_ps(v, vs), vhi);
    const __m256i q = _mm256_cvtps_epi32(v);  // round half to even
    const __m128i q16 = _mm_packs_epi32(_mm256_castsi256_si128(q),
                                        _mm256_extracti128_si256(q, 1));
    _mm_storeu_si128(reinterpret_cast<__m128i*>(a + i), q16);
    unsigned m = ~static_cast<unsigned>(_mm256_movemask_ps(
                     _mm256_castsi256_ps(_mm256_cmpeq_epi32(q, iz)))) & 0xFFu;
    // branch-free compaction: the positions of the set bits of m, ascending,
    // from a 256-entry table; always stores 8 entries (room: nnz + 8 <= n)
    const __m128i pos = _mm_add_epi16(
        _mm_cvtepu8_epi16(_mm_cvtsi64_si128(static_cast<long long>(kPos.t[m]))),
        _mm_set1_epi16(static_cast<short>(i)));
    _mm_storeu_si128(reinterpret_cast<__m128i*>(idx + nnz), pos);
    nnz += __builtin_popcount(m);
  }
  const uint16_t fill = nnz ? idx[nnz - 1] : 0;  // in-range prefetch slack
  for (int k = nnz; k < nnz + 8; k++) idx[k] = fill;
  return nnz;
}

void quant192_i16(const float* x, float s, int16_t* a) {
  const __m256 vs = _mm256_set1_ps(s);
  const __m256 vlo = _mm256_set1_ps(-32768.0f);
  const __m256 vhi = _mm256_set1_ps(32767.0f);
  for (int i = 0; i < 192; i += 8) {
    __m256 v = _mm256_div_ps(_mm256_loadu_ps(x + i), vs);
    v = _mm256_min_ps(_mm256_max_ps(v, vlo), vhi);
    const __m256i q = _mm256_cvtps_epi32(v);
    _mm_storeu_si128(reinterpret_cast<__m128i*>(a + i),
                     _mm_packs_epi32(_mm256_castsi256_si128(q),
                                     _mm256_extracti128_si256(q, 1)));
  }
}

namespace {

// rows [row0, row0 + 96): 6 blocks of 16 rows, 12 int32 accumulators
inline void spmv16_half(const int8_t* cols, const float* fold,
                        const int16_t* a, const uint16_t* idx, int nnz,
                        int row0, float* out) {
  __m256i lo[6], hi[6];
  for (int b = 0; b < 6; b++) lo[b] = hi[b] = _mm256_setzero_si256();
  int k = 0;
  for (; k + 1 < nnz; k += 2) {
    const unsigned c0 = idx[k], c1 = idx[k + 1];
    const __m256i pair = _mm256_set1_epi32(static_cast<int>(
        static_cast<uint32_t>(static_cast<uint16_t>(a[c0])) |
        (static_cast<uint32_t>(static_cast<uint16_t>(a[c1])) << 16)));
    const int8_t* p0 = cols + size_t(c0) * 192 + row0;
    const int8_t* p1 = cols + size_t(c1) * 192 + row0;
    _mm_prefetch(reinterpret_cast<const char*>(cols + size_t(idx[k + 2]) * 192 + row0), _MM_HINT_T0);
    _mm_prefetch(reinterpret_cast<const char*>(cols + size_t(idx[k + 2]) * 192 + row0 + 64), _MM_HINT_T0);
    _mm_prefetch(reinterpret_cast<const char*>(cols + size_t(idx[k + 3]) * 192 + row0), _MM_HINT_T0);
    _mm_prefetch(reinterpret_cast<const char*>(cols + size_t(idx[k + 3]) * 192 + row0 + 64), _MM_HINT_T0);
    for (int b = 0; b < 6; b++) {
      const __m256i w0 = _mm256_cvtepi8_epi16(
          _mm_loadu_si128(reinterpret_cast<const __m128i*>(p0 + 16 * b)));
      const __m256i w1 = _mm256_cvtepi8_epi16(
          _mm_loadu_si128(reinterpret_cast<const __m128i*>(p1 + 16 * b)));
      lo[b] = _mm256_add_epi32(
          lo[b], _mm256_madd_epi16(_mm256_unpacklo_epi16(w0, w1), pair));
      hi[b] = _mm256_add_epi32(
          hi[b], _mm256_madd_epi16(_mm256_unpackhi_epi16(w0, w1), pair));
    }
  }
  if (k < nnz) {
    const unsigned c0 = idx[k];
    const __m256i pair = _mm256_set1_epi32(
        static_cast<int>(static_cast<uint32_t>(static_cast<uint16_t>(a[c0]))));
    const int8_t* p0 = cols + size_t(c0) * 192 + row0;
    const __m256i z = _mm256_setzero_si256();
    for (int b = 0; b < 6; b++) {
      const __m256i w0 = _mm256_cvtepi8_epi16(
          _mm_loadu_si128(reinterpret_cast<const __m128i*>(p0 + 16 * b)));
      lo[b] = _mm256_add_epi32(
          lo[b], _mm256_madd_epi16(_mm256_unpacklo_epi16(w0, z), pair));
      hi[b] = _mm256_add_epi32(
          hi[b], _mm256_madd_epi16(_mm256_unpackhi_epi16(w0, z), pair));
    }
  }
  // lo = rows {0-3, 8-11}, hi = rows {4-7, 12-15} of each 16-row block
  for (int b = 0; b < 6; b++) {
    const __m256i r0 = _mm256_permute2x128_si256(lo[b], hi[b], 0x20);
    const __m256i r1 = _mm256_permute2x128_si256(lo[b], hi[b], 0x31);
    float* o = out + row0 + 16 * b;
    const float* f = fold + row0 + 16 * b;
    _mm256_storeu_ps(
        o, _mm256_add_ps(_mm256_loadu_ps(o),
                         _mm256_mul_ps(_mm256_loadu_ps(f),
                                       _mm256_cvtepi32_ps(r0))));
    _mm256_storeu_ps(
        o + 8, _mm256_add_ps(_mm256_loadu_ps(o + 8),
                             _mm256_mul_ps(_mm256_loadu_ps(f + 8),
                                           _mm256_cvtepi32_ps(r1))));
  }
}

// sum of the 8 int32 lanes of each of 4 accumulators -> 4 int32
inline __m128i hsum4(__m256i a0, __m256i a1, __m256i a2, __m256i a3) {
  const __m256i t = _mm256_hadd_epi32(_mm256_hadd_epi32(a0, a1),
                                      _mm256_hadd_epi32(a2, a3));
  return _mm_add_epi32(_mm256_castsi256_si128(t),
                       _mm256_extracti128_si256(t, 1));
}

}  // namespace

// idx must have 8 readable in-range entries past nnz (prefetch lookahead)
void spmv16_add(const int8_t* cols, const float* fold, const int16_t* a,
                const uint16_t* idx, int nnz, float* out) {
  spmv16_half(cols, fold, a, idx, nnz, 0, out);
  spmv16_half(cols, fold, a, idx, nnz, 96, out);
}

void gemv16_add(const int8_t* rows, const float* fold, const int16_t* a,
                float* out) {
  __m256i av[12];
  for (int j = 0; j < 12; j++)
    av[j] = _mm256_loadu_si256(reinterpret_cast<const __m256i*>(a + 16 * j));
  for (int r = 0; r < 192; r += 16) {
    __m256i res[2];
    for (int h = 0; h < 2; h++) {
      const int8_t* w = rows + size_t(r + 8 * h) * 192;
      __m256i acc[8];
      for (int q = 0; q < 8; q++) {
        const int8_t* wr = w + size_t(q) * 192;
        __m256i s = _mm256_madd_epi16(
            _mm256_cvtepi8_epi16(
                _mm_loadu_si128(reinterpret_cast<const __m128i*>(wr))),
            av[0]);
        for (int j = 1; j < 12; j++)
          s = _mm256_add_epi32(
              s, _mm256_madd_epi16(_mm256_cvtepi8_epi16(_mm_loadu_si128(
                                       reinterpret_cast<const __m128i*>(
                                           wr + 16 * j))),
                                   av[j]));
        acc[q] = s;
      }
      res[h] = _mm256_set_m128i(hsum4(acc[4], acc[5], acc[6], acc[7]),
                                hsum4(acc[0], acc[1], acc[2], acc[3]));
    }
    float* o = out + r;
    const float* f = fold + r;
    _mm256_storeu_ps(
        o, _mm256_add_ps(_mm256_loadu_ps(o),
                         _mm256_mul_ps(_mm256_loadu_ps(f),
                                       _mm256_cvtepi32_ps(res[0]))));
    _mm256_storeu_ps(
        o + 8, _mm256_add_ps(_mm256_loadu_ps(o + 8),
                             _mm256_mul_ps(_mm256_loadu_ps(f + 8),
                                           _mm256_cvtepi32_ps(res[1]))));
  }
}

// ---------------------------------------------------------------------------
// packed variants (see act16.h)
// ---------------------------------------------------------------------------
int relu2_quant16p(const float* h, float s, int n, int16_t* a, uint16_t* idx,
                   uint16_t* idxh, int* nh_out, int32_t* suma_out) {
  const __m256 vs = _mm256_set1_ps(s);
  const __m256 vhi = _mm256_set1_ps(32767.0f);
  const __m256 vz = _mm256_setzero_ps();
  const __m256i iz = _mm256_setzero_si256();
  const __m256i i255 = _mm256_set1_epi32(255);
  __m256i vsum = _mm256_setzero_si256();
  int nnz = 0, nh = 0;
  for (int i = 0; i < n; i += 8) {
    __m256 v = _mm256_max_ps(_mm256_loadu_ps(h + i), vz);
    v = _mm256_mul_ps(v, v);
    v = _mm256_min_ps(_mm256_div_ps(v, vs), vhi);
    const __m256i q = _mm256_cvtps_epi32(v);  // round half to even
    vsum = _mm256_add_epi32(vsum, q);
    const __m128i q16 = _mm_packs_epi32(_mm256_castsi256_si128(q),
                                        _mm256_extracti128_si256(q, 1));
    _mm_storeu_si128(reinterpret_cast<__m128i*>(a + i), q16);
    const unsigned m = ~static_cast<unsigned>(_mm256_movemask_ps(
                           _mm256_castsi256_ps(_mm256_cmpeq_epi32(q, iz)))) & 0xFFu;
    const unsigned mh = static_cast<unsigned>(_mm256_movemask_ps(
        _mm256_castsi256_ps(_mm256_cmpgt_epi32(q, i255))));
    const __m128i base = _mm_set1_epi16(static_cast<short>(i));
    _mm_storeu_si128(
        reinterpret_cast<__m128i*>(idx + nnz),
        _mm_add_epi16(_mm_cvtepu8_epi16(_mm_cvtsi64_si128(
                          static_cast<long long>(kPos.t[m]))), base));
    nnz += __builtin_popcount(m);
    _mm_storeu_si128(
        reinterpret_cast<__m128i*>(idxh + nh),
        _mm_add_epi16(_mm_cvtepu8_epi16(_mm_cvtsi64_si128(
                          static_cast<long long>(kPos.t[mh]))), base));
    nh += __builtin_popcount(mh);
  }
  const uint16_t fill = nnz ? idx[nnz - 1] : 0;  // in-range prefetch slack
  for (int k = nnz; k < nnz + 16; k++) idx[k] = fill;
  __m128i t4 = _mm_add_epi32(_mm256_castsi256_si128(vsum),
                             _mm256_extracti128_si256(vsum, 1));
  t4 = _mm_add_epi32(t4, _mm_shuffle_epi32(t4, 0x4E));
  t4 = _mm_add_epi32(t4, _mm_shuffle_epi32(t4, 0xB1));
  *suma_out = _mm_cvtsi128_si32(t4);
  *nh_out = nh;
  return nnz;
}

void pack16_nibbles(const int8_t* w, int n, uint8_t* dst) {
  for (int j = 0; j < n / 64; j++)
    for (int i = 0; i < 32; i++)
      dst[32 * j + i] = static_cast<uint8_t>(
          (w[64 * j + i] + 7) | ((w[64 * j + 32 + i] + 7) << 4));
}

namespace {

// One sweep over the listed columns: S[r] += sum_k mult(idx[k]) * u[r][idx[k]]
// with mult(c) = the byte ab[2c] (the low or the high byte of a[c]). Columns
// go two at a time: their bytes are interleaved, so each 16-bit lane of
// vpmaddubsw holds one row's m0*u0 + m1*u1. The 12 u16 accumulators (16 rows
// each) take MAXP pairs before they are widened into S, so
// MAXP * 2 * max(mult) * 14 must stay below 65536. PD = prefetch distance in
// pairs (0 = none; else idx needs 2*PD + 2 in-range entries past n).
template <int MAXP, int PD>
inline void sweep16(const uint8_t* cols, const uint16_t* idx, int n,
                    const uint8_t* ab, int32_t* S) {
  const __m256i m0F = _mm256_set1_epi8(0x0F);
  __m256i acc[12];
  for (int q = 0; q < 12; q++) acc[q] = _mm256_setzero_si256();
  int pend = 0;
  for (int k = 0; k < n; k += 2) {
    const unsigned c0 = idx[k];
    const bool two = k + 1 < n;
    const unsigned c1 = two ? idx[k + 1] : c0;
    const unsigned m0 = ab[2 * c0], m1 = two ? ab[2 * c1] : 0u;
    const __m256i pair =
        _mm256_set1_epi16(static_cast<short>(m0 | (m1 << 8)));
    const uint8_t* p0 = cols + size_t(c0) * 96;
    const uint8_t* p1 = cols + size_t(c1) * 96;
    if (PD) {
      const char* f0 = reinterpret_cast<const char*>(cols) +
                       size_t(idx[k + 2 * PD]) * 96;
      const char* f1 = reinterpret_cast<const char*>(cols) +
                       size_t(idx[k + 2 * PD + 1]) * 96;
      _mm_prefetch(f0, _MM_HINT_T0);
      _mm_prefetch(f0 + 64, _MM_HINT_T0);
      _mm_prefetch(f1, _MM_HINT_T0);
      _mm_prefetch(f1 + 64, _MM_HINT_T0);
    }
    for (int j = 0; j < 3; j++) {
      const __m256i v0 =
          _mm256_loadu_si256(reinterpret_cast<const __m256i*>(p0 + 32 * j));
      const __m256i v1 =
          _mm256_loadu_si256(reinterpret_cast<const __m256i*>(p1 + 32 * j));
      const __m256i xl = _mm256_unpacklo_epi8(v0, v1);
      const __m256i xh = _mm256_unpackhi_epi8(v0, v1);
      acc[4 * j + 0] = _mm256_add_epi16(
          acc[4 * j + 0],
          _mm256_maddubs_epi16(pair, _mm256_and_si256(xl, m0F)));
      acc[4 * j + 1] = _mm256_add_epi16(
          acc[4 * j + 1],
          _mm256_maddubs_epi16(pair, _mm256_and_si256(xh, m0F)));
      acc[4 * j + 2] = _mm256_add_epi16(
          acc[4 * j + 2],
          _mm256_maddubs_epi16(
              pair, _mm256_and_si256(_mm256_srli_epi16(xl, 4), m0F)));
      acc[4 * j + 3] = _mm256_add_epi16(
          acc[4 * j + 3],
          _mm256_maddubs_epi16(
              pair, _mm256_and_si256(_mm256_srli_epi16(xh, 4), m0F)));
    }
    if (++pend == MAXP || k + 2 >= n) {
      // acc[4j + 2*nib + uh]: its low half is rows b..b+7 and its high half
      // rows b+16..b+23, with b = 64j + 32*nib + 8*uh
      for (int q = 0; q < 12; q++) {
        int32_t* s = S + 64 * (q >> 2) + 32 * ((q >> 1) & 1) + 8 * (q & 1);
        __m256i* s0 = reinterpret_cast<__m256i*>(s);
        __m256i* s1 = reinterpret_cast<__m256i*>(s + 16);
        _mm256_storeu_si256(
            s0, _mm256_add_epi32(_mm256_loadu_si256(s0),
                                 _mm256_cvtepu16_epi32(
                                     _mm256_castsi256_si128(acc[q]))));
        _mm256_storeu_si256(
            s1, _mm256_add_epi32(_mm256_loadu_si256(s1),
                                 _mm256_cvtepu16_epi32(
                                     _mm256_extracti128_si256(acc[q], 1))));
        acc[q] = _mm256_setzero_si256();
      }
      pend = 0;
    }
  }
}

}  // namespace

void spmv16p_add(const uint8_t* cols, const float* fold, const int16_t* a,
                 const uint16_t* idx, int nnz, const uint16_t* idxh, int nh,
                 int32_t suma, float* out) {
  alignas(32) int32_t SL[192], SH[192];
  for (int r = 0; r < 192; r += 8) {
    _mm256_store_si256(reinterpret_cast<__m256i*>(SL + r),
                       _mm256_setzero_si256());
    _mm256_store_si256(reinterpret_cast<__m256i*>(SH + r),
                       _mm256_setzero_si256());
  }
  const uint8_t* ab = reinterpret_cast<const uint8_t*>(a);
  sweep16<8, 6>(cols, idx, nnz, ab, SL);       // low bytes (<= 255)
  sweep16<16, 0>(cols, idxh, nh, ab + 1, SH);  // high bytes (<= 127)
  // sum_c a*w = sum al*u + 256 * sum ah*u - 7 * sum a
  const __m256i corr = _mm256_set1_epi32(7 * suma);
  for (int r = 0; r < 192; r += 8) {
    const __m256i t = _mm256_sub_epi32(
        _mm256_add_epi32(
            _mm256_load_si256(reinterpret_cast<const __m256i*>(SL + r)),
            _mm256_slli_epi32(
                _mm256_load_si256(reinterpret_cast<const __m256i*>(SH + r)),
                8)),
        corr);
    _mm256_storeu_ps(
        out + r, _mm256_add_ps(_mm256_loadu_ps(out + r),
                               _mm256_mul_ps(_mm256_loadu_ps(fold + r),
                                             _mm256_cvtepi32_ps(t))));
  }
}

// a = sl + 256*sh + 128 with sl = (a & 255) - 128 and sh = a >> 8, both
// signed bytes. With u = w + 7:
//   sum_c a*w = sum u*sl + 256 * sum u*sh - 7 * (sum sl + 256 * sum sh)
//               + 128 * sum_c w
// Each vpmaddubsw lane is at most 2*14*128; a row's six sum to < 32768.
void gemv16p_add(const uint8_t* rows, const float* fold, const int32_t* krow,
                 const int16_t* a, float* out) {
  alignas(32) int8_t sl[192], sh[192];
  const __m256i mFF = _mm256_set1_epi16(0x00FF);
  const __m256i m80 = _mm256_set1_epi8(static_cast<char>(0x80));
  const __m256i ones = _mm256_set1_epi16(1);
  __m256i sums = _mm256_setzero_si256();  // sum of a (int32 lanes)
  for (int i = 0; i < 192; i += 32) {
    const __m256i x0 =
        _mm256_loadu_si256(reinterpret_cast<const __m256i*>(a + i));
    const __m256i x1 =
        _mm256_loadu_si256(reinterpret_cast<const __m256i*>(a + i + 16));
    __m256i lo = _mm256_packus_epi16(_mm256_and_si256(x0, mFF),
                                     _mm256_and_si256(x1, mFF));
    __m256i hi = _mm256_packs_epi16(_mm256_srai_epi16(x0, 8),
                                    _mm256_srai_epi16(x1, 8));
    lo = _mm256_xor_si256(_mm256_permute4x64_epi64(lo, 0xD8), m80);
    hi = _mm256_permute4x64_epi64(hi, 0xD8);
    _mm256_store_si256(reinterpret_cast<__m256i*>(sl + i), lo);
    _mm256_store_si256(reinterpret_cast<__m256i*>(sh + i), hi);
    sums = _mm256_add_epi32(
        sums, _mm256_add_epi32(_mm256_madd_epi16(x0, ones),
                               _mm256_madd_epi16(x1, ones)));
  }
  __m128i t4 = _mm_add_epi32(_mm256_castsi256_si128(sums),
                             _mm256_extracti128_si256(sums, 1));
  t4 = _mm_add_epi32(t4, _mm_shuffle_epi32(t4, 0x4E));
  t4 = _mm_add_epi32(t4, _mm_shuffle_epi32(t4, 0xB1));
  // sum sl + 256 * sum sh = sum a - 128 * 192
  const __m256i corr =
      _mm256_set1_epi32(7 * (_mm_cvtsi128_si32(t4) - 128 * 192));
  const __m256i m0F = _mm256_set1_epi8(0x0F);
  const __m256i c256 = _mm256_set1_epi16(256);
  const __m256i* SLv = reinterpret_cast<const __m256i*>(sl);
  const __m256i* SHv = reinterpret_cast<const __m256i*>(sh);
  for (int r = 0; r < 192; r += 8) {
    __m256i t[8];
    for (int q = 0; q < 8; q++) {
      const uint8_t* w = rows + size_t(r + q) * 96;
      __m256i aL = _mm256_setzero_si256(), aH = aL;
      for (int j = 0; j < 3; j++) {
        const __m256i v = _mm256_loadu_si256(
            reinterpret_cast<const __m256i*>(w + 32 * j));
        const __m256i lo = _mm256_and_si256(v, m0F);
        const __m256i hi = _mm256_and_si256(_mm256_srli_epi16(v, 4), m0F);
        aL = _mm256_add_epi16(
            aL, _mm256_add_epi16(_mm256_maddubs_epi16(lo, SLv[2 * j]),
                                 _mm256_maddubs_epi16(hi, SLv[2 * j + 1])));
        aH = _mm256_add_epi16(
            aH, _mm256_add_epi16(_mm256_maddubs_epi16(lo, SHv[2 * j]),
                                 _mm256_maddubs_epi16(hi, SHv[2 * j + 1])));
      }
      t[q] = _mm256_add_epi32(_mm256_madd_epi16(aL, ones),
                              _mm256_madd_epi16(aH, c256));
    }
    const __m256i q0 = _mm256_hadd_epi32(_mm256_hadd_epi32(t[0], t[1]),
                                         _mm256_hadd_epi32(t[2], t[3]));
    const __m256i q1 = _mm256_hadd_epi32(_mm256_hadd_epi32(t[4], t[5]),
                                         _mm256_hadd_epi32(t[6], t[7]));
    __m256i dots = _mm256_add_epi32(_mm256_permute2x128_si256(q0, q1, 0x20),
                                    _mm256_permute2x128_si256(q0, q1, 0x31));
    dots = _mm256_add_epi32(
        _mm256_sub_epi32(dots, corr),
        _mm256_loadu_si256(reinterpret_cast<const __m256i*>(krow + r)));
    _mm256_storeu_ps(
        out + r, _mm256_add_ps(_mm256_loadu_ps(out + r),
                               _mm256_mul_ps(_mm256_loadu_ps(fold + r),
                                             _mm256_cvtepi32_ps(dots))));
  }
}

}  // namespace opt
}  // namespace fx2
