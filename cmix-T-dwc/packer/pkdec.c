// pkdec.c: the decoder of the pk packer ("stage 1" of the unpacking stub). New in this entry
// (the previous winning entry, fx2-cmix-transformer-v1, packed its executable with UPX; see
// the header of pk.cpp for why this packer replaces it).
//
// What it does. It is pk.cpp's model with the decoding half of the coder and nothing else:
// the same predictor, run on the packed stream, gives back the cmix executable. As stage 1 of
// the stub (Linux x86-64, no libc) it decodes the packed image that follows the stub in
// memory, writes the executable to a memfd and executes it with the original arguments
// (cstart, at the end of this file). Stage 0 (stage0.S) is what unpacks and calls this code.
//
// It must stay bit-exact with pk.cpp. Every section below names the part of pk.cpp it
// mirrors; the differences are only in form (C without libc, state in static variables, no
// config file). What is fixed here and read from the config in pk.cpp:
//   - the contexts: cfg[] and NCTX, copied from model.cfg by cfg2c.py;
//   - the "set" values of model.cfg and pk.cpp's defaults for the rest, as constants in the
//     code: tbits 20 (TBITS), limA 255, rateB 8, lr1 11, lr2 12, mm1 4, mm2 2, apr 6, hist 5,
//     hrate 6, all six selector sets, second counter and confidence input on. If model.cfg
//     changes one of them, change it here by hand.
// pack.sh decodes every packed image with this file and compares, so a disagreement with
// pk.cpp or model.cfg fails the build instead of producing a broken executable.
//
// The stub is not compiled from this file at build time. pack.sh assembles stage1.s, the
// compiler's assembly output for this file (regenerated with PACK_STUB_REGEN=1), and checks
// the md5 of this file recorded in stage1.s: after ANY edit here, comments included,
// stage1.s must be regenerated or its md5 line updated.
//
// Testing: with -DTEST it builds as an ordinary program,
//   pkdec IN.pk OUT [x]     (a third argument: decode the decompressor's form, hole left zero)
// which pack.sh runs on every build (stub decoder check, decompressor-form check).
typedef unsigned char u8; typedef unsigned short u16; typedef unsigned int u32; typedef unsigned long long u64;
typedef long long i64;

// TBITS = pk.cpp's tbits; NCTX = number of contexts in cfg[]; NIN = the number of mixer inputs
// this model produces (4 per context, 2 per match model, 1 constant; for reference, not used);
// MAXIN = length of one layer-1 weight row and NSEL = number of selector sets, as in pk.cpp.
#define TBITS 20
#define NCTX 25
#define NIN (NCTX * 4 + 5)
#define MAXIN 160
#define NSEL 6
// Layout constants of the binary being packed, all file offsets:
//   TEXT_LO, TEXT_HI  the code (.text .. end of .fini);
//   HOLE_LO, HOLE_LEN the hole (see pk.cpp): [HOLE_LO, HOLE_LO + HOLE_LEN) inside the code holds
//                     the compress-only functions. It is coded last, so the decompressor's copy of
//                     the file is the same file cut short; that copy decodes everything else and
//                     leaves the hole as zeros. HOLE_LEN 0: no hole.
// The TEST build gets them as -D macros from pack.sh. The stub gets them from the linker
// (ld --defsym PK_...=value): they appear in its assembly as symbols, so the stub's assembly
// source (stage1.s) is the same for every binary and can be kept, and tuned, as assembly.
#ifndef TEXT_LO
extern const char PK_TEXT_LO[], PK_TEXT_HI[], PK_HOLE_LO[], PK_HOLE_LEN[];
#define TEXT_LO ((u32)(unsigned long)PK_TEXT_LO)
#define TEXT_HI ((u32)(unsigned long)PK_TEXT_HI)
#define HOLE_LO ((u32)(unsigned long)PK_HOLE_LO)
#define HOLE_LEN ((u32)(unsigned long)PK_HOLE_LEN)
#endif

// Contexts (mirrors the "ctx" lines of model.cfg as read by pk.cpp load_config). The
// enumerators are the atom numbers of pk.cpp Model::atom(), in the order of its ATOMS[];
// one-letter atom names carry an A prefix here (F -> AF ...). In cfg[] each context is its
// list of atoms ended by 255. cfg2c.py rewrites cfg[] and NCTX from model.cfg.
enum { b1, b2, b3, b4, b5, b6, b7, b8, AF, AO, AM, P1, P2, P3, AX, AI, AR, AS, q4, q8, q24, AT, AE, AL, Mm, Mr, Mg, AN, pg, P4,
       R2, b1h, b2h, E2, AW, AZ, q16, b9, b10, b11, b12, b16, b24, b13, b17, AK, p1o, NATOM };
