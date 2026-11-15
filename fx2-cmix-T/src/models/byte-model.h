// byte-model.h: base class of models that predict a whole byte (256 probabilities) at once.
//
// PPMD (ppmd.*), Bracket (bracket.*) and ByteMixer (src/mixer/byte-mixer.*, which carries the
// transformer's distribution) derive from it. The derived class fills probs_ once per byte in
// its ByteUpdate(); this class turns that byte distribution into the bit probabilities the
// mixers need, one per bit, by walking down the binary tree over the byte values.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
//   - LoadVocabProbs() added: lets the multi-core experiment mode (CMIX_PIPE, compress only,
//     never in the submitted binary) put back a PPMD distribution that a worker thread computed
//     ahead of the coder. It does not affect the normal (submitted) code path.

#ifndef BYTE_MODEL_H
#define BYTE_MODEL_H

#include "model.h"

#include <valarray>
#include <vector>

class ByteModel : public Model {
 public:
  virtual ~ByteModel() {}
  ByteModel(const std::vector<bool>& vocab);
  const std::valarray<float>& BytePredict();
   std::valarray<float>& Predict() ;
  void Perceive(int bit);
  // ex: the most probable byte among those still possible ("expected byte"), set by Predict().
  // The fxcm model reads the byte mixer's value through the global lstmex (src/predictor.cpp).
  int ex;
  // [this entry] Used only by Predictor::PipeAdvance (CMIX_PIPE mode) in src/predictor.cpp.
  // Puts back a distribution saved from BytePredict() right after a
  // ByteUpdate (p[i] = the probability of byte vocab_bytes[i]; every other
  // byte has probability 0), as if that ByteUpdate had just run.
  void LoadVocabProbs(const float* p, const std::vector<int>& vocab_bytes) {
    top_ = 255;
    bot_ = 0;
    probs_ = 0.0f;
    for (size_t i = 0; i < vocab_bytes.size(); ++i) probs_[vocab_bytes[i]] = p[i];
  }
 protected:
  void ByteUpdate();
  // [bot_, top_]: the byte values still possible given the bits of the current byte coded so
  // far. vocab_[b]: whether byte b occurs in the stream at all (bytes outside the vocabulary get
  // probability 0). probs_: the distribution over the 256 byte values for the current byte.
  int top_, mid_, bot_;
  const std::vector<bool>& vocab_;
  std::valarray<float> probs_;
};

#endif

