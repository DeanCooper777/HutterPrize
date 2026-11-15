// run-map.h: state machine that counts runs of equal bits.
//
// States 1..127: a run of that many 0 bits; states 128..255: a run of (state - 127) 1 bits;
// state 0: start. Used by one Indirect model (word context {1}, Predictor::AddWord in
// src/predictor.cpp).
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef RUN_MAP_H
#define RUN_MAP_H

#include "state.h"

#include <array>

class RunMap : public State {
 public:
  RunMap();
  float InitProbability(int state) const;
  int Next(int state, int bit) const;

 private:
  std::array<unsigned char, 512> table_;
};

#endif