static const u8 cfg[] = {
  b1, b2, b3, 255, b1, b2, b3, b4, b5, b6, 255, b1, b4, 255, b2, b3, b4, 255, AF, AO, P1, P2, 255, AF, AI, AO, 255,
  AF, AX, AO, 255, AF, b1, b2, 255, q8, b1, 255, AF, AO, P1, P2, P3, P4, 255, AF, AR, Mm, 255, AF, AK, b1h, 255, b8,
  b16, b24, 255, AF, pg, 255, AF, AO, AR, p1o, 255, AF, AX, Mm, 255, AF, AO, P2, R2, 255, b4, b8, b12, 255, AF, AO,
  P1, P2, P3, 255, AF, AO, AM, P1, AX, 255, AF, AO, P2, b1, 255, AF, AI, AK, 255, AF, AO, P1, AW, 255, AF, Mm, b2,
  255, b1, b5, b9, 255 };

// Memory. TEST: calloc. Stub: a bump allocator over one zero-filled anonymous mapping made in
// cstart (nothing is ever freed; the process image is replaced by execveat).
#ifdef TEST
#include <stdio.h>
#include <stdlib.h>
static void* alloc(u64 n) { return calloc(n, 1); }
#else
static u8* arena;
static void* alloc(u64 n) { void* p = arena; arena += (n + 63) & ~63ull; return p; }
#endif

// ------------------------------------------------------------ squash / stretch
// Mirrors pk.cpp squash / stretch. The stretch table is built in unpack() into allocated
// memory instead of a static array. clampd = the ">> 16, limit to +-2047" step of the mixer.
static const short sqt[33] = {1, 2, 3, 6, 10, 16, 27, 45, 73, 120, 194, 310, 488, 747, 1101, 1546, 2047, 2549,
                              2994, 3348, 3607, 3785, 3901, 3975, 4024, 4050, 4068, 4079, 4085, 4089, 4092, 4093, 4094};
static int squash(int d) {
  if (d > 2047) return 4095;
  if (d < -2047) return 0;
  int w = d & 127; d = (d >> 7) + 16;
  return (sqt[d] * (128 - w) + sqt[d + 1] * w + 64) >> 7;
}
static short* stretch_t;
static int clampd(i64 s) { int d = (int)(s >> 16); return d > 2047 ? 2047 : (d < -2047 ? -2047 : d); }

