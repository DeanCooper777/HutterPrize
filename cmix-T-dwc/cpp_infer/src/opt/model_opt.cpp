// TransformerOpt implementation. Wiring order matches SPEC section 3.3 and
// the arena stream order of arena_build.cpp exactly.
//
// Profiling (-DFX2_PROF): raw rdtsc (no lfence/rdtscp — the ~67-cycle
// serialized stamp would distort short sections; raw back-to-back stamps
// measure ~10-20 core cycles) section accumulators, one per call site,
// aggregated into the four SPEC section-9 groups at print time and
// overhead-corrected by the measured empty-section delta.
//
// What this file is: the forward pass of the transformer byte model as cmix
// runs it. One call of step() takes the current symbol (a byte of the
// preprocessed, dictionary-coded text; 205 distinct values) and the PPMD
// model's probabilities for it as a "prior", and returns the transformer's
// probabilities for the NEXT symbol. cmix (src/predictor.cpp) feeds those
// into its mixers, then SSE, then the arithmetic coder. Compressor and
// decompressor run this same code on the same inputs and must get the same
// bits out, which is why every kernel is either exact integer arithmetic or a
// fixed sequence of single IEEE operations.
//
// The forward pass, with the kernel that serves each matrix. "8" = 8-bit
// input (the previous winner's kernels, qmat_dense.h / qmat_sparse.h), "16" =
// [this entry] 16-bit input (act16.h), as selected by the default
// CMIX_ACT16 = 15:
//   input   x = tok_table[token] + rms_norm(prior_embedding(prior))
//             prior_embedding 192x205   8  qsparse4_f32 (sparse columns)
//   layers l = 0..11 (9 Kimi linear-attention layers, 3 vanilla: 3, 7, 11):
//     x += skip_w * (output of layer 11-l)           (layers 6..11 only)
//     x  = rsc[l] * x + tec[l] * tok                 (token connection)
//     xn = rms_norm(x)
//     q, k, v = Q(xn), K(xn), V(xn)   3 x 192x192   16  gemv16p_set
//     Kimi layer:
//       forget gate  192->64->192      8  qgemv_quant_bias, qgemv_f32
//       output gate  192->64->192      8  qgemv_quant_bias, qgemv_f32
//       beta         3x192 fp32           dot192
//       conv+silu, state update, gated norm:  kda_layer_step (kda.h)
//     vanilla layer:
//       per-head rms_norm of q and k, RoPE, 8-bit q/k/v, KV ring insert,
//       softmax over the last 1024 positions: attn_step_var / _fixed (attn.h)
//     x += O(attention output)         192x192      16  gemv16p_add
//     xn = rms_norm(x)
//     h  = relu(up(xn))^2              768x192      16  gemv16p_set
//     x += down(h)                     192x768      16  spmv16p_add (sparse)
//   output  logits = unembed(rms_norm(x))  205x192   8  qgemv_f32
//           probs  = softmax(15 * tanh(logits / 15))    head_softcap_softmax
//
// Testing: test_e2e_opt (loss on the 1024-article test set against the Python
// reference), test_xcheck (against the naive src/model.cpp), bench_opt /
// bench_opt_prof (-DFX2_PROF profile below). CMIX_ACT16=0 gives the previous
// winner's all-8-bit forward pass.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
// - [this entry] 16-bit activation inputs for the q/k/v projections, the
//   attention output projection, mlp.up and mlp.down (act16.h): the same
//   weights with 256 times finer input rounding predict better, so the
//   archive is smaller.
// - [this entry] the weights can be shared between instances (ShareWeights),
//   for the multi-core experiment mode CMIX_PIPE (never in the submission).
// - [this entry] last_hidden() and the MLP activation capture: inputs for the
//   online adaptation of the output layer in src/predictor.cpp.
// - [this entry] FX2_DMLP: compile-time MLP width for experiments.

#include "model_opt.h"

#include <immintrin.h>

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <vector>

#include "act16.h"
#include "arena_build.h"
#include "attn.h"
#include "glue.h"
#include "kda.h"
#include "kda_math.h"
#include "qmat_dense.h"
#include "qmat_sparse.h"

// Debug-only component isolation for the naive-vs-opt cross-check (never
// defined in the production build targets): swap the fused KDA step and/or
// the attention kernel for the naive path (bit-exact vs src/model.cpp) to
// attribute divergence per component.
#if defined(FX2_XCHECK_NAIVE_KDA) || defined(FX2_XCHECK_NAIVE_ATTN)
#include "../kernels.h"
#endif

