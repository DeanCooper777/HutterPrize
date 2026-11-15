// pk.cpp: the build-time side of the executable packer. New in this entry.
//
// What it is. A bitwise context-mixing compressor specialised for x86-64 machine code. It packs
// the cmix executable itself: pack.sh runs "pk c" once per build and puts the output behind a
// small unpacking stub; when the packed executable starts, the stub's decoder (pkdec.c,
// "stage 1") rebuilds the real executable in memory and runs it.
//
// What it replaces and why. The previous winning entry (fx2-cmix-transformer-v1) packed its
// executable with UPX. The executable is stored twice in an entry, in the compressor package
// (comp9) and at the head of the self-extracting archive (archive9), so every byte saved here
// counts twice in the score. A model that knows the instruction format predicts machine code
// much better than a general-purpose LZ packer (upx --lzma gave about 170 KB for this
// executable; pack.sh prints the size reached by this packer at the end of every build).
//
// Place in the whole. Not a stage of the enwik9 pipeline (preprocess -> dictionary -> context
// models / PPMD / transformer byte model -> mixers -> SSE -> arithmetic coder -> self-extracting
// archive): it acts on the finished executable as the last build step
// (build_and_construct_comp.sh -> pack.sh -> pk).
//
// Reading guide, top to bottom:
//   parameters         numeric settings of the model ("set" lines of the config)
//   squash / stretch   the logistic function and its inverse, as integer tables
//   x86-64 parser      tells the model which field of which instruction the next byte is in
//   address transform  relative call / jump / RIP-relative operands -> absolute targets
//   hole               the compress-only functions are coded last, so that the archive's copy of
//                      the executable is this packed file cut short
//   model              hashed context slots, two match models, two-layer mixer, three APM stages
//   coder              32-bit binary arithmetic coder
//   config, main       the e / c / d modes
//
// One bit in short (Model::predict, Model::update). Every context looks up one slot and gives
// up to four inputs in the stretch (logit) domain; each match model gives two; one input is a
// constant. Layer 1 of the mixer computes NSEL weighted sums of all inputs, each with a weight
// row chosen by a different selector; layer 2 mixes those NSEL results. Three APM (SSE) stages
// refine the mixed probability and are averaged with it. The 12-bit result drives the coder.
// Then every part adapts to the coded bit.
//
// What pkdec.c must mirror bit for bit: squash/stretch, the opcode table and the parser, the
// atoms and the context hash, slot lookup and update, the match models, the selectors, both
// mixer layers, the APM stages and the final average, the coder, the inverse address transform
// and the hole layout. For that reason the model uses integer arithmetic only (the one use of
// floating point is the size estimate printed by main). The contexts ("ctx" lines) are copied
// into pkdec.c by cfg2c.py; the "set" values of the shipped model.cfg are constants in pkdec.c.
//
// Usage:
//   pk e CONFIG IN            estimate size (also real size via the coder); writes nothing
//   pk c CONFIG IN OUT        compress
//   pk d CONFIG IN OUT [NDEC] decompress (NDEC: only the first NDEC image bytes, see main)
//
// CONFIG lines (pack.sh writes the text and hole lines for the binary at hand and appends
// model.cfg, which holds the ctx and set lines):
//   text LO HI                file range of the code (x86 parser + address transform on)
//   hole LO HI                file range inside the code that is coded last (see "hole" below)
//   ctx ATOM,ATOM,...         one hashed context (see Model::atom() for the atoms)
//   set NAME VALUE            numeric parameter (see Params)
// Other lines are ignored.
//
// Output: 4 bytes, the length of the input, least significant first; then the coder's bytes.
//
// Testing: "pk e" is the measuring tool of search.py / retune.sh (model search). Before coding,
// main checks that the address transform and the hole permutation invert exactly. pack.sh
// decodes every packed image with pkdec.c (built with -DTEST) and compares with the input;
// "pk d" is this file's own decoder for the same stream.
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <cmath>
#include <string>
#include <vector>
typedef uint8_t u8; typedef uint16_t u16; typedef uint32_t u32; typedef uint64_t u64;

// ---------------------------------------------------------------- parameters
// The defaults below are overridden by "set NAME VALUE". pkdec.c reads no config: it contains
// the values of the shipped model.cfg (tbits 20, lr1 11, lr2 12, rateB 8, mm1 4, mm2 2, apr 6,
// hist 5) and the defaults below for everything else as constants, so a changed value must be
// changed there by hand as well (pack.sh's decoder check fails until it is).
//   tbits        each context has its own table of 2^tbits slots (8 bytes per slot)
//   limA         the slot's adaptive counter averages over up to limA + 1 observations, then
//                keeps that rate
//   rateB        the slot's second counter moves 1 / 2^rateB of the way to each bit
//   useB, conf   switch the second counter / the confidence input on
//   lr1, lr2     the mixer weight step is (input * error) >> lr, for layer 1 and layer 2
//   mm1, mm2     number of bytes hashed to find a match, for the two match models
//   apm          1 = use the three APM stages
//   apr          an APM entry moves 1 / 2^apr of the way to each bit
//   xform        1 = apply the address transform
//   sel          bit i set = layer-1 weight set i is in use (pkdec.c uses all six)
//   hist, hrate  bits of bit history kept per slot, and the rate of the map that turns the
//                history into a probability
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

