// pk: experimental context-mixing packer model for the cmix ELF binary.
// Model-development tool (step 1 of the custom packer): measures how small an
// x86-64-aware bitwise CM model can make the binary. Integer-only predictor so
// a small freestanding decoder stub can reproduce it exactly.
//
//   pk e CONFIG IN            estimate size (also real size via the coder)
//   pk c CONFIG IN OUT        compress
//   pk d CONFIG IN OUT        decompress
//
// CONFIG lines:
//   text LO HI                file range of .text (x86 parser + address transform on)
//   ctx ATOM,ATOM,...         one hashed context (see atom())
//   set NAME VALUE            numeric parameter
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <cmath>
#include <string>
#include <vector>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef uint64_t u64;

// ---------------------------------------------------------------- parameters
struct Params {
  int tbits = 21;      // log2 slots per context table
  int limA = 255;      // adaptive counter limit
  int rateB = 4;       // fast counter shift
  int useB = 1;        // feed the fast counter to the mixer
  int lr1 = 6, lr2 = 3;      // mixer learning rates (higher = slower)
  int mm1 = 5, mm2 = 0;      // match model minimum lengths (0 = off)
  int apm = 1;
  int xform = 1;       // address transform on
  int sel = 0x3f;      // bit mask of layer-1 selector sets in use
  int apr = 7;         // apm rate
  int conf = 1;        // confidence input
  int hist = 5;        // bits of per-slot bit history fed through an adaptive map (0 = off)
  int hrate = 6;
} P;

// ---------------------------------------------------------------- squash/stretch
static int squash(int d) {
  if (d > 2047) return 4095;
  if (d < -2047) return 0;
  static const int t[33] = {1, 2, 3, 6, 10, 16, 27, 45, 73, 120, 194, 310, 488, 747, 1101, 1546, 2047, 2549,
                            2994, 3348, 3607, 3785, 3901, 3975, 4024, 4050, 4068, 4079, 4085, 4089, 4092, 4093, 4094};
  int w = d & 127; d = (d >> 7) + 16;
  return (t[d] * (128 - w) + t[d + 1] * w + 64) >> 7;
}
static short stretch_t[4096];
static void init_stretch() {
  int pi = 0;
  for (int x = -2047; x <= 2047; ++x) { int v = squash(x); for (int i = pi; i <= v; ++i) stretch_t[i] = x; pi = v + 1; }
  for (int i = pi; i < 4096; ++i) stretch_t[i] = 2047;
}
static inline int stretch(int p) { return stretch_t[p]; }