#ifndef FX2_DMLP
#define FX2_DMLP 768  // MLP width; phase 2 builds use -DFX2_DMLP=384/512
#endif
namespace fx2 {
namespace opt {

namespace {
constexpr int V = 205, D = 192, NL = 12, DH = 64, NH = 3, DMLP = FX2_DMLP;
constexpr int WIN = 1024, ROPE_LEN = 131072;
// density thresholds for the sparse column kernels (qmat.h)
constexpr int DOWN_DENSE_NNZ =
    static_cast<int>(QMAT_SPARSE_DENSITY_THRESHOLD * DMLP);  // 729 at width 768
constexpr int PRIOR_DENSE_NNZ =
    static_cast<int>(QMAT_SPARSE_DENSITY_THRESHOLD * V);  // 194

// beta projection: 3x192 fp32 matvec on xn. Bit-identical to the naive
// fx2::dot_f32(xn, w, 192) (same 8-wide fmadd chain + hsum tree).
inline float dot192(const float* a, const float* b) {
  __m256 acc = _mm256_setzero_ps();
  for (int i = 0; i < 192; i += 8)
    acc = _mm256_fmadd_ps(_mm256_loadu_ps(a + i), _mm256_loadu_ps(b + i), acc);
  return hsum256v(acc);
}
}  // namespace

// ---------------------------------------------------------------------------
// profiling sites
// ---------------------------------------------------------------------------
namespace {

enum PSite : int {
  // group 0: int4 x int8 matmuls (ALL arenas)
  PS_MM_PRIOR = 0,
  PS_MM_KQKV,
  PS_MM_GUP,
  PS_MM_GDN,
  PS_MM_KOP,
  PS_MM_VQKV,
  PS_MM_VOP,
  PS_MM_MLP_UP,
  PS_MM_MLP_DOWN,
  PS_MM_UNEMB,
  // group 1: vanilla attention mechanism
  PS_AT_INSERT,
  PS_AT_STEP,
  // group 2: kimi linear attention mechanism
  PS_KD_BETA,
  PS_KD_STEP,
  // group 3: everything else
  PS_EL_PRIORQ,
  PS_EL_EMBED,
  PS_EL_RESID,
  PS_EL_NQ_KIMI,
  PS_EL_NQ_VAN,
  PS_EL_NQ_MLP,
  PS_EL_NQ_FIN,
  PS_EL_HEADPREP,
  PS_EL_OQ,
  PS_EL_HEAD,
  PS_N
};

#ifdef FX2_PROF
struct PSiteInfo {
  const char* name;
  int group;
};
const PSiteInfo kPSites[PS_N] = {
    {"prior spmv (int4 cols)", 0},
    {"kimi q/k/v proj (27)", 0},
    {"gate up (fg+og, 18)", 0},
    {"gate down (fg+og, 18)", 0},
    {"kimi out proj (9)", 0},
    {"van q/k/v proj (9)", 0},
    {"van out proj (3)", 0},
    {"mlp up + relu2q (12)", 0},
    {"mlp down spmv (12)", 0},
    {"unembed (1)", 0},
    {"kv insert (3)", 1},
    {"attn step qk+sm+pv (3)", 1},
    {"beta matvec (9)", 2},
    {"kda fused step (9)", 2},
    {"prior quant+idx", 3},
    {"embed combine", 3},
    {"resid/skip/tok ops", 3},
    {"norm+quant kimi (9)", 3},
    {"norm+quant van (3)", 3},
    {"norm+quant mlp (12)", 3},
    {"final norm+quant", 3},
    {"head-prep norm/rope/q (3)", 3},
    {"attnout quant (12)", 3},
    {"softcap+softmax head", 3},
};
const char* kGroups[4] = {"int4xint8 matmuls", "vanilla attention mechanism",
                          "kimi (KDA) mechanism", "everything else"};

inline uint64_t prof_rdtsc() {
  unsigned lo, hi;
  asm volatile("rdtsc" : "=a"(lo), "=d"(hi)::"memory");
  return (static_cast<uint64_t>(hi) << 32) | lo;
}
uint64_t g_pacc[PS_N] = {};
uint64_t g_pcalls[PS_N] = {};
struct PScope {
  int s;
  uint64_t t0;
  explicit PScope(int s_) : s(s_), t0(prof_rdtsc()) {}
  ~PScope() {
    g_pacc[s] += prof_rdtsc() - t0;
    g_pcalls[s]++;
  }
};
#define PSCOPE(site) PScope pscope_(site)
#else
#define PSCOPE(site) \
  do {               \
  } while (0)
#endif

}  // namespace

void prof_reset() {
#ifdef FX2_PROF
  std::memset(g_pacc, 0, sizeof(g_pacc));
  std::memset(g_pcalls, 0, sizeof(g_pcalls));
#endif
}

bool prof_enabled() {
#ifdef FX2_PROF
  return true;
#else
  return false;
#endif
}

void prof_print(double tsc_to_core, long tokens) {
#ifndef FX2_PROF
  (void)tsc_to_core;
  (void)tokens;
  std::printf("prof: not compiled in (build with -DFX2_PROF)\n");
#else
  // empty-section overhead: median back-to-back raw-rdtsc delta
  const int NS = 4001;
  std::vector<uint64_t> st(NS);
  for (int i = 0; i < NS; i++) st[i] = prof_rdtsc();
  std::vector<double> dd(NS - 1);
  for (int i = 0; i + 1 < NS; i++) dd[i] = double(st[i + 1] - st[i]);
  std::nth_element(dd.begin(), dd.begin() + (NS - 1) / 2, dd.end());
  const double stamp_ticks = dd[(NS - 1) / 2];
  std::printf("\n== per-part profile (raw rdtsc, overhead-corrected by %.1f "
              "ticks/section = %.1f core cyc) ==\n",
              stamp_ticks, stamp_ticks * tsc_to_core);
  double gcyc[4] = {}, gcalls[4] = {};
  double site_cyc[PS_N];
  double total = 0;
  for (int s = 0; s < PS_N; s++) {
    double ticks = double(g_pacc[s]) - double(g_pcalls[s]) * stamp_ticks;
    if (ticks < 0) ticks = 0;
    site_cyc[s] = ticks * tsc_to_core / double(tokens > 0 ? tokens : 1);
    gcyc[kPSites[s].group] += site_cyc[s];
    gcalls[kPSites[s].group] += double(g_pcalls[s]);
    total += site_cyc[s];
  }
  std::printf("%-34s %12s %6s %9s\n", "group", "cyc/token", "%", "calls/tok");
  for (int g = 0; g < 4; g++)
    std::printf("%-34s %12.0f %5.1f%% %9.1f\n", kGroups[g], gcyc[g],
                100.0 * gcyc[g] / total,
                gcalls[g] / double(tokens > 0 ? tokens : 1));
  std::printf("%-34s %12.0f %5.1f%%\n", "TOTAL (instrumented sections)", total,
              100.0);
  std::printf("\n%-34s %12s %6s %9s\n", "  site", "cyc/token", "%",
              "calls/tok");
  for (int g = 0; g < 4; g++) {
    std::printf("  -- %s --\n", kGroups[g]);
    for (int s = 0; s < PS_N; s++) {
      if (kPSites[s].group != g) continue;
      std::printf("  %-32s %12.0f %5.1f%% %9.1f\n", kPSites[s].name,
                  site_cyc[s], 100.0 * site_cyc[s] / total,
                  double(g_pcalls[s]) / double(tokens > 0 ? tokens : 1));
    }
  }
#ifdef ATTN_PROFILE
  {
    const double t = double(tokens > 0 ? tokens : 1);
    std::printf("  attention phases (lfence rdtsc ticks/token): qk %.0f  exp %.0f  pv %.0f\n",
                double(g_attn_prof[0]) / t, double(g_attn_prof[1]) / t,
                double(g_attn_prof[2]) / t);
  }
#endif
#endif
}

// ---------------------------------------------------------------------------
// the model
// ---------------------------------------------------------------------------
// State and scratch of one model instance. The weights (OptModel) are
// read-only; everything that changes from byte to byte lives here.
struct TransformerOptImpl {
  // [this entry] pointer instead of a member, so instances can share weights
  OptModel* Mp;  // the weights; shared (not owned) if !owns
  bool owns;
  OptModel& M;
  AttnKind kind;

