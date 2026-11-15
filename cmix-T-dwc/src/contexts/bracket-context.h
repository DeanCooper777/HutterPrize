// bracket-context.h: context = (innermost open bracket, distance in bytes since it opened).
//
// ContextManager creates one (Predictor::AddBracket in src/predictor.cpp); it selects the
// statistics of one Direct and one Indirect model, so those models learn what tends to follow
// "n bytes after an opening bracket of this kind". The companion byte-level model is
// src/models/bracket.*.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef BRACKET_CONTEXT_H
#define BRACKET_CONTEXT_H

#include "context.h"

#include "../ds/emhash_map.hpp"
#include <vector>

// byte_: the byte just coded (ContextManager::bit_context_ holds the whole byte at the time
// Update() is called). brackets_: opening byte -> closing byte. active_ / distance_: stack of
// open brackets and the number of bytes since each was opened.
class BracketContext : public Context {
 public:
  BracketContext(const unsigned int& bit_context, int distance_limit,
      int stack_limit);
  void Update();
  bool IsEqual(Context* c) const;

 private:
  const unsigned int& byte_;
  emhash6::HashMap<unsigned char, unsigned char> brackets_;
  unsigned int distance_limit_, stack_limit_;
  std::vector<unsigned int> active_, distance_;
};

#endif

