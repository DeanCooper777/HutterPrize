// bit-context.cpp: BitContext, see bit-context.h. Not instantiated by this entry.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#include "bit-context.h"

BitContext::BitContext(const unsigned long long& bit_context,
    const unsigned long long& byte_context,
    unsigned long long byte_context_size) : bit_context_(bit_context),
    byte_context_(byte_context) {
  context_ = 0;
  size_ = 256 * byte_context_size;
}

// The byte context goes to the high bits; the partial byte (0..255) fills the low 8 bits.
void BitContext::Update() {
  context_ = (byte_context_<<8) + bit_context_;
}

// Two BitContexts are the same if they are built from the same two source variables.
bool BitContext::IsEqual(BitContext* p) const {
  if (!p) return false;
  if (&(p->byte_context_) != &byte_context_) return false;
  if (&(p->bit_context_) != &bit_context_) return false;
  return true;
}