  // streaming state (hugepage pool: KDA states, then KV caches)
  HugeBuf spool;
  KdaState* kst = nullptr;   // [9]
  AttnKVF32* kvf = nullptr;  // [3] iff kind == KVF32
  AttnKV* kvi = nullptr;     // [3] iff kind == KVI8
  int64_t t = 0;
  int64_t rope_off = 0;

#ifdef FX2_XCHECK_NAIVE_KDA
  struct NaiveKst {
    alignas(64) float S[NH][DH * DH];
    alignas(64) float hist[3][3][D];
  };
  std::vector<NaiveKst> nkst = std::vector<NaiveKst>(9);
#endif
#ifdef FX2_XCHECK_NAIVE_ATTN
  struct NaiveVst {
    alignas(64) int8_t kring[WIN][D];
    alignas(64) int8_t vring[WIN][D];
  };
  std::vector<NaiveVst> nvst = std::vector<NaiveVst>(3);
#endif

  // per-token skip stack (written by layers 0..5, read by 6..11 of the SAME
  // token) — transient within step
  alignas(64) float skip_store[6][D] = {};

  // scratch
  alignas(64) float x[D] = {}, xn[D] = {}, yb[D] = {};
  alignas(64) uint8_t q5[5 * D] = {};  // up to 5 biased-u8 copies of xn
  alignas(64) uint8_t q64b[DH] = {};
  alignas(64) float bq[D] = {}, bk[D] = {}, bv[D] = {};
  alignas(64) float graw[D] = {}, og192[D] = {}, gn[D] = {};
  alignas(32) float braw[8] = {};
  alignas(64) float qf[D] = {}, kf[D] = {}, vf[D] = {}, pre[D] = {};
  alignas(64) int8_t qq[D] = {}, kk[D] = {}, vv[D] = {};
  alignas(64) uint8_t q768[DMLP] = {};
  // [this entry] 16-bit activation path (act16.h): cur_l = layer being
  // evaluated (the 16-bit arenas are indexed by layer); h768 = mlp.up output;
  // a768 / a192 = 16-bit quantized activations; idx768 = positions of the
  // nonzero a768, idxh768 = positions with a768 >= 256. ident192 is not read
  // by the shipped paths.
  int cur_l = 0;
  alignas(64) float h768[DMLP] = {};
  alignas(64) int16_t a768[DMLP] = {};
  alignas(64) int16_t a192[D] = {};
  alignas(64) uint16_t ident192[D + 16] = {};
  alignas(64) uint16_t idx768[DMLP + 16] = {};
  alignas(64) uint16_t idxh768[DMLP + 16] = {};
  alignas(64) float prior_f32[208] = {};
  alignas(64) uint8_t q8p[224] = {};      // 224 = 205 rounded to 32
  alignas(64) uint16_t idxp[224 + 16] = {};
  alignas(64) float logits[208] = {};
  alignas(64) float probs208[208] = {};
  // [this entry] MLP activation capture (TransformerOpt::set_capture_layers);
  // filled only on the 8-bit mlp.down path (CMIX_ACT16 bit 1 clear)
  uint32_t cap_mask = 0;
  int cap_nnz[12] = {};
  uint16_t cap_idx[12][DMLP + 16] = {};
  alignas(64) uint8_t cap_q[12][DMLP] = {};
  alignas(32) float sfall[32] = {}, cfall[32] = {};  // rope fallback row