// Probabilities are 12 bits: P(next bit is 1) * 4096. stretch(p) = ln(p / (1 - p)) is the logit
// in units of 1/256, limited to +-2047; squash(d) = 4096 / (1 + e^(-d/256)) is its inverse.
// The mixer adds weighted logits, which is why every model output is stretched first.
// squash interpolates linearly in a table of 33 values (one per 128 units).
// ---------------------------------------------------------------- squash/stretch
static int squash(int d) {
  if (d > 2047) return 4095;
  if (d < -2047) return 0;
  static const int t[33] = {1, 2, 3, 6, 10, 16, 27, 45, 73, 120, 194, 310, 488, 747, 1101, 1546, 2047, 2549,
                            2994, 3348, 3607, 3785, 3901, 3975, 4024, 4050, 4068, 4079, 4085, 4089, 4092, 4093, 4094};
  int w = d & 127; d = (d >> 7) + 16;
  return (t[d] * (128 - w) + t[d + 1] * w + 64) >> 7;
}
// stretch as a table over all 4096 probabilities: stretch_t[p] = the smallest d with
// squash(d) >= p. Built from squash so that the two are exact inverses on every machine.
static short stretch_t[4096];
static void init_stretch() {
  int pi = 0;
  for (int x = -2047; x <= 2047; ++x) { int v = squash(x); for (int i = pi; i <= v; ++i) stretch_t[i] = x; pi = v + 1; }
  for (int i = pi; i < 4096; ++i) stretch_t[i] = 2047;
}
static inline int stretch(int p) { return stretch_t[p]; }

// ---------------------------------------------------------------- x86-64 parser
// A state machine fed one byte at a time. It does not work out what an instruction does, only
// where its fields are:
//   [prefixes] [REX | VEX] opcode [ModRM] [SIB] [displacement] [immediate]
// The model uses the state as context (atoms F, O, M, ... in Model::atom) and the address
// transform uses it to find the 4-byte relative fields. The parser need not be complete or
// right: coder and decoder run the same code over the same bytes, so a misparse (data inside
// the code, an encoding it does not know, e.g. EVEX) only costs compression. Displacement and
// immediate bytes never change the path the parser takes; the address transform, which
// rewrites such bytes, relies on that to be invertible.
//
// Field types of the NEXT byte:
//   F_START  start of an instruction: a prefix, REX, a VEX escape (C4 / C5), the 0F escape or
//            a one-byte opcode
//   F_OP2    the byte after 0F: an opcode of the 0F map, or 38 / 3A (three-byte opcode maps)
//   F_OP3    the opcode after 0F 38 or 0F 3A
//   F_VEX1   the second byte of a three-byte VEX prefix (C4)
//   F_VEX2   the last byte of a VEX prefix (third byte of C4, second byte of C5)
//   F_VEXOP  the opcode after a VEX prefix
//   F_MODRM, F_SIB, F_DISP, F_IMM   ModRM, SIB, a displacement byte, an immediate byte
//   F_NONE   unused
enum { F_START, F_OP2, F_OP3, F_VEX1, F_VEX2, F_VEXOP, F_MODRM, F_SIB, F_DISP, F_IMM, F_NONE };
// Opcode table entry: bit 0 = a ModRM byte follows; the bits above = kind of immediate:
//   I_8      1 byte (also 8-bit relative jumps)
//   I_Z      4 bytes, 2 with the 66 prefix
//   I_16     2 bytes (ret imm16)
//   I_REL32  4-byte relative target (call, jmp, jcc): the address transform acts on these
//   I_V      mov reg, imm: 8 bytes with REX.W, else as I_Z
//   I_MOFFS  8-byte absolute address (A0..A3)
//   I_ENTER  3 bytes (enter imm16, imm8)
//   I_GRP3B / I_GRP3Z   F6 / F7: an immediate (1 byte / as I_Z) only for the TEST forms, which
//            the ModRM byte selects
//   I_PFX, I_ESC, I_REX, I_VEX3, I_VEX2   not immediates: these mark the byte as a legacy
//            prefix, the 0F escape, a REX prefix, the C4 and the C5 VEX escape
// opcode flags: bit0 modrm, bits1-4 imm kind
enum { I_NONE, I_8, I_Z, I_16, I_REL32, I_V, I_MOFFS, I_ENTER, I_GRP3B, I_GRP3Z, I_PFX, I_ESC, I_REX, I_VEX3, I_VEX2 };
// optab[0] = one-byte opcode map, optab[1] = 0F map (two-byte opcodes). The maps 0F 38 and
// 0F 3A need no table (see after_opcode). setr fills the range lo..hi of one map.
static u8 optab[2][256];
static void setr(int map, int lo, int hi, int modrm, int imm) { for (int i = lo; i <= hi; ++i) optab[map][i] = modrm | imm << 1; }
static void init_optab() {
  // 00..3F: eight blocks of eight (add, or, adc, sbb, and, sub, xor, cmp): four forms with
  // ModRM, AL imm8, eAX imm32, and two one-byte opcodes; the segment prefixes among them are
  // set on the next line.
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
  // 0F map: ModRM and no immediate unless listed below.
  setr(1, 0x00, 0xff, 1, I_NONE);
  setr(1, 0x05, 0x0b, 0, I_NONE); setr(1, 0x0e, 0x0e, 0, I_NONE); setr(1, 0x0f, 0x0f, 1, I_8);
  setr(1, 0x30, 0x37, 0, I_NONE); setr(1, 0x70, 0x73, 1, I_8); setr(1, 0x77, 0x77, 0, I_NONE);
  setr(1, 0x80, 0x8f, 0, I_REL32); setr(1, 0xa0, 0xa2, 0, I_NONE); setr(1, 0xa4, 0xa4, 1, I_8);
  setr(1, 0xa8, 0xaa, 0, I_NONE); setr(1, 0xac, 0xac, 1, I_8); setr(1, 0xba, 0xba, 1, I_8);
  setr(1, 0xc2, 0xc2, 1, I_8); setr(1, 0xc4, 0xc6, 1, I_8); setr(1, 0xc8, 0xcf, 0, I_NONE);
}

