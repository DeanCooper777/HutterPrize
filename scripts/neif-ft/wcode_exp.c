// wcode_exp.c: testing tool, not part of any submitted program.
//
// Offline estimate of how much smaller the int4 weights of the cmix-neif 2.0 weight
// container could be coded.  Reads the decoded tensors (FX2TFW01 layout, written by
// wcode_breakdown.py as shipped.raw, tensors in the stored order of the container) and
// prints, per int4 tensor, the IDEAL code length (sum of -log2 p of an adaptive model that
// only looks at values a decoder would already have) of
//   base : the authors' model (ENC_INT4W: zero-row flag, 24 width buckets, 4-bit counting
//          trees, limit 4095, 11-bit probabilities, models shared by all tensors of a stream)
//   ord0 : the weight coder of our entry cmix-T-dwc (ENC_INTC: one 4-bit tree of KT counts
//          per tensor, no context, 12-bit probabilities)
//   mix  : logistic mixing of count models over the contexts selected by <mask> (see ctx[]
//          below), magnitude coded in unary decisions |q|>0, >1, ... then the sign.
// An ideal code length is not a working coder: the mixing here is in double precision.
//
//   wcode_exp <shipped.raw> <nA> <mask hex> [lr] [limit] [selmode] [scalefirst]
//     nA        number of tensors in stream A (the int4 models restart there)
//     mask      bit i set = context i is an input of the mixer
//     lr        mixer learning rate (default 0.02)
//     limit     count limit of the context counters (default 1023)
//     selmode   mixer weight set: 0 per node, 1 per node x coarse width (default 1)
//     scalefirst 1: contexts 11 may use the row scale (needs the scale tensor in front of
//               the weights in the file; default 0 = context 11 gives nothing)
// Output: one line per tensor (TSV), then sums per class.
// Build: gcc -O2 -o wcode_exp wcode_exp.c -lm      One core, well under 1 GB, seconds.
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  char name[200], canon[200];
  int dt, nd, blk;
  unsigned sh[4];
  size_t numel;
  unsigned char* data;
  int rows, cols, is4;
  double *rowmean, *colmean, M;  // filled when the tensor has been coded
  int* rowzero;
} T;

static T* ts;
static int nt;

static int dsize(int dt) { return dt == 0 ? 1 : dt == 1 ? 2 : 4; }

static void load(const char* path) {
  FILE* f = fopen(path, "rb");
  if (!f) { perror(path); exit(1); }
  char mg[8];
  uint32_t n;
  if (fread(mg, 1, 8, f) != 8 || memcmp(mg, "FX2TFW01", 8) || fread(&n, 4, 1, f) != 1) { fprintf(stderr, "bad raw file\n"); exit(1); }
  nt = (int)n;
  ts = calloc(nt, sizeof(T));
  for (int i = 0; i < nt; i++) {
    T* t = &ts[i];
    uint32_t nl, nd;
    unsigned char dt;
    fread(&nl, 4, 1, f);
    fread(t->name, 1, nl, f);
    fread(&dt, 1, 1, f);
    fread(&nd, 4, 1, f);
    t->dt = dt;
    t->nd = (int)nd;
    t->numel = 1;
    for (uint32_t d = 0; d < nd; d++) { fread(&t->sh[d], 4, 1, f); t->numel *= t->sh[d]; }
    t->data = malloc(t->numel * dsize(dt) + 1);
    if (fread(t->data, dsize(dt), t->numel, f) != t->numel) { fprintf(stderr, "short read\n"); exit(1); }
    t->rows = nd > 1 ? (int)t->sh[0] : 1;
    t->cols = t->rows ? (int)(t->numel / t->rows) : 0;
    t->is4 = dt == 0;
    if (t->is4) for (size_t k = 0; k < t->numel; k++) { int v = (int8_t)t->data[k]; if (v < -7 || v > 7) t->is4 = 0; }
    // canonical name: blocks.<n>. -> blocks.#.
    t->blk = -1;
    strcpy(t->canon, t->name);
    if (!strncmp(t->name, "blocks.", 7)) {
      const char* p = t->name + 7;
      int b = 0;
      while (*p >= '0' && *p <= '9') b = b * 10 + (*p++ - '0');
      if (*p == '.' && p > t->name + 7) { t->blk = b; snprintf(t->canon, sizeof t->canon, "blocks.#%s", p); }
    }
  }
  fclose(f);
}

