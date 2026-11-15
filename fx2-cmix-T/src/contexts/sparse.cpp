// sparse.cpp: Sparse, see sparse.h.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#include "sparse.h"

#include <limits.h>

Sparse::Sparse(const std::vector<unsigned long long>& recent_contexts,
    const std::vector<unsigned int>& orders) :
    recent_contexts_(recent_contexts), orders_(orders), factors_(6, 1) {
  // Multipliers that spread the selected values over the 64-bit context (at most 6 values).
  factors_[1] = 256;
  factors_[2] = 29 * 31;
  factors_[3] = 29 * 31 * 37;
  factors_[4] = 29 * 31 * 37 * 41;
  factors_[5] = 29 * 31 * 37 * 41 * 43;
  context_ = 0;
  size_ = ULLONG_MAX;
}

// context_ = sum of factor[i] * recent_contexts[orders[i]].
void Sparse::Update() {
  context_ = recent_contexts_[orders_[0]];
  for (unsigned int i = 1; i < orders_.size(); ++i) {
    context_ += factors_[i] * recent_contexts_[orders_[i]];
  }
}

// Same source vector and same list of orders = same context.
bool Sparse::IsEqual(Context* c) const {
  Sparse* p = dynamic_cast<Sparse*>(c);
  if (!p) return false;
  if (&recent_contexts_ != &(p->recent_contexts_)) return false;
  if (orders_.size() != p->orders_.size()) return false;
  for (unsigned int i = 0; i < orders_.size(); ++i) {
    if (orders_[i] != p->orders_[i]) return false;
  }
  return true;
}