// ---------------------------------------------------------------- x86-64 parser
// Field types of the NEXT byte.
enum { F_START, F_OP2, F_OP3, F_VEX1, F_VEX2, F_VEXOP, F_MODRM, F_SIB, F_DISP, F_IMM, F_NONE };
// opcode flags: bit0 modrm, bits1-4 imm kind
enum { I_NONE, I_8, I_Z, I_16, I_REL32, I_V, I_MOFFS, I_ENTER, I_GRP3B, I_GRP3Z, I_PFX, I_ESC, I_REX, I_VEX3, I_VEX2 };
static u8 optab[2][256];
static void setr(int map, int lo, int hi, int modrm, int imm) { for (int i = lo; i <= hi; ++i) optab[map][i] = modrm | imm << 1; }
static void init_optab() {
  for (int b = 0; b < 0x40; b += 8) { setr(0, b, b + 3, 1, I_NONE); setr(0, b + 4, b + 4, 0, I_8); setr(0, b + 5, b + 5, 0, I_Z); setr(0, b + 6, b + 7, 0, I_NONE); }
  setr(0, 0x26, 0x26, 0, I_PFX); setr(0, 0x2e, 0x2e, 0, I_PFX); setr(0, 0x36, 0x36, 0, I_PFX); setr(0, 0x3e, 0x3e, 0, I_PFX);
  setr(0, 0x0f, 0x0f, 0, I_ESC);
  setr(0, 0x40, 0x4f, 0, I_REX); setr(0, 0x50, 0x62, 0, I_NONE); setr(0, 0x63, 0x63, 1, I_NONE);
  setr(0, 0x64, 0x67, 0, I_PFX); setr(0, 0x68, 0x68, 0, I_Z); setr(0, 0x69, 0x69, 1, I_Z); setr(0, 0x6a, 0x6a, 0, I_8);
  setr(0, 0x6b, 0x6b, 1, I_8); setr(0, 0x6c, 0x6f, 0, I_NONE); setr(0, 0x70, 0x7f, 0, I_8);
  setr(0, 0x80, 0x80, 1, I_8); setr(0, 0x81, 0x81, 1, I_Z); setr(0, 0x82, 0x82, 1, I_8); setr(0, 0x83, 0x83, 1, I_8);
  setr(0, 0x84, 0x8f, 1, I_NONE); setr(0, 0x90, 0x9f, 0, I_NONE); setr(0, 0xa0, 0xa3, 0, I_MOFFS);
  setr(0, 0xa4, 0xa7, 0, I_NONE); setr(0, 0xa8, 0xa8, 0, I_8); setr(0, 0xa9, 0xa9, 0, I_Z); setr(0, 0xaa, 0xaf, 0, I_NONE);
  setr(0, 0xb0, 0xb7, 0, I_8); setr(0, 0xb8, 0xbf, 0, I_V); setr(0, 0xc0, 0xc1, 1, I_8); setr(0, 0xc2, 0xc2, 0, I_16);
  setr(0, 0xc3, 0xc3, 0, I_NONE); setr(0, 0xc4, 0xc4, 0, I_VEX3); setr(0, 0xc5, 0xc5, 0, I_VEX2);
  setr(0, 0xc6, 0xc6, 1, I_8); setr(0, 0xc7, 0xc7, 1, I_Z); setr(0, 0xc8, 0xc8, 0, I_ENTER); setr(0, 0xc9, 0xc9, 0, I_NONE);
  setr(0, 0xca, 0xca, 0, I_16); setr(0, 0xcb, 0xcc, 0, I_NONE); setr(0, 0xcd, 0xcd, 0, I_8); setr(0, 0xce, 0xcf, 0, I_NONE);
  setr(0, 0xd0, 0xd3, 1, I_NONE); setr(0, 0xd4, 0xd7, 0, I_NONE); setr(0, 0xd8, 0xdf, 1, I_NONE);
  setr(0, 0xe0, 0xe7, 0, I_8); setr(0, 0xe8, 0xe9, 0, I_REL32); setr(0, 0xea, 0xea, 0, I_NONE); setr(0, 0xeb, 0xeb, 0, I_8);
  setr(0, 0xec, 0xef, 0, I_NONE); setr(0, 0xf0, 0xf0, 0, I_PFX); setr(0, 0xf1, 0xf1, 0, I_NONE); setr(0, 0xf2, 0xf3, 0, I_PFX);
  setr(0, 0xf4, 0xf5, 0, I_NONE); setr(0, 0xf6, 0xf6, 1, I_GRP3B); setr(0, 0xf7, 0xf7, 1, I_GRP3Z);
  setr(0, 0xf8, 0xfd, 0, I_NONE); setr(0, 0xfe, 0xff, 1, I_NONE);
  // 0F map
  setr(1, 0x00, 0xff, 1, I_NONE);
  setr(1, 0x05, 0x0b, 0, I_NONE); setr(1, 0x0e, 0x0e, 0, I_NONE); setr(1, 0x0f, 0x0f, 1, I_8);
  setr(1, 0x30, 0x37, 0, I_NONE); setr(1, 0x70, 0x73, 1, I_8); setr(1, 0x77, 0x77, 0, I_NONE);
  setr(1, 0x80, 0x8f, 0, I_REL32); setr(1, 0xa0, 0xa2, 0, I_NONE); setr(1, 0xa4, 0xa4, 1, I_8);
  setr(1, 0xa8, 0xaa, 0, I_NONE); setr(1, 0xac, 0xac, 1, I_8); setr(1, 0xba, 0xba, 1, I_8);
  setr(1, 0xc2, 0xc2, 1, I_8); setr(1, 0xc4, 0xc6, 1, I_8); setr(1, 0xc8, 0xcf, 0, I_NONE);
}