static int find(const char* name) {
  for (int i = 0; i < nt; i++) if (!strcmp(ts[i].name, name)) return i;
  return -1;
}
static int ends(const char* s, const char* e) {
  size_t a = strlen(s), b = strlen(e);
  return a >= b && !strcmp(s + a - b, e);
}
static const char* klass(const T* t) {
  const char* c = t->canon;
  if (strstr(c, ".mlp.up.")) return "q mlp.up";
  if (strstr(c, ".mlp.down.")) return "q mlp.down";
  if (strstr(c, ".attention.")) return strstr(c, "gate_projection") ? "q attn gates" : "q attn q/k/v/out";
  return "q embeddings/other";
}

// ---- the authors' model -------------------------------------------------------------
typedef struct { uint16_t n0, n1; } CN;
static CN b_w[24 * 16], b_z;
static double cb(CN* n, int bit, unsigned limit) {
  uint32_t p = 2048u * n->n0 / ((uint32_t)n->n0 + n->n1);
  if (p < 1) p = 1; else if (p > 2047) p = 2047;
  double c = bit ? -log2(1.0 - p / 2048.0) : -log2(p / 2048.0);
  if (bit) n->n1++; else n->n0++;
  if ((uint32_t)n->n0 + n->n1 > limit) { n->n0 = n->n0 >> 1 ? n->n0 >> 1 : 1; n->n1 = n->n1 >> 1 ? n->n1 >> 1 : 1; }
  return c;
}
// variant of the authors' model (same coder, other constants; environment, see main):
// replaces the ord0 column when W_VAR=1
static CN* v_w;
static int v_on, v_arow = 64, v_acol = 64, v_limit = 4095, v_kind = 0, v_nb = 24, v_step = 8, v_fresh = 0;
static void var_reset(void) {
  if (!v_w) v_w = malloc(sizeof(CN) * 256 * 64 * 16);
  for (int i = 0; i < 256 * 64 * 16; i++) v_w[i].n0 = v_w[i].n1 = 1;
}
static void base_reset(void) {
  for (int i = 0; i < 24 * 16; i++) b_w[i].n0 = b_w[i].n1 = 1;
  b_z.n0 = b_z.n1 = 1;
  var_reset();
}
static int envi(const char* k, int d) { const char* v = getenv(k); return v ? atoi(v) : d; }

// ---- mixing model -------------------------------------------------------------------
#define NCTX 16
#define NODES 8  // 0..6: |q| > d, 7: sign
static const int ctxsize[NCTX] = {24, 64, 64, 64, 24 * 24, 9 * 9 * 6, 29 * 8, 29 * 8, 0 /*set at run time*/, 9 * 24, 25 * 24, 33 * 6, 25 * 24, 25 * 24, 1, 64 * 3};
static const char* ctxname[NCTX] = {
    "0 authors' bucket b", "1 fine log width (A=64)", "2 fine log width (A=16)", "3 fine log width (A=4)",
    "4 row width x column width (A=16)", "5 |left| x |up| x coarse b", "6 sum |q| last 4 in row x column width",
    "7 sum |q| last 4 rows in column x row width", "8 tensor kind x b", "9 |q| same place previous layer x b",
    "10 partner unit width x row width", "11 row scale (relative) x coarse b", "12 previous layer column width x row width",
    "13 previous layer row width x column width", "14 no context", "15 fine log width (A=64) x position in row"};
typedef struct { float n0, n1; } FN;
static FN* tab[NCTX];
static int tabsize[NCTX];
static double* mw;  // mixer weights
static int nsel;
static unsigned mask;
static double lr = 0.02;
static float climit = 1023;
static int selmode = 1, scalefirst = 0;
static int ncanon;
static char canons[256][200];

