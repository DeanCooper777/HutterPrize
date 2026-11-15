// direct.h: directly indexed probability table. The probability of a 1 is stored for every
// (byte context value, bits of the current byte so far) pair and nudged towards each coded bit.
//
// One instance, selected by the bracket context (Predictor::AddBracket in src/predictor.cpp).
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef DIRECT_H
#define DIRECT_H

#include "model.h"

#include <vector>
#include <array>

class Direct : public Model {
 public:
  Direct(const unsigned long long& byte_context,
      const unsigned int& bit_context, int limit, float delta, int size);
  const std::valarray<float>& Predict() const;
  void Perceive(int bit);
  void ByteUpdate() {};

 private:
  const unsigned long long& byte_context_;
  const unsigned int& bit_context_;
  // The adaptation rate is 1 / (count + delta) while the slot has been used fewer than limit_
  // times, then stays at 1 / (limit + delta): fast learning first, then a moving average.
  int limit_;
  float delta_, divisor_;
  std::vector<std::array<float, 256>> predictions_;
  std::vector<std::array<unsigned char, 256>> counts_;
};

#endif

