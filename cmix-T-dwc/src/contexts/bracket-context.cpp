// bracket-context.cpp: BracketContext, see bracket-context.h.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#include "bracket-context.h"

BracketContext::BracketContext(const unsigned int& bit_context,
    int distance_limit, int stack_limit) : byte_(bit_context),
    distance_limit_(distance_limit), stack_limit_(stack_limit) {
  // Opening byte -> closing byte, as byte values of the preprocessed stream, which is what
  // the models see: there 'P' / 'R' stand for { / } and 'L' / 'N' for < / > (see the
  // #defines under "//wrt" in src/models/fxcmv1.cpp).
  brackets_ = {{'(',')'}, {'P','R'}, {'[',']'}, {'L','N'}};
  context_ = 0;
  size_ = 257 * distance_limit_;
}

// Called once per byte. Close the innermost bracket if its closing byte arrived or it has been
// open for distance_limit_ bytes; otherwise count one more byte. Then push the new byte if it
// opens a bracket. context_ = 0 when nothing is open, else a number unique to
// (opening byte, distance).
void BracketContext::Update() {
  if (!active_.empty()) {
    if (brackets_[active_[active_.size() - 1]] == byte_ ||
        distance_[distance_.size() - 1] >= distance_limit_ - 1) {
      active_.pop_back();
      distance_.pop_back();
    } else {
      ++distance_[distance_.size() - 1];
    }
  }
  if (brackets_.find(byte_) != brackets_.end()) {
    active_.push_back(byte_);
    distance_.push_back(0);
    // Note: this compares the size of the bracket table (4), not of the stack, with the limit,
    // so with the limit used (15) the stack is never trimmed here. Inherited behaviour; changing
    // it would change the compressed output.
    if (brackets_.size() > stack_limit_) {
      active_.erase(active_.begin());
      distance_.erase(distance_.begin());
    }
  }
  if (!active_.empty()) {
    context_ = distance_limit_ * (active_[active_.size() - 1] + 1) +
        distance_[distance_.size() - 1];
  } else {
    context_ = 0;
  }
}

// Same parameters = same context (all bracket contexts read the same byte).
bool BracketContext::IsEqual(Context* c) const {
  BracketContext* p = dynamic_cast<BracketContext*>(c);
  if (!p) return false;
  if (distance_limit_ == p->distance_limit_ && stack_limit_ == p->stack_limit_)
    return true;
  return false;
}

