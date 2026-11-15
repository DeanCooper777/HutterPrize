// mixer.cpp: Mixer, the online-trained weighted sum of model predictions. See mixer.h for what
// a mixer is and where it sits.
//
// Per coded bit, for every mixer: Predictor calls Mix() (dot product of the inputs with the
// weight row of the current context), and after the bit is known Perceive(bit) (one gradient
// step on that row). With about 460 inputs and two dozen mixers this is one of the largest
// costs of the non-transformer part, which is why this entry reworked the memory layout.
//
// Testing: tune keys decay_t1..t3 and decay_d0..d3 (the schedule below); experiments only.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
//   - Arena storage (speed, bit-identical). Before: map<context, {valarray weights, valarray
//     extra_weights}>, looked up in Mix() and again in Perceive(), each lookup followed by
//     pointer chases to two heap arrays. Now: the map gives a row index into one aligned
//     arena; Perceive() reuses the row pointer saved by Mix(). SUBMISSION.md reports the mixer
//     update 35% faster.
//   - Perceive() is written so the compiler can vectorize it (speed, bit-identical).
//   - Prefetch() (speed, no effect on the output): see below and Predictor::Perceive.
//     SUBMISSION.md reports the mixer mix time 60% lower with it.
//   - The learning-rate decay schedule is read through tune::Get, and its last value, used
//     after 25,000,000 bits, is lower: 0.2 before, the decay_d3 default now (compression gain,
//     found by tuning on enwik7).
//   - <sys/resource.h> is skipped on Windows (development build only).

#include "mixer.h"

#include "sigmoid.h"
#include "../tune.h"

#include <cstdlib>
#include <cstring>
#include <numeric>
#include <utility>
#include <math.h>
#include <immintrin.h>
// [this entry] Not available on Windows; nothing in this file needs it.
#ifndef _WIN32
#include <sys/resource.h>
#endif

namespace {
// [this entry] Learning-rate schedule of every mixer: the update is multiplied by d0 for the
// first t1 bits, d1 up to t2, d2 up to t3 and d3 from then on. The step thresholds and
// d0..d2 are the previous entry's constants; d3 was 0.2. Each value is a tune key so it could
// be searched without rebuilding; in the official build tune::Get returns the default.
struct DecaySchedule {
  unsigned long long t1, t2, t3;
  float d0, d1, d2, d3;
};
const DecaySchedule& Decay() {
  static DecaySchedule d = {
      (unsigned long long)tune::Get("decay_t1", 1000000),
      (unsigned long long)tune::Get("decay_t2", 5000000),
      (unsigned long long)tune::Get("decay_t3", 25000000),
      (float)tune::Get("decay_d0", 1.0), (float)tune::Get("decay_d1", 0.7),
      (float)tune::Get("decay_d2", 0.3), (float)tune::Get("decay_d3", 0.08)};
  return d;
}

// [this entry] 64-byte aligned, uninitialized block (aligned_alloc needs a size that is a
// multiple of the alignment). Not zeroed here on purpose: see the constructor.
float* AllocArena(size_t floats) {
  size_t bytes = floats * sizeof(float);
#ifdef _WIN32
  void* p = _aligned_malloc(bytes, 64);
#else
  void* p = aligned_alloc(64, (bytes + 63) & ~size_t(63));
#endif
  if (!p) abort();
  return static_cast<float*>(p);
}
}  // namespace

// inputs / extra_inputs / context are references to data the predictor updates before every
// Mix(). extra_input_size = number of extra inputs this mixer reads.
Mixer::Mixer(const std::valarray<float>& inputs,
    const std::valarray<float>& extra_inputs,
    const unsigned long long& context, float learning_rate,
    unsigned int extra_input_size) : inputs_(inputs),
    extra_inputs_vec_(extra_inputs), extra_inputs_size_(extra_input_size),
    p_(0.5), learning_rate_(learning_rate), context_(context), steps_(0) {
  Decay();  // register the tunables before tune::CheckAllUsed()
  num_inputs_ = inputs.size();
  // [this entry] Row layout: main weights, padding to a multiple of 16 floats (one cache
  // line), extra weights, padding again. kMaxContexts rows plus one fallback row.
  extra_offset_ = (num_inputs_ + 15) & ~15u;
  stride_ = (extra_offset_ + extra_inputs_size_ + 15) & ~15u;
  // Rows are zeroed on first use (lazily), so untouched rows cost no RAM.
  arena_ = AllocArena(size_t(stride_) * (kMaxContexts + 1));
  // Only the fallback row is zeroed now. All weights start at 0, as before.
  memset(arena_ + size_t(stride_) * kMaxContexts, 0, stride_ * sizeof(float));
  context_map_.reserve(kMaxContexts);
}

