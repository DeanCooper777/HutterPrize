// ppmd.h: interface of the PPMD byte model (ppmd.cpp): PPM variant D by Dmitry Shkarin, in
// Eugene Shelwien's mod_ppmd form, order 25 with a 14 GB model heap (Predictor::AddPPMD in
// src/predictor.cpp).
//
// Once per byte it produces a probability for each of the 256 byte values. That distribution
// is used twice: converted to bit probabilities it is one input of the cmix mixers (through
// ByteModel), and the whole distribution is an input of the transformer byte model.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.
// (For the memory budget see ppmd.cpp.)

#ifndef PPMD_H
#define PPMD_H

#include "byte-model.h"

#include <memory>

namespace PPMD {

struct ppmd_Model;

class PPMD : public ByteModel {
 public:
  PPMD(int order, int memory, const unsigned int& bit_context,
      const std::vector<bool>& vocab);
  ~PPMD();
  void ByteUpdate();
 private:
  // byte_: the byte just coded (ContextManager::bit_context_ at byte boundaries).
  // ppmd_model_: the PPMD engine and its heap. byte_map_ is not used.
  const unsigned int& byte_;
  std::unique_ptr<ppmd_Model> ppmd_model_;
  std::valarray<int> byte_map_;
};

} // namespace PPMD

#endif