  ~TransformerOptImpl() {
    if (owns) delete Mp;
  }

  // path != nullptr: loads its own weights; else reads those of *shared
  TransformerOptImpl(const char* path, OptModel* shared, AttnKind k)
      : Mp(path ? new OptModel() : shared), owns(path != nullptr), M(*Mp),
        kind(k) {
    if (path) M.load(path);
    const size_t kda_sz = sizeof(KdaState) * 9;
    const size_t kv_sz =
        (kind == AttnKind::KVF32 ? sizeof(AttnKVF32) : sizeof(AttnKV)) * 3;
    spool.alloc(kda_sz + kv_sz);
    kst = reinterpret_cast<KdaState*>(spool.p);
    if (kind == AttnKind::KVF32)
      kvf = reinterpret_cast<AttnKVF32*>(spool.p + kda_sz);
    else
      kvi = reinterpret_cast<AttnKV*>(spool.p + kda_sz);
    for (int i = 0; i < 9; i++) kda_layer_reset(kst[i]);
    for (int i = 0; i < D + 16; i++)
      ident192[i] = static_cast<uint16_t>(i < D ? i : D - 1);
  }

  // Start of a new article: clear the Kimi states and conv histories and
  // restart the position counter (which also empties the attention window).
  void begin(int64_t rope_position_offset) {
    for (int i = 0; i < 9; i++) kda_layer_reset(kst[i]);
#ifdef FX2_XCHECK_NAIVE_KDA
    std::memset(nkst.data(), 0, sizeof(NaiveKst) * 9);
#endif
    t = 0;  // invalidates the KV rings (validity is [0, t] within an article)
    rope_off = rope_position_offset;
  }

