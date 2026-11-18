// compares WeightsFile::load(reference) against
// WeightsFile::load_compressed(compressed) tensor by tensor, bit for bit.
//
// usage: test_weights_compressed <reference.bin> <compressed>
//
// What it verifies: the weight-file decoder used at start-up
// (WeightsFile::load_compressed in weights_io_compressed.cpp) is lossless.
// Reference = the same weights in the plain uncompressed container read by
// WeightsFile::load (weights_io.cpp), i.e. the export that the Python coder
// (pysrc/weights_compress.py) compressed. Every tensor must have the same
// name, dtype, shape and bytes.
//
// Where it sits: the compressed weights file is appended to the compressor
// and to the self-extracting archive, and is decoded once before the
// transformer byte model starts predicting. One wrong weight would change the
// predictions, so this protects weights_io_compressed.cpp.
//
// Testing: build with `make test_weights_compressed` in cpp_infer/
// (-> bin/test_weights_compressed). Pass: the line "OK: N tensors, M payload
// bytes bit-identical" and exit code 0; any difference prints "FAIL: ..." and
// exits 1.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
// this file is unchanged. [this entry] added a tensor encoding (ENC_INTC) to
// the FX2TFWC2 decoder it tests; load_compressed picks the format from the
// file's magic, so the same test covers the shipped .tfwc2 files.

#include <cstdio>
#include <cstring>

#include "weights_io.h"

int main(int argc, char** argv) {
  if (argc != 3) {
    std::fprintf(stderr, "usage: %s <reference.bin> <compressed>\n", argv[0]);
    return 2;
  }
  fx2::WeightsFile ref = fx2::WeightsFile::load(argv[1]);
  fx2::WeightsFile cmp = fx2::WeightsFile::load_compressed(argv[2]);

  if (ref.tensors.size() != cmp.tensors.size()) {
    std::fprintf(stderr, "FAIL: %zu tensors vs %zu\n", ref.tensors.size(),
                 cmp.tensors.size());
    return 1;
  }
  size_t bytes = 0;
  for (const auto& [name, rt] : ref.tensors) {
    if (!cmp.has(name)) {
      std::fprintf(stderr, "FAIL: missing tensor %s\n", name.c_str());
      return 1;
    }
    const fx2::WTensor& ct = cmp.get(name);
    if (rt.dtype != ct.dtype || rt.shape != ct.shape ||
        rt.data.size() != ct.data.size() ||
        std::memcmp(rt.data.data(), ct.data.data(), rt.data.size()) != 0) {
      std::fprintf(stderr, "FAIL: tensor %s differs\n", name.c_str());
      return 1;
    }
    bytes += rt.data.size();
  }
  std::printf("OK: %zu tensors, %zu payload bytes bit-identical\n",
              ref.tensors.size(), bytes);
  return 0;
}