// ------------------------------------------------------------ x86-64 parser
// Mirrors pk.cpp "x86-64 parser" (enums, optab, struct X86 and its methods end, start_imm,
// start_disp, after_opcode, feed -> x_end, x_imm, x_disp, x_opcode, x_feed). See pk.cpp for
// what the states and immediate kinds mean.
enum { F_START, F_OP2, F_OP3, F_VEX1, F_VEX2, F_VEXOP, F_MODRM, F_SIB, F_DISP, F_IMM };
enum { I_NONE, I_8, I_Z, I_16, I_REL32, I_V, I_MOFFS, I_ENTER, I_GRP3B, I_GRP3Z, I_PFX, I_ESC, I_REX, I_VEX3, I_VEX2 };
// The opcode table of pk.cpp init_optab, stored compactly: optab[0..255] = one-byte map,
// optab[256..511] = 0F map. opr lists (lo, hi, value) ranges; init_optab first fills the
// eight arithmetic blocks 00..3F by rule, then applies the ranges in order (later ranges
// overwrite earlier ones, as the setr calls of pk.cpp do).
static u8 optab[512];
#define R(lo, hi, m, i) lo, hi, (m) | (i) << 1
static const u8 opr[] = {   // map 0 ranges, then 0xff marker, then map 1 ranges
  R(0x26, 0x26, 0, I_PFX), R(0x2e, 0x2e, 0, I_PFX), R(0x36, 0x36, 0, I_PFX), R(0x3e, 0x3e, 0, I_PFX), R(0x0f, 0x0f, 0, I_ESC),
  R(0x40, 0x4f, 0, I_REX), R(0x50, 0x62, 0, I_NONE), R(0x63, 0x63, 1, I_NONE), R(0x64, 0x67, 0, I_PFX), R(0x68, 0x68, 0, I_Z),
  R(0x69, 0x69, 1, I_Z), R(0x6a, 0x6a, 0, I_8), R(0x6b, 0x6b, 1, I_8), R(0x6c, 0x6f, 0, I_NONE), R(0x70, 0x7f, 0, I_8),
  R(0x80, 0x80, 1, I_8), R(0x81, 0x81, 1, I_Z), R(0x82, 0x83, 1, I_8), R(0x84, 0x8f, 1, I_NONE), R(0x90, 0x9f, 0, I_NONE),
  R(0xa0, 0xa3, 0, I_MOFFS), R(0xa4, 0xa7, 0, I_NONE), R(0xa8, 0xa8, 0, I_8), R(0xa9, 0xa9, 0, I_Z), R(0xaa, 0xaf, 0, I_NONE),
  R(0xb0, 0xb7, 0, I_8), R(0xb8, 0xbf, 0, I_V), R(0xc0, 0xc1, 1, I_8), R(0xc2, 0xc2, 0, I_16), R(0xc3, 0xc3, 0, I_NONE),
  R(0xc4, 0xc4, 0, I_VEX3), R(0xc5, 0xc5, 0, I_VEX2), R(0xc6, 0xc6, 1, I_8), R(0xc7, 0xc7, 1, I_Z), R(0xc8, 0xc8, 0, I_ENTER),
  R(0xc9, 0xc9, 0, I_NONE), R(0xca, 0xca, 0, I_16), R(0xcb, 0xcc, 0, I_NONE), R(0xcd, 0xcd, 0, I_8), R(0xce, 0xcf, 0, I_NONE),
  R(0xd0, 0xd3, 1, I_NONE), R(0xd4, 0xd7, 0, I_NONE), R(0xd8, 0xdf, 1, I_NONE), R(0xe0, 0xe7, 0, I_8), R(0xe8, 0xe9, 0, I_REL32),
  R(0xea, 0xea, 0, I_NONE), R(0xeb, 0xeb, 0, I_8), R(0xec, 0xef, 0, I_NONE), R(0xf0, 0xf0, 0, I_PFX), R(0xf1, 0xf1, 0, I_NONE),
  R(0xf2, 0xf3, 0, I_PFX), R(0xf4, 0xf5, 0, I_NONE), R(0xf6, 0xf6, 1, I_GRP3B), R(0xf7, 0xf7, 1, I_GRP3Z),
  R(0xf8, 0xfd, 0, I_NONE), R(0xfe, 0xff, 1, I_NONE),
  0xff,
  R(0x00, 0xff, 1, I_NONE), R(0x05, 0x0b, 0, I_NONE), R(0x0e, 0x0e, 0, I_NONE), R(0x0f, 0x0f, 1, I_8), R(0x30, 0x37, 0, I_NONE),
  R(0x70, 0x73, 1, I_8), R(0x77, 0x77, 0, I_NONE), R(0x80, 0x8f, 0, I_REL32), R(0xa0, 0xa2, 0, I_NONE), R(0xa4, 0xa4, 1, I_8),
  R(0xa8, 0xaa, 0, I_NONE), R(0xac, 0xac, 1, I_8), R(0xba, 0xba, 1, I_8), R(0xc2, 0xc2, 1, I_8), R(0xc4, 0xc6, 1, I_8),
  R(0xc8, 0xcf, 0, I_NONE) };