  // [this entry] Each projection has its own activation scale, so xn is
  // quantized three times (IEEE divide + round-half-even), then one exact
  // integer matmul each.
  // 16-bit query / key / value projections of layer cur_l from xn
  void qkv16(float* oq, float* ok, float* ov) {
    float* const o[3] = {oq, ok, ov};
    for (int c = 0; c < 3; c++) {
      const OptModel::Rows16& r = M.qkv16[cur_l][c];
      quant192_i16(xn, r.s16, a192);
      gemv16p_set(r.rows, r.fold, r.k, a192, D, o[c]);
    }
  }

  // Attention half of a Kimi (linear attention) layer: x += O(kda(xn)).
  // The layer keeps a 64x64 fp32 state per head instead of a window of past
  // keys and values (KIMI_SEMANTICS.md).
  void kimi_layer(int ki) {
    KimiArenas& L = M.kimi[ki];
    // xn = rms_norm(x), and the 8-bit quantized copies of xn that the 8-bit
    // matmuls below read (one copy per site: each has its own scale).
    // [this entry] with 16-bit q/k/v only the two gate inputs are needed.
    {
      PSCOPE(PS_EL_NQ_KIMI);
      const float s5[5] = {L.qp.s_act, L.kp.s_act, L.vp.s_act, L.fg_up.s_act,
                           L.og_up.s_act};
      if (M.act16 & 8)
        rms_norm_quant192_multi(x, xn, s5 + 3, 2, q5 + 3 * D);
      else
        rms_norm_quant192_multi(x, xn, s5, 5, q5);
    }
    // query / key / value projections (192x192 each) -> bq, bk, bv
    {
      PSCOPE(PS_MM_KQKV);
      if (M.act16 & 8) {
        qkv16(bq, bk, bv);
      } else {
        qgemv_f32(L.qp.m, q5, bq);
        qgemv_f32(L.kp.m, q5 + D, bk);
        qgemv_f32(L.vp.m, q5 + 2 * D, bv);
      }
    }
    // forget gate, low rank: 192 -> 64 (quantized again to 8 bits in the
    // kernel's epilogue) -> 192 = graw, the per-channel decay pre-activation
    {
      PSCOPE(PS_MM_GUP);
      qgemv_quant_bias(L.fg_up.m, q5 + 3 * D, L.fg_down.s_act, q64b);
    }
    {
      PSCOPE(PS_MM_GDN);
      qgemv_f32(L.fg_down.m, q64b, graw);
    }
    // output gate, same shape -> og192
    {
      PSCOPE(PS_MM_GUP);
      qgemv_quant_bias(L.og_up.m, q5 + 4 * D, L.og_down.s_act, q64b);
    }
    {
      PSCOPE(PS_MM_GDN);
      qgemv_f32(L.og_down.m, q64b, og192);
    }
    // beta (write strength per head): unquantized fp32 3x192 matvec on xn
    {
      PSCOPE(PS_KD_BETA);
      for (int h = 0; h < NH; h++)
        braw[h] = dot192(xn, L.beta_w + size_t(h) * D);
    }
    // the recurrent step: causal conv + silu on q/k/v, state decay, delta-rule
    // update, read-out, gated rms norm -> gn (192 fp32)
    {
      PSCOPE(PS_KD_STEP);
#ifdef FX2_XCHECK_NAIVE_KDA
      // naive scalar kimi path (bit-exact vs src/model.cpp kimi_attention)
      NaiveKst& st = nkst[ki];
      alignas(32) float cq[D], ck[D], cv[D], o192[D];
      conv4_silu(L.kw.conv_w[0], st.hist[0][0], st.hist[0][1], st.hist[0][2],
                 bq, cq, D);
      conv4_silu(L.kw.conv_w[1], st.hist[1][0], st.hist[1][1], st.hist[1][2],
                 bk, ck, D);
      conv4_silu(L.kw.conv_w[2], st.hist[2][0], st.hist[2][1], st.hist[2][2],
                 bv, cv, D);
      const float* newest[3] = {bq, bk, bv};
      for (int c = 0; c < 3; c++) {
        std::memmove(st.hist[c][0], st.hist[c][1], sizeof(float) * 2 * D);
        std::memcpy(st.hist[c][2], newest[c], sizeof(float) * D);
      }
      for (int h = 0; h < NH; h++)
        kda_head_step(st.S[h], cq + h * DH, ck + h * DH, cv + h * DH,
                      graw + h * DH, L.kw.dt_bias + h * DH, L.kw.a_neg[h],
                      sigmoid1f(braw[h]), o192 + h * DH);
      for (int h = 0; h < NH; h++)
        gated_rms_norm64(o192 + h * DH, og192 + h * DH, L.kw.gn_w,
                         gn + h * DH);
#else
      kda_layer_step(L.kw, kst[ki], bq, bk, bv, graw, og192, braw, gn);
#endif
    }
    // output projection added to the residual stream: x += O(quant(gn))
    // [this entry] 16-bit quantizer + gemv16p_add instead of 8-bit + qgemv_add
    {
      PSCOPE(PS_EL_OQ);
      if (M.act16 & 2) quant192_i16(gn, M.op_s16[cur_l], a192);
      else quant192_u8(gn, L.op.s_act, q5);
    }
    {
      PSCOPE(PS_MM_KOP);
      if (M.act16 & 2)
        gemv16p_add(M.op16[cur_l], M.op_fold16[cur_l], M.op_k16[cur_l], a192, x);
      else
        qgemv_add(L.op.m, q5, x);
    }
  }

