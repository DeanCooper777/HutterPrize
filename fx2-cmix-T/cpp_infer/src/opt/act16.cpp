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

}  // namespace opt
}  // namespace fx2
