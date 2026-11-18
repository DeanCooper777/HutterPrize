// decoder.h: binary arithmetic decoder, the mirror image of Encoder (encoder.h). x_ holds
// the next 32 bits of the coded stream; Decode() makes the same interval split as the
// encoder and reads the bit from which side of the split x_ lies on.
//
// Place in the pipeline: archive -> [arithmetic decoder] <- SSE <- mixers <- models.
// Driven by Decompress() in runner.cpp.
//
// Unchanged from the previous winning entry.

#ifndef DECODER_H
#define DECODER_H

#include <fstream>

#include "../predictor.h"

class Decoder {
 public:
  Decoder(std::ifstream* is, Predictor* p);
  int Decode();

 private:
  int ReadByte();
  unsigned int Discretize(float p);

  std::ifstream* is_;
  unsigned int x1_, x2_, x_;
  Predictor* p_;
};

#endif