// [this entry] Move: take over the arena and leave the source without one, so its destructor
// frees nothing.
Mixer::Mixer(Mixer&& o) noexcept : inputs_(o.inputs_),
    extra_inputs_vec_(o.extra_inputs_vec_),
    extra_inputs_size_(o.extra_inputs_size_), p_(o.p_),
    learning_rate_(o.learning_rate_), context_(o.context_), steps_(o.steps_),
    num_inputs_(o.num_inputs_), extra_offset_(o.extra_offset_),
    stride_(o.stride_), context_map_(std::move(o.context_map_)),
    arena_(o.arena_), used_rows_(o.used_rows_), row_(o.row_) {
  o.arena_ = nullptr;
  o.row_ = nullptr;
}

Mixer::~Mixer() {
#ifdef _WIN32
  _aligned_free(arena_);
#else
  free(arena_);
#endif
}

// [this entry] Weight row of the current context. The first kMaxContexts distinct contexts
// get rows in order of first appearance (zeroed when handed out); once they are used up,
// unknown contexts share the fallback row. This is the same policy as the previous
// GetContextData(), including the use of the low 32 bits of the context as the key.
float* Mixer::GetRow() {
  unsigned int key = (unsigned int)context_;
  auto it = context_map_.find(key);
  if (it != context_map_.end()) return arena_ + size_t(stride_) * it->second;
  if (used_rows_ >= kMaxContexts) return arena_ + size_t(stride_) * kMaxContexts;
  unsigned int idx = used_rows_++;
  context_map_.insert({key, idx});
  float* row = arena_ + size_t(stride_) * idx;
  memset(row, 0, stride_ * sizeof(float));
  return row;
}

// [this entry] Ask the CPU to load the row of the current context into cache. Predictor::
// Perceive calls this for all first-layer mixers as soon as the contexts of the next bit are
// set, so the cache misses overlap with the remaining work of the bit instead of stalling the
// next Mix(). A context without a row yet is skipped: inserting here would change which
// contexts get rows. Purely a hint; tune key prefetch_mixers=0 turns it off.
void Mixer::Prefetch() const {
  auto it = context_map_.find((unsigned int)context_);
  if (it == context_map_.end()) return;
  const char* row = reinterpret_cast<const char*>(arena_ + size_t(stride_) * it->second);
  const size_t bytes = stride_ * sizeof(float);
  for (size_t off = 0; off < bytes; off += 64) _mm_prefetch(row + off, _MM_HINT_T0);
}

// Weighted sum of the inputs and the extra inputs with the row of the current context. The
// two sums are accumulated separately and in index order, exactly as before, so the float
// result is unchanged. [this entry] The row pointer is kept for Perceive().
float Mixer::Mix() {
  float* w = GetRow();
  row_ = w;
  const float* in = &inputs_[0];
  float p = 0;
  for (unsigned int i = 0; i < num_inputs_; ++i) {
    p += in[i] * w[i];
  }
  p_ = p;
  const float* ex = extra_inputs_size_ ? &extra_inputs_vec_[0] : nullptr;
  const float* ew = w + extra_offset_;
  float e = 0;
  for (unsigned int i = 0; i < extra_inputs_size_; ++i) {
    e += ex[i] * ew[i];
  }
  p_ += e;
  return p_;
}

// One gradient step: weight -= rate * (predicted probability - bit) * input, with the rate
// scaled down as the mixer ages (the schedule above).
void Mixer::Perceive(int bit) {
  const DecaySchedule& ds = Decay();
  float decay = ds.d3;
  if (steps_ < ds.t3) {
      decay = ds.d2;
      if (steps_ < ds.t2) {
          decay = ds.d1;
          if (steps_ < ds.t1)
              decay = ds.d0;
      }
  }
  ++steps_;

  float update =   learning_rate_ * (Sigmoid::Logistic(p_) - bit);
  // Skip an update too small to matter (not for the mixer without extra inputs).
  if(fabs(update)<0.000000000005f && extra_inputs_size_>0) {
      return;
  }
  update = decay * update;
  // [this entry] row_ is the row Mix() used: the context cannot change between Mix() and
  // Perceive() of the same bit, so no second lookup is needed.
  // The weight row (arena) never overlaps the input arrays (valarrays) or
  // this object, but the compiler cannot prove it: clang targeting MSVC has
  // no strict aliasing, so every store to w could change num_inputs_, the
  // trip count becomes "uncountable" and the loop stays scalar
  // (load-FMA-store per weight). Local bounds + __restrict let it vectorize;
  // each element is still one fused w - update*in, so results are
  // bit-identical.
  const unsigned int n = num_inputs_, n_extra = extra_inputs_size_;
  float* __restrict w = row_;
  const float* __restrict in = &inputs_[0];
  for (unsigned int i = 0; i < n; ++i) w[i] -= update * in[i];
  const float* __restrict ex = n_extra ? &extra_inputs_vec_[0] : nullptr;
  float* __restrict ew = row_ + extra_offset_;
  for (unsigned int i = 0; i < n_extra; ++i) ew[i] -= update * ex[i];
}
