// run-map.cpp: RunMap, see run-map.h.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#include "run-map.h"

// Build table_[state * 2 + bit]. A 0 bit lengthens a run of zeros (up to 127) and resets a run
// of ones to state 0; a 1 bit lengthens a run of ones (up to 255) and turns a run of zeros
// into state 128.
RunMap::RunMap() {
  for (int i = 0; i < 512; ++i) {
    int state = i/2;
    if (i%2 == 0) {
      if (state < 127) ++state;
      else if (state >= 128) state = 0;
    } else {
      if (state < 128) state = 128;
      else if (state < 255) ++state;
    }
    table_[i] = state;
  }
}

// Starting probability of a 1: the longer the run of zeros, the lower; the longer the run of
// ones, the higher.
float RunMap::InitProbability(int state) const {
  if (state < 128) return (128.0 - state) / 256;
  return state / 256.0;
}

int RunMap::Next(int state, int bit) const {
  return table_[state * 2 + bit];
}