  // Attention half of a vanilla layer (3, 7, 11): softmax attention over the
  // last 1024 positions of the article (SPEC.md section 3.5).
  void van_layer(int vi) {
    VanArenas& L = M.van[vi];
    // xn = rms_norm(x) (+ its three 8-bit copies on the 8-bit path)
    {
      PSCOPE(PS_EL_NQ_VAN);
      const float s3[3] = {L.qp.s_act, L.kp.s_act, L.vp.s_act};
      if (M.act16 & 8)
        rms_norm192(x, xn);
      else
        rms_norm_quant192_x3(x, xn, s3, q5, q5 + D, q5 + 2 * D);
    }
    // query / key / value projections -> qf, kf, vf
    {
      PSCOPE(PS_MM_VQKV);
      if (M.act16 & 8) {
        qkv16(qf, kf, vf);
      } else {
        qgemv_f32(L.qp.m, q5, qf);
        qgemv_f32(L.kp.m, q5 + D, kf);
        qgemv_f32(L.vp.m, q5 + 2 * D, vf);
      }
    }
    // per head: normalize q and k, rotate both by the position (RoPE), then
    // quantize q, k, v to int8 with their per-head scales. These quantizers
    // stay 8-bit in this entry: the KV cache stores int8 and the q.k dot
    // products are exact int32.
    {
      PSCOPE(PS_EL_HEADPREP);
      for (int h = 0; h < NH; h++) rms_norm64(qf + h * DH, qf + h * DH);
      for (int h = 0; h < NH; h++) rms_norm64(kf + h * DH, kf + h * DH);
      const int64_t pos = rope_off + t;
      const float *sp, *cp;
      if (pos < ROPE_LEN) {
        sp = M.rope_sin.data() + size_t(pos) * 32;
        cp = M.rope_cos.data() + size_t(pos) * 32;
      } else {  // beyond the shipped table: libm fallback (same as naive)
        const float fpos = static_cast<float>(pos);
        for (int i = 0; i < 32; i++) {
          const float ang = fpos * M.inv_freq[i];
          sfall[i] = std::sin(ang);
          cfall[i] = std::cos(ang);
        }
        sp = sfall;
        cp = cfall;
      }
      rope_apply_192(qf, sp, cp);
      rope_apply_192(kf, sp, cp);
      for (int h = 0; h < NH; h++) {
        quant64_i8(qf + h * DH, L.sq[h], qq + h * DH);
        quant64_i8(kf + h * DH, L.sk[h], kk + h * DH);
        quant64_i8(vf + h * DH, L.sv[h], vv + h * DH);
      }
    }
    // store this position's k and v in the ring, then attend over the n
    // valid positions (variable-length kernel until the window is full)
    const int slot = static_cast<int>(t % WIN);
    const int64_t n = t + 1;
#ifdef FX2_EXP_KPF
    {  // experiment: warm the first 2KB of each head's K stream (the scan's
       // software prefetch runs +2KB ahead, so the first 2KB are cold-start
       // demand misses paced by the QK compute)
      const char* kb = kind == AttnKind::KVF32
                           ? reinterpret_cast<const char*>(kvf[vi].k)
                           : reinterpret_cast<const char*>(kvi[vi].k);
      for (int h = 0; h < 3; h++)
        for (int off = 0; off < 2048; off += 64)
          _mm_prefetch(kb + h * (ATTN_NBLK * 32 * ATTN_DH) + off, _MM_HINT_T0);
    }
#endif
#ifdef FX2_XCHECK_NAIVE_ATTN
    {
      NaiveVst& st = nvst[vi];
      std::memcpy(st.kring[slot], kk, D);
      std::memcpy(st.vring[slot], vv, D);
      if (n < WIN)
        fx2::attention_step_var(qq, st.kring[0], st.vring[0], L.coef, L.sv,
                                static_cast<int>(n), pre, 0.0f);
      else
        fx2::attention_step_fixed(qq, st.kring[0], st.vring[0], L.coef, L.sv,
                                  pre, 0.0f);
    }
#else
    if (kind == AttnKind::KVF32) {
      {
        PSCOPE(PS_AT_INSERT);
        attn_kv_insert(kvf[vi], slot, kk, vv);
      }
      {
        PSCOPE(PS_AT_STEP);
        if (n < WIN)
          attn_step_var(kvf[vi], qq, L.coef, L.sv, static_cast<int>(n), pre,
                        0.0f);
        else
          attn_step_fixed(kvf[vi], qq, L.coef, L.sv, pre, 0.0f);
      }
    } else {
      {
        PSCOPE(PS_AT_INSERT);
        attn_kv_insert(kvi[vi], slot, kk, vv);
      }
      {
        PSCOPE(PS_AT_STEP);
        if (n < WIN)
          attn_step_var(kvi[vi], qq, L.coef, L.sv, static_cast<int>(n), pre,
                        0.0f);
        else
          attn_step_fixed(kvi[vi], qq, L.coef, L.sv, pre, 0.0f);
      }
    }
#endif
    // output projection added to the residual stream: x += O(quant(pre))
    // [this entry] 16-bit quantizer + gemv16p_add instead of 8-bit + qgemv_add
    {
      PSCOPE(PS_EL_OQ);
      if (M.act16 & 2) quant192_i16(pre, M.op_s16[cur_l], a192);
      else quant192_u8(pre, L.op.s_act, q5);
    }
    {
      PSCOPE(PS_MM_VOP);
      if (M.act16 & 2)
        gemv16p_add(M.op16[cur_l], M.op_fold16[cur_l], M.op_k16[cur_l], a192, x);
      else
        qgemv_add(L.op.m, q5, x);
    }
  }