static int canon_id(const char* c) {
  for (int i = 0; i < ncanon; i++) if (!strcmp(canons[i], c)) return i;
  strcpy(canons[ncanon], c);
  return ncanon++;
}
static inline int lq8(double x) {  // 1/8 octave, 64 levels
  int q = (int)floor(8.0 * log2(x > 1e-9 ? x : 1e-9)) + 40;
  return q < 0 ? 0 : q > 63 ? 63 : q;
}
static inline int lq4(double x) {  // 1/4 octave, 24 levels
  int q = (int)floor(4.0 * log2(x > 1e-9 ? x : 1e-9)) + 12;
  return q < 0 ? 0 : q > 23 ? 23 : q;
}
static inline double stretch(double p) { return log(p / (1.0 - p)); }
static inline double squash(double x) { return 1.0 / (1.0 + exp(-x)); }

static void mix_reset(void) {
  for (int i = 0; i < NCTX; i++) {
    if (!tab[i]) { tabsize[i] = (i == 8 ? 256 * 24 : ctxsize[i]) * NODES; tab[i] = malloc(sizeof(FN) * tabsize[i]); }
    for (int k = 0; k < tabsize[i]; k++) tab[i][k].n0 = tab[i][k].n1 = 0;
  }
  nsel = NODES * 6;
  if (!mw) mw = malloc(sizeof(double) * nsel * (NCTX + 1));
  int nin = 0;
  for (int i = 0; i < NCTX; i++) nin += (mask >> i) & 1;
  for (int s = 0; s < nsel; s++) {
    for (int i = 0; i < NCTX; i++) mw[s * (NCTX + 1) + i] = 1.0 / (nin ? nin : 1);
    mw[s * (NCTX + 1) + NCTX] = 0;
  }
}

// code one binary decision; idx[i] = slot of context i (already includes the node)
static inline double mix_bit(const int* idx, int sel, int bit) {
  double st[NCTX], dot;
  double* w = &mw[sel * (NCTX + 1)];
  dot = w[NCTX] * 0.25;
  for (int i = 0; i < NCTX; i++) if ((mask >> i) & 1) {
    FN* c = &tab[i][idx[i]];
    double p = (c->n1 + 0.4) / (c->n0 + c->n1 + 0.8);
    st[i] = stretch(p);
    dot += w[i] * st[i];
  }
  if (dot > 12) dot = 12; else if (dot < -12) dot = -12;
  double p = squash(dot);
  if (p < 1.0 / 4096) p = 1.0 / 4096; else if (p > 1 - 1.0 / 4096) p = 1 - 1.0 / 4096;
  double cost = -log2(bit ? p : 1 - p), err = (bit - p) * lr;
  w[NCTX] += err * 0.25;
  for (int i = 0; i < NCTX; i++) if ((mask >> i) & 1) {
    w[i] += err * st[i];
    FN* c = &tab[i][idx[i]];
    if (bit) c->n1 += 1; else c->n0 += 1;
    if (c->n0 + c->n1 > climit) { c->n0 *= 0.5f; c->n1 *= 0.5f; }
  }
  return cost;
}

static double bf16(const unsigned char* p) {
  uint32_t u = ((uint32_t)p[0] | ((uint32_t)p[1] << 8)) << 16;
  float f;
  memcpy(&f, &u, 4);
  return f;
}

typedef struct { const char* k; double n, base, ord0, mix; int cnt; } Sum;
static Sum sums[8];
static int nsums;