// The 56 in the loop is the number of map-0 ranges in opr (the position of the 0xff marker).
static void init_optab(void) {
  for (int b = 0; b < 0x40; ++b) { int l = b & 7; optab[b] = l < 4 ? 1 : (l == 4 ? I_8 << 1 : (l == 5 ? I_Z << 1 : 0)); }
  u8* t = optab;
  for (unsigned i = 0; i < sizeof opr;) {
    if (i == 56 * 3) { t += 256; ++i; continue; }
    for (int c = opr[i]; c <= opr[i + 1]; ++c) t[c] = opr[i + 2];
    i += 3;
  }
}
// Parser state, same fields as pk.cpp struct X86. x_reset = a newly constructed X86.
typedef struct {
  int st, k, rem; u32 op, pfx; int p66, rexw, map, modrm, sib, dispn, immn, immkind, riprel, rel32; u32 fv;
  u32 hist[4], mhist[2]; int ilen; u32 lastfield; int fielddone, after;
} X86;
static void x_reset(X86* x) { u8* p = (u8*)x; for (unsigned i = 0; i < sizeof *x; ++i) p[i] = 0; x->modrm = x->sib = -1; }
// = X86::end: instruction complete.
static void x_end(X86* x) {
  x->hist[3] = x->hist[2]; x->hist[2] = x->hist[1]; x->hist[1] = x->hist[0]; x->hist[0] = x->op * 4 + (x->p66 ? 1 : 0) + (x->rexw ? 2 : 0);
  x->mhist[1] = x->mhist[0]; x->mhist[0] = x->modrm + 1;
  x->st = F_START; x->k = 0; x->op = 0; x->pfx = 0; x->p66 = x->rexw = x->map = 0; x->modrm = x->sib = -1; x->dispn = x->immn = 0;
  x->ilen = 0; x->fv = 0; x->riprel = x->rel32 = 0;
}
// = X86::start_imm / start_disp: enter the field if it exists, else go on.
static void x_imm(X86* x) {
  if (x->immn > 0) { x->st = F_IMM; x->k = 0; x->rem = x->immn; x->fv = 0; x->rel32 = x->immkind == I_REL32; x->riprel = 0; } else x_end(x);
}
static void x_disp(X86* x) {
  if (x->dispn > 0) { x->st = F_DISP; x->k = 0; x->rem = x->dispn; x->fv = 0; x->rel32 = 0; } else x_imm(x);
}
// = X86::after_opcode: opcode byte known; ModRM and immediate size from the table.
static void x_opcode(X86* x, int c) {
  x->op = (x->map << 8 | c) + 1;
  int f = optab[(x->map == 0 ? 0 : 256) + c];
  if (x->map == 2) f = 1; else if (x->map == 3) f = 1 | I_8 << 1;
  int ik = x->immkind = f >> 1, z = x->p66 ? 2 : 4;
  x->immn = ik == I_8 ? 1 : ik == I_Z ? z : ik == I_16 ? 2 : ik == I_REL32 ? 4 : ik == I_V ? (x->rexw ? 8 : z) : ik == I_MOFFS ? 8 : ik == I_ENTER ? 3 : 0;
  if (f & 1) x->st = F_MODRM; else x_imm(x);
}
// = X86::feed: consume one byte. (lastfield, unused in pk.cpp too, is not kept up to date.)
static void x_feed(X86* x, int c) {
  x->fielddone = 0; ++x->ilen;
  switch (x->st) {
    case F_START: {
      int f = optab[c] >> 1;
      if (f == I_PFX) { x->pfx = x->pfx * 31 + c; if (c == 0x66) x->p66 = 1; if (x->ilen > 8) x_end(x); }
      else if (f == I_REX) { x->pfx = x->pfx * 31 + c; x->rexw = (c >> 3) & 1; }
      else if (f == I_ESC) x->st = F_OP2;
      else if (f == I_VEX3) x->st = F_VEX1;
      else if (f == I_VEX2) { x->st = F_VEX2; x->map = 1; }
      else x_opcode(x, c);
      break; }
    case F_OP2:
      if (c == 0x38) { x->map = 2; x->st = F_OP3; } else if (c == 0x3a) { x->map = 3; x->st = F_OP3; } else { x->map = 1; x_opcode(x, c); }
      break;
    case F_OP3: case F_VEXOP: x_opcode(x, c); break;
    case F_VEX1: x->map = c & 3; if (x->map == 0) x->map = 1; x->pfx = x->pfx * 31 + (c & 0xe0); x->st = F_VEX2; break;
    case F_VEX2: x->pfx = x->pfx * 31 + (c & 0x87) + 256; x->st = F_VEXOP; break;
    case F_MODRM: {
      x->modrm = c; int mod = c >> 6, rm = c & 7;
      if (x->immkind == I_GRP3B) x->immn = (c & 0x30) == 0 ? 1 : 0;
      if (x->immkind == I_GRP3Z) x->immn = (c & 0x30) == 0 ? (x->p66 ? 2 : 4) : 0;
      x->dispn = 0; x->riprel = 0;
      if (mod == 1) x->dispn = 1; else if (mod == 2) x->dispn = 4; else if (mod == 0 && rm == 5) { x->dispn = 4; x->riprel = 1; }
      if (mod != 3 && rm == 4) x->st = F_SIB; else x_disp(x);
      break; }
    case F_SIB:
      x->sib = c; if ((x->modrm >> 6) == 0 && (c & 7) == 5) x->dispn = 4;
      x_disp(x); break;
    case F_DISP:
      x->fv = x->fv << 8 | c; ++x->k;
      if (--x->rem == 0) { if (x->riprel) { x->fielddone = 1; x->after = x->immn; } x_imm(x); }
      break;
    case F_IMM:
      x->fv = x->fv << 8 | c; ++x->k;
      if (--x->rem == 0) { if (x->rel32) { x->fielddone = 2; x->after = 0; } x_end(x); }
      break;
  }
}

// ------------------------------------------------------------ model state
// Mirrors pk.cpp Slot, Ctx, Model::MM, Apm and the members of Model (same names). The slot
// tables, weights, APM tables and match hash tables are allocated in unpack().
typedef struct { u16 a, b; u8 n, chk, h, pad; } Slot;
typedef struct { Slot* t; Slot* s; u32 h; int smi; u16 sm[1024]; } Ctx;
typedef struct { int minlen; u32* ht; u32 ptr; int len, exp, si; u16 sm[64][2]; } MM;
typedef struct { u16* t; int idx; } Apm;

static Ctx ctx[NCTX];
static MM mm[2];
static Apm apm[3];
static X86 X;
static u8* buf; static u32 pos; static int c0 = 1, bpos;
static int in[MAXIN], nin, sel[NSEL], p1[NSEL], in2[NSEL + 1], pmix;
static int* w1[NSEL]; static int* w2;
static const u16 selsize[NSEL] = {256, 256 * 12, 256, 2048, 1024, 4096};
static u16 rec_t[256];

