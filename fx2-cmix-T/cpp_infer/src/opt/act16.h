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

}  // namespace opt
}  // namespace fx2
