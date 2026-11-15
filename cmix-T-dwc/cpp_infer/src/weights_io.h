// weights_io: loader for cpp_infer/data/weights.bin (SPEC.md section 4)
//
// The in-memory form of a weights file: a map from tensor name to WTensor.
// Two readers fill it: load (plain FX2TFW01, weights_io.cpp) and
// load_compressed (FX2TFWC1 / FX2TFWC2, weights_io_compressed.cpp; the
// shipped ".tfwc2" file).
//
// How it fits: start-up only. opt/arena_build.cpp reads the tensors through
// this interface and builds the run-time weight stream of the transformer
// byte model.
//
// Testing: test_weights_compressed.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
// Unchanged from the previous winning entry.
// ([this entry] added a payload coding to the compressed reader; this
// interface did not change.)
#pragma once

#include <cstddef>
#include <cstdint>
#include <initializer_list>
#include <string>
#include <unordered_map>
#include <vector>

namespace fx2 {

enum WDtype : uint8_t { DT_I8 = 0, DT_BF16 = 1, DT_F32 = 2, DT_I32 = 3 };

struct WTensor {
  uint8_t dtype = 0;
  std::vector<uint32_t> shape;
  std::vector<uint8_t> data;
  size_t numel = 0;

  const int8_t* i8() const { return reinterpret_cast<const int8_t*>(data.data()); }
  const uint16_t* bf16_bits() const {
    return reinterpret_cast<const uint16_t*>(data.data());
  }
  const float* f32() const { return reinterpret_cast<const float*>(data.data()); }
  const int32_t* i32() const {
    return reinterpret_cast<const int32_t*>(data.data());
  }
};

// fp32 value of raw bfloat16 bits (bits << 16 reinterpreted as float)
inline float bf16_to_f32(uint16_t bits) {
  union {
    uint32_t u;
    float f;
  } v;
  v.u = static_cast<uint32_t>(bits) << 16;
  return v.f;
}

struct WeightsFile {
  std::unordered_map<std::string, WTensor> tensors;

  // parses the whole file; aborts with a message on any format error
  static WeightsFile load(const char* path);

  // parses a losslessly compressed file (magic FX2TFWC1/FX2TFWC2, written by
  // pysrc/weights_compress.py); yields tensors bit-identical to load() on the
  // matching uncompressed file (weights_io_compressed.cpp)
  static WeightsFile load_compressed(const char* path);

  bool has(const std::string& name) const { return tensors.count(name) != 0; }
  const WTensor& get(const std::string& name) const;
  // get + validate dtype and exact shape
  const WTensor& get(const std::string& name, uint8_t dtype,
                     std::initializer_list<uint32_t> shape) const;
};

}  // namespace fx2
