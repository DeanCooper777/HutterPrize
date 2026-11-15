// match.h: match model. It remembers, for each context hash, where in the history the byte
// that followed that context is stored. When the context comes back it predicts that the same
// byte follows, and keeps following the old text for as long as the prediction is right.
//
// Predictor creates ten of them (AddWord: word contexts; AddMatch: byte-hash contexts of
// several orders; src/predictor.cpp). Each gives one mixer input. They also report the longest
// current match through *longest_match, which the predictor uses as a mixer-selection context.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef MATCH_H
#define MATCH_H

#include "model.h"

#include <vector>
#include <array>

class Match : public Model {
 public:
  Match(const std::vector<unsigned char>& history,
    const unsigned long long& byte_context, const unsigned int& bit_context_,
    int limit, float delta, unsigned long long map_size,
    unsigned long long* longest_match);
  const std::valarray<float>& Predict() const;
  void Perceive(int bit);
  void ByteUpdate();

 private:
  const std::vector<unsigned char>& history_;
  const unsigned long long& byte_context_;
  const unsigned int& bit_context_;
  // history_: the bytes coded so far (a ring buffer owned by ContextManager). cur_match_:
  // position in history_ of the predicted byte, cur_byte_. bit_pos_: mask of the bit being
  // predicted. match_length_: number of consecutive correctly predicted bits (max 255).
  // map_: context hash -> history position. predictions_[match_length_]: learned probability
  // that the predicted bit is right at that match length.
  unsigned long long history_pos_, cur_match_;
  unsigned char cur_byte_, bit_pos_, match_length_;
  unsigned long long* longest_match_;
  int limit_;
  float delta_, divisor_;
  std::vector<unsigned int> map_;
  std::array<float, 256> predictions_;
  std::array<int, 256> counts_;
};

#endif


