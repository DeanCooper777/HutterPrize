// lstm-layer.h: one layer of the fx2-cmix LSTM (see lstm.h). The code is in lstm-layer.hpp.
//
// Not used when the transformer is loaded, and not part of the official build.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef LSTM_LAYER_H
#define LSTM_LAYER_H

#include <valarray>
#include <vector>
#include <stdlib.h>
#include <math.h>

// One gate (a set of num_cells neurons) with everything needed to train it: weights_, their
// gradient sums (update_) and Adam moments (m_, v_); the layer-normalization gain and bias
// (gamma_, beta_) with their gradient sums and moments; and, per time step of the horizon,
// the normalized pre-activations (norm_), their inverse standard deviation (ivar_) and the
// gate outputs (state_).
struct NeuronLayer {
  NeuronLayer(unsigned int input_size, unsigned int num_cells, int horizon,
    int offset) : error_(num_cells), ivar_(horizon), gamma_(1.0, num_cells),
    gamma_u_(num_cells), gamma_m_(num_cells), gamma_v_(num_cells),
    beta_(num_cells), beta_u_(num_cells), beta_m_(num_cells),
    beta_v_(num_cells), weights_(std::valarray<float>(input_size), num_cells),
    state_(std::valarray<float>(num_cells), horizon),
    update_(std::valarray<float>(input_size), num_cells),
    m_(std::valarray<float>(input_size), num_cells),
    v_(std::valarray<float>(input_size), num_cells),
    transpose_(std::valarray<float>(num_cells), input_size - offset),
    norm_(std::valarray<float>(num_cells), horizon) {};

  std::valarray<float> error_, ivar_, gamma_, gamma_u_, gamma_m_, gamma_v_,
      beta_, beta_u_, beta_m_, beta_v_;
  std::valarray<std::valarray<float>> weights_, state_, update_, m_, v_,
      transpose_, norm_;
};

// An LSTM layer with three gates: forget gate, input node and output gate. The input gate
// is tied to the forget gate (input gate = 1 - forget gate).
class LstmLayer {
 public:
  LstmLayer(unsigned int input_size, unsigned int auxiliary_input_size,
      unsigned int output_size, unsigned int num_cells, int horizon,
      float gradient_clip, float learning_rate);
  void ForwardPass(const std::valarray<float>& input, int input_symbol,
      std::valarray<float>* hidden, int hidden_start);
  void BackwardPass(const std::valarray<float>& input, int epoch,
      int layer, int input_symbol, std::valarray<float>* hidden_error);
  static inline float Rand() {
    return static_cast <float> (rand()) / static_cast <float> (RAND_MAX);
  }
  std::vector<std::valarray<std::valarray<float>>*> Weights();

 private:
  std::valarray<float> state_, state_error_, stored_error_;
  std::valarray<std::valarray<float>> tanh_state_, input_gate_state_,
      last_state_;
  float gradient_clip_, learning_rate_;
  unsigned int num_cells_, epoch_, horizon_, input_size_, output_size_;
  unsigned long long update_steps_ = 0;
  NeuronLayer forget_gate_, input_node_, output_gate_;

  void ClipGradients(std::valarray<float>* arr);
  void ForwardPass(NeuronLayer& neurons, const std::valarray<float>& input,
      int input_symbol);
  void BackwardPass(NeuronLayer& neurons, const std::valarray<float>&input,
      int epoch, int layer, int input_symbol,
      std::valarray<float>* hidden_error);
};
#include "lstm-layer.hpp"

#endif

