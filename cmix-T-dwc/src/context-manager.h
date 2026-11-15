// context-manager.h: ContextManager owns the shared state that the context models and
// the mixers select on: the current partial byte, the byte history, word hashes, and a
// set of small derived contexts (mx*, b2stream, b3stream, ind*, ...). Models and mixers
// hold references to these fields, so one update per bit serves all of them.
//
// Place in the pipeline: feeds [context models] and the weight-set selection of the
// [mixers]. Predictor owns one instance (manager_) and calls UpdateContexts(bit) from
// Perceive().
//
// Unchanged from the previous winning entry.

#ifndef CONTEXT_MANAGER_H
#define CONTEXT_MANAGER_H

#include "states/nonstationary.h"
#include "states/run-map.h"
#include "contexts/context.h"
#include "contexts/bit-context.h"
#include "contexts/context-hash.h"
#include "contexts/bracket-context.h"
#include "contexts/combined-context.h"
#include "contexts/indirect-hash.h"
#include "contexts/interval.h"
#include "contexts/interval-hash.h"
#include "contexts/indirect-hash.h"
#include "contexts/sparse.h"

#include <cmath>
#include "ds/SmallVector.h"

#include <vector>

struct ContextManager {
  ContextManager();

  // Add*Context: create a context object, or return the existing one with the same
  // parameters, so that models asking for the same context share one hash computation.
  template<typename ... Args>
  const BracketContext& AddBracketContext(Args&& ...args) {
    BracketContext tmp(std::forward<Args>(args)...);
    for (const auto& old : bracket_contexts_) {
      if (old.IsEqual(&tmp)) return old;
    }
    bracket_contexts_.emplace_back(std::forward<Args>(args)...);
    return bracket_contexts_[bracket_contexts_.size() - 1];
  }

  template<typename ... Args>
  const ContextHash& AddContextHashContext(Args&& ...args) {
    ContextHash tmp(std::forward<Args>(args)...);
    for (const auto& old : context_hash_contexts_) {
      if (old.IsEqual(&tmp)) return old;
    }
    context_hash_contexts_.emplace_back(std::forward<Args>(args)...);
    return context_hash_contexts_[context_hash_contexts_.size() - 1];
  }


  template<typename ... Args>
  const Sparse& AddSparseContext(Args&& ...args) {
    Sparse tmp(std::forward<Args>(args)...);
    for (const auto& old : sparse_contexts_) {
      if (old.IsEqual(&tmp)) return old;
    }
    sparse_contexts_.emplace_back(std::forward<Args>(args)...);
    return sparse_contexts_[sparse_contexts_.size() - 1];
  }

  // UpdateContexts runs every bit; the other Update* functions run once per completed byte.
  void UpdateContexts(int bit);
  void UpdateHistory();
  void UpdateWords();
  void UpdateRecentBytes();
  void UpdateWRTContext();

  // bit_context_: 1 followed by the bits of the current byte seen so far (1..255); at a
  // byte boundary it briefly holds the completed byte value. The mx* fields are the
  // contexts of the layer-0 mixers (see Predictor::AddMixers).
  unsigned int bit_context_ = 1, wrt_state_ = 0, bpos=0;
  unsigned long long long_bit_context_ = 1, zero_context_ = 0, history_pos_ = 0,
      line_break_ = 0, longest_match_ = 0, auxiliary_context_ = 0,
      wrt_context_ = 0,
      b2stream=0,b2streamcxt=0, o2bState=0, n2bState=0, stream2bR=0,
      b3stream=0,b3streamcxt=0,o3bState=0, n3bState=0, stream3bR=0,
      b4stream=0,
      mx5=0,mx6=0 ,mx7=0,mx8=0,
      mx9=0,mx9cxt=0,
      mx10=0,mx10cxt=0,
      mx11=0,mx11cxt=0,
      mx12=0,mx12cxt=0,
      mx13=0,mx13cxt=0,
      mx14=0,mx14cxt=0,
      mx15=0,mx15cxt=0,
      mx16=0,mx16cxt=0,
      mx17=0,mx17cxt=0,
      mx18=0,mx18cxt=0,
      mxx=0,
      words=0,wordscxt=0,
      ind1=0,context1_ind=0,
      ind2=0,context1_ind2=0,
      ind3=0,context1_ind3=0,
      ind4=0,context1_ind4=0,
      ind5=0,context1_ind5=0,
      mx19cxt=0;
  std::vector<unsigned char> history_, shared_map_;
  std::vector<unsigned long long> words_, recent_bytes_;
  llvm::SmallVector<ContextHash, 12> context_hash_contexts_;
  llvm::SmallVector<Sparse, 18> sparse_contexts_;
  llvm::SmallVector<BracketContext, 1> bracket_contexts_;
  std::vector<unsigned long long> hashes_ind1,hashes_ind2,hashes_ind3,hashes_ind4,hashes_ind5;
  RunMap run_map_;
  Nonstationary nonstationary_;
};

#endif

