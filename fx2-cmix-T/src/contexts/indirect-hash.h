// indirect-hash.h: two-step ("indirect") context: a hash of the last order1 bytes selects a
// slot that remembers what followed that hash last time; the remembered history is the context.
//
// Inherited from cmix. Compiled, but not instantiated by this entry (the indirect contexts this
// entry uses, ind1, ind2, ind3 and ind5, are computed directly in src/context-manager.cpp).
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef INDIRECT_HASH_H
#define INDIRECT_HASH_H

#include "context.h"

#include <vector>

class IndirectHash : public Context {
 public:
  IndirectHash(const unsigned int& bit_context, unsigned int order1,
      unsigned int hash_size1, unsigned int order2, unsigned int hash_size2);
  void Update();
  bool IsEqual(Context* c) const;

 private:
  const unsigned int& byte_;
  unsigned long long context1_;
  unsigned int hash_size1_, hash_size2_, size1_;
  std::vector<unsigned long long> hashes_;
};

#endif