struct X86 {
  int st = F_START, k = 0, rem = 0;
  u32 op = 0;          // (map << 8 | opcode) + 1, 0 = not known yet
  u32 pfx = 0;         // hash of prefix bytes of the current instruction
  int p66 = 0, rexw = 0, map = 0;
  int modrm = -1, sib = -1;
  int dispn = 0, immn = 0, immkind = 0;
  int riprel = 0, rel32 = 0;   // current field is a rip-relative disp / rel32 immediate
  u32 fv = 0;          // bytes of the current disp/imm field so far
  u32 hist[4] = {0, 0, 0, 0}, mhist[2] = {0, 0};   // previous opcodes / modrms
  int ilen = 0;        // bytes of the current instruction so far
  u32 lastfield = 0;   // value of the last complete 4-byte disp/imm (for the transform)
  int fielddone = 0;   // 1: riprel disp just completed, 2: rel32 just completed
  int after = 0;       // bytes of this instruction that follow the completed field

  void end() {
    hist[3] = hist[2]; hist[2] = hist[1]; hist[1] = hist[0]; hist[0] = op * 4 + (p66 ? 1 : 0) + (rexw ? 2 : 0);
    mhist[1] = mhist[0]; mhist[0] = modrm + 1;
    st = F_START; k = 0; op = 0; pfx = 0; p66 = rexw = map = 0; modrm = sib = -1; dispn = immn = 0; ilen = 0; fv = 0;
    riprel = rel32 = 0;
  }
  void after_opcode(int c) {
    op = (map << 8 | c) + 1;
    int f = optab[map == 0 ? 0 : 1][c];
    if (map == 2) f = 1; else if (map == 3) f = 1 | I_8 << 1;
    immkind = f >> 1; immn = 0;
    switch (immkind) {
      case I_8: immn = 1; break;
      case I_Z: immn = p66 ? 2 : 4; break;
      case I_16: immn = 2; break;
      case I_REL32: immn = 4; break;
      case I_V: immn = rexw ? 8 : (p66 ? 2 : 4); break;
      case I_MOFFS: immn = 8; break;
      case I_ENTER: immn = 3; break;
    }
    if (f & 1) st = F_MODRM; else start_imm();
  }
  void start_imm() {
    if (immn > 0) { st = F_IMM; k = 0; rem = immn; fv = 0; rel32 = immkind == I_REL32; riprel = 0; } else end();
  }
  void start_disp() {
    if (dispn > 0) { st = F_DISP; k = 0; rem = dispn; fv = 0; rel32 = 0; } else start_imm();
  }
  void feed(int c) {
    fielddone = 0; ++ilen;
    switch (st) {
      case F_START: {
        int f = optab[0][c] >> 1;
        if (f == I_PFX) { pfx = pfx * 31 + c; if (c == 0x66) p66 = 1; if (ilen > 8) end(); }
        else if (f == I_REX) { pfx = pfx * 31 + c; rexw = (c >> 3) & 1; }
        else if (f == I_ESC) { st = F_OP2; }
        else if (f == I_VEX3) { st = F_VEX1; }
        else if (f == I_VEX2) { st = F_VEX2; map = 1; }
        else after_opcode(c);
        break; }
      case F_OP2:
        if (c == 0x38) { map = 2; st = F_OP3; } else if (c == 0x3a) { map = 3; st = F_OP3; } else { map = 1; after_opcode(c); }
        break;
      case F_OP3: after_opcode(c); break;
      case F_VEX1: map = c & 3; if (map == 0) map = 1; pfx = pfx * 31 + (c & 0xe0); st = F_VEX2; break;
      case F_VEX2: pfx = pfx * 31 + (c & 0x87) + 256; st = F_VEXOP; break;
      case F_VEXOP: after_opcode(c); break;
      case F_MODRM: {
        modrm = c; int mod = c >> 6, rm = c & 7;
        if (immkind == I_GRP3B) immn = (c & 0x30) == 0 ? 1 : 0;
        if (immkind == I_GRP3Z) immn = (c & 0x30) == 0 ? (p66 ? 2 : 4) : 0;
        dispn = 0; riprel = 0;
        if (mod == 1) dispn = 1; else if (mod == 2) dispn = 4; else if (mod == 0 && rm == 5) { dispn = 4; riprel = 1; }
        if (mod != 3 && rm == 4) st = F_SIB; else start_disp();
        break; }
      case F_SIB:
        sib = c; if ((modrm >> 6) == 0 && (c & 7) == 5) dispn = 4;
        start_disp(); break;
      case F_DISP:
        fv = fv << 8 | c; ++k;
        if (--rem == 0) { if (riprel) { fielddone = 1; lastfield = fv; after = immn; } start_imm(); }
        break;
      case F_IMM:
        fv = fv << 8 | c; ++k;
        if (--rem == 0) { if (rel32) { fielddone = 2; lastfield = fv; after = 0; } end(); }
        break;
    }
  }
};

