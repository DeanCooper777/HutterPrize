// arena_build.h — integration loader: reads weights.bin (SPEC section 4 via
// weights_io) and repacks every quantized matmul into the qmat.h arenas laid
// out CONTIGUOUSLY IN EXACT PER-TOKEN CONSUMPTION ORDER, so the whole weight
// stream is one big sequential read per token (hardware prefetch friendly;
// the kernels' prefetcht0 +2KB runs across arena boundaries into the next
// matmul's stream, which is exactly what we want).
//
// Stream order (must equal the call order in model_opt.cpp):
//   [prior fold|cols int4]                                  (sparse, raw u8)
//   per layer l = 0..11:
//     kimi:  [qp][kp][vp][fg_up][fg_down][og_up][og_down]
//            [beta_w f32][conv_q f32][conv_k f32][conv_v f32][dt_bias][gn_w]
//            [out_proj]
//     van:   [qp][kp][vp][out_proj]
//     both:  [mlp.up][mlp.down fold|cols int4]
//   [unembed]
// The fp32 KDA weights sit inside the stream at their consumption point.
// The pool has QMAT_TAIL_SLACK mapped past the last arena (prefetch overrun),
// then the normed token-embedding table (random-access, not part of the
// stream). RoPE tables (32 MB, 256 B/token) live in separate heap vectors.
//
// How it fits: runs once when cmix creates the transformer byte model
// (TransformerOpt in model_opt.cpp calls OptModel::load); after that the
// model only reads the pool. Position in the whole: preprocess -> dictionary
// -> context models / PPMD / TRANSFORMER BYTE MODEL -> mixers -> SSE ->
// arithmetic coder.
//
// Testing: exercised by every test that builds a TransformerOpt
// (test_e2e_opt, test_xcheck, bench_opt). The environment variable CMIX_ACT16
// (read in load) selects which matmul inputs are 16-bit.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
// - [this entry] 16-bit activation sites (act16.h). With the default
//   CMIX_ACT16 = 15 these arenas REPLACE the 8-bit arena at the same place of
//   the stream:
//     q/k/v projections  -> packed rows   (OptModel::qkv16, bit 8)
//     attention out_proj -> packed rows   (op16 ..., bit 2)
//     mlp.up             -> packed rows   (up16, bit 4)
//     mlp.down           -> packed columns (down16 ..., bit 1)
//   Each stores [fold | (128 * row sums, rows only) | nibbles]; the fold uses
//   the activation scale / 256. Still 8-bit: the prior embedding, the Kimi
//   gate projections (fg/og up and down) and the unembedding. Smaller
//   activation rounding error -> better predictions -> smaller archive.
// - [this entry] FX2_DMLP makes the MLP width a compile-time parameter (used
//   for experiments with narrower models; the submission uses 768).
// - [this entry] Windows allocation path in HugeBuf (development builds).
#pragma once

#include <cstddef>
#include <cstdint>
#include <vector>

#include "kda.h"
#include "qmat.h"

