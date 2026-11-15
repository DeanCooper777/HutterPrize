// act16.h — 16-bit activation kernels for the quantized matmuls of the
// transformer byte model.
//
// What it does. Every quantized matmul of the model is
//   y[o] = (s_act * s_w[o]) * sum_i qa[i] * qw[o][i]
// with 4-bit weights qw in [-7, 7] and a quantized input qa (SPEC.md section
// 2). The previous winning entry rounds every input to 8 bits (256 levels).
// The kernels here take the input rounded to 16 bits instead: 65,536 levels
// over the same clamp range, i.e. the activation scale becomes
// (stored scale) / 256 and qa is an int16. The weights file and the 4-bit
// weights are unchanged (the training side has the same option, A_ACT16).
//
// Why it makes the archive smaller. Rounding an activation to 256 levels adds
// noise to every matmul input; with 65,536 levels that noise is 256 times
// smaller, so the same weights predict the next byte better and the
// arithmetic coder spends fewer bits. The cost is run time only (wider
// products); no extra bytes are stored.
//
// Which inputs use it: arena_build.h, switch CMIX_ACT16 (bitmask, default 15):
//   bit 1: mlp.down input (the relu^2 output, >= 0)   -> spmv16p_add
//   bit 2: attention output-projection input           -> gemv16p_add
//   bit 4: mlp.up input (needs bit 1)                  -> gemv16p_set
//   bit 8: query / key / value projection inputs       -> gemv16p_set
// The prior embedding, the Kimi gate projections and the unembedding keep
// their 8-bit inputs (qmat_dense.h / qmat_sparse.h). Compressor and
// decompressor must run with the same value.
//
// Why the results are identical on every CPU (the decompressor has to
// reproduce the compressor's probabilities bit for bit):
//   - quantization is one IEEE fp32 division, a clamp and a round-half-even
//     conversion, each an explicit intrinsic;
//   - the dot products are integer sums that never overflow or saturate (the
//     bounds are stated at each kernel), so every way of splitting the sum
//     gives the same int32;
//   - the epilogue is one int32 -> fp32 conversion, one fp32 multiply by the
//     folded scale and, for the "_add" kernels, one fp32 add: the same three
//     operations as the 8-bit kernels of qmat_dense.h.
// Only AVX2 is used.
//
// Where it sits: preprocess -> dictionary -> context models / PPMD /
// TRANSFORMER BYTE MODEL -> mixers -> SSE -> arithmetic coder. Called once or
// more per layer per byte by model_opt.cpp; the weights are laid out by
// arena_build.cpp.
//
// Testing: test_act16.cpp requires bitwise equal results on random inputs:
// the packed kernels against the plain int8 kernels below, and gemv16p_set
// against a scalar reference.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
// New in this entry.
//
// Two generations of kernels live here. The first (spmv16_add, gemv16_add)
// keeps the weights as plain int8 (mlp.down as columns, the output
// projection as rows), takes int16 activations and accumulates exact int32
// dots with vpmaddwd. The model uses the second, "packed" generation below;
// the first is kept as the simple form the packed one is tested against.
#pragma once

#include <cstdint>

namespace fx2 {
namespace opt {

// ---- first generation: plain int8 weights (reference for the packed ones) --

// The MLP nonlinearity fused with the quantizer of the mlp.down input:
// a[i] = clamp(round_half_even(relu(h[i])^2 / s), 0, 32767) for i < 768
// (n must be a multiple of 8); idx receives the ascending positions of the
// nonzeros (room for n + 8 entries). Returns nnz. Most relu^2 outputs are
// zero, so the matmul that follows only visits the listed columns.
int relu2_quant16(const float* h, float s, int n, int16_t* a, uint16_t* idx);

// The signed 16-bit activation quantizer (s = stored 8-bit scale / 256):
// a[i] = clamp(round_half_even(x[i] / s), -32768, 32767), i < 192
void quant192_i16(const float* x, float s, int16_t* a);

// Sparse matrix x vector, added to the residual stream (fold[r] = activation
// scale * weight scale of row r):
// out[r] += fold[r] * float(sum_k a[idx[k]] * cols[idx[k]*192 + r]), r < 192
// (int8 columns; idx needs 8 readable in-range entries past nnz)
void spmv16_add(const int8_t* cols, const float* fold, const int16_t* a,
                const uint16_t* idx, int nnz, float* out);

// dense 192x192, weights as int8 ROWS:
// out[r] += fold[r] * float(sum_c a[c] * rows[r*192 + c])
void gemv16_add(const int8_t* rows, const float* fold, const int16_t* a,
                float* out);

// ---------------------------------------------------------------------------
// Packed variants (the ones the model uses). The weights are stored as
// nibbles u = w + 7 in [0, 14], 96 bytes per 192-element column / row: byte i
// of 32-byte chunk j holds element 64j + i in its low nibble and element
// 64j + 32 + i in its high nibble. That is half the bytes of the int8 layout
// (these kernels are cache-miss-bound), and the 16-bit activation is split
// into its two bytes so the products run on vpmaddubsw (32 per instruction)
// instead of sign-extended vpmaddwd. The int32 dots, and so the results, are
// exactly those of spmv16_add / gemv16_add.
// ---------------------------------------------------------------------------

// [this entry] mlp.down input quantizer of the shipped path.
// As relu2_quant16, and also lists the positions with a[i] >= 256 in idxh
// (room for n + 8 entries; *nh receives their count) and returns the sum of
// a in *suma. idx gets 16 readable in-range entries past nnz (room for
// n + 16).
int relu2_quant16p(const float* h, float s, int n, int16_t* a, uint16_t* idx,
                   uint16_t* idxh, int* nh, int32_t* suma);

// pack int8 weights w[n] in [-7, 7] (n a multiple of 64) into n / 2 bytes
void pack16_nibbles(const int8_t* w, int n, uint8_t* dst);

// [this entry] mlp.down (192 x 768) of every layer, added to the residual:
// out[r] += fold[r] * float(sum_k a[idx[k]] * W[r][idx[k]]), r < 192, a >= 0;
// cols = packed columns (96 B each); idx / idxh / nh / suma as returned by
// relu2_quant16p.
void spmv16p_add(const uint8_t* cols, const float* fold, const int16_t* a,
                 const uint16_t* idx, int nnz, const uint16_t* idxh, int nh,
                 int32_t suma, float* out);

// [this entry] attention output projection of every layer, added to the
// residual (a = signed 16-bit quantized attention output):
// dense 192x192, packed ROWS (96 B each); krow[r] = 128 * sum_c W[r][c]:
// out[r] += fold[r] * float(sum_c a[c] * W[r][c])
void gemv16p_add(const uint8_t* rows, const float* fold, const int32_t* krow,
                 const int16_t* a, float* out);

// [this entry] mlp.up (768 rows) and the query / key / value projections
// (192 rows each); the result is a fresh vector, not added to the residual.
// As gemv16p_add for nrows packed rows (a multiple of 8) of 192 inputs, and
// it stores instead of adding: out[r] = fold[r] * float(sum_c a[c] * W[r][c])
void gemv16p_set(const uint8_t* rows, const float* fold, const int32_t* krow,
                 const int16_t* a, int nrows, float* out);

}  // namespace opt
}  // namespace fx2
