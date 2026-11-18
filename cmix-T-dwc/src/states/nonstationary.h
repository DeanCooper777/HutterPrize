// nonstationary.h: the general-purpose bit-history state machine (256 states), given as a
// fixed transition table. Used by every Indirect model of this entry except one (see
// Predictor::AddWord, AddBracket and AddDoubleIndirect in src/predictor.cpp).
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef NONSTATIONARY_H
#define NONSTATIONARY_H

#include "state.h"

#include <array>

class Nonstationary : public State {
 public:
  Nonstationary();
  float InitProbability(int state) const;
  int Next(int state, int bit) const;

 private:
  std::array<std::array<unsigned char, 2>, 256> table_;
};

#endif

