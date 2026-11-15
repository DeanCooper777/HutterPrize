// byte-model.cpp: ByteModel, the byte-distribution -> bit-probability conversion. See
// byte-model.h.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#include "byte-model.h"

#include <numeric>

ByteModel::ByteModel(const std::vector<bool>& vocab) : ex(0),top_(255), mid_(0),
    bot_(0),  vocab_(vocab), probs_(1.0 / 256, 256) {}

 // P(next bit = 1) = (probability mass of the upper half of [bot_, top_]) / (mass of the whole
 // range). Also records in `ex` the most probable byte of the range. If the range has no mass
 // (the model gave probability 0 to everything still possible) the answer is 0.5.
 std::valarray<float>& ByteModel::Predict()  {
  auto mid = bot_ + ((top_ - bot_) / 2);
  float num = std::accumulate(&probs_[mid + 1], &probs_[top_ + 1], 0.0f);
  float denom = std::accumulate(&probs_[bot_], &probs_[mid + 1], num);
  ex = bot_;
    float max_prob_val = probs_[bot_];
    for (int i = bot_ + 1; i <= top_; i++) {
      if (probs_[i] > max_prob_val) {
        max_prob_val = probs_[i];
        ex = i;
      }
    }
  if (denom == 0) outputs_[0] = 0.5;
  else outputs_[0] = num / denom;
  return outputs_;
}

const std::valarray<float>& ByteModel::BytePredict() {
  return probs_;
}

// Narrow the range to the half selected by the coded bit (bits are coded high to low).
void ByteModel::Perceive(int bit) {
  mid_ = bot_ + ((top_ - bot_) / 2);
  if (bit) {
    bot_ = mid_ + 1;
  } else {
    top_ = mid_;
  }
}

// Start a new byte: the whole range is possible again; bytes outside the vocabulary get 0.
// The derived class has already written the new distribution into probs_.
void ByteModel::ByteUpdate() {
  top_ = 255;
  bot_ = 0;
  for (int i = 0; i < 256; ++i) {
    if (!vocab_[i]) probs_[i] = 0;
  }
}