// = Model::B: the byte i positions back, 0 before the start.
static u32 B(u32 i) { return pos >= i ? buf[pos - i] : 0; }
// The image (what the model sees) is the file with the hole moved to the end: code is
// [TEXT_LO, TEXT_HI - HOLE_LEN) and, if there is a hole, [t2lo, n).
static u32 t2lo = 0xffffffffu;
static int intextp(u32 i) { return (i >= TEXT_LO && i < TEXT_HI - HOLE_LEN) || i >= t2lo; }
static int intext(void) { return intextp(pos); }

// = Model::atom + Model::byte_update: once per byte, the atom values and each context's hash.
// Only the atoms that the contexts in cfg[] can use are computed (the rest stay 0); cfg2c.py
// refuses a model.cfg that needs an atom not assigned here. Hash constants as in pk.cpp.
static void byte_update(void) {
  u32 av[NATOM];
  for (int i = 0; i < NATOM; ++i) av[i] = 0;
  for (int i = 0; i < 8; ++i) av[b1 + i] = B(i + 1);
  av[b9] = B(9); av[b12] = B(12); av[b16] = B(16); av[b24] = B(24); av[AW] = X.rexw * 2 + X.p66;
  av[AF] = X.st * 16 + (X.k < 15 ? X.k : 15); av[AO] = X.op; av[AM] = X.modrm + 1;
  av[P1] = X.hist[0]; av[P2] = X.hist[1]; av[P3] = X.hist[2]; av[P4] = X.hist[3];
  av[AX] = X.pfx; av[AI] = X.fv + ((u32)X.k << 28); av[AR] = X.mhist[0]; av[R2] = X.mhist[1];
  av[q8] = pos & 7; av[q24] = pos % 24; av[AE] = mm[0].exp + 1; av[Mm] = X.modrm < 0 ? 0 : (X.modrm >> 6) + 1;
  av[pg] = pos >> 12; av[b1h] = B(1) >> 4; av[AK] = X.riprel * 2 + X.rel32; av[p1o] = (X.hist[0] >> 2) & 0xff;
  const u8* p = cfg;
  for (u32 i = 0; i < NCTX; ++i) {
    u32 h = 0x811c9dc5u + i * 0x01000193u;
    for (; *p != 255; ++p) { h = (h ^ av[*p]) * 0x2f0b4d67u; h ^= h >> 15; h += *p * 0x9e3779b1u; }
    ++p; ctx[i].h = h;
  }
}
// = Model::mm_predict: the two match-model inputs for the current bit.
static void mm_predict(MM* m) {
  m->exp = -1; m->si = -1;
  if (m->len > 0 && m->ptr < pos) {
    int eb = buf[m->ptr] | 256;
    if ((eb >> (8 - bpos)) == c0) {
      m->exp = buf[m->ptr];
      int bit = (eb >> (7 - bpos)) & 1, l = m->len < 32 ? m->len : 31 + (m->len >= 64);
      m->si = l; int st = stretch_t[m->sm[l][0] >> 4];
      int v = m->len < 16 ? m->len * 32 : 512 + (m->len > 400 ? 400 : m->len);
      in[nin++] = bit ? st : -st; in[nin++] = bit ? v : -v;
      m->sm[0][1] = bit;
      return;
    }
    m->len = 0;
  }
  in[nin++] = 0; in[nin++] = 0;
}
// = Model::mm_byte: after each byte, extend the match or look for a new one.
static void mm_byte(MM* m) {
  if (m->len > 0 && m->ptr < pos && buf[m->ptr] == buf[pos - 1]) { ++m->len; ++m->ptr; } else m->len = 0;
  if (pos >= (u32)m->minlen) {
    u32 h = 0; for (int i = 1; i <= m->minlen; ++i) h = (h + buf[pos - i] + 1) * 0x2f0b4d67u;
    h >>= 12;
    if (m->len == 0) {
      m->ptr = m->ht[h];
      if (m->ptr > 0) { u32 l = 0; while (l < 65535 && l < m->ptr && buf[m->ptr - 1 - l] == buf[pos - 1 - l]) ++l; m->len = l < (u32)m->minlen ? 0 : l; }
    }
    m->ht[h] = pos;
  }
}
// = Apm::pp: interpolated lookup; remembers the nearer table entry for the update.
static int apm_pp(Apm* a, int pr, u32 cx) {
  int s = stretch_t[pr] + 2048, lo = s >> 7, w = s & 127; u16* t = a->t + cx * 33 + lo; a->idx = cx * 33 + lo + (w >> 6);
  return (t[0] * (128 - w) + t[1] * w) >> 11;
}
// = Model::predict (with Model::find inline): P(next bit = 1) in 12 bits. Same order of
// inputs, same selectors, both mixer layers, three APM stages, final average.
static int predict(void) {
  nin = 0;
  for (int i = 0; i < NCTX; ++i) {
    Ctx* c = &ctx[i];
    // slot lookup (Model::find): hash with the partial byte; a slot with another check is reset
    u32 xh = (c->h ^ (u32)c0 * 0x9e3779b1u) * 0x85ebca6bu; xh ^= xh >> 13; xh *= 0xc2b2ae35u;
    Slot* s = c->s = &c->t[xh >> (32 - TBITS)]; u8 chk = (xh >> 3) & 255;
    if (s->chk != chk) { s->a = s->b = 32768; s->n = 0; s->chk = chk; s->h = 1; }
    int n = s->n;
    // four inputs per context: history map, slow counter, fast counter, confidence
    c->smi = s->h + 256 * (n < 2 ? n : (n < 6 ? 2 : 3));
    if (n == 0) { in[nin++] = 0; in[nin++] = 0; in[nin++] = 0; in[nin++] = 0; }
    else {
      int sa = stretch_t[s->a >> 4], cf = n < 3 ? 0 : (n < 8 ? 1 : (n < 32 ? 2 : 3));
      in[nin++] = stretch_t[c->sm[c->smi] >> 4]; in[nin++] = sa; in[nin++] = stretch_t[s->b >> 4]; in[nin++] = (sa * cf) >> 1;
    }
  }
  mm_predict(&mm[0]); mm_predict(&mm[1]);
  in[nin++] = 256;
  // selectors of the six layer-1 weight sets, then layer 1, layer 2 and the APM stages
  int fld = X.st * 4 + (X.k < 3 ? X.k : 3), l0 = mm[0].len;
  int ml = l0 == 0 ? 0 : (l0 < 8 ? 1 : (l0 < 16 ? 2 : (l0 < 32 ? 3 : 4)));
  sel[0] = c0;
  sel[1] = bpos + 8 * (fld < 48 ? fld : 47);
  sel[2] = B(1);
  sel[3] = (ml * 2 + (mm[0].exp >= 0 ? ((mm[0].exp >> (7 - bpos)) & 1) : 0)) * 8 + bpos + 80 * (intext() ? X.st + 1 : 0);
  sel[4] = X.op & 1023;
  sel[5] = ((X.modrm + 1) & 0x1ff) * 8 + bpos;
  for (int i = 0; i < NSEL; ++i) {
    sel[i] %= selsize[i];
    int* w = w1[i] + sel[i] * MAXIN; i64 s = 0;
    for (int j = 0; j < nin; ++j) s += (i64)in[j] * w[j];
    in2[i] = clampd(s); p1[i] = squash(in2[i]);
  }
  in2[NSEL] = 256;
  { int* w = w2 + c0 * (NSEL + 1); i64 s = 0; for (int j = 0; j <= NSEL; ++j) s += (i64)in2[j] * w[j]; pmix = squash(clampd(s)); }
  int q1 = apm_pp(&apm[0], pmix, c0 + 256 * (X.st < 11 ? X.st : 11));
  int q2 = apm_pp(&apm[1], pmix, (c0 | B(1) << 8) & 0xffff);
  int q3 = apm_pp(&apm[2], pmix, (((u32)c0 * 0x9e3779b1u) ^ (X.op * 0x2f0b4d67u) ^ ((u32)(X.modrm + 1) * 0x85ebca6bu) ^ ((u32)X.st * 0x1234567u + (u32)X.k * 77777u)) >> 16);
  int pr = (2 * pmix + q1 + q2 + 2 * q3 + 3) / 6;
  return pr < 1 ? 1 : (pr > 4094 ? 4094 : pr);
}
// = Model::update (with Model::mm_update and Apm::update inline): adapt slots, match models,
// both mixer layers and the APMs to the bit y; at the end of a byte feed the parser (fresh at
// the start of each code piece, cleared outside code), the match models and the atoms.
// The shift counts are pk.cpp's parameters: 8 = rateB, 6 = hrate, 5 = hist, 11 = lr1,
// 12 = lr2, 6 = apr; 255 = limA.
static void update(int y) {
  int t = y ? 65535 : 0;
  for (int i = 0; i < NCTX; ++i) {
    Ctx* c = &ctx[i]; Slot* s = c->s;
    s->a += ((t - s->a) * rec_t[s->n]) >> 16; if (s->n < 255) ++s->n;
    s->b += (t - s->b) >> 8;
    c->sm[c->smi] += (t - c->sm[c->smi]) >> 6;
    int h = s->h << 1 | y; if (h >> 5 > 1) h = (h & 31) | 32; s->h = h;
  }
  for (int i = 0; i < 2; ++i) { MM* m = &mm[i]; if (m->si >= 0) { int ok = (y == m->sm[0][1]); u16* p = &m->sm[m->si][0]; *p += ((ok << 16) - ok - *p) >> 6; } }
  for (int i = 0; i < NSEL; ++i) {
    int err = (y << 12) - p1[i]; int* w = w1[i] + sel[i] * MAXIN;
    for (int j = 0; j < nin; ++j) w[j] += (in[j] * err) >> 11;
  }
  { int err = (y << 12) - pmix; int* w = w2 + c0 * (NSEL + 1); for (int j = 0; j <= NSEL; ++j) w[j] += (in2[j] * err) >> 12; }
  for (int i = 0; i < 3; ++i) { u16* p = &apm[i].t[apm[i].idx]; int g = (y << 16) + (y << 6) - y - y; *p += (g - *p) >> 6; }
  c0 = c0 << 1 | y;
  if (++bpos == 8) {
    int c = c0 & 255; buf[pos++] = c; bpos = 0; c0 = 1;
    if (intextp(pos - 1)) { if (pos - 1 == t2lo || pos - 1 == HOLE_LO) x_reset(&X); x_feed(&X, c); }
    else if (X.st != F_START || X.op) x_reset(&X);
    mm_byte(&mm[0]); mm_byte(&mm[1]);
    byte_update();
  }
}

