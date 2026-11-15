// s0pack: compressor for the first stage of the unpacking stub (new in this entry).
//
// The stub that unpacks the cmix executable (pkdec.c, "stage 1") is about 6 KB of code and
// tables, and it is stored twice (comp9 and archive9). s0pack compresses stage 1 itself with a
// very small context-mixing coder whose decoder ("stage 0", stage0.S, hand-written assembly)
// is under 300 bytes. At start, stage 0 decodes stage 1 into memory and jumps to it; stage 1
// then decodes the cmix executable as before.
//
// Model (the decoder in stage0.S must match bit for bit):
//   * Bits are coded most significant first. For every bit, each of NM models looks up a pair
//     of 8-bit counts (n0, n1) in one shared hash table. A model is a mask over the previous 8
//     bytes (bit j set = byte i-1-j is part of the context); the slot is
//       crc32c(...crc32c(crc32c(mask, byte...), ...), c0) & (TSIZE - 1)
//     using the CPU's CRC32 instruction, with c0 = 1 followed by the bits of the current byte
//     seen so far. Bytes before the start of the data count as zero.
//   * The counts of all models are added up; a pair in which one count is zero (the context has
//     only ever seen one value) is multiplied by BOOST first. p(bit = 1) = (N1 + 1) / (N0 + N1 + 2).
//   * Update: the count of the coded bit is incremented (up to 255); the other count, if above 1,
//     is halved (rounding down).
//   * Coder: 32-bit binary arithmetic coder without carry (same as pk.cpp).
// The set of masks is chosen per input by greedy search (add the mask that helps most, then try
// to drop masks), since the decoder cost of a mask is one byte.
//
// Usage: s0pack IN OUT.cm OUT.inc [MAXMODELS]
//   OUT.cm   coded stream;  OUT.inc  assembler constants for stage0.S (S1_LEN, NM, mask bytes)
// Testing: after coding it decodes OUT.cm again with an independent copy of the decoder loop and
// compares; exit status 1 on mismatch.
//
// New in this entry: part of the executable packer that replaces UPX (see pk.cpp). Run by
// pack.sh on the flat image of stage 1; stage0.S includes its two output files.
// Only S1_LEN, the masks, TBITS and BOOST reach stage0.S through OUT.inc. The other experiment
// knobs (S0_LIMIT, S0_HALVE, S0_WEIGHTS) have no counterpart in stage0.S, which implements
// their defaults: a stream coded with other values passes the check below but would not be
// decoded by the stub.
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <vector>
#include <nmmintrin.h>
typedef uint8_t u8; typedef uint32_t u32; typedef uint64_t u64;

enum { TBITS = 20 };   // 2^20 slots of 2 bytes
static int BOOST_SHIFT = 2, LIMIT = 255, HALVE = 1;   // experiment knobs (env S0_BOOST, S0_LIMIT, S0_HALVE)
static const u32 TMASK = (1u << TBITS) - 1;

// The model: shared count table, the masks in use, and the slots touched by the last predict
// (for update). wt = optional per-model weight shifts (experiment, normally empty).
// predict() takes the history either from the input d (coding) or from `hist` (the output
// being rebuilt, in the decode check).
struct Coder {
  std::vector<u8> table; const u8* d; size_t n; std::vector<u8> masks; std::vector<u8> wt;
  u32 slot[64];
  void reset(const u8* data, size_t len, const std::vector<u8>& m) { table.assign((size_t)2 << TBITS, 0); d = data; n = len; masks = m; }
  u8 prev(size_t i, int j) const { return i > (size_t)j ? d[i - 1 - j] : 0; }
  // counts for the next bit of byte i with partial byte c0; fills slot[]
  void predict(size_t i, u32 c0, u32& n0, u32& n1, const u8* hist) {
    n0 = n1 = 0;
    for (size_t k = 0; k < masks.size(); ++k) {
      u32 h = masks[k]; u8 m = masks[k];
      for (int j = 0; j < 8; ++j) if (m >> j & 1) h = _mm_crc32_u8(h, hist ? (i > (size_t)j ? hist[i - 1 - j] : 0) : prev(i, j));
      h = _mm_crc32_u8(h, (u8)c0) & TMASK; slot[k] = h;
      u32 a = table[2 * h], b = table[2 * h + 1];
      if (a == 0 || b == 0) { a <<= BOOST_SHIFT; b <<= BOOST_SHIFT; }
      int w = k < wt.size() ? wt[k] : 0;
      n0 += a << w; n1 += b << w;
    }
  }
  void update(int y) {
    for (size_t k = 0; k < masks.size(); ++k) {
      u8* c = &table[2 * slot[k]];
      if (c[y] < LIMIT) ++c[y];
      if (c[!y] > 1) c[!y] = HALVE == 1 ? c[!y] >> 1 : (c[!y] + 1) >> 1;
    }
  }
};

