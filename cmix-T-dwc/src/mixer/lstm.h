// lstm.h: the LSTM byte predictor of fx2-cmix (class Lstm; the code is in lstm.hpp).
//
// It is trained while coding, by backpropagation through time over `horizon` bytes. The
// previous winning entry replaced it by the transformer, and this entry keeps that: the lstm
// is only created when the program runs without a transformer (Predictor::AddMixers in
// src/predictor.cpp), and never in the official build (CMIX_OFFICIAL).
//
// Testing: it remains as the reference "cmix without the transformer" path in non-official
// builds.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef LSTM_COMPRESS_H
#define LSTM_COMPRESS_H

#include <valarray>
#include <vector>
#include <memory>
#include <string>

#include "lstm-layer.h"

#include "../ds/emhash_set.hpp"
#include "../ds/SmallVector.h"

class Lstm {
 public:
  Lstm(unsigned int input_size, unsigned int output_size, unsigned int
      num_cells, unsigned int num_layers, int horizon, float learning_rate,
      float gradient_clip);
  ~Lstm();
  std::valarray<float>& Perceive(unsigned int input);
  std::valarray<float>& Predict(unsigned int input);
  void SetInput(const std::valarray<float>& input);
  //void SaveToDisk(const std::string& path);
  //void LoadFromDisk(const std::string& path);

 private:
  // All per-time-step arrays are indexed by `epoch` = position inside the current horizon.
  // layer_input_[epoch][layer]: the layer's input vector. output_layer_[epoch][symbol]: the
  // weights of the softmax output layer. output_[epoch]: the predicted distribution.
  llvm::SmallVector<LstmLayer, 1> layers_;
  std::vector<uint8_t> input_history_; // horizon
  std::valarray<float> hidden_, hidden_error_;
  std::valarray<std::valarray<std::valarray<float>>> layer_input_,
      output_layer_;
  std::valarray<std::valarray<float>> output_;
  float learning_rate_;
  unsigned int num_cells_, epoch_, horizon_, input_size_, output_size_;
  int last_input_ = -1;
};
#include "lstm.hpp"
#endif