// = pk.cpp xform, inverse direction only: undo the address transform of one code range
// [lo, hi) of the image; bias = file offset - image position. Runs after decoding, on buf.
static void unxform(u32 lo, u32 hi, u32 bias) {
  x_reset(&X);
  for (u32 i = lo; i < hi; ++i) {
    x_feed(&X, buf[i]);
    if (X.fielddone && i >= lo + 3) {
      u32 v = ((u32)buf[i - 3] << 24 | buf[i - 2] << 16 | buf[i - 1] << 8 | buf[i]) - (i + bias + 1 + X.after);
      buf[i - 3] = v; buf[i - 2] = v >> 8; buf[i - 1] = v >> 16; buf[i] = v >> 24;
    }
  }
}
// Decodes the stream at src (4-byte length, then coder bytes) and returns the image (the ELF file
// with the hole moved to its end). full = 0: stop before the hole, which stays zero.
// Mirrors pk.cpp main, mode 'd': set_ranges, Model::init (same initial values), the decoder
// (struct Dec, inline in the loop) and xform_all(inverse). The hole permutation is not undone
// here: the callers write the pieces of the image in file order (PIECES).
static u8* unpack(const u8* src, u32* np, int full) {
  u32 n = src[0] | src[1] << 8 | src[2] << 16 | (u32)src[3] << 24; src += 4;
  if (HOLE_LEN) t2lo = n - HOLE_LEN;
  u32 ndec = full ? n : n - HOLE_LEN;
  // tables: stretch (pk.cpp init_stretch), opcode table, counter steps (rec_t)
  stretch_t = alloc(4096 * 2);
  { int pi = 0; for (int x = -2047; x <= 2047; ++x) { int v = squash(x); for (int i = pi; i <= v; ++i) stretch_t[i] = x; pi = v + 1; }
    for (int i = pi; i < 4096; ++i) stretch_t[i] = 2047; }
  init_optab();
  for (int i = 0; i < 256; ++i) rec_t[i] = 131072 / (2 * i + 3);
  // model state as in Model::init
  buf = alloc(n + 8); x_reset(&X);
  for (int i = 0; i < 2; ++i) { mm[i].minlen = i ? 2 : 4; mm[i].ht = alloc(4u << 20); mm[i].exp = -1; for (int j = 0; j < 64; ++j) mm[i].sm[j][0] = mm[i].sm[j][1] = 32768; }
  for (int i = 0; i < NSEL; ++i) { u32 k = (u32)selsize[i] * MAXIN; w1[i] = alloc(k * 4); for (u32 j = 0; j < k; ++j) w1[i][j] = 1 << 14; }
  w2 = alloc(256 * (NSEL + 1) * 4); for (int j = 0; j < 256 * (NSEL + 1); ++j) w2[j] = 65536 / 4;
  for (int i = 0; i < 3; ++i) {
    u32 k = i ? 65536 : 256 * 12; u16* t = apm[i].t = alloc(k * 33 * 2);
    for (u32 j = 0; j < k * 33; ++j) t[j] = squash(((int)(j % 33) - 16) * 128) * 16;
  }
  for (int i = 0; i < NCTX; ++i) {
    Slot* t = ctx[i].t = alloc((u64)sizeof(Slot) << TBITS);
    for (u32 j = 0; j < 1u << TBITS; ++j) { t[j].a = t[j].b = 32768; t[j].h = 1; }
    for (int j = 0; j < 1024; ++j) ctx[i].sm[j] = 32768;
  }
  byte_update();
  // arithmetic decoder (pk.cpp struct Dec); x = the next four stream bytes
  u32 x1 = 0, x2 = 0xffffffff, x = 0;
  for (int k = 0; k < 4; ++k) x = x << 8 | *src++;
  for (u32 i = 0; i < ndec * 8; ++i) {
    u32 xm = x1 + (u32)(((u64)(x2 - x1) * (u32)predict()) >> 12); int y = x <= xm;
    if (y) x2 = xm; else x1 = xm + 1;
    while (((x1 ^ x2) & 0xff000000) == 0) { x1 <<= 8; x2 = x2 << 8 | 255; x = x << 8 | *src++; }
    update(y);
  }
  // inverse address transform, piece by piece as in pk.cpp xform_all. Decompressor's form:
  // the hole was not decoded and is left as zeros.
  if (HOLE_LEN) {
    unxform(TEXT_LO, HOLE_LO, 0); unxform(HOLE_LO, TEXT_HI - HOLE_LEN, HOLE_LEN);
    if (full) unxform(n - HOLE_LEN, n, HOLE_LO - (n - HOLE_LEN));
  } else unxform(TEXT_LO, TEXT_HI < n ? TEXT_HI : n, 0);
  *np = n; return buf;
}
// = pk.cpp permute(inverse), without copying: the three pieces of the image in file order:
// before the hole, the hole (stored at the end of the image), after the hole.
#define PIECES(o, n) {{o, HOLE_LO}, {o + n - HOLE_LEN, HOLE_LEN}, {o + HOLE_LO, n - HOLE_LEN - HOLE_LO}}
typedef struct { u8* p; u32 n; } Piece;

