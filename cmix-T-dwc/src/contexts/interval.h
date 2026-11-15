// interval.h: context = the classes of the last few bytes (byte -> small class number through
// the `map` table), packed into num_bits bits.
//
// Inherited from cmix. Compiled, but not instantiated by this entry.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef INTERVAL_H
#define INTERVAL_H

#include "context.h"

#include <vector>

class Interval : public Context {
 public:
  Interval(const unsigned int& bit_context, const std::vector<int>& map,
      unsigned int num_bits);
  void Update();
  bool IsEqual(Interval* c) const;

 private:
  const unsigned int& byte_;
  std::vector<int> map_;
  unsigned long long mask_;
  int shift_;
};

#endif

