/* neif_cost.c: runs the cmix-neif 2.0 packer model (tools_src/packer/cm_core.h, unchanged, included
 * from a copy) over an image and reports the stream size, the cut for a prefix, and the ideal code
 * length of every byte.
 * Testing tool for the packer trial; not part of any submitted program.
 *
 *   neif_cost IMG ND COSTFILE [S2BIN S2TEXT]
 * IMG      the image as the packer receives it (address transform is applied here, as pack_tool xform)
 * ND       prefix length: K = stream bytes the decoder needs for the first ND bytes
 * COSTFILE float32 per input byte, bits ("-" = none)
 * S2BIN S2TEXT  warm-up on the flat stage-2 image as the shipped packer does it (pack_tool warm)
 * Environment CR="LO HI VADJ": one code range given by hand instead of the executable PT_LOADs of the
 * ELF header (for an image whose code segment also holds headers and constants).
 * Prints: stream K est_bytes
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "cm_core.h"
#include "x86t.h"

static unsigned char *rd(const char *p, size_t *n) {
  FILE *f = fopen(p, "rb"); long L; unsigned char *b;
  if (!f) { perror(p); exit(2); }
  fseek(f, 0, SEEK_END); L = ftell(f); fseek(f, 0, SEEK_SET);
  b = malloc(L + 64); if (fread(b, 1, L, f) != (size_t)L) exit(2); fclose(f);
  memset(b + L, 0, 64); *n = L; return b;
}
static long o_lo, o_hi, o_va; static int o_on;
static void set_override(void) { cm_ncr = 1; cm_cr_lo[0] = o_lo; cm_cr_hi[0] = o_hi; cm_cr_va[0] = o_va; cm_crdone = 1; }

int main(int c, char **v) {
  size_t n, nd, i, ke = 0, cl; unsigned char *b, *r, *out = malloc(CM_MAXBUF + 65536); float *cost; double tot = 0;
  cm_ac a; int bb, j;
  if (c < 4) { fprintf(stderr, "neif_cost IMG ND COSTFILE [S2BIN S2TEXT]\n"); return 2; }
  b = rd(v[1], &n); nd = strtoull(v[2], 0, 10); r = malloc(n); memcpy(r, b, n); cost = calloc(n, sizeof(float));
  if (getenv("CR")) { sscanf(getenv("CR"), "%ld %ld %ld", &o_lo, &o_hi, &o_va); o_on = 1; }
  /* forward address transform, as pack_tool xform, and its inverse as a check */
  if (o_on) set_override(); else cm_elf_ranges(b, n);
  if (!getenv("NOXFORM")) {
    unsigned char *k = malloc(n);
    for (j = 0; j < cm_ncr; ++j)
      if (cm_cr_lo[j] < (long)n)
        x86t_range(b, cm_cr_lo[j], cm_cr_hi[j] < (long)n ? cm_cr_hi[j] : (long)n, cm_cr_va[j], (int)PV(xt) >> 1, +1);
    memcpy(k, b, n);
    for (j = 0; j < cm_ncr; ++j)
      if (cm_cr_lo[j] < (long)n)
        x86t_range(k, cm_cr_lo[j], cm_cr_hi[j] < (long)n ? cm_cr_hi[j] : (long)n, cm_cr_va[j], (int)PV(xt) >> 1, -1);
    if (memcmp(k, r, n)) { fprintf(stderr, "xform not invertible\n"); return 4; }
    free(k);
  }
  /* the model must start as in pack_tool compress (a separate process there): no ranges known yet;
   * cm_cr_lo[0] = 0 matters for the warm-up, whose code range is [0, S2TEXT) */
  cm_ncr = 0; cm_cr_lo[0] = 0; cm_crdone = 0;
  fprintf(stderr, "ranges=%d", cm_ncr); for (j = 0; j < cm_ncr; ++j) fprintf(stderr, " [%ld,%ld)", cm_cr_lo[j], cm_cr_hi[j]); fprintf(stderr, "\n");
  if (c > 5) {   /* warm-up data: the flat stage-2 image, code address-transformed (pack_tool warm) */
    size_t wn; unsigned char *w = rd(v[4], &wn);
    cm_wt = strtol(v[5], 0, 0); cm_wn = wn;
    x86t_range(w, 0, cm_wt, CM_WARM_VA, (int)PV(xt) >> 1, +1);
    cm_wp = w;
  }
  if (!cm_model_init()) return 5;
  if (CM_WARM_P) cm_warm();
  if (o_on) set_override();
  cm_ac_enc_init(&a, out);
  for (i = 0; i < n; ++i) {
    if (i == nd) ke = a.outn + 4;
    for (bb = 7; bb >= 0; --bb) {
      int bit = (b[i] >> bb) & 1, p = cm_predict(); double q = (bit ? p : (PV(p16) ? 65536 : 4096) - p) / (PV(p16) ? 65536.0 : 4096.0);
      if (q < 1e-9) q = 1e-9;
      cost[i] -= (float)log2(q); tot -= log2(q);
      cm_ac_encode(&a, bit, p); cm_update(bit);
    }
  }
  cl = cm_ac_enc_flush(&a); if (!ke || ke > cl) ke = cl;
  if (strcmp(v[3], "-")) { FILE *f = fopen(v[3], "wb"); fwrite(cost, 4, n, f); fclose(f); }
  printf("%zu %zu %.0f\n", cl, ke, tot / 8);
  return 0;
}