// cost in bits (no coding), for the search
static std::vector<u8> g_wt;
static double cost(const u8* d, size_t n, const std::vector<u8>& masks) {
  static Coder c; c.reset(d, n, masks); c.wt = g_wt; double bits = 0;
  static double lg[1 << 16]; static bool init = false;
  if (!init) { for (int i = 1; i < 1 << 16; ++i) lg[i] = __builtin_log2((double)i); init = true; }
  for (size_t i = 0; i < n; ++i) { u32 c0 = 1;
    for (int b = 7; b >= 0; --b) { int y = d[i] >> b & 1; u32 n0, n1; c.predict(i, c0, n0, n1, nullptr);
      bits += lg[n0 + n1 + 2] - lg[(y ? n1 : n0) + 1]; c.update(y); c0 = c0 << 1 | y; } }
  return bits;
}

// Read IN; choose the masks; code; check by decoding; write OUT.cm and OUT.inc.
int main(int argc, char** argv) {
  if (argc < 4) { fprintf(stderr, "usage: s0pack IN OUT.cm OUT.inc [MAXMODELS]\n"); return 2; }
  FILE* f = fopen(argv[1], "rb"); if (!f) { perror(argv[1]); return 2; }
  std::vector<u8> d; int ch; while ((ch = fgetc(f)) != EOF) d.push_back((u8)ch); fclose(f);
  size_t n = d.size(); int maxm = argc > 4 ? atoi(argv[4]) : 24;
  if (getenv("S0_BOOST")) BOOST_SHIFT = atoi(getenv("S0_BOOST")); if (getenv("S0_LIMIT")) LIMIT = atoi(getenv("S0_LIMIT")); if (getenv("S0_HALVE")) HALVE = atoi(getenv("S0_HALVE"));

  // Greedy model search. Repeat: add the mask (of the 256 possible) that lowers the cost most,
  // if it saves more than the byte it costs in stage 0; when none does, drop the mask whose
  // removal costs less than a byte; stop when neither applies.
  std::vector<u8> masks; double best = 1e30;
  for (;;) {
    int bm = -1; double bc = best;
    if ((int)masks.size() < maxm)
      for (int m = 0; m < 256; ++m) {
        bool have = false; for (u8 x : masks) have |= x == m; if (have) continue;
        std::vector<u8> t = masks; t.push_back((u8)m); double c = cost(d.data(), n, t);
        if (c < bc - 8) { bc = c; bm = m; }      // a mask costs one byte in the decoder
      }
    if (bm >= 0) { masks.push_back((u8)bm); best = bc; fprintf(stderr, "add %02x -> %.0f bytes (%zu models)\n", bm, best / 8, masks.size()); continue; }
    // try dropping
    int bd = -1; bc = best;
    for (size_t k = 0; k < masks.size() && masks.size() > 1; ++k) {
      std::vector<u8> t = masks; t.erase(t.begin() + k); double c = cost(d.data(), n, t);
      if (c < bc + 8) { bc = c - 8; bd = (int)k; }
    }
    if (bd < 0) break;
    fprintf(stderr, "drop %02x\n", masks[bd]); masks.erase(masks.begin() + bd); best = cost(d.data(), n, masks);
  }

  if (getenv("S0_WEIGHTS")) {     // experiment: per-model weight shifts 0..3 by coordinate descent
    g_wt.assign(masks.size(), 0); bool ch = true;
    while (ch) { ch = false;
      for (size_t k = 0; k < masks.size(); ++k) for (int w = 0; w < 4; ++w) { u8 old = g_wt[k]; if (w == old) continue; g_wt[k] = w;
        double c = cost(d.data(), n, masks); if (c < best - 1) { best = c; ch = true; } else g_wt[k] = old; } }
    fprintf(stderr, "weights:"); for (u8 w : g_wt) fprintf(stderr, " %d", w); fprintf(stderr, " -> %.0f bytes\n", best / 8);
  }
  // encode
  Coder c; c.reset(d.data(), n, masks); c.wt = g_wt;
  std::vector<u8> out; u32 x1 = 0, x2 = 0xffffffff;
  for (size_t i = 0; i < n; ++i) { u32 c0 = 1;
    for (int b = 7; b >= 0; --b) {
      int y = d[i] >> b & 1; u32 n0, n1; c.predict(i, c0, n0, n1, nullptr);
      u32 xm = x1 + (u32)((u64)(x2 - x1) * (n1 + 1) / (n0 + n1 + 2));
      if (y) x2 = xm; else x1 = xm + 1;
      while (((x1 ^ x2) & 0xff000000) == 0) { out.push_back(x2 >> 24); x1 <<= 8; x2 = x2 << 8 | 255; }
      c.update(y); c0 = c0 << 1 | y;
    } }
  out.push_back(x1 >> 24); out.push_back(x1 >> 16); out.push_back(x1 >> 8); out.push_back(x1);

  // decode check (mirrors stage0.S)
  { Coder q; std::vector<u8> o(n, 0); q.reset(o.data(), n, masks); q.wt = g_wt;
    size_t ip = 0; u32 a1 = 0, a2 = 0xffffffff, x = 0;
    auto get = [&]() -> u32 { return ip < out.size() ? out[ip++] : 0; };
    for (int k = 0; k < 4; ++k) x = x << 8 | get();
    for (size_t i = 0; i < n; ++i) { u32 c0 = 1;
      for (int b = 0; b < 8; ++b) {
        u32 n0, n1; q.predict(i, c0, n0, n1, o.data());
        u32 xm = a1 + (u32)((u64)(a2 - a1) * (n1 + 1) / (n0 + n1 + 2)); int y = x <= xm;
        if (y) a2 = xm; else a1 = xm + 1;
        while (((a1 ^ a2) & 0xff000000) == 0) { a1 <<= 8; a2 = a2 << 8 | 255; x = x << 8 | get(); }
        q.update(y); c0 = c0 << 1 | y;
      }
      o[i] = (u8)c0; }
    if (memcmp(o.data(), d.data(), n)) { fprintf(stderr, "s0pack: decode check FAILED\n"); return 1; } }

  // stage0.S implements the default count limit, halving rule and unit weights only (S0_BOOST is
  // passed on through OUT.inc). A stream made with the other experiment knobs would not decode
  // in the real stub, so nothing is written for it.
  if (LIMIT != 255 || HALVE != 1 || !g_wt.empty()) {
    printf("s0pack: %zu -> %zu bytes, %zu models (experiment settings: no output written)\n", n, out.size(), masks.size());
    return 3;
  }
  f = fopen(argv[2], "wb"); fwrite(out.data(), 1, out.size(), f); fclose(f);
  f = fopen(argv[3], "w");
  fprintf(f, "/* written by s0pack: constants for stage0.S */\n#define S1_LEN %zu\n#define S0_NM %zu\n#define S0_TBITS %d\n#define S0_BOOST %d\n#define S0_MASKS ", n, masks.size(), (int)TBITS, (int)BOOST_SHIFT);
  for (size_t k = 0; k < masks.size(); ++k) fprintf(f, "%s0x%02x", k ? "," : "", masks[k]);
  fprintf(f, "\n"); fclose(f);
  printf("s0pack: %zu -> %zu bytes, %zu models\n", n, out.size(), masks.size());
  return 0;
}
