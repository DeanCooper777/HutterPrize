#include "mixer.h"

#include "sigmoid.h"
#include "../tune.h"

#include <cstdlib>
#include <cstring>
#include <numeric>
#include <utility>
#include <math.h>
#include <immintrin.h>
#ifndef _WIN32
#include <sys/resource.h>
#endif

namespace {
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
      (float)tune::Get("decay_d2", 0.3), (float)tune::Get("decay_d3", 0.05)};
  return d;
}

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

Mixer::Mixer(const std::valarray<float>& inputs,
    const std::valarray<float>& extra_inputs,
    const unsigned long long& context, float learning_rate,
    unsigned int extra_input_size) : inputs_(inputs),
    extra_inputs_vec_(extra_inputs), extra_inputs_size_(extra_input_size),
    p_(0.5), learning_rate_(learning_rate), context_(context), steps_(0) {
  Decay();  // register the tunables before tune::CheckAllUsed()
  num_inputs_ = inputs.size();
  extra_offset_ = (num_inputs_ + 15) & ~15u;
  stride_ = (extra_offset_ + extra_inputs_size_ + 15) & ~15u;
  // Rows are zeroed on first use (lazily), so untouched rows cost no RAM.
  arena_ = AllocArena(size_t(stride_) * (kMaxContexts + 1));
  memset(arena_ + size_t(stride_) * kMaxContexts, 0, stride_ * sizeof(float));
  context_map_.reserve(kMaxContexts);
}

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

void Mixer::Prefetch() const {
  auto it = context_map_.find((unsigned int)context_);
  if (it == context_map_.end()) return;
  const char* row = reinterpret_cast<const char*>(arena_ + size_t(stride_) * it->second);
  const size_t bytes = stride_ * sizeof(float);
  for (size_t off = 0; off < bytes; off += 64) _mm_prefetch(row + off, _MM_HINT_T0);
}

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
  if(fabs(update)<0.000000000005f && extra_inputs_size_>0) {
      return;
  }
  update = decay * update;
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