// Parser state. feed(c) consumes one byte; afterwards st / k describe the byte that comes next.
//   st, k, rem    field type of the next byte; index of that byte within a displacement or
//                 immediate; bytes of that field still to come
//   map           opcode map: 0 one-byte, 1 = 0F, 2 = 0F 38, 3 = 0F 3A
//   p66, rexw     operand-size prefix 66 seen; REX.W set (they decide immediate sizes)
//   modrm, sib    those bytes of the current instruction, -1 while not seen
//   dispn, immn   sizes in bytes of the displacement / immediate of the current instruction
//   hist[i]       previous instructions, most recent first: op * 4 + p66 + 2 * rexw
//   mhist[i]      their ModRM bytes + 1 (0 = none)
//   fielddone, after   set by feed() for the address transform, see xform()
// lastfield is written but never read (xform takes the field from the buffer).
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

  // The instruction is complete: push it onto the histories and clear the per-instruction state.
  void end() {
    hist[3] = hist[2]; hist[2] = hist[1]; hist[1] = hist[0]; hist[0] = op * 4 + (p66 ? 1 : 0) + (rexw ? 2 : 0);
    mhist[1] = mhist[0]; mhist[0] = modrm + 1;
    st = F_START; k = 0; op = 0; pfx = 0; p66 = rexw = map = 0; modrm = sib = -1; dispn = immn = 0; ilen = 0; fv = 0;
    riprel = rel32 = 0;
  }
  // c is the opcode byte: note it, and look up whether a ModRM byte follows and how long the
  // immediate is. Map 2 (0F 38): always ModRM, no immediate. Map 3 (0F 3A): ModRM and imm8.
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
  // Enter the immediate / displacement field if the instruction has one, else go on to what
  // follows it (disp -> imm -> end of instruction).
  void start_imm() {
    if (immn > 0) { st = F_IMM; k = 0; rem = immn; fv = 0; rel32 = immkind == I_REL32; riprel = 0; } else end();
  }
  void start_disp() {
    if (dispn > 0) { st = F_DISP; k = 0; rem = dispn; fv = 0; rel32 = 0; } else start_imm();
  }
  // Consume one byte.
  void feed(int c) {
    fielddone = 0; ++ilen;
    switch (st) {
      case F_START: {
        int f = optab[0][c] >> 1;
        // Prefixes and REX are folded into the hash pfx. A run of more than 8 prefix bytes is
        // not code: start over.
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
      // VEX, C4 form: byte 1 holds R, X, B (hashed into pfx) and the opcode map (only the low
      // two bits are looked at; map 0 does not exist and is read as 1).
      // Last VEX byte (both forms): the bits kept by the mask 0x87 are hashed, vvvv (a register
      // number) is left out; + 256 marks the instruction as VEX. C5 implies map 1 (set above).
      case F_VEX1: map = c & 3; if (map == 0) map = 1; pfx = pfx * 31 + (c & 0xe0); st = F_VEX2; break;
      case F_VEX2: pfx = pfx * 31 + (c & 0x87) + 256; st = F_VEXOP; break;
      case F_VEXOP: after_opcode(c); break;
      case F_MODRM: {
        // ModRM: mod 1 -> disp8; mod 2 -> disp32; mod 0 with rm 5 -> disp32 relative to RIP
        // (the 64-bit mode form the address transform acts on); rm 4 (mod != 3) -> SIB follows.
        // F6 / F7 have an immediate only if bits 5 and 4 of ModRM are 0 (test).
        modrm = c; int mod = c >> 6, rm = c & 7;
        if (immkind == I_GRP3B) immn = (c & 0x30) == 0 ? 1 : 0;
        if (immkind == I_GRP3Z) immn = (c & 0x30) == 0 ? (p66 ? 2 : 4) : 0;
        dispn = 0; riprel = 0;
        if (mod == 1) dispn = 1; else if (mod == 2) dispn = 4; else if (mod == 0 && rm == 5) { dispn = 4; riprel = 1; }
        if (mod != 3 && rm == 4) st = F_SIB; else start_disp();
        break; }
      case F_SIB:
        // SIB: base 5 with mod 0 means a disp32 without base register (not RIP-relative).
        sib = c; if ((modrm >> 6) == 0 && (c & 7) == 5) dispn = 4;
        start_disp(); break;
      case F_DISP:
        // Displacement / immediate bytes are collected in fv, first byte in the high bits.
        // When a RIP-relative displacement or a rel32 immediate ends, fielddone tells xform();
        // `after` = number of bytes of this instruction that follow the field (RIP-relative
        // addresses count from the end of the instruction).
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

// ---------------------------------------------------------------- address transform
// A call to one function is coded as "E8 rel32", where rel32 = target - address of the next
// instruction: a different number at every call site. Adding the position back gives the
// target itself, the same four bytes at every site, which the model's contexts and match
// models then predict well. The same is done for jmp / jcc rel32 and for RIP-relative
// displacements (references to data and constants). The result is stored most significant
// byte first, so that the model sees the slowly changing high bytes before the low ones.
//
// xform handles one code range [lo, hi) of the image being modelled (indices into d), with a
// parser started at lo. For each completed field (the four bytes ending at i):
//   forward:  field (little-endian) + base -> stored big-endian
//   inverse:  field (big-endian) - base    -> stored little-endian
// where base = i + bias + 1 + after = file offset of the end of the instruction. `bias` = file
// offset minus image position for this range (non-zero when a hole was moved to the end of the
// image, see permute()), so that a target becomes the same absolute value from every caller.
// The value is a file offset, not a virtual address; the two differ by a constant here.
// The parser sees original bytes in the forward direction and transformed bytes in the inverse
// one; since field bytes never steer it, it finds the same fields both ways. main() verifies
// the round trip on the actual input before coding. pkdec.c has the inverse only (unxform).
static void xform(std::vector<u8>& d, size_t lo, size_t hi, bool fwd, size_t bias = 0) {
  X86 x;
  for (size_t i = lo; i < hi && i < d.size(); ++i) {
    x.feed(d[i]);
    if (x.fielddone && i >= lo + 3) {
      u32 base = (u32)(i + bias + 1 + x.after);
      if (fwd) { u32 v = d[i - 3] | d[i - 2] << 8 | d[i - 1] << 16 | (u32)d[i] << 24; v += base;
                 d[i - 3] = v >> 24; d[i - 2] = v >> 16; d[i - 1] = v >> 8; d[i] = v; }
      else { u32 v = (u32)d[i - 3] << 24 | d[i - 2] << 16 | d[i - 1] << 8 | d[i]; v -= base;
             d[i - 3] = v; d[i - 2] = v >> 8; d[i - 1] = v >> 16; d[i] = v >> 24; }
    }
  }
}

// ---------------------------------------------------------------- model
// Slot: the statistics of one context for one bit position (8 bytes). pkdec.c has the same
// layout.
//   a    P(1) * 65536, adaptive rate: after n observations the step is 1 / (n + 1.5) (rec_t),
//        i.e. close to the average of the bits seen, until n reaches limA
//   b    P(1) * 65536, fixed fast rate 1 / 2^rateB
//   n    number of observations (saturates at limA)
//   chk  8 hash bits that identify the context; on a mismatch the slot is simply taken over
//   h    bit history: the last `hist` bits seen in this slot below a leading 1 (1 = empty)
struct Slot { u16 a, b; u8 n, chk, h, pad; };
// rec_t[n] = 65536 * 2 / (2 n + 3), the step of counter `a` after n observations (set in main).
static int rec_t[256];

// One context of the config: its atoms, its slot table t, the hash h of its atom values (per
// byte), the slot s in use for the current bit, and sm, an adaptive map from (bit history,
// count class) of the slot to a probability (index smi for the current bit).
struct Ctx { std::vector<int> atoms; std::vector<Slot> t; u32 h = 0; Slot* s = nullptr; u16 sm[1024]; int smi = 0; };
static std::vector<Ctx> ctxs;
static std::vector<std::string> atom_names;
// File range of the code, from the "text" line.
static size_t text_lo = 0, text_hi = 0;
// ---------------------------------------------------------------- hole
// The executable is stored twice: comp9 holds it for compressing and decompressing, archive9
// holds it for decompressing only. Functions that only compression can reach are dead weight
// in archive9. packer/enc_only.py finds them and the build links them as one run at the end
// of .text: the "hole", a file range inside the code ("hole LO HI" in the config).
//
// The packer codes the hole LAST, after everything else. The model is adaptive and never
// looks ahead, so the stream for the rest is then a prefix of the full stream: the
// decompressor's copy of the executable is the same packed file cut short ("cut" in the output
// of pk c), and its decoder stops before the hole and leaves it as zeros. The compressor
// writes that copy into archive9 (src/readalike_prepr/self_extract.h, selfextract_comp): the
// first `cut` bytes of itself, with byte 9 of the ELF header set to 1 (which tells pkdec.c to
// stop early) and the file size in the program header reduced to match.
// hole_lo == hole_hi: no hole.
static size_t hole_lo = 0, hole_hi = 0;
// To code the hole last, the model works on the "image" = the file with the hole moved to the
// end (permute). Code ranges of the image: [text_lo, t1_hi), which is the code before the hole
// followed by the code after it (.fini), and [t2_lo, n), the hole. Set by set_ranges().
static size_t t1_hi = 0, t2_lo = (size_t)-1, img_n = 0;
static void set_ranges(size_t n) {
  img_n = n; size_t H = hole_hi - hole_lo;
  t1_hi = text_hi - H; t2_lo = H ? n - H : (size_t)-1;
}
// Is image position i code? (parser on, atom T)
static bool in_text(size_t i) { return (i >= text_lo && i < t1_hi) || (i >= t2_lo && i < img_n); }
// File -> image (fwd) or image -> file: moves the hole to the end / back into place.
static std::vector<u8> permute(const std::vector<u8>& d, bool fwd) {
  size_t H = hole_hi - hole_lo, n = d.size(); if (!H) return d;
  std::vector<u8> o(n);
  for (size_t i = 0; i < n; ++i) {              // i = image position, f = file offset
    size_t f = i < hole_lo ? i : (i < n - H ? i + H : i - (n - H) + hole_lo);
    if (fwd) o[i] = d[f]; else o[f] = d[i];
  }
  return o;
}
// Address transform of the whole image. Each piece gets its own parser and the bias that
// turns its image positions back into file offsets, so that targets stay absolute file
// offsets whichever piece they are seen from. The model restarts its parser at the same
// places (Model::update). pkdec.c: the three unxform calls at the end of unpack().
static void xform_all(std::vector<u8>& t, bool fwd) {
  size_t H = hole_hi - hole_lo, n = t.size();
  if (!H) { xform(t, text_lo, text_hi, fwd); return; }
  xform(t, text_lo, hole_lo, fwd, 0);                 // code before the hole
  xform(t, hole_lo, t1_hi, fwd, H);                   // code after the hole (.fini)
  xform(t, n - H, n, fwd, hole_lo - (n - H));         // the hole itself
}

// APM / SSE stage: refines a probability given a small context. Per context, 33 points over
// stretch(p) (one per 128 units), each a 16-bit probability; the output is the linear
// interpolation between the two points around stretch(pr). Initially the identity map.
// Only the nearer of the two points (idx) is updated, at rate 1 / 2^apr. The target for a 1
// is a little above 65535 so that the shift, which rounds down, does not hold entries below
// the top of the range.
struct Apm {
  std::vector<u16> t; int idx = 0;
  void init(int n) { t.resize(n * 33); for (int i = 0; i < n; ++i) for (int j = 0; j < 33; ++j) t[i * 33 + j] = squash((j - 16) * 128) * 16; }
  int pp(int pr, int cx) {
    int s = stretch(pr) + 2048; int lo = s >> 7, w = s & 127; idx = cx * 33 + lo + (w >> 6);
    return (t[cx * 33 + lo] * (128 - w) + t[cx * 33 + lo + 1] * w) >> 11;
  }
  void update(int y) { int g = (y << 16) + (y << P.apr) - y - y; t[idx] += (g - t[idx]) >> P.apr; }
};

// The whole predictor. predict() returns P(next bit = 1) in 12 bits; update(y) adapts to the
// bit and, at the end of a byte, advances the parser, the match models and the atoms. The
// coder and the decoder make exactly the same sequence of calls.
struct Model {
  std::vector<u8> buf;         // history (transformed bytes)
  size_t pos = 0;              // bytes so far
  // c0 = the bits of the current byte so far below a leading 1 (1 = none); bpos = their number.
  // x = the instruction parser, fed the bytes of the code ranges.
  int c0 = 1, bpos = 0;
  X86 x;
  // Match models. ht maps a hash of the last minlen bytes to the position after their latest
  // occurrence; ptr = position of the byte predicted to come next; len = length of the match
  // behind it; exp = the byte predicted (-1: no prediction for this bit). sm[l][0] = how often
  // a prediction at length class l came true (16-bit probability); sm[0][1] holds the bit
  // predicted for the bit being coded; si = the class in use. sm2 is unused.
  struct MM { int minlen = 0; std::vector<u32> ht; u32 ptr = 0; int len = 0; int exp = -1; u16 sm[64][2]; int si = 0; u16 sm2[256 * 2]; } mm[2];
  // Mixer. in[] = the nin inputs of the current bit. Layer 1: NSEL weight sets; set i has
  // nsel_size[i] rows of MAXIN weights, the row is chosen by the selector sel[i], and its
  // output is p1[i]. Layer 2: w2, row chosen by sel2, inputs in2[] = the layer-1 outputs in the
  // stretch domain plus a constant. Weights are 16.16 fixed point. Nothing checks nin against
  // MAXIN: a config needs (2 + useB + conf) inputs per context (one fewer with hist 0) plus 5.
  enum { MAXIN = 160, NSEL = 6 };
  int in[MAXIN], nin = 0;
  std::vector<int> w1[NSEL]; int sel[NSEL], p1[NSEL], nsel_size[NSEL];
  std::vector<int> w2; int sel2 = 0, in2[NSEL + 1];
  // a1..a3 = the APM stages; pmix = the mixer's output; pr = the final probability.
  // atomv = the values of all atoms for the current byte.
  Apm a1, a2, a3; int pr = 2048, pmix = 2048;
  std::vector<u32> atomv;

  // Initial state for an image of n bytes: probabilities one half, layer-1 weights 0.25,
  // layer-2 weights 0.25, APMs the identity. pkdec.c unpack() sets up the same values.
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
  // B(i) = the byte i positions back (transformed image bytes), 0 before the start.
  // intext() = is the byte about to be coded inside a code range.
  u8 B(int i) const { return pos >= (size_t)i ? buf[pos - i] : 0; }
  bool intext() const { return in_text(pos); }

  // Atoms: the values a context can be made of. A "ctx" line lists atoms by the names in
  // ATOMS[] (below, same order as the case numbers); the context is the hash of their values.
  // Atoms are evaluated once per byte (byte_update), after the parser and the match models
  // have taken in the previous byte, so parser atoms describe the byte about to be coded.
  //   b1..b13, b16, b17, b24   the byte that many positions back
  //   b1h, b2h   the high four bits of b1 / b2
  //   F          field type of the next byte and its index within a displacement / immediate
  //   O          opcode of the current instruction with its map, 0 before the opcode byte
  //   M          ModRM of the current instruction + 1, 0 before it; Mm, Mr, Mg = its mod, rm
  //              and reg fields + 1
  //   S          SIB + 1, 0 if none yet
  //   X          hash of the prefix / REX / VEX bytes of the current instruction
  //   W          REX.W * 2 + operand-size prefix
  //   I          the bytes so far of the displacement / immediate being coded, and how many
  //   Z          sizes of the immediate and displacement of the current instruction
  //   K          2 = the field being coded is a RIP-relative displacement, 1 = a rel32 target
  //   N          number of bytes of the current instruction so far
  //   P1..P4     opcode (with map and operand-size flags) of the 1st..4th previous instruction
  //   p1o        the opcode byte alone of the previous instruction
  //   R, R2      ModRM + 1 of the previous instruction / the one before
  //   q4, q8, q16, q24   position modulo 4, 8, 16, 24 (aligned tables and records in data)
  //   pg         position / 4096: lets a context specialise in one region of the file
  //   T          1 inside the code ranges
  //   L          length of match model 1's current match, at most 32
  //   E, E2      expected byte + 1 of match model 1 / 2. Note the timing: exp is set by
  //              mm_predict() during the bits of a byte, and the atoms are taken before the
  //              first bit of the next byte, so E is what the match model expected for the byte
  //              just coded (0 if it had dropped out by its last bit), not for the next one.
  // The parser atoms keep their last values outside the code ranges only until update()
  // clears the parser there.
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
  // Once per byte: evaluate all atoms and hash each context's atom values (seeded with the
  // context's number so that equal atom lists still get different slots). The bits of the
  // current byte are added per bit in find().
  void byte_update() {
    atomv.resize(64);
    for (int a = 0; a < 47; ++a) atomv[a] = atom(a);
    for (auto& c : ctxs) {
      u32 h = 0x811c9dc5u + (u32)(&c - &ctxs[0]) * 0x01000193u;
      for (int a : c.atoms) { h = (h ^ atomv[a]) * 0x2f0b4d67u; h ^= h >> 15; h += a * 0x9e3779b1u; }
      c.h = h;
    }
  }
  // The slot of context c for the current bit: hash of (context hash, c0). The top tbits bits
  // index the table, 8 other bits are the check. No probing and no replacement policy: a slot
  // with a different check is reset and taken over.
  Slot* find(Ctx& c) {
    u32 xh = (c.h ^ (u32)c0 * 0x9e3779b1u) * 0x85ebca6bu; xh ^= xh >> 13; xh *= 0xc2b2ae35u;
    Slot* s = &c.t[xh >> (32 - P.tbits)]; u8 chk = (xh >> 3) & 255;
    if (s->chk != chk) { s->a = s->b = 32768; s->n = 0; s->chk = chk; s->h = 1; }
    return s;
  }
  // Match model, per bit. If there is a match and the predicted byte agrees with the bits of
  // this byte so far, give two inputs with the sign of the predicted bit: the stretched
  // measured hit rate of this length class, and a value that grows with the match length.
  // Length classes: 1..31, 32..63 -> 31, 64 and more -> 32. On the first wrong bit the match
  // is dropped (len = 0) and the inputs are 0 for the rest of the byte.
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
  // Match model, after the bit: move the hit rate of the length class used towards "was right".
  void mm_update(MM& m, int y) {
    if (m.minlen == 0) return;
    if (m.si >= 0) { int ok = (y == m.sm[0][1]); u16& p = m.sm[m.si][0]; p += ((ok << 16) - ok - p) >> 6; }
  }
  // Match model, after each byte. If the match continued, extend it. Then look up the hash of
  // the last minlen bytes: if there is no match, take the candidate from the table and count
  // how far it really agrees backwards (a candidate shorter than minlen is a hash collision
  // and is dropped). The table then points at the current position.
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
  // Prediction of one bit.
  int predict() {
    nin = 0;
    // 1. Inputs from the contexts. Per context, in this order: the bit-history map (if hist),
    //    stretch(a), stretch(b) (if useB), and a confidence input = stretch(a) scaled by 0,
    //    0.5, 1 or 1.5 according to the count (if conf). A slot that has seen nothing gives
    //    zeros. The history map is indexed by the slot's history and a count class
    //    (0, 1, 2..5, 6 or more).
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
    // 2. Two inputs from each match model, and a constant input (bias).
    mm_predict(mm[0]); mm_predict(mm[1]);
    in[nin++] = 256;
    // 3. Layer 1. One weighted sum of all inputs per selector set, the weight row chosen by:
    //      sel[0]  the bits of the current byte so far
    //      sel[1]  bit position and field type / index of the byte (fld)
    //      sel[2]  the previous byte
    //      sel[3]  match state (length class ml, predicted bit), bit position and, inside
    //              code, the field type
    //      sel[4]  the opcode of the current instruction (low 10 bits of atom O)
    //      sel[5]  ModRM of the current instruction and bit position
    //    Each sum is limited to +-2047 (stretch domain); p1[i] is its probability, kept for the
    //    weight update.
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
    // 4. Layer 2: mixes the layer-1 outputs (stretch domain) and a constant, with a weight
    //    row chosen by the bits of the current byte so far.
    in2[ns++] = 256;
    sel2 = c0;
    { int* w = &w2[sel2 * (NSEL + 1)]; long long s = 0; for (int j = 0; j < ns; ++j) s += (long long)in2[j] * w[j];
      int d = (int)(s >> 16); if (d > 2047) d = 2047; if (d < -2047) d = -2047; pmix = squash(d); }
    pr = pmix;
    // 5. APM stages on the mixer output, with contexts: a1 = partial byte and field type;
    //    a2 = partial byte and previous byte; a3 = hash of partial byte, opcode, ModRM, field
    //    type and index. Final probability = (2 pmix + q1 + q2 + 2 q3) / 6, rounded, kept
    //    inside 1..4094 so that the coder never gets a zero-width interval.
    if (P.apm) {
      int q1 = a1.pp(pmix, c0 + 256 * (x.st < 11 ? x.st : 11));
      int q2 = a2.pp(pmix, (c0 | B(1) << 8) & 0xffff);
      int q3 = a3.pp(pmix, ((c0 * 0x9e3779b1u) ^ (x.op * 0x2f0b4d67u) ^ ((x.modrm + 1) * 0x85ebca6bu) ^ (x.st * 0x1234567u + x.k * 77777u)) >> 16);
      pr = (2 * pmix + q1 + q2 + 2 * q3 + 3) / 6;
    }
    if (pr < 1) pr = 1; if (pr > 4094) pr = 4094;
    return pr;
  }
  // Adaptation to the coded bit y, in the order of the prediction; then the end-of-byte work.
  void update(int y) {
    // Slots: both counters, the count, the history map entry that was used, the history.
    for (auto& c : ctxs) {
      Slot* s = c.s; int t = y ? 65535 : 0;
      s->a += ((t - s->a) * rec_t[s->n]) >> 16; if (s->n < P.limA) ++s->n;
      s->b += (t - s->b) >> P.rateB;
      if (P.hist) { c.sm[c.smi] += (t - c.sm[c.smi]) >> P.hrate; int h = s->h << 1 | y; if (h >> P.hist > 1) h = (h & ((1 << P.hist) - 1)) | 1 << P.hist; s->h = h; }
    }
    mm_update(mm[0], y); mm_update(mm[1], y);
    // Mixer: for both layers, weight += input * (y - p) >> rate, with p in 12 bits; the rows
    // are the ones used for the prediction.
    int ns = 0;
    for (int i = 0; i < NSEL; ++i) {
      if (!(P.sel >> i & 1)) continue;
      int err = ((y << 12) - p1[i]); int* w = &w1[i][(size_t)(sel[i] % nsel_size[i]) * MAXIN];
      for (int j = 0; j < nin; ++j) w[j] += (in[j] * err) >> P.lr1 << 0;
      ++ns;
    }
    { int err = ((y << 12) - pmix); int* w = &w2[sel2 * (NSEL + 1)]; for (int j = 0; j <= ns; ++j) w[j] += (in2[j] * err) >> P.lr2; }
    if (P.apm) { a1.update(y); a2.update(y); a3.update(y); }
    // Shift the bit into the partial byte. At the end of a byte: store it; inside a code
    // range feed it to the parser, with a fresh parser at the start of each piece the address
    // transform treats separately (see xform_all); outside code keep the parser cleared; then
    // advance the match models and evaluate the atoms for the next byte.
    c0 = c0 << 1 | y; ++bpos;
    if (bpos == 8) {
      buf[pos++] = (u8)c0; bpos = 0; int c = c0 & 255; c0 = 1;
      if (in_text(pos - 1)) { if (pos - 1 == t2_lo || pos - 1 == hole_lo) x = X86(); x.feed(c); } else if (x.st != F_START || x.op) { x = X86(); }
      mm_byte(mm[0]); mm_byte(mm[1]);
      byte_update();
    }
  }
};

// ---------------------------------------------------------------- coder
// Binary arithmetic coder, 32-bit, carry-less (the range [x1, x2] is split in proportion to
// p = P(1) in 12 bits; 1 takes the lower part; leading bytes on which x1 and x2 agree are
// shifted out). The decoder keeps x = 4 stream bytes and reads zeros past the end of its input.
// pkdec.c has the Dec part inline in unpack().
struct Enc { u32 x1 = 0, x2 = 0xffffffff; std::vector<u8>* out;
  void code(int y, int p) { u32 xm = x1 + (u32)(((u64)(x2 - x1) * (u32)p) >> 12); y ? x2 = xm : x1 = xm + 1;
    while (((x1 ^ x2) & 0xff000000) == 0) { out->push_back(x2 >> 24); x1 <<= 8; x2 = x2 << 8 | 255; } }
  void flush() { out->push_back(x1 >> 24); out->push_back(x1 >> 16); out->push_back(x1 >> 8); out->push_back(x1); } };
struct Dec { u32 x1 = 0, x2 = 0xffffffff, x = 0; const u8* in; size_t n, i = 0;
  int get() { return i < n ? in[i++] : 0; }
  void init() { for (int k = 0; k < 4; ++k) x = x << 8 | get(); }
  int code(int p) { u32 xm = x1 + (u32)(((u64)(x2 - x1) * (u32)p) >> 12); int y = x <= xm; y ? x2 = xm : x1 = xm + 1;
    while (((x1 ^ x2) & 0xff000000) == 0) { x1 <<= 8; x2 = x2 << 8 | 255; x = x << 8 | get(); } return y; } };

// Atom names as used in "ctx" lines; the index is the case number in Model::atom().
static const char* ATOMS[] = {"b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "F", "O", "M", "P1", "P2", "P3", "X", "I", "R", "S",
  "q4", "q8", "q24", "T", "E", "L", "Mm", "Mr", "Mg", "N", "pg", "P4", "R2", "b1h", "b2h", "E2", "W", "Z", "q16",
  "b9", "b10", "b11", "b12", "b16", "b24", "b13", "b17", "K", "p1o"};

// Reads the config (format in the header of this file).
static void load_config(const char* fn) {
  FILE* f = fopen(fn, "r"); if (!f) { fprintf(stderr, "no config %s\n", fn); exit(1); }
  char line[1024];
  while (fgets(line, sizeof line, f)) {
    char a[64], b[900]; long long v, v2;
    if (sscanf(line, "text %lld %lld", &v, &v2) == 2) { text_lo = v; text_hi = v2; }
    else if (sscanf(line, "hole %lld %lld", &v, &v2) == 2) { hole_lo = v; hole_hi = v2; }
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
// Whole-file read / write.
static std::vector<u8> rd(const char* fn) { FILE* f = fopen(fn, "rb"); if (!f) { perror(fn); exit(1); } std::vector<u8> d; u8 b[65536]; size_t n;
  while ((n = fread(b, 1, sizeof b, f)) > 0) d.insert(d.end(), b, b + n); fclose(f); return d; }
static void wr(const char* fn, const std::vector<u8>& d) { FILE* f = fopen(fn, "wb"); fwrite(d.data(), 1, d.size(), f); fclose(f); }

int main(int argc, char** argv) {
  if (argc < 4) { fprintf(stderr, "usage: pk e|c|d CONFIG IN [OUT] [NDEC]\n"); return 1; }
  init_stretch(); init_optab(); load_config(argv[2]);
  for (int i = 0; i < 256; ++i) rec_t[i] = 131072 / (2 * i + 3);
  char mode = argv[1][0];
  std::vector<u8> d = rd(argv[3]);
  // Decompress: read the length, run the model with the decoder, then undo the address
  // transform and the hole permutation.
  if (mode == 'd') {
    // NDEC (optional): decode only the first NDEC image bytes (the decompressor's form: the hole,
    // which is coded last, stays zero). The input may then be the stream cut at "cut".
    size_t n = d[0] | d[1] << 8 | d[2] << 16 | (size_t)d[3] << 24; set_ranges(n);
    size_t ndec = argc > 5 ? (size_t)atoll(argv[5]) : n;
    Model m; m.init(n); Dec dc; dc.in = d.data() + 4; dc.n = d.size() - 4; dc.init();
    for (size_t i = 0; i < ndec * 8; ++i) m.update(dc.code(m.predict()));
    std::vector<u8> o(m.buf.begin(), m.buf.begin() + n);
    if (P.xform) xform_all(o, false);
    wr(argv[4], permute(o, false)); return 0;
  }
  // Compress or estimate: file -> image (hole to the end) -> address transform; check that
  // both steps invert exactly on this input; then code the image bit by bit, most significant
  // bit first. bits / tb / ob / hb add up the ideal code length in total, in code, outside
  // code and in the hole, for the report line only.
  set_ranges(d.size());
  std::vector<u8> t = permute(d, true); if (P.xform) xform_all(t, true);
  { std::vector<u8> chk = t; if (P.xform) xform_all(chk, false); if (permute(chk, false) != d) { fprintf(stderr, "transform not invertible\n"); return 1; } }
  Model m; m.init(t.size());
  std::vector<u8> out; size_t n = t.size(); out.push_back(n); out.push_back(n >> 8); out.push_back(n >> 16); out.push_back(n >> 24);
  Enc e; e.out = &out; double bits = 0, tb = 0, ob = 0, hb = 0; size_t cut = 0;
  for (size_t i = 0; i < n; ++i) {
    // The decoder has read 4 bytes more than the coder has written; everything before the hole
    // decodes from the first `cut` bytes of the output.
    if (i == t2_lo) cut = out.size() + 4;
    for (int b = 7; b >= 0; --b) {
      int y = (t[i] >> b) & 1, p = m.predict();
      double c = -log2((y ? p : 4096 - p) / 4096.0); bits += c; (i >= t2_lo ? hb : in_text(i) ? tb : ob) += c;
      e.code(y, p); m.update(y);
    }
  }
  e.flush();
  // No hole: the decompressor needs the whole stream.
  if (!cut || cut > out.size()) cut = out.size();
  printf("%zu -> %zu bytes (est %.0f; text %.0f other %.0f hole %.0f) ctx %zu inputs %d cut %zu\n", n, out.size(), bits / 8, tb / 8, ob / 8, hb / 8, ctxs.size(), m.nin, cut);
  if (mode == 'c') wr(argv[4], out);
  return 0;
}
