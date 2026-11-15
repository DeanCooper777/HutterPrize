// encoder.h: binary arithmetic encoder (the carry-less 32-bit coder of the paq / lpaq
// family). Encode(bit) asks the Predictor for P(bit = 1), splits the current interval
// [x1_, x2_] in that proportion, keeps the part that belongs to the bit, and emits the
// leading bytes on which both ends agree.
//
// Place in the pipeline: ... -> mixers -> SSE -> [arithmetic coder] -> archive. Driven by
// Compress() in runner.cpp, one call per bit of the preprocessed stream.
//
// Unchanged from the previous winning entry.

#ifndef ENCODER_H
#define ENCODER_H

#include <fstream>
#include <vector>

#include "../predictor.h"

class Encoder {
 public:
  Encoder(std::ofstream* os, Predictor* p);
  void Encode(int bit);
  void Flush();
  size_t OutputSize() { return out_.size();}
 private:
  void WriteByte(unsigned int byte);
  unsigned int Discretize(float p);

  // The whole coded output is collected in memory and written by Flush().
  std::vector<char> out_;
  std::ofstream* os_;
  unsigned int x1_, x2_;
  Predictor* p_;
};
#endif