int main(int argc, char** argv) {
  if (argc < 4) { fprintf(stderr, "usage: wcode_exp <shipped.raw> <nA> <mask hex> [lr] [limit] [selmode] [scalefirst]\n"); return 2; }
  load(argv[1]);
  int nA = atoi(argv[2]);
  mask = (unsigned)strtoul(argv[3], 0, 16);
  if (argc > 4) lr = atof(argv[4]);
  if (argc > 5) climit = (float)atof(argv[5]);
  if (argc > 6) selmode = atoi(argv[6]);
  if (argc > 7) scalefirst = atoi(argv[7]);
  v_on = envi("W_VAR", 0); v_arow = envi("W_AROW", 64); v_acol = envi("W_ACOL", 64); v_limit = envi("W_LIMIT", 4095);
  v_kind = envi("W_KIND", 0); v_nb = envi("W_NB", 24); v_step = envi("W_STEP", 8); v_fresh = envi("W_FRESH", 0);
  if (v_on) printf("# ord0 column = authors' model with AROW %d ACOL %d limit %d trees per kind %d NB %d step 1/%d fresh per tensor %d\n", v_arow, v_acol, v_limit, v_kind, v_nb, v_step, v_fresh);
  base_reset();
  mix_reset();
  printf("# mask %x lr %g limit %g selmode %d scalefirst %d; contexts:", mask, lr, climit, selmode, scalefirst);
  for (int i = 0; i < NCTX; i++) if ((mask >> i) & 1) printf(" [%s]", ctxname[i]);
  printf("\nname\trows\tcols\tzero_rows\tbase_bits\tord0_bits\tmix_bits\n");
  double tb = 0, to = 0, tm = 0, tn = 0;
  for (int ti = 0; ti < nt; ti++) {
    T* t = &ts[ti];
    if (ti == nA) { base_reset(); mix_reset(); }
    if (!t->is4) continue;
    int R = t->rows, C = t->cols;
    const int8_t* q = (const int8_t*)t->data;
    t->rowmean = calloc(R, sizeof(double));
    t->colmean = calloc(C, sizeof(double));
    t->rowzero = calloc(R, sizeof(int));
    // partner (hidden units: column j of this tensor = row j of the partner, coded before)
    int pi = -1;
    char nm[220];
    if (ends(t->name, ".down.weight.q")) {
      strcpy(nm, t->name);
      strcpy(nm + strlen(nm) - strlen(".down.weight.q"), ".up.weight.q");
      pi = find(nm);
    } else if (ends(t->name, "attention.output_projection.weight.q")) {
      strcpy(nm, t->name);
      strcpy(nm + strlen(nm) - strlen("output_projection.weight.q"), "value_projection.weight.q");
      pi = find(nm);
    }
    if (pi >= 0 && (pi >= ti || !ts[pi].rowmean || C % ts[pi].rows)) pi = -1;
    // the same tensor of the nearest earlier layer with the same shape
    int li = -1;
    if (t->blk > 0)
      for (int k = ti - 1; k >= 0; k--)
        if (ts[k].is4 && ts[k].blk >= 0 && ts[k].blk < t->blk && !strcmp(ts[k].canon, t->canon) && ts[k].rows == R && ts[k].cols == C && ts[k].rowmean) { li = k; break; }
    // the row scales (context 11, only with scalefirst)
    int si = -1;
    if (scalefirst && ends(t->name, ".weight.q")) {
      strcpy(nm, t->name);
      strcpy(nm + strlen(nm) - 1, "scale");
      si = find(nm);
      if (si >= 0 && (ts[si].dt != 1 || (int)ts[si].numel != R)) si = -1;
    }
    const int cid = canon_id(t->canon);
    // authors' state
    uint64_t* cs = calloc(C, sizeof(uint64_t));
    uint64_t n = 0, Tt = 0, N = 0;
    // ord0 state (KT counts, 4-bit tree, 12-bit probability)
    uint32_t o0[16] = {0}, o1[16] = {0};
    double bbits = 0, obits = 0, mbits = 0, slog = 0, vbits = 0;
    if (v_on && v_fresh) var_reset();
    int ns = 0, zr = 0;
    for (int r = 0; r < R; r++) {
      const int8_t* row = q + (size_t)r * C;
      int zero = 1;
      for (int k = 0; k < C; k++) if (row[k]) { zero = 0; break; }
      double zc = cb(&b_z, zero, 1023);
      bbits += zc;
      vbits += zc;
      mbits += zc;  // the mixing model keeps the authors' zero-row flag
      double ls = 0;
      if (si >= 0) { double s = bf16(ts[si].data + 2 * r); ls = log2(s > 1e-30 ? s : 1e-30); }
      if (zero) { t->rowzero[r] = 1; zr++; continue; }
      int sq = 32;  // scale context: log2 scale of this row against the mean of the coded rows above
      if (si >= 0 && ns > 0) { int d = (int)floor(4.0 * (ls - slog / ns) + 16.5); sq = d < 0 ? 0 : d > 31 ? 31 : d; }
      uint64_t rs = 0;
      for (int k = 0; k < C; k++) {
        const int v = row[k], a = v < 0 ? -v : v;
        // ---- ord0 (our entry's coder; zero rows are coded like any other row there)
        // ---- base
        uint64_t M = (Tt * 65536 + 64 * 190054) / (N + 64);
        if (M < 1) M = 1;
        uint64_t rr = (rs * 65536 + 64 * M) / (k + 64);
        uint64_t cc = (cs[k] * 65536 + 64 * M) / (n + 64);
        uint64_t b = (8 * rr * cc) / (M * 65536);
        b = b < 8 ? 0 : (b > 8 + 23 ? 23 : b - 8);
        {
          uint32_t node = 1, sym = (uint32_t)(v + 7);
          for (int j = 3; j >= 0; j--) {
            int bit = (sym >> j) & 1;
            bbits += cb(&b_w[b * 16 + node], bit, 4095);
            node = (node << 1) | bit;
          }
        }
        if (v_on) {  // the variant: same formula, other constants
          uint64_t r2 = (rs * 65536 + (uint64_t)v_arow * M) / (k + v_arow);
          uint64_t c2 = (cs[k] * 65536 + (uint64_t)v_acol * M) / (n + v_acol);
          int64_t b2 = (int64_t)(((uint64_t)v_step * r2 * c2) / (M * 65536)) - v_step * 3 / 4;
          if (v_nb == 24 && v_step == 8) b2 = (int64_t)((8 * r2 * c2) / (M * 65536)) - 8;
          b2 = b2 < 0 ? 0 : b2 > v_nb - 1 ? v_nb - 1 : b2;
          CN* tr = &v_w[((size_t)(v_kind ? cid : 0) * 64 + b2) * 16];
          uint32_t node = 1, sym = (uint32_t)(v + 7);
          for (int j = 3; j >= 0; j--) {
            int bit = (sym >> j) & 1;
            vbits += cb(&tr[node], bit, v_limit);
            node = (node << 1) | bit;
          }
        }
        // ---- mix
        if (mask) {
          const double Mf = (Tt + 64 * 2.9) / (N + 64.0);
          const double r64 = (rs + 64 * Mf) / (k + 64.0), r16 = (rs + 16 * Mf) / (k + 16.0), r4 = (rs + 4 * Mf) / (k + 4.0);
          const double c64 = (cs[k] + 64 * Mf) / (n + 64.0), c16 = (cs[k] + 16 * Mf) / (n + 16.0), c4 = (cs[k] + 4 * Mf) / (n + 4.0);
          const int left = k ? row[k - 1] : 8, up = r && !t->rowzero[r - 1] ? row[k - C] : 8;
          const int al = left == 8 ? 8 : abs(left), au = up == 8 ? 8 : abs(up);
          int sl = 0, su = 0;
          for (int j = 1; j <= 4; j++) {
            if (k >= j) sl += abs(row[k - j]);
            if (r >= j) su += abs(row[k - j * C]);
          }
          const int bc = (int)b / 4, qr = lq4(r16 / Mf), qc = lq4(c16 / Mf);
          int base[NCTX], bsign[NCTX];
          base[0] = (int)b;
          base[1] = lq8(r64 * c64 / Mf / 2.9 * 2.0);
          base[2] = lq8(r16 * c16 / Mf / 2.9 * 2.0);
          base[3] = lq8(r4 * c4 / Mf / 2.9 * 2.0);
          base[4] = qr * 24 + qc;
          base[5] = (al * 9 + au) * 6 + bc;
          base[6] = sl * 8 + lq4(c64 / Mf) / 3;
          base[7] = su * 8 + lq4(r64 / Mf) / 3;
          base[8] = cid * 24 + (int)b;
          base[9] = (li >= 0 ? abs((int8_t)ts[li].data[(size_t)r * C + k]) : 8) * 24 + (int)b;
          base[10] = (pi >= 0 ? (ts[pi].rowzero[k % ts[pi].rows] ? 0 : 1 + lq4(ts[pi].rowmean[k % ts[pi].rows] / ts[pi].M)) : 0) * 24 + qr;
          if (pi < 0) base[10] = 24 * 24 + qr;
          base[11] = sq * 6 + bc;
          base[12] = (li >= 0 ? 1 + lq4(ts[li].colmean[k] / ts[li].M) : 0) * 24 + qr;
          base[13] = (li >= 0 ? (ts[li].rowzero[r] ? 0 : 1 + lq4(ts[li].rowmean[r] / ts[li].M)) : 0) * 24 + qc;
          base[14] = 0;
          base[15] = base[1] * 3 + (k < 16 ? 0 : k < 64 ? 1 : 2);
          memcpy(bsign, base, sizeof base);
          // the sign node sees the neighbours' signs instead of their magnitudes
          bsign[5] = ((left == 8 ? 8 : left > 0 ? 1 : left < 0 ? 2 : 0) * 9 + (up == 8 ? 8 : up > 0 ? 1 : up < 0 ? 2 : 0)) * 6 + bc;
          bsign[9] = (li >= 0 ? ((int8_t)ts[li].data[(size_t)r * C + k] > 0 ? 1 : (int8_t)ts[li].data[(size_t)r * C + k] < 0 ? 2 : 0) : 8) * 24 + (int)b;
          int idx[NCTX];
          for (int d = 0; d < 7; d++) {
            int bit = a > d;
            for (int i = 0; i < NCTX; i++) idx[i] = base[i] * NODES + d;
            mbits += mix_bit(idx, selmode ? d * 6 + bc : d, bit);
            if (!bit) break;
          }
          if (a) {
            for (int i = 0; i < NCTX; i++) idx[i] = bsign[i] * NODES + 7;
            mbits += mix_bit(idx, selmode ? 7 * 6 + bc : 7, v < 0);
          }
        }
        rs += a;
        cs[k] += a;
        Tt += a;
        N++;
      }
      t->rowmean[r] = (double)rs / C;
      n++;
      if (si >= 0) { slog += ls; ns++; }
    }
    // ord0 over all values (zero rows included, as in our entry)
    for (size_t k = 0; k < t->numel; k++) {
      uint32_t node = 1, sym = (uint32_t)(q[k] + 7);
      for (int j = 3; j >= 0; j--) {
        int bit = (sym >> j) & 1;
        uint32_t p = (uint32_t)(((uint64_t)(2 * o0[node] + 1) << 12) / (2 * (o0[node] + o1[node]) + 2));
        if (p < 1) p = 1; else if (p > 4095) p = 4095;
        obits += bit ? -log2(1.0 - p / 4096.0) : -log2(p / 4096.0);
        if (bit) o1[node]++; else o0[node]++;
        node = (node << 1) | bit;
      }
    }
    if (v_on) obits = vbits;
    for (int k = 0; k < C; k++) t->colmean[k] = n ? (double)cs[k] / n : 0;
    t->M = N ? (double)Tt / N : 1;
    if (t->M <= 0) t->M = 1;
    free(cs);
    printf("%s\t%d\t%d\t%d\t%.1f\t%.1f\t%.1f\n", t->name, R, C, zr, bbits, obits, mbits);
    const char* kl = klass(t);
    int s;
    for (s = 0; s < nsums; s++) if (!strcmp(sums[s].k, kl)) break;
    if (s == nsums) { sums[nsums++].k = kl; }
    sums[s].n += t->numel; sums[s].base += bbits; sums[s].ord0 += obits; sums[s].mix += mbits; sums[s].cnt++;
    tb += bbits; to += obits; tm += mbits; tn += t->numel;
  }
  printf("# %-22s %4s %9s %12s %12s %12s %10s %8s\n", "class", "n", "weights", "base B", "ord0 B", "mix B", "mix-base B", "%");
  for (int s = 0; s < nsums; s++)
    printf("# %-22s %4d %9.0f %12.1f %12.1f %12.1f %10.1f %8.3f\n", sums[s].k, sums[s].cnt, sums[s].n, sums[s].base / 8, sums[s].ord0 / 8, sums[s].mix / 8,
           (sums[s].mix - sums[s].base) / 8, 100 * (sums[s].mix - sums[s].base) / sums[s].base);
  printf("# %-22s %4s %9.0f %12.1f %12.1f %12.1f %10.1f %8.3f\n", "TOTAL int4", "", tn, tb / 8, to / 8, tm / 8, (tm - tb) / 8, 100 * (tm - tb) / tb);
  return 0;
}