  // MLP half of a layer: x += down(relu(up(rms_norm(x)))^2).
  void mlp_block(int l) {
    MlpArenas& mm = M.mlp[l];
    // xn = rms_norm(x) and its quantized form ([this entry] 16-bit: a192)
    {
      PSCOPE(PS_EL_NQ_MLP);
      if (M.act16 & 4) {
        rms_norm192(x, xn);
        quant192_i16(xn, M.up16[l].s16, a192);
      } else {
        rms_norm_quant192(x, xn, mm.up.s_act, q5);
      }
    }
    int nnz;
    // [this entry] the shipped path. up: 768 exact int32 dots -> fp32 h768.
    // relu2_quant16p: h = relu(h)^2 quantized to 16 bits, with the list of
    // nonzero positions (most are zero). down: only those columns are added
    // into x. All dots are exact; the fp32 steps are single IEEE operations.
    if (M.act16 & 1) {
      int nh16 = 0;
      int32_t suma16 = 0;
      {
        PSCOPE(PS_MM_MLP_UP);
        if (M.act16 & 4)
          gemv16p_set(M.up16[l].rows, M.up16[l].fold, M.up16[l].k, a192, DMLP,
                      h768);
        else
          qgemv_f32(mm.up.m, q5, h768);
        nnz = relu2_quant16p(h768, M.down_s16[l], DMLP, a768, idx768, idxh768,
                             &nh16, &suma16);
      }
      {
        PSCOPE(PS_MM_MLP_DOWN);
        spmv16p_add(M.down16[l], M.down_fold16[l], a768, idx768, nnz, idxh768,
                    nh16, suma16, x);
      }
      return;
    }
    // the previous winner's 8-bit path (CMIX_ACT16 bit 1 clear): up with the
    // relu^2 + 8-bit quantizer fused into its epilogue, then the int4 column
    // kernel (or its dense fallback when nearly all columns are active)
    {
      PSCOPE(PS_MM_MLP_UP);
      nnz = qgemv_relu2q(mm.up.m, q5, mm.down_s_act, q768, idx768);
    }
    if ((cap_mask >> l) & 1) {
      cap_nnz[l] = nnz;
      std::memcpy(cap_idx[l], idx768, sizeof(uint16_t) * nnz);
      std::memcpy(cap_q[l], q768, DMLP);
    }
    {
      PSCOPE(PS_MM_MLP_DOWN);
      if (nnz > DOWN_DENSE_NNZ)
        qsparse4_dense_add(mm.down, q768, x);
      else
        qsparse4_add(mm.down, q768, idx768, nnz, x);
    }
  }

