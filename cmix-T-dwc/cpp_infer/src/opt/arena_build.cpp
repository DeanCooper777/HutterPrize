// arena_build.cpp - OptModel::load: reads the weights file and lays every
// matrix out in the order the forward pass reads it (see arena_build.h for
// the stream order and for which sites use 16-bit activations).
//
// How it fits: load-time only (once per run, compiled -Os in the submission
// makefile). Input: the tensors of weights_io.h (raw FX2TFW01 or the
// compressed FX2TFWC1/2 file, same tensors). Output: the pool that
// model_opt.cpp streams through for every byte.
//
// Testing: CMIX_ACT16 (environment) selects the 16-bit sites; every test or
// bench that constructs a TransformerOpt runs this code.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
// - [this entry] cols16 / rows16 builders and the CMIX_ACT16 switch: nibble
//   packed weights + folds for the 16-bit activation kernels of act16.h.
//   The weights file is unchanged; only the activation scale is divided by
//   256 here.
// - [this entry] Windows (VirtualAlloc) branch of HugeBuf, for development.
#include "arena_build.h"

#include "act16.h"

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#else
#include <sys/mman.h>
#endif

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

#include "../weights_io.h"
#include "glue.h"

namespace fx2 {
namespace opt {

namespace {

[[noreturn]] void die(const char* msg) {
  std::fprintf(stderr, "arena_build: %s\n", msg);
  std::exit(1);
}

constexpr size_t round64(size_t x) { return (x + 63) & ~size_t(63); }

}  // namespace

// Allocates n bytes rounded up to 2 MB, zeroed. Linux: anonymous mmap with a
// transparent-huge-page hint. [this entry] Windows: VirtualAlloc.
void HugeBuf::alloc(size_t n) {
  bytes = (n + (size_t(2) << 20) - 1) & ~((size_t(2) << 20) - 1);
#ifdef _WIN32
  void* m = ::VirtualAlloc(nullptr, bytes, MEM_COMMIT | MEM_RESERVE,
                           PAGE_READWRITE);
  if (m == nullptr) die("VirtualAlloc failed");
#else
  void* m = ::mmap(nullptr, bytes, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  if (m == MAP_FAILED) die("mmap failed");
  ::madvise(m, bytes, MADV_HUGEPAGE);
#endif
  std::memset(m, 0, bytes);  // touch every page
  p = static_cast<uint8_t*>(m);
}

HugeBuf::~HugeBuf() {
#ifdef _WIN32
  if (p) ::VirtualFree(p, 0, MEM_RELEASE);
#else
  if (p) ::munmap(p, bytes);
#endif
}

void OptModel::load(const char* weights_path) {
  // accept both the raw FX2TFW01 file and the losslessly compressed
  // FX2TFWC1/FX2TFWC2 files (bit-identical tensors either way)
  char magic[8] = {0};
  if (FILE* f = std::fopen(weights_path, "rb")) {
    if (std::fread(magic, 1, 8, f) != 8) magic[0] = 0;
    std::fclose(f);
  }
  WeightsFile wf = std::memcmp(magic, "FX2TFWC", 7) == 0
                       ? WeightsFile::load_compressed(weights_path)
                       : WeightsFile::load(weights_path);

  {  // config sanity (same checks as the naive loader)
    const WTensor& ci = wf.get("config.ints", DT_I32, {11});
    const int32_t want[11] = {V, D, NL, DH, NH, DMLP, 1024, DH, NH, 4, 10000};
    for (int i = 0; i < 11; i++)
      if (ci.i32()[i] != want[i]) die("config.ints mismatch");
    const WTensor& ck = wf.get("config.kimi", DT_I32, {NL});
    for (int i = 0; i < NL; i++)
      if ((ck.i32()[i] != 0) != KIMI_L[i]) die("config.kimi mismatch");
  }

  // One 16 MB pool holds the whole weight stream. take(n) returns the next
  // 64-byte-aligned block of it, so the order of the take calls below IS the
  // memory order.
  pool.alloc(size_t(16) << 20);
  size_t off = 0;
  auto take = [&](size_t n) -> uint8_t* {
    off = round64(off);
    uint8_t* q = pool.p + off;
    off += n;
    if (off + QMAT_TAIL_SLACK > pool.bytes) die("weight pool overflow");
    return q;
  };

  // dense arena site in stream order (8-bit input). fold[o] = activation
  // scale * weight scale of row o: the one fp32 factor that turns the integer
  // dot product into the fp32 output.
  auto qsite = [&](const std::string& prefix, int d_out, int d_in,
                   bool biased) -> QSite {
    const WTensor& wq =
        wf.get(prefix + ".weight.q", DT_I8,
               {static_cast<uint32_t>(d_out), static_cast<uint32_t>(d_in)});
    const WTensor& ws = wf.get(prefix + ".weight.scale", DT_BF16,
                               {static_cast<uint32_t>(d_out)});
    const WTensor& sa =
        wf.get(prefix + ".quantize_activation.scale", DT_BF16, {1});
    QSite s;
    s.s_act = bf16_to_f32(sa.bf16_bits()[0]);
    if (!(s.s_act > 0.0f)) die("activation scale not positive");
    std::vector<float> fold(d_out);
    for (int o = 0; o < d_out; o++)
      fold[o] = s.s_act * bf16_to_f32(ws.bf16_bits()[o]);
    uint8_t* dst = take(qdense_bytes(d_out, d_in));
    s.m = qdense_build(dst, wq.i8(), fold.data(), d_out, d_in, biased);
    return s;
  };

  // int4 sparse-column arena site (d_out must be 192): [fold | cols]
  auto qsp4 = [&](const std::string& prefix, int d_in,
                  float* s_act_out) -> QSparse4 {
    const WTensor& wq =
        wf.get(prefix + ".weight.q", DT_I8,
               {static_cast<uint32_t>(D), static_cast<uint32_t>(d_in)});
    const WTensor& ws = wf.get(prefix + ".weight.scale", DT_BF16,
                               {static_cast<uint32_t>(D)});
    const WTensor& sa =
        wf.get(prefix + ".quantize_activation.scale", DT_BF16, {1});
    float s_act = bf16_to_f32(sa.bf16_bits()[0]);
    if (!(s_act > 0.0f)) die("activation scale not positive");
    *s_act_out = s_act;
    std::vector<float> fold(D);
    for (int o = 0; o < D; o++)
      fold[o] = s_act * bf16_to_f32(ws.bf16_bits()[o]);
    float* foldp = reinterpret_cast<float*>(take(sizeof(float) * D));
    uint8_t* cols = take(qsparse4_bytes(d_in));
    return qsparse4_build(cols, foldp, wq.i8(), fold.data(), D, d_in);
  };

  // unquantized fp32 weights copied into the stream at their point of use
  auto f32block = [&](const float* src, size_t n) -> float* {
    float* p = reinterpret_cast<float*>(take(sizeof(float) * n));
    std::memcpy(p, src, sizeof(float) * n);
    return p;
  };

  // [this entry] which matmul inputs are quantized to 16 bits (arena_build.h)
  // The official build (-DCMIX_OFFICIAL) uses the default only: nothing in the environment of
  // the machine that decompresses may change a prediction.
#ifndef CMIX_OFFICIAL
  if (const char* e = std::getenv("CMIX_ACT16")) act16 = std::atoi(e);
#endif
  // [this entry] Builder for a 192-output site with 16-bit input: mlp.down
  // (by_rows = false: one packed column per input, for the sparse kernel
  // spmv16p_add) and the attention output projection (by_rows = true, for
  // gemv16p_add). The 16-bit quantizer has 256 times as many levels over the
  // same range, so its step is the stored scale / 256; 1/256 is a power of
  // two, so that multiply is exact.
  // 16-bit activation path (act16.h), in the stream at the place of the
  // 8-bit arena it replaces: nibble-packed weights (96 B per column, or per
  // row if by_rows) + fold with the activation scale / 256 (exact); for rows also
  // krow = 128 * the row's weight sum
  auto cols16 = [&](const std::string& prefix, int d_in, bool by_rows,
                    const uint8_t** cols, const float** foldp, float* s16,
                    const int32_t** krowp) {
    const WTensor& wq =
        wf.get(prefix + ".weight.q", DT_I8,
               {static_cast<uint32_t>(D), static_cast<uint32_t>(d_in)});
    const WTensor& ws = wf.get(prefix + ".weight.scale", DT_BF16,
                               {static_cast<uint32_t>(D)});
    const WTensor& sa =
        wf.get(prefix + ".quantize_activation.scale", DT_BF16, {1});
    *s16 = bf16_to_f32(sa.bf16_bits()[0]) * (1.0f / 256.0f);
    float* f = reinterpret_cast<float*>(take(sizeof(float) * D));
    for (int o = 0; o < D; o++)
      f[o] = *s16 * bf16_to_f32(ws.bf16_bits()[o]);
    const int8_t* q = wq.i8();
    for (size_t i = 0; i < size_t(D) * d_in; i++)
      if (q[i] < -7 || q[i] > 7) die("act16: weight outside [-7, 7]");
    if (by_rows) {
      if (d_in != D) die("act16: row layout needs d_in == 192");
      int32_t* k = reinterpret_cast<int32_t*>(take(sizeof(int32_t) * D));
      uint8_t* c = take(size_t(D) * (D / 2));
      for (int o = 0; o < D; o++) {
        int32_t sum = 0;
        for (int i = 0; i < D; i++) sum += q[size_t(o) * D + i];
        k[o] = 128 * sum;
        pack16_nibbles(q + size_t(o) * D, D, c + size_t(o) * (D / 2));
      }
      *cols = c;
      *krowp = k;
    } else {
      uint8_t* c = take(size_t(d_in) * (D / 2));
      int8_t col[D];
      for (int i = 0; i < d_in; i++) {
        for (int o = 0; o < D; o++) col[o] = q[size_t(o) * d_in + i];
        pack16_nibbles(col, D, c + size_t(i) * (D / 2));
      }
      *cols = c;
    }
    *foldp = f;
  };

  // [this entry] Builder for mlp.up (768 rows) and the q / k / v projections
  // (192 rows), kernel gemv16p_set. k[o] = 128 * (sum of row o's weights)
  // undoes the re-centring of the activation's low byte (act16.cpp).
  // packed-row site with 192 inputs and d_out rows (act16 bits 4 and 8)
  auto rows16 = [&](const std::string& prefix, int d_out) -> Rows16 {
    const WTensor& wq =
        wf.get(prefix + ".weight.q", DT_I8,
               {static_cast<uint32_t>(d_out), static_cast<uint32_t>(D)});
    const WTensor& ws = wf.get(prefix + ".weight.scale", DT_BF16,
                               {static_cast<uint32_t>(d_out)});
    const WTensor& sa =
        wf.get(prefix + ".quantize_activation.scale", DT_BF16, {1});
    Rows16 r;
    r.s16 = bf16_to_f32(sa.bf16_bits()[0]) * (1.0f / 256.0f);
    float* f = reinterpret_cast<float*>(take(sizeof(float) * d_out));
    for (int o = 0; o < d_out; o++)
      f[o] = r.s16 * bf16_to_f32(ws.bf16_bits()[o]);
    const int8_t* q = wq.i8();
    for (size_t i = 0; i < size_t(d_out) * D; i++)
      if (q[i] < -7 || q[i] > 7) die("act16: weight outside [-7, 7]");
    int32_t* k = reinterpret_cast<int32_t*>(take(sizeof(int32_t) * d_out));
    uint8_t* c = take(size_t(d_out) * (D / 2));
    for (int o = 0; o < d_out; o++) {
      int32_t sum = 0;
      for (int i = 0; i < D; i++) sum += q[size_t(o) * D + i];
      k[o] = 128 * sum;
      pack16_nibbles(q + size_t(o) * D, D, c + size_t(o) * (D / 2));
    }
    r.rows = c;
    r.k = k;
    r.fold = f;
    return r;
  };
  if ((act16 & 4) && !(act16 & 1)) die("CMIX_ACT16: bit 4 needs bit 1");
  const char* const qkv_names[3] = {"query_projection", "key_projection",
                                    "value_projection"};

  // ---- stream, in per-token consumption order ----
  // prior embedding: 192 x 205, input = the PPMD prior probabilities quantized
  // to 8 bits (mostly zeros), int4 column arena for the sparse kernel
  prior = qsp4("prior_embedding", V, &prior_s_act);

  {
    const WTensor& sw = wf.get("skip_connection_weights.value", DT_F32, {6});
    for (int i = 0; i < 6; i++) skip_w[i] = sw.f32()[i];
  }

  int ki = 0, vi = 0;
  for (int l = 0; l < NL; l++) {
    std::string b = "blocks." + std::to_string(l) + ".";
    rsc[l] =
        wf.get(b + "residual_stream_coefficient.value", DT_F32, {1}).f32()[0];
    tec[l] =
        wf.get(b + "token_embedding_coefficient.value", DT_F32, {1}).f32()[0];
    std::string a = b + "attention.";

    if (KIMI_L[l]) {
      // Kimi layer: q/k/v projections, forget gate and output gate (each a
      // low-rank 192 -> 64 -> 192 pair), fp32 extras, output projection
      KimiArenas& L = kimi[ki];
      layer2kimi[l] = ki;
      // [this entry] 16-bit packed rows instead of the 8-bit dense arenas
      if (act16 & 8) {
        for (int c = 0; c < 3; c++) qkv16[l][c] = rows16(a + qkv_names[c], D);
      } else {
        L.qp = qsite(a + "query_projection", D, D, true);
        L.kp = qsite(a + "key_projection", D, D, true);
        L.vp = qsite(a + "value_projection", D, D, true);
      }
      L.fg_up = qsite(a + "forget_gate_projection.up", DH, D, true);
      L.fg_down = qsite(a + "forget_gate_projection.down", D, DH, true);
      L.og_up = qsite(a + "output_gate_projection.up", DH, D, true);
      L.og_down = qsite(a + "output_gate_projection.down", D, DH, true);

      {
        const WTensor& bw =
            wf.get(a + "beta_projection.weight", DT_F32, {NH, D});
        L.beta_w = f32block(bw.f32(), size_t(NH) * D);
      }
      const char* convs[3] = {"query_convolution.weight",
                              "key_convolution.weight",
                              "value_convolution.weight"};
      for (int c = 0; c < 3; c++) {
        const WTensor& cw = wf.get(a + convs[c], DT_F32, {D, 4});
        float* wt = reinterpret_cast<float*>(take(sizeof(float) * 4 * D));
        for (int j = 0; j < 4; j++)  // tap-major repack, same as naive
          for (int ch = 0; ch < D; ch++) wt[j * D + ch] = cw.f32()[ch * 4 + j];
        L.kw.conv_w[c] = wt;
      }
      {
        const WTensor& dt = wf.get(a + "dt_bias", DT_F32, {D});
        L.kw.dt_bias = f32block(dt.f32(), D);
      }
      {
        const WTensor& gw =
            wf.get(a + "output_fused_norm_gate.weight", DT_F32, {DH});
        L.kw.gn_w = f32block(gw.f32(), DH);
      }
      {
        const WTensor& al = wf.get(a + "log_baseline_decay_rate", DT_F32, {NH});
        for (int h = 0; h < NH; h++) L.kw.a_neg[h] = -std::exp(al.f32()[h]);
      }
      // [this entry] output projection with a 16-bit input
      if (act16 & 2)
        cols16(a + "output_projection", D, true, &op16[l], &op_fold16[l],
               &op_s16[l], &op_k16[l]);
      else
        L.op = qsite(a + "output_projection", D, D, true);
      ki++;
    } else {
      // vanilla attention layer: q/k/v projections, output projection, and
      // the per-head scales of the post-RoPE q/k/v quantizers
      VanArenas& L = van[vi];
      layer2van[l] = vi;
      // [this entry] 16-bit variants, as in the Kimi branch
      if (act16 & 8) {
        for (int c = 0; c < 3; c++) qkv16[l][c] = rows16(a + qkv_names[c], D);
      } else {
        L.qp = qsite(a + "query_projection", D, D, true);
        L.kp = qsite(a + "key_projection", D, D, true);
        L.vp = qsite(a + "value_projection", D, D, true);
      }
      if (act16 & 2)
        cols16(a + "output_projection", D, true, &op16[l], &op_fold16[l],
               &op_s16[l], &op_k16[l]);
      else
        L.op = qsite(a + "output_projection", D, D, true);
      const WTensor& qs = wf.get(a + "quantize_queries.scale", DT_BF16, {NH});
      const WTensor& ks = wf.get(a + "quantize_keys.scale", DT_BF16, {NH});
      const WTensor& vs = wf.get(a + "quantize_values.scale", DT_BF16, {NH});
      for (int h = 0; h < NH; h++) {
        L.sq[h] = bf16_to_f32(qs.bf16_bits()[h]);
        L.sk[h] = bf16_to_f32(ks.bf16_bits()[h]);
        L.sv[h] = bf16_to_f32(vs.bf16_bits()[h]);
        L.coef[h] = 0.125f * L.sq[h] * L.sk[h];
      }
      vi++;
    }

    // MLP of the layer: up (768 x 192) then down (192 x 768)
    // [this entry] 16-bit inputs: packed rows for up, packed columns for down
    if (act16 & 4)
      up16[l] = rows16(b + "mlp.up", DMLP);
    else
      mlp[l].up = qsite(b + "mlp.up", DMLP, D, true);
    if (act16 & 1)
      cols16(b + "mlp.down", DMLP, false, &down16[l], &down_fold16[l],
             &down_s16[l], nullptr);
    else
      mlp[l].down = qsp4(b + "mlp.down", DMLP, &mlp[l].down_s_act);
  }
  if (ki != 9 || vi != 3) die("layer pattern mismatch");

  // output layer: 205 logits from the final hidden state (8-bit input)
  unembed = qsite("unembedding", V, D, true);
  stream_bytes = round64(off);

  // ---- non-stream data: tail slack gap, then the normed embedding table ----
  off += QMAT_TAIL_SLACK;
  {
    const WTensor& eq = wf.get("embedding.weight.q", DT_I8, {V, D});
    const WTensor& es = wf.get("embedding.weight.scale", DT_BF16, {V});
    std::vector<float> rs(V);
    for (int c = 0; c < V; c++) rs[c] = bf16_to_f32(es.bf16_bits()[c]);
    float* table = reinterpret_cast<float*>(take(sizeof(float) * V * D));
    build_normed_embedding_table(eq.i8(), rs.data(), table);
    tok_table = table;
  }

  // RoPE sin / cos tables for the vanilla layers (the FX2TFWC2 weights file
  // does not store them: its decoder, weights_io_compressed.cpp, recomputes
  // them bit-exactly)
  {
    const WTensor& fi = wf.get("rope.inv_freq", DT_F32, {32});
    std::memcpy(inv_freq, fi.f32(), sizeof(inv_freq));
    const WTensor& si = wf.get("rope.sin", DT_F32,
                               {static_cast<uint32_t>(ROPE_LEN), 32});
    const WTensor& co = wf.get("rope.cos", DT_F32,
                               {static_cast<uint32_t>(ROPE_LEN), 32});
    rope_sin.assign(si.f32(), si.f32() + size_t(ROPE_LEN) * 32);
    rope_cos.assign(co.f32(), co.f32() + size_t(ROPE_LEN) * 32);
  }
}

}  // namespace opt
}  // namespace fx2
