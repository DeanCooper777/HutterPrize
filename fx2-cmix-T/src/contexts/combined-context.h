// combined-context.h: context = two other contexts packed into one number.
//
// Inherited from cmix. Compiled, but not instantiated by this entry.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef COMBINED_CONTEXT_H
#define COMBINED_CONTEXT_H

#include "context.h"

class CombinedContext : public Context {
 public:
  CombinedContext(const unsigned long long& context1, const unsigned long long&
      context2, unsigned long long context1_size, unsigned long long
      context2_size);
  void Update();
  bool IsEqual(Context* c) const;

 private:
  const unsigned long long& context1_;
  const unsigned long long& context2_;
  unsigned int shift_;
};

#endif

