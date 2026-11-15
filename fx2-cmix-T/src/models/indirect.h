// indirect.h: indirect context model. The context selects a one-byte bit-history state (see
// src/states/state.h), and the state selects an adaptive probability. So contexts that have
// seen the same pattern of bits share one probability, which is learned much faster than one
// probability per context.
//
// Predictor (src/predictor.cpp: AddBracket, AddWord, AddDoubleIndirect) creates these over the
// bracket context, the word contexts and the indirect contexts ind1, ind2, ind3 and ind5
// (src/context-manager.cpp), with the
// Nonstationary state machine, and one with the RunMap machine. Each gives one mixer input.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// All instances keep their states in one shared table (ContextManager::shared_map_), each at
// its own offset.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef INDIRECT_H
#define INDIRECT_H

#include "model.h"
#include "../states/state.h"

#include <vector>
#include <array>
#include <stdlib.h>

template<typename StateType>
class Indirect : public Model {
 public:
  Indirect(const StateType& state,
      const unsigned long long& byte_context,
      const unsigned int& bit_context, float delta,
      std::vector<unsigned char>& map);
  const std::valarray<float>& Predict() const;
  void Perceive(int bit);
  void ByteUpdate();

 private:
  const unsigned long long& byte_context_;
  const unsigned int& bit_context_;
  // map_index_: start of the 256 state slots of the current byte context inside the shared map
  // (slot = map_index_ + partial byte). predictions_[state]: learned probability of a 1.
  unsigned long long map_index_, map_offset_;
  float divisor_;
  const StateType& state_;
  std::vector<unsigned char>& map_;
  std::array<float, 256> predictions_;
};


template<typename StateType>
Indirect<StateType>::Indirect(const StateType& state,
    const unsigned long long& byte_context,
    const unsigned int& bit_context, float delta,
    std::vector<unsigned char>& map) :  byte_context_(byte_context),
    bit_context_(bit_context), map_index_(0), map_offset_(0),
    divisor_(1.0 / delta), state_(state), map_(map) {
  // A per-instance offset keeps the instances from all hitting the same slots. rand() is seeded
  // identically in the compressor and the decompressor, so both get the same offsets.
  map_offset_ = rand() % (map_.size() - 257);
  for (int i = 0; i < 256; ++i) {
    predictions_[i] = state_.InitProbability(i);
  }
}

template<typename StateType>
const std::valarray<float>& Indirect<StateType>::Predict() const {
  outputs_[0] = predictions_[map_[map_index_ + bit_context_]];
  return outputs_;
}

// Move the probability of the current state towards the bit (rate 1 / delta), then advance
// the state stored for this context.
template<typename StateType>
void Indirect<StateType>::Perceive(int bit) {
  map_index_ += bit_context_;
  int state = map_[map_index_];
  predictions_[state] += (bit - predictions_[state]) * divisor_;
  map_[map_index_] = state_.Next(state, bit);
  map_index_ -= bit_context_;
}

// New byte context: pick its block of the shared map (the slots map_index_ + partial byte).
template<typename StateType>
void Indirect<StateType>::ByteUpdate() {
  map_index_ = (257 * byte_context_ + map_offset_) % (map_.size() - 257);
}


#endif

