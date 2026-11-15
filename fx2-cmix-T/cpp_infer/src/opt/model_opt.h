// model_opt.h — TransformerOpt: the optimized fx2 transformer (SPEC section 6
// interface) assembled from the four kernel workstreams:
//   qmat  (src/opt/qmat*.{h,cpp})  — all int4x int8 matmuls, arena format
//   attn  (src/opt/attn.{h,cpp})   — vanilla sliding-window attention + KV
//   kda   (src/opt/kda.{h,cpp})    — fused Kimi linear-attention step
//   glue  (src/opt/glue.{h,cpp})   — norms/quants/rope/residual/head
// Numerics: bit-exact vs the naive src/model.cpp except the documented
// vector-math ulp divergences (attention softmax/PV reassociation ~1e-7 rel,
// KDA exp-family <= ~2 ulp/elem, head tanh/exp <= ~2 ulp) — expected
// whole-model probability drift <= ~1e-5 absolute.
// The vanilla-attention low-prob skip is hardwired OFF (exact softmax; at the
// SPEC-safe threshold 21 it never fires anyway).
//
// How it fits: this is the transformer byte model that cmix links
// (src/predictor.cpp owns one TransformerOpt). Per symbol cmix calls step()
// with the symbol and the PPMD prior, and feeds the returned probabilities to
// the mixers -> SSE -> arithmetic coder. The naive src/model.cpp is the test
// reference only and is not part of the cmix binary.
//
// Testing: test_e2e_opt, test_xcheck, bench_opt (cpp_infer/Makefile).
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
// - [this entry] 16-bit activation inputs for most matmuls (act16.h,
//   CMIX_ACT16, default 15); see model_opt.cpp for the per-layer kernel map.
//   With them the model is no longer bit-exact vs src/model.cpp (which is
//   all 8-bit); CMIX_ACT16=0 restores the statement above.
// - [this entry] ShareWeights constructor, last_hidden(), MLP activation
//   capture (see the members below).
#pragma once

#include <cstdint>
#include <memory>

namespace fx2 {
namespace opt {

// KV-cache variant (attn.h): outputs are bitwise identical; F32V is fastest,
// I8V saves 1.7 MB of L3 footprint (0.56 vs 2.81 MB KV total).
enum class AttnKind : int { KVF32 = 0, KVI8 = 1 };

struct TransformerOptImpl;

struct TransformerOpt {
  explicit TransformerOpt(const char* weights_path,
                          AttnKind attn = AttnKind::KVF32);
  ~TransformerOpt();
  // [this entry] for the multi-core experiment mode (CMIX_PIPE).
  // A second instance with its own streaming state (KV rings, KDA states,
  // scratch) that reads the weights of `shared`, which must outlive it.
  // Instances can step concurrently on different threads.
  struct ShareWeights {};
  TransformerOpt(const TransformerOpt& shared, ShareWeights);
  TransformerOpt(const TransformerOpt&) = delete;
  TransformerOpt& operator=(const TransformerOpt&) = delete;

  // resets KV rings, KDA states and conv histories; rope positions for the
  // article are rope_position_offset + local position (0-based)
  void begin_article(int64_t rope_position_offset = 0);

  // feed input token and its prior (205 float16 values); fills probs_out[205]
  // with the fp32 distribution over the NEXT token
  void step(uint8_t token, const uint16_t* prior_f16, float* probs_out);
  // same with an fp32 prior row (205 values)
  void step(uint8_t token, const float* prior205, float* probs_out);

  // the 205 post-softcap logits of the last step (valid until the next step)
  const float* last_logits() const;
  // [this entry] input of the online output-layer adaptation in cmix.
  // the final rms-normed hidden state (192 floats) the head was applied to
  const float* last_hidden() const;

  // [this entry] experiment hook. Only the 8-bit mlp.down path fills the
  // capture (CMIX_ACT16 bit 1 clear).
  // capture the sparse relu^2 MLP activations (u8, 0..127) of the layers in
  // mask (bit l = layer l) at every step; mlp_acts returns the last step's
  // active count for layer l and points idx/q at its indices and the dense
  // 768-entry activation row
  void set_capture_layers(uint32_t mask);
  int mlp_acts(int layer, const uint16_t** idx, const uint8_t** q) const;

  AttnKind attn_kind() const;

 private:
  std::unique_ptr<TransformerOptImpl> impl;
};

// ---- profiling hooks (functional only when model_opt.cpp is compiled with
// -DFX2_PROF; no-ops otherwise). Accumulators are raw-rdtsc ticks. ----
void prof_reset();
bool prof_enabled();
// Print the per-group / per-site table. tsc_to_core = core cycles per tsc
// tick (bench_common.h Calib::ratio()); tokens = steps accumulated since
// prof_reset. Overhead-corrects each section by the measured median
// back-to-back raw-rdtsc delta.
void prof_print(double tsc_to_core, long tokens);

}  // namespace opt
}  // namespace fx2
