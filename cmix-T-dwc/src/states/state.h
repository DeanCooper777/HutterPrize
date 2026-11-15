// state.h: interface of the bit-history state machines used by the Indirect model
// (src/models/indirect.h).
//
// A state is one byte that summarizes the bits seen so far in one context. Next(state, bit)
// gives the state after one more bit; InitProbability(state) is the starting guess for the
// probability of a 1 in that state. The Indirect model learns the real probability of each
// state while coding.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
// Two machines exist: Nonstationary (general bit histories) and RunMap (runs of equal bits).
//
// The functions are not virtual: Indirect is a template over the concrete state type.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef STATE_H
#define STATE_H

class State {
 public:
  virtual ~State() {}
  float InitProbability(int state) const { return 0.5; }
  int Next(int state, int bit) const { return 0; }
};

#endif


