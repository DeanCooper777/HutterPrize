// bracket.h: byte-level model that predicts the closing bracket or quote.
//
// It keeps a stack of open brackets and counts, for each opening byte and each distance since
// it opened, how often the matching closing byte came next. Its distribution gives that
// probability to the closing byte and spreads the rest evenly. One instance, created by
// Predictor::AddBracket (src/predictor.cpp); its bit prediction is one mixer input.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef BRACKET_H
#define BRACKET_H

#include "byte-model.h"

#include "../ds/emhash_map.hpp"
#include <vector>
#include <utility>

class Bracket : public ByteModel {
 public:
  Bracket(const unsigned int& bit_context, int distance_limit, int stack_limit,
      int stats_limit, const std::vector<bool>& vocab);
  void ByteUpdate();

 private:
  // brackets_: opening byte -> closing byte. active_ / distance_: the stack of open brackets and
  // the bytes since each opened. stats_[open][distance] = {times the closing byte came next,
  // times this situation was seen}; halved when the second count passes stats_limit_.
  emhash6::HashMap<unsigned char, unsigned char> brackets_;
  unsigned int distance_limit_, stack_limit_, stats_limit_;
  std::vector<unsigned int> active_, distance_;
  const unsigned int& byte_;
  std::vector<std::vector<std::pair<unsigned int, unsigned int>>> stats_;
};

#endif