// Address transform over [lo, hi): rip-relative disp32 and rel32 -> absolute, big-endian.
static void xform(std::vector<u8>& d, size_t lo, size_t hi, bool fwd) {
  X86 x;
  for (size_t i = lo; i < hi && i < d.size(); ++i) {
    x.feed(d[i]);
    if (x.fielddone && i >= lo + 3) {
      u32 base = (u32)(i + 1 + x.after);
      if (fwd) { u32 v = d[i - 3] | d[i - 2] << 8 | d[i - 1] << 16 | (u32)d[i] << 24; v += base;
                 d[i - 3] = v >> 24; d[i - 2] = v >> 16; d[i - 1] = v >> 8; d[i] = v; }
      else { u32 v = (u32)d[i - 3] << 24 | d[i - 2] << 16 | d[i - 1] << 8 | d[i]; v -= base;
             d[i - 3] = v; d[i - 2] = v >> 8; d[i - 1] = v >> 16; d[i] = v >> 24; }
    }
  }
}

// ---------------------------------------------------------------- model
struct Slot { u16 a, b; u8 n, chk, h, pad; };
static int rec_t[256];

struct Ctx { std::vector<int> atoms; std::vector<Slot> t; u32 h = 0; Slot* s = nullptr; u16 sm[1024]; int smi = 0; };
static std::vector<Ctx> ctxs;
static std::vector<std::string> atom_names;
static size_t text_lo = 0, text_hi = 0;

struct Apm {
  std::vector<u16> t; int idx = 0;
  void init(int n) { t.resize(n * 33); for (int i = 0; i < n; ++i) for (int j = 0; j < 33; ++j) t[i * 33 + j] = squash((j - 16) * 128) * 16; }
  int pp(int pr, int cx) {
    int s = stretch(pr) + 2048; int lo = s >> 7, w = s & 127; idx = cx * 33 + lo + (w >> 6);
    return (t[cx * 33 + lo] * (128 - w) + t[cx * 33 + lo + 1] * w) >> 11;
  }
  void update(int y) { int g = (y << 16) + (y << P.apr) - y - y; t[idx] += (g - t[idx]) >> P.apr; }
};

struct Model {
  std::vector<u8> buf;         // history (transformed bytes)
  size_t pos = 0;              // bytes so far
  int c0 = 1, bpos = 0;
  X86 x;
  // match models
  struct MM { int minlen = 0; std::vector<u32> ht; u32 ptr = 0; int len = 0; int exp = -1; u16 sm[64][2]; int si = 0; u16 sm2[256 * 2]; } mm[2];
  // mixer
  enum { MAXIN = 160, NSEL = 6 };
  int in[MAXIN], nin = 0;
  std::vector<int> w1[NSEL]; int sel[NSEL], p1[NSEL], nsel_size[NSEL];
  std::vector<int> w2; int sel2 = 0, in2[NSEL + 1];
  Apm a1, a2, a3; int pr = 2048, pmix = 2048;
  std::vector<u32> atomv;

  void init(size_t n) {
    buf.assign(n + 8, 0);
    for (int i = 0; i < 2; ++i) {
      mm[i].minlen = i == 0 ? P.mm1 : P.mm2; mm[i].ht.assign(1 << 20, 0);
      for (int j = 0; j < 64; ++j) mm[i].sm[j][0] = mm[i].sm[j][1] = 32768;
    }
    int sizes[NSEL] = {256, 256 * 12, 256, 2048, 1024, 4096};
    for (int i = 0; i < NSEL; ++i) { nsel_size[i] = sizes[i]; w1[i].assign(sizes[i] * MAXIN, 1 << 14); sel[i] = 0; }
    w2.assign(256 * (NSEL + 1), 65536 / 4);
    a1.init(256 * 12); a2.init(65536); a3.init(65536);
    for (auto& c : ctxs) { c.t.assign((size_t)1 << P.tbits, Slot{32768, 32768, 0, 0, 1, 0}); c.s = &c.t[0]; for (auto& v : c.sm) v = 32768; }
    byte_update();
  }
  u8 B(int i) const { return pos >= (size_t)i ? buf[pos - i] : 0; }
  bool intext() const { return pos >= text_lo && pos < text_hi; }

