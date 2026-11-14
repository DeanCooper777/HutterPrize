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
  int ex;
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
  int top_, mid_, bot_;
  const std::vector<bool>& vocab_;
  std::valarray<float> probs_;
};

#endif