namespace fx2 {
namespace opt {

// mmap'd, hugepage-advised (MADV_HUGEPAGE), zero-initialized buffer
struct HugeBuf {
  uint8_t* p = nullptr;
  size_t bytes = 0;
  void alloc(size_t n);
  ~HugeBuf();
  HugeBuf() = default;
  HugeBuf(const HugeBuf&) = delete;
  HugeBuf& operator=(const HugeBuf&) = delete;
};

// one dense matmul site: arena descriptor + this site's activation scale
// (8-bit input; consumed by the qmat_dense.h kernels)
struct QSite {
  QDense m;
  float s_act = 0.0f;
};

// A Kimi linear-attention layer (9 of the 12). With CMIX_ACT16 bits 8 / 2 set
// qp, kp, vp / op stay empty and OptModel::qkv16 / op16 are used instead.
struct KimiArenas {
  QSite qp, kp, vp;        // 192x192, biased-u8 input
  QSite fg_up, og_up;      // 64x192, biased (consumed via quant_bias epilogue)
  QSite fg_down, og_down;  // 192x64, biased
  QSite op;                // 192x192, biased
  const float* beta_w = nullptr;  // [3][192] fp32 (in the stream)
  KdaWeights kw;                  // conv/dt_bias/gn_w point into the stream
};

// A vanilla sliding-window attention layer (layers 3, 7, 11); same remark
// about qp, kp, vp, op. sq/sk/sv are the per-head scales of the post-RoPE
// 8-bit query / key / value quantizers (those stay 8-bit: the KV cache holds
// int8).
struct VanArenas {
  QSite qp, kp, vp, op;  // 192x192, biased
  float sq[3] = {}, sk[3] = {}, sv[3] = {};
  float coef[3] = {};  // 0.125f * sq[h] * sk[h] (same fp order as naive)
};

#ifndef FX2_DMLP
#define FX2_DMLP 768  // MLP width; phase 2 builds use -DFX2_DMLP=384/512
#endif

// The MLP of a layer in its 8-bit form (unused when CMIX_ACT16 bits 4 / 1 are
// set: see up16 / down16 below).
struct MlpArenas {
  QSite up;                  // 768x192, biased; relu2q epilogue s_next below
  QSparse4 down;             // int4 columns, raw-u8 input (relu^2 output)
  float down_s_act = 0.0f;   // = mlp.down activation scale (relu2q s_next)
};

// All weights of the transformer in run-time layout. Read-only after load(),
// so several TransformerOpt instances can share one (model_opt.h ShareWeights).
struct OptModel {
  static constexpr int V = 205, D = 192, NL = 12, DH = 64, NH = 3,
                       DMLP = FX2_DMLP, ROPE_LEN = 131072;
  static constexpr bool KIMI_L[NL] = {true, true, true,  false, true, true,
                                      true, false, true, true,  true, false};

  HugeBuf pool;          // weight stream + tok table
  size_t stream_bytes = 0;  // bytes of the per-token weight stream

  QSparse4 prior;        // 192x205, raw-u8 quantized prior
  float prior_s_act = 0.0f;
  KimiArenas kimi[9];
  VanArenas van[3];
  MlpArenas mlp[NL];
  QSite unembed;         // 205x192 (rows_padded 208), biased

  int layer2kimi[NL] = {};
  int layer2van[NL] = {};
  float rsc[NL] = {}, tec[NL] = {}, skip_w[6] = {};
  const float* tok_table = nullptr;  // 205x192 normed embedding rows
  std::vector<float> rope_sin, rope_cos;  // 131072 x 32 each
  float inv_freq[32] = {};

  // [this entry] 16-bit activation path (act16.h); CMIX_ACT16 bitmask:
  // 1 = mlp.down input, 2 = attention output-projection input,
  // 4 = mlp.up input (needs 1), 8 = query/key/value projection inputs
  // Default 15 = all four; the environment variable CMIX_ACT16 overrides it
  // (0 = the previous winner's all-8-bit model). The value changes the
  // predictions, so compression and decompression must use the same one.
  // The arrays below are indexed by layer 0..11 (not by kimi / vanilla index).
#ifdef CMIX_OFFICIAL
  // The official build fixes the mask at compile time: the 8-bit variants of these four sites
  // (their kernels, arena builders and branches) then drop out of the binary, which is stored
  // twice in the entry.
  static constexpr int act16 = 15;
#else
  int act16 = 15;
#endif
  struct Rows16 {                    // packed rows (96 B each), act16.h
    const uint8_t* rows = nullptr;
    const int32_t* k = nullptr;      // 128 * (row sum of the weights)
    const float* fold = nullptr;     // (activation scale / 256) * row scale
    float s16 = 0.0f;                // activation scale / 256
  };
  Rows16 up16[NL];                   // mlp.up, DMLP rows
  Rows16 qkv16[NL][3];               // query / key / value projections
  const uint8_t* down16[NL] = {};  // [DMLP] packed columns, 96 B each
  const float* down_fold16[NL] = {};
  float down_s16[NL] = {};
  const uint8_t* op16[NL] = {};    // [192] packed rows, 96 B each
  const int32_t* op_k16[NL] = {};  // [192] 128 * (row sum of the weights)
  const float* op_fold16[NL] = {};
  float op_s16[NL] = {};

  void load(const char* weights_path);
};

}  // namespace opt
}  // namespace fx2
