// combined-context.cpp: CombinedContext, see combined-context.h. Not instantiated by this entry.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#include "combined-context.h"

CombinedContext::CombinedContext(const unsigned long long& context1,
    const unsigned long long& context2, unsigned long long context1_size,
    unsigned long long context2_size) : context1_(context1),
    context2_(context2) {
  context_ = 0;
  size_ = context1_size * context2_size;
  shift_ = 1;
  while ((unsigned long long)(1 << shift_) < context1_size) ++shift_;
}

// context1 occupies the low shift_ bits (shift_ = bits needed for context1_size).
void CombinedContext::Update() {
  context_ = (context2_ << shift_) + context1_;
}

bool CombinedContext::IsEqual(Context* c) const {
  CombinedContext* p = dynamic_cast<CombinedContext*>(c);
  if (!p) return false;
  if (&(p->context1_) != &context1_) return false;
  if (&(p->context2_) != &context2_) return false;
  return true;
}