  u32 atom(int a) {
    switch (a) {
      case 0: return B(1); case 1: return B(2); case 2: return B(3); case 3: return B(4);
      case 4: return B(5); case 5: return B(6); case 6: return B(7); case 7: return B(8);
      case 8: return x.st * 16 + (x.k < 15 ? x.k : 15);                 // F: field type + index
      case 9: return x.op;                                              // O
      case 10: return x.modrm + 1;                                      // M
      case 11: return x.hist[0];                                        // P1
      case 12: return x.hist[1];                                        // P2
      case 13: return x.hist[2];                                        // P3
      case 14: return x.pfx;                                            // X
      case 15: return x.fv + (x.k << 28);                               // I: field bytes so far
      case 16: return x.mhist[0];                                       // R: previous modrm
      case 17: return x.sib + 1;                                        // S
      case 18: return (u32)(pos & 3);                                   // q4
      case 19: return (u32)(pos & 7);                                   // q8
      case 20: return (u32)(pos % 24);                                  // q24
      case 21: return intext();                                         // T
      case 22: return mm[0].exp + 1;                                    // E: byte predicted by match model 1
      case 23: return mm[0].len < 32 ? mm[0].len : 32;                  // L
      case 24: return x.modrm < 0 ? 0 : (x.modrm >> 6) + 1;             // Mm: mod
      case 25: return x.modrm < 0 ? 0 : (x.modrm & 7) + 1;              // Mr: rm
      case 26: return x.modrm < 0 ? 0 : ((x.modrm >> 3) & 7) + 1;       // Mg: reg
      case 27: return x.ilen;                                           // N: bytes into the instruction
      case 28: return (u32)(pos >> 12);                                 // pg: page
      case 29: return x.hist[3];                                        // P4
      case 30: return x.mhist[1];                                       // R2
      case 31: return B(1) >> 4;                                        // b1h
      case 32: return B(2) >> 4;                                        // b2h
      case 33: return mm[1].exp + 1;                                    // E2
      case 34: return x.rexw * 2 + x.p66;                               // W
      case 35: return x.immn * 8 + x.dispn;                             // Z: pending field sizes
      case 36: return (u32)(pos % 16);                                  // q16
      case 37: return B(9); case 38: return B(10); case 39: return B(11); case 40: return B(12);
      case 41: return B(16); case 42: return B(24); case 43: return B(13); case 44: return B(17);
      case 45: return x.riprel * 2 + x.rel32;                           // K: address field kind
      case 46: return (x.hist[0] >> 2) & 0xff;                          // p1o: previous opcode byte only
    }
    return 0;
  }
  void byte_update() {
    atomv.resize(64);
    for (int a = 0; a < 47; ++a) atomv[a] = atom(a);
    for (auto& c : ctxs) {
      u32 h = 0x811c9dc5u + (u32)(&c - &ctxs[0]) * 0x01000193u;
      for (int a : c.atoms) { h = (h ^ atomv[a]) * 0x2f0b4d67u; h ^= h >> 15; h += a * 0x9e3779b1u; }
      c.h = h;
    }
  }
  Slot* find(Ctx& c) {
    u32 xh = (c.h ^ (u32)c0 * 0x9e3779b1u) * 0x85ebca6bu; xh ^= xh >> 13; xh *= 0xc2b2ae35u;
    Slot* s = &c.t[xh >> (32 - P.tbits)]; u8 chk = (xh >> 3) & 255;
    if (s->chk != chk) { s->a = s->b = 32768; s->n = 0; s->chk = chk; s->h = 1; }
    return s;
  }
  void mm_predict(MM& m) {
    m.exp = -1; m.si = -1;
    if (m.minlen == 0) return;
    if (m.len > 0 && m.ptr < pos) {
      int eb = buf[m.ptr] | 256; // expected byte with leading 1
      if ((eb >> (8 - bpos)) == c0) {
        m.exp = buf[m.ptr];
        int bit = (eb >> (7 - bpos)) & 1; int l = m.len < 32 ? m.len : 31 + (m.len >= 64) ; if (l > 32) l = 32;
        m.si = l; int p = m.sm[l][0] >> 4; int st = stretch(p);
        in[nin++] = bit ? st : -st;
        in[nin++] = bit ? (m.len < 16 ? m.len * 32 : 512 + (m.len > 400 ? 400 : m.len)) : -(m.len < 16 ? m.len * 32 : 512 + (m.len > 400 ? 400 : m.len));
        m.sm[0][1] = bit;
        return;
      }
      m.len = 0;
    }
    in[nin++] = 0; in[nin++] = 0;
  }
  void mm_update(MM& m, int y) {
    if (m.minlen == 0) return;
    if (m.si >= 0) { int ok = (y == m.sm[0][1]); u16& p = m.sm[m.si][0]; p += ((ok << 16) - ok - p) >> 6; }
  }
  void mm_byte(MM& m) {
    if (m.minlen == 0) return;
    if (m.len > 0 && m.ptr < pos && buf[m.ptr] == buf[pos - 1]) { ++m.len; ++m.ptr; } else m.len = 0;
    if (pos >= (size_t)m.minlen) {
      u32 h = 0; for (int i = 1; i <= m.minlen; ++i) h = (h + buf[pos - i] + 1) * 0x2f0b4d67u;
      h >>= 12;
      if (m.len == 0) { m.ptr = m.ht[h]; if (m.ptr > 0) { int l = 0; while (l < 65535 && (size_t)l < m.ptr && buf[m.ptr - 1 - l] == buf[pos - 1 - l]) ++l; m.len = l; if (l < m.minlen) m.len = 0; } }
      m.ht[h] = (u32)pos;
    }
  }
  int predict() {
    nin = 0;
    for (auto& c : ctxs) {
      Slot* s = c.s = find(c);
      if (P.hist) { c.smi = s->h + 256 * (s->n < 2 ? s->n : (s->n < 6 ? 2 : 3)); in[nin++] = s->n ? stretch(c.sm[c.smi] >> 4) : 0; }
      if (s->n == 0) { in[nin++] = 0; if (P.useB) in[nin++] = 0; if (P.conf) in[nin++] = 0; }
      else {
        int sa = stretch(s->a >> 4);
        in[nin++] = sa; if (P.useB) in[nin++] = stretch(s->b >> 4);
        if (P.conf) { int cf = s->n < 3 ? 0 : (s->n < 8 ? 1 : (s->n < 32 ? 2 : 3)); in[nin++] = (sa * cf) >> 1; }
      }
    }
    mm_predict(mm[0]); mm_predict(mm[1]);
    in[nin++] = 256;
    // selectors
    int fld = x.st * 4 + (x.k < 3 ? x.k : 3);
    int ml = mm[0].len == 0 ? 0 : (mm[0].len < 8 ? 1 : (mm[0].len < 16 ? 2 : (mm[0].len < 32 ? 3 : 4)));
    sel[0] = c0;
    sel[1] = bpos + 8 * ((fld < 48 ? fld : 47) + 0) ; if (sel[1] >= 256 * 12) sel[1] = 0;
    sel[2] = B(1);
    sel[3] = (ml * 2 + (mm[0].exp >= 0 ? ((mm[0].exp >> (7 - bpos)) & 1) : 0)) * 8 + bpos + 80 * (intext() ? x.st + 1 : 0);
    sel[4] = (x.op & 1023);
    sel[5] = ((x.modrm + 1) & 0x1ff) * 8 + bpos;
    int ns = 0;
    for (int i = 0; i < NSEL; ++i) {
      if (!(P.sel >> i & 1)) continue;
      int* w = &w1[i][(size_t)(sel[i] % nsel_size[i]) * MAXIN]; long long s = 0;
      for (int j = 0; j < nin; ++j) s += (long long)in[j] * w[j];
      int d = (int)(s >> 16); if (d > 2047) d = 2047; if (d < -2047) d = -2047;
      p1[i] = squash(d); in2[ns++] = d;
    }
    in2[ns++] = 256;
    sel2 = c0;
    { int* w = &w2[sel2 * (NSEL + 1)]; long long s = 0; for (int j = 0; j < ns; ++j) s += (long long)in2[j] * w[j];
      int d = (int)(s >> 16); if (d > 2047) d = 2047; if (d < -2047) d = -2047; pmix = squash(d); }
    pr = pmix;
    if (P.apm) {
      int q1 = a1.pp(pmix, c0 + 256 * (x.st < 11 ? x.st : 11));
      int q2 = a2.pp(pmix, (c0 | B(1) << 8) & 0xffff);
      int q3 = a3.pp(pmix, ((c0 * 0x9e3779b1u) ^ (x.op * 0x2f0b4d67u) ^ ((x.modrm + 1) * 0x85ebca6bu) ^ (x.st * 0x1234567u + x.k * 77777u)) >> 16);
      pr = (2 * pmix + q1 + q2 + 2 * q3 + 3) / 6;
    }
    if (pr < 1) pr = 1; if (pr > 4094) pr = 4094;
    return pr;
  }
  void update(int y) {
    for (auto& c : ctxs) {
      Slot* s = c.s; int t = y ? 65535 : 0;
      s->a += ((t - s->a) * rec_t[s->n]) >> 16; if (s->n < P.limA) ++s->n;
      s->b += (t - s->b) >> P.rateB;
      if (P.hist) { c.sm[c.smi] += (t - c.sm[c.smi]) >> P.hrate; int h = s->h << 1 | y; if (h >> P.hist > 1) h = (h & ((1 << P.hist) - 1)) | 1 << P.hist; s->h = h; }
    }
    mm_update(mm[0], y); mm_update(mm[1], y);
    int ns = 0;
    for (int i = 0; i < NSEL; ++i) {
      if (!(P.sel >> i & 1)) continue;
      int err = ((y << 12) - p1[i]); int* w = &w1[i][(size_t)(sel[i] % nsel_size[i]) * MAXIN];
      for (int j = 0; j < nin; ++j) w[j] += (in[j] * err) >> P.lr1 << 0;
      ++ns;
    }
    { int err = ((y << 12) - pmix); int* w = &w2[sel2 * (NSEL + 1)]; for (int j = 0; j <= ns; ++j) w[j] += (in2[j] * err) >> P.lr2; }
    if (P.apm) { a1.update(y); a2.update(y); a3.update(y); }
    c0 = c0 << 1 | y; ++bpos;
    if (bpos == 8) {
      buf[pos++] = (u8)c0; bpos = 0; int c = c0 & 255; c0 = 1;
      if (pos - 1 >= text_lo && pos - 1 < text_hi) x.feed(c); else if (x.st != F_START || x.op) { x = X86(); }
      mm_byte(mm[0]); mm_byte(mm[1]);
      byte_update();
    }
  }
};

