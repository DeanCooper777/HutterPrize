#ifndef MIXER_H
#define MIXER_H

#include <vector>
#include <valarray>
#include "../ds/emhash_map.hpp"
#include <memory>

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
  Mixer(const Mixer&) = delete;
  Mixer(Mixer&& o) noexcept;
  ~Mixer();
  float Mix();
  void Perceive(int bit);
  // Hint: prefetch the row of the current context (no insertion).
  void Prefetch() const;

 private:
  static constexpr unsigned int kMaxContexts = 10000;
  float* GetRow();
  const std::valarray<float>& inputs_;
  const std::valarray<float>& extra_inputs_vec_;
  uint16_t extra_inputs_size_;
  float p_, learning_rate_;
  const unsigned long long& context_;
  unsigned long long steps_;
  unsigned int num_inputs_, extra_offset_, stride_;
  emhash6::HashMap<unsigned int, unsigned int> context_map_;
  float* arena_ = nullptr;      // (kMaxContexts + 1) rows; last = fallback
  unsigned int used_rows_ = 0;
  float* row_ = nullptr;        // row of the last Mix()
};

#endif
