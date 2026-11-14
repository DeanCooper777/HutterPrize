// act16.h — EXPERIMENTAL 16-bit activation path for two matmul inputs:
// the mlp.down input (relu^2 output) and the attention output-projection
// input. The 4-bit weights are unchanged; the activation quantizer gets
// 65,536 levels over the same clamp range (scale / 256), as in the training
// side's A_ACT16 option. Enabled by the environment variable CMIX_ACT16
// (bit 0 = mlp.down input, bit 1 = output-projection input); compressor and
// decompressor must see the same value.
//
// Weights for these sites are kept as plain int8 (mlp.down as columns,
// the output projection as rows); the kernels take int16 activations
// and accumulate exact int32 dots with vpmaddwd.
#pragma once

#include <cstdint>

namespace fx2 {
namespace opt {

// a[i] = clamp(round_half_even(relu(h[i])^2 / s), 0, 32767) for i < 768
// (n must be a multiple of 8); idx receives the ascending positions of the
// nonzeros (room for n + 8 entries). Returns nnz.
int relu2_quant16(const float* h, float s, int n, int16_t* a, uint16_t* idx);

// a[i] = clamp(round_half_even(x[i] / s), -32768, 32767), i < 192
void quant192_i16(const float* x, float s, int16_t* a);

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

// As relu2_quant16, and also lists the positions with a[i] >= 256 in idxh
// (room for n + 8 entries; *nh receives their count) and returns the sum of
// a in *suma. idx gets 16 readable in-range entries past nnz (room for
// n + 16).
int relu2_quant16p(const float* h, float s, int n, int16_t* a, uint16_t* idx,
                   uint16_t* idxh, int* nh, int32_t* suma);

// pack int8 weights w[n] in [-7, 7] (n a multiple of 64) into n / 2 bytes
void pack16_nibbles(const int8_t* w, int n, uint8_t* dst);

// out[r] += fold[r] * float(sum_k a[idx[k]] * W[r][idx[k]]), r < 192, a >= 0;
// cols = packed columns (96 B each); idx / idxh / nh / suma as returned by
// relu2_quant16p.
void spmv16p_add(const uint8_t* cols, const float* fold, const int16_t* a,
                 const uint16_t* idx, int nnz, const uint16_t* idxh, int nh,
                 int32_t suma, float* out);

// dense 192x192, packed ROWS (96 B each); krow[r] = 128 * sum_c W[r][c]:
// out[r] += fold[r] * float(sum_c a[c] * W[r][c])
void gemv16p_add(const uint8_t* rows, const float* fold, const int32_t* krow,
                 const int16_t* a, float* out);

}  // namespace opt
}  // namespace fx2