// ---------------------------------------------------------------- coder
struct Enc { u32 x1 = 0, x2 = 0xffffffff; std::vector<u8>* out;
  void code(int y, int p) { u32 xm = x1 + (u32)(((u64)(x2 - x1) * (u32)p) >> 12); y ? x2 = xm : x1 = xm + 1;
    while (((x1 ^ x2) & 0xff000000) == 0) { out->push_back(x2 >> 24); x1 <<= 8; x2 = x2 << 8 | 255; } }
  void flush() { out->push_back(x1 >> 24); out->push_back(x1 >> 16); out->push_back(x1 >> 8); out->push_back(x1); } };
struct Dec { u32 x1 = 0, x2 = 0xffffffff, x = 0; const u8* in; size_t n, i = 0;
  int get() { return i < n ? in[i++] : 0; }
  void init() { for (int k = 0; k < 4; ++k) x = x << 8 | get(); }
  int code(int p) { u32 xm = x1 + (u32)(((u64)(x2 - x1) * (u32)p) >> 12); int y = x <= xm; y ? x2 = xm : x1 = xm + 1;
    while (((x1 ^ x2) & 0xff000000) == 0) { x1 <<= 8; x2 = x2 << 8 | 255; x = x << 8 | get(); } return y; } };

static const char* ATOMS[] = {"b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "F", "O", "M", "P1", "P2", "P3", "X", "I", "R", "S",
  "q4", "q8", "q24", "T", "E", "L", "Mm", "Mr", "Mg", "N", "pg", "P4", "R2", "b1h", "b2h", "E2", "W", "Z", "q16",
  "b9", "b10", "b11", "b12", "b16", "b24", "b13", "b17", "K", "p1o"};

