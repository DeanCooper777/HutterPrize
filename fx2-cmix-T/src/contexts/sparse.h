// sparse.h: context = a combination of selected entries of a vector of recent values.
//
// Predictor::AddWord (src/predictor.cpp) builds these over ContextManager::words_ (hashes of the
// current and the previous words): `orders` lists which words take part, e.g. {1, 3} = the
// previous word and the one two before it, skipping the one in between ("sparse"). Each such
// context selects the statistics of an Indirect or a Match model.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef SPARSE_H
#define SPARSE_H

#include "context.h"

#include <vector>

class Sparse : public Context {
 public:
  Sparse(const std::vector<unsigned long long>& recent_contexts,
      const std::vector<unsigned int>& orders);
  void Update();
  bool IsEqual(Context* c) const;

 private:
  const std::vector<unsigned long long>& recent_contexts_;
  std::vector<unsigned int> orders_, factors_;
};

#endif

