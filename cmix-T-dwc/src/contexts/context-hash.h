// context-hash.h: context = rolling hash of the last `order` bytes, hash_size bits per byte.
//
// Used by Predictor::AddMatch (src/predictor.cpp): each (order, hash_size) pair gives the
// context with which one Match model (src/models/match.*) looks up where the same bytes
// occurred before.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef CONTEXT_HASH_H
#define CONTEXT_HASH_H

#include "context.h"

class ContextHash : public Context {
 public:
  ContextHash(const unsigned int& bit_context, unsigned int order,
      unsigned int hash_size);
  void Update();
  bool IsEqual(Context* c) const;

 private:
  const unsigned int& byte_;
  unsigned int hash_size_;
};

#endif