static void load_config(const char* fn) {
  FILE* f = fopen(fn, "r"); if (!f) { fprintf(stderr, "no config %s\n", fn); exit(1); }
  char line[1024];
  while (fgets(line, sizeof line, f)) {
    char a[64], b[900]; long long v, v2;
    if (sscanf(line, "text %lld %lld", &v, &v2) == 2) { text_lo = v; text_hi = v2; }
    else if (sscanf(line, "set %63s %lld", a, &v) == 2) {
      std::string s = a;
#define PP(n) if (s == #n) P.n = (int)v;
      PP(tbits) PP(limA) PP(rateB) PP(useB) PP(lr1) PP(lr2) PP(mm1) PP(mm2) PP(apm) PP(xform) PP(sel) PP(apr) PP(conf) PP(hist) PP(hrate)
    } else if (sscanf(line, "ctx %899s", b) == 1) {
      Ctx c; char* t = strtok(b, ",");
      while (t) { int id = -1; for (int i = 0; i < (int)(sizeof ATOMS / sizeof *ATOMS); ++i) if (!strcmp(t, ATOMS[i])) id = i;
        if (id < 0) { fprintf(stderr, "bad atom %s\n", t); exit(1); } c.atoms.push_back(id); t = strtok(nullptr, ","); }
      ctxs.push_back(c);
    }
  }
  fclose(f);
}
static std::vector<u8> rd(const char* fn) { FILE* f = fopen(fn, "rb"); if (!f) { perror(fn); exit(1); } std::vector<u8> d; u8 b[65536]; size_t n;
  while ((n = fread(b, 1, sizeof b, f)) > 0) d.insert(d.end(), b, b + n); fclose(f); return d; }
