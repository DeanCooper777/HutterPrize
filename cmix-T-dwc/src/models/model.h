// model.h: base class of every bit-level model.
//
// A model is one "expert" of the context-mixing compressor. For every bit of the preprocessed
// stream, Predictor (src/predictor.cpp) asks each model for Predict(): one or more
// probabilities that the next bit is 1. They become the inputs of the mixers
// (src/mixer/mixer.*). After the bit is coded, Perceive(bit) lets the model learn from it, and
// ByteUpdate() is called after every eighth bit so byte-oriented models can move on.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// The functions are not virtual: Predictor keeps each model type in its own container and
// calls the derived functions directly.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef MODEL_H
#define MODEL_H

#include <valarray>

class Model {
 public:
  Model() : outputs_(0.5, 1) {}
  Model(int size) : outputs_(0.5, size) {}
  ~Model() {}
  const std::valarray<float>& Predict() const {return outputs_;}
  unsigned int NumOutputs() {return outputs_.size();}
  void Perceive(int bit) {}
  void ByteUpdate() {}

 protected:
  // The predictions returned by Predict(); `mutable` because Predict() is const in the models
  // that fill it on demand.
  mutable std::valarray<float> outputs_;
};

#endif

