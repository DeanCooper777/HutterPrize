// bit-context.h: context = (a byte-level context, the bits of the current byte seen so far).
//
// Inherited from cmix. Compiled, but not instantiated by this entry (ContextManager creates only
// BracketContext, ContextHash and Sparse contexts).
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef BIT_CONTEXT_H
#define BIT_CONTEXT_H

#include "context.h"

class BitContext : public Context {
 public:
  BitContext(const unsigned long long& bit_context, const unsigned long long&
      byte_context, unsigned long long byte_context_size);
  void Update();
  bool IsEqual(BitContext* c) const;

 private:
  const unsigned long long& bit_context_;
  const unsigned long long& byte_context_;
};

#endif

