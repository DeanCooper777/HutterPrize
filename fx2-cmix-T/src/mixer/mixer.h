// mixer.h: the cmix mixer: an online-trained weighted sum of model predictions.
//
// Every model prediction is a "stretched" probability, ln(p / (1 - p)). A mixer multiplies each
// by a weight and adds them up; the logistic function of the sum is the mixed probability.
// After each bit the weights move a small step in the direction that would have made the
// coded bit more probable (gradient descent on coding cost). Each mixer has many weight sets
// and picks one per bit with its own selector context, so it can trust different models in
// different situations.
//
// Predictor (src/predictor.cpp, AddMixers) builds two layers: about two dozen first-layer
// mixers, each with a different selector context, all reading the same input vector; and one
// final mixer that mixes their outputs. Its result goes to SSE (sse.*) and then to the coder.
// How it fits: preprocess -> dictionary -> context models / PPMD / transformer byte model
// -> [mixers] -> SSE -> arithmetic coder -> self-extracting archive.
//
// Testing: tune keys decay_* (mixer.cpp), lr<layer>_<index> and prefetch_mixers
// (src/predictor.cpp); experiments only, the shipped values are the defaults in the source.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
//   - Weight storage: one contiguous, cache-line-aligned arena of rows per mixer instead of a
//     hash map of separately allocated arrays, and the row found by Mix() is reused by
//     Perceive(). Fewer hash lookups and cache misses per bit (speed). Same arithmetic in the
//     same order, so the output is bit-identical.
//   - Prefetch(): lets the predictor start loading the next bit's weight row early (speed).
//   - Because a mixer now owns raw memory, it has a destructor and a move constructor and
//     cannot be copied.
// See mixer.cpp for the details and for the changed learning-rate schedule.

#ifndef MIXER_H
#define MIXER_H

#include <vector>
#include <valarray>
#include "../ds/emhash_map.hpp"
#include <memory>

// [this entry] The class comment below describes the new storage layout.
// Gated linear mixer with one weight row per context (at most kMaxContexts
// rows, further contexts share one fallback row).
//
// Performance layout (numerically identical to the original
// map<context, {valarray weights, valarray extra_weights}>): all rows live in
// one contiguous arena, the map stores row indices, and the row found by
// Mix() is reused by Perceive() (the context cannot change in between), so
// each bit costs one hash lookup per mixer instead of two dependent
// lookups + pointer chases.
class Mixer {
 public:
  Mixer(const std::valarray<float>& inputs,
      const std::valarray<float>& extra_inputs, const unsigned long long& context,
      float learning_rate, unsigned int extra_input_size);
  // [this entry] The arena is owned by exactly one object: movable (the predictor keeps its
  // mixers in a container that may relocate them), not copyable.
  Mixer(const Mixer&) = delete;
  Mixer(Mixer&& o) noexcept;
  ~Mixer();
  // Mix(): the weighted sum for the current context, in the stretched domain (the caller
  // applies the logistic function where it needs a probability). Perceive(bit): the weight
  // update for the row used by the last Mix().
  float Mix();
  void Perceive(int bit);
  // [this entry]
  // Hint: prefetch the row of the current context (no insertion).
  void Prefetch() const;

 private:
  // At most this many contexts get a weight row of their own (the same limit as before); any
  // context that arrives later shares the fallback row.
  static constexpr unsigned int kMaxContexts = 10000;
  // inputs_ / extra_inputs_vec_: references to the layer's input arrays (MixerInput), filled by
  // the predictor before Mix(). extra_inputs_size_: how many of the extra inputs this mixer
  // uses; first-layer mixer i uses the outputs of mixers 0..i-1. context_: reference to the
  // selector context. steps_: number of Perceive() calls, drives the learning-rate schedule.
  float* GetRow();
  const std::valarray<float>& inputs_;
  const std::valarray<float>& extra_inputs_vec_;
  uint16_t extra_inputs_size_;
  float p_, learning_rate_;
  const unsigned long long& context_;
  unsigned long long steps_;
  // [this entry] Row layout, in floats: [0, num_inputs_) the main weights; [extra_offset_,
  // extra_offset_ + extra_inputs_size_) the extra weights; stride_ = length of a row. Both
  // offsets are multiples of 16 floats = 64 bytes, so both parts start on a cache line.
  // context_map_: context (low 32 bits) -> row index.
  unsigned int num_inputs_, extra_offset_, stride_;
  emhash6::HashMap<unsigned int, unsigned int> context_map_;
  float* arena_ = nullptr;      // (kMaxContexts + 1) rows; last = fallback
  unsigned int used_rows_ = 0;
  float* row_ = nullptr;        // row of the last Mix()
};

#endif