#ifdef TEST
// Test decoder: pkdec IN.pk OUT [x]. The 16 zero bytes after the input stand for the bytes
// the stub would read past the end of a cut stream.
int main(int argc, char** argv) {
  FILE* f = fopen(argv[1], "rb"); fseek(f, 0, SEEK_END); long sz = ftell(f); fseek(f, 0, SEEK_SET);
  u8* d = malloc(sz + 16); fread(d, 1, sz, f); fclose(f); for (int i = 0; i < 16; ++i) d[sz + i] = 0;
  u32 n; u8* o = unpack(d, &n, argc < 4);        // a third argument: the decompressor's form
  Piece pc[3] = PIECES(o, n);
  f = fopen(argv[2], "wb"); for (int i = 0; i < 3; ++i) fwrite(pc[i].p, 1, pc[i].n, f); fclose(f); return 0;
}
#else
// Stage 1 of the stub. Stage 0 (stage0.S) decodes this code to a fixed address and calls its
// first byte, which is cstart (placed first by its section name, see stage1.ld), with the stack
// pointer the kernel gave the process and the address of the packed image.
static long sys(long n, long a, long b, long c, long d, long e, long f) {
// Raw Linux system call with up to six arguments.
  long r; register long r10 __asm__("r10") = d; register long r8 __asm__("r8") = e; register long r9 __asm__("r9") = f;
  __asm__ volatile("syscall" : "=a"(r) : "a"(n), "D"(a), "S"(b), "d"(c), "r"(r10), "r"(r8), "r"(r9) : "rcx", "r11", "memory");
  return r;
}
// Entry point of stage 1. sp = the initial stack pointer (argc, argv, envp as the kernel left
// them), packed = the packed image inside the stub. Steps: map memory for the model; decode
// (full image in the compressor's copy, without the hole in the archive's copy); create a
// memfd and write the executable into it in file order; execveat it with the same argv and
// envp. The exit at the end is reached only if execveat fails.
__attribute__((section(".text.entry"))) void cstart(long* sp, const u8* packed) {
  char** argv = (char**)(sp + 1); char** envp = argv + sp[0] + 1;
  arena = (u8*)sys(9, 0, 320u << 20, 3, 0x22, -1, 0);            // mmap anonymous, zeroed
  // Byte 9 of our own ELF header (padding, ignored by the kernel) is 0 in the compressor's copy and
  // 1 in the copy the compressor writes into the archive, whose stream stops before the hole.
  u32 n; u8* o = unpack(packed, &n, !((const u8*)0x400000)[9]);
  int fd = sys(319, (long)"", 0, 0, 0, 0, 0);                    // memfd_create
  Piece pc[3] = PIECES(o, n);
  for (int i = 0; i < 3; ++i)
    for (u32 w = 0; w < pc[i].n;) { long r = sys(1, fd, (long)(pc[i].p + w), pc[i].n - w, 0, 0, 0); if (r <= 0) break; w += r; }
  sys(322, fd, (long)"", (long)argv, (long)envp, 0x1000, 0);     // execveat(AT_EMPTY_PATH)
  sys(60, 127, 0, 0, 0, 0, 0);
}
#endif