  // One symbol: the whole forward pass (see the table at the top of the file).
  // prior must be the cap-208 internal buffer with pads [205..208) zeroed
  void step(uint8_t token, float* probs_out) {
    const float* tok = M.tok_table + size_t(token) * D;
    int nnzp;
    // input embedding. The prior probabilities are quantized to 8 bits; most
    // round to zero, so the 192x205 prior embedding is a sparse column sum.
    {
      PSCOPE(PS_EL_PRIORQ);
      prior_quant_raw(prior_f32, M.prior_s_act, q8p);  // raw u8; q8p[208..224)=0
      nnzp = qsparse_make_idx(q8p, V, idxp);
      const uint16_t fillv = nnzp ? idxp[nnzp - 1] : 0;
      for (int k = nnzp; k < nnzp + 8; k++) idxp[k] = fillv;
    }
    {
      PSCOPE(PS_MM_PRIOR);
      if (nnzp > PRIOR_DENSE_NNZ)
        qsparse4_dense_f32(M.prior, q8p, yb);
      else
        qsparse4_f32(M.prior, q8p, idxp, nnzp, yb);
    }
    {
      PSCOPE(PS_EL_EMBED);
      embed_combine192(tok, yb, x);  // x0 = tok_row + rms_norm(prior_y)
    }

    // the 12 layers. Layers 0..5 save their output; layers 6..11 add the
    // saved output of layer 11-l (U-net style skip connections).
    for (int l = 0; l < NL; l++) {
      {
        PSCOPE(PS_EL_RESID);
        // skip-add BEFORE the token connection (SPEC 3.3); pairing 11-l
        if (l >= 6) add_scaled192(x, M.skip_w[l - 6], skip_store[11 - l]);
        axpby_tok192(M.rsc[l], x, M.tec[l], tok);
      }
      cur_l = l;
      if (OptModel::KIMI_L[l])
        kimi_layer(M.layer2kimi[l]);
      else
        van_layer(M.layer2van[l]);
      mlp_block(l);
      if (l < 6) {
        PSCOPE(PS_EL_RESID);
        std::memcpy(skip_store[l], x, sizeof(float) * D);  // push AFTER block
      }
    }

    // output head: final norm (xn is what last_hidden() returns), 205 logits
    // (8-bit input), soft cap 15 * tanh(l / 15), softmax
    {
      PSCOPE(PS_EL_NQ_FIN);
      rms_norm_quant192(x, xn, M.unembed.s_act, q5);
    }
    {
      PSCOPE(PS_MM_UNEMB);
      qgemv_f32(M.unembed.m, q5, logits);  // rows_padded 208
    }
    {
      PSCOPE(PS_EL_HEAD);
      head_softcap_softmax(logits, probs208);
      std::memcpy(probs_out, probs208, sizeof(float) * V);
    }
    t++;
  }
};

TransformerOpt::TransformerOpt(const char* weights_path, AttnKind attn)
    : impl(new TransformerOptImpl(weights_path, nullptr, attn)) {}

// [this entry] second instance on the same weights (CMIX_PIPE worker threads)
TransformerOpt::TransformerOpt(const TransformerOpt& shared, ShareWeights)
    : impl(new TransformerOptImpl(nullptr, shared.impl->Mp,
                                  shared.impl->kind)) {}

TransformerOpt::~TransformerOpt() = default;

void TransformerOpt::begin_article(int64_t rope_position_offset) {
  impl->begin(rope_position_offset);
}

// public step: bring the prior into the internal 208-float buffer, then run
void TransformerOpt::step(uint8_t token, const uint16_t* prior_f16,
                          float* probs_out) {
  prior_f16_to_f32(prior_f16, impl->prior_f32);  // exact; pads zeroed
  impl->step(token, probs_out);
}

void TransformerOpt::step(uint8_t token, const float* prior205,
                          float* probs_out) {
  std::memcpy(impl->prior_f32, prior205, sizeof(float) * V);
  impl->prior_f32[205] = impl->prior_f32[206] = impl->prior_f32[207] = 0.0f;
  impl->step(token, probs_out);
}

const float* TransformerOpt::last_logits() const { return impl->logits; }

// [this entry] accessors used by the online adaptation in src/predictor.cpp
const float* TransformerOpt::last_hidden() const { return impl->xn; }

void TransformerOpt::set_capture_layers(uint32_t mask) {
  impl->cap_mask = mask;
}

int TransformerOpt::mlp_acts(int layer, const uint16_t** idx,
                             const uint8_t** q) const {
  *idx = impl->cap_idx[layer];
  *q = impl->cap_q[layer];
  return impl->cap_nnz[layer];
}

AttnKind TransformerOpt::attn_kind() const { return impl->kind; }

}  // namespace opt
}  // namespace fx2