static void wr(const char* fn, const std::vector<u8>& d) { FILE* f = fopen(fn, "wb"); fwrite(d.data(), 1, d.size(), f); fclose(f); }

int main(int argc, char** argv) {
  if (argc < 4) { fprintf(stderr, "usage: pk e|c|d CONFIG IN [OUT]\n"); return 1; }
  init_stretch(); init_optab(); load_config(argv[2]);
  for (int i = 0; i < 256; ++i) rec_t[i] = 131072 / (2 * i + 3);
  char mode = argv[1][0];
  std::vector<u8> d = rd(argv[3]);
  if (mode == 'd') {
    size_t n = d[0] | d[1] << 8 | d[2] << 16 | (size_t)d[3] << 24;
    Model m; m.init(n); Dec dc; dc.in = d.data() + 4; dc.n = d.size() - 4; dc.init();
    for (size_t i = 0; i < n * 8; ++i) m.update(dc.code(m.predict()));
    std::vector<u8> o(m.buf.begin(), m.buf.begin() + n);
    if (P.xform) xform(o, text_lo, text_hi, false);
    wr(argv[4], o); return 0;
  }
  std::vector<u8> t = d; if (P.xform) xform(t, text_lo, text_hi, true);
  { std::vector<u8> chk = t; if (P.xform) xform(chk, text_lo, text_hi, false); if (chk != d) { fprintf(stderr, "transform not invertible\n"); return 1; } }
  Model m; m.init(t.size());
  std::vector<u8> out; size_t n = t.size(); out.push_back(n); out.push_back(n >> 8); out.push_back(n >> 16); out.push_back(n >> 24);
  Enc e; e.out = &out; double bits = 0, tb = 0, ob = 0;
  for (size_t i = 0; i < n; ++i) for (int b = 7; b >= 0; --b) {
    int y = (t[i] >> b) & 1, p = m.predict();
    double c = -log2((y ? p : 4096 - p) / 4096.0); bits += c; (i >= text_lo && i < text_hi ? tb : ob) += c;
    e.code(y, p); m.update(y);
  }
  e.flush();
  printf("%zu -> %zu bytes (est %.0f; text %.0f other %.0f) ctx %zu inputs %d\n", n, out.size(), bits / 8, tb / 8, ob / 8, ctxs.size(), m.nin);
  if (mode == 'c') wr(argv[4], out);
  return 0;
}
