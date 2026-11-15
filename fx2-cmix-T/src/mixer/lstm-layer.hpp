// lstm-layer.hpp: implementation of LstmLayer (see lstm-layer.h). Included at the end of
// lstm-layer.h.
//
// UPDATE_LIMIT is a compile-time definition (-DUPDATE_LIMIT=..., set in
// build_and_construct_comp.sh): after that many updates the step size and the Adam bias
// corrections stop changing.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#include "lstm-layer.h"

#include "sigmoid.h"

#include <math.h>
#include <algorithm>
#include <numeric>

#define FAST_TANH tanh //fast_tanh
#define FAST_TANH_VEC tanh //fast_tanh_vec
namespace {
// inline float fast_tanh(const float x)
// {
//     const float ax = fabs(x);
//     const float x2 = x * x;

//     return(x * (2.45550750702956f + 2.45550750702956f * ax +
//         (0.893229853513558f + 0.821226666969744f * ax) * x2) /
//         (2.44506634652299f + (2.44506634652299f + x2) *
//             fabs(x + 0.814642734961073f * x * ax)));
// }

// float fast_tanh(float x){
//   float x2 = x * x;
//   float a = x * (135135.0f + x2 * (17325.0f + x2 * (378.0f + x2)));
//   float b = 135135.0f + x2 * (62370.0f + x2 * (3150.0f + x2 * 28.0f));
//   return a / b;
// }
// 
// template <class _Tp>
// inline std::valarray<_Tp> fast_tanh_vec(const std::valarray<_Tp>& __x) {
//   std::valarray<_Tp> __tmp(__x.size());
//   for (size_t __i = 0; __i < __x.size(); ++__i)
//     __tmp[__i] = fast_tanh(__x[__i]);
//   return __tmp;
// }

// One Adam step on weights w with gradient g and moment estimates m, v. The step size
// decays with the update count t until t reaches UPDATE_LIMIT.
inline void Adam(std::valarray<float>* g, std::valarray<float>* m,
    std::valarray<float>* v, std::valarray<float>* w, float learning_rate,
    float t) {
  const float beta1 = 0.025, beta2 = 0.9999, eps = 1e-6f; 
  float alpha;
  if (t < UPDATE_LIMIT) {
    alpha = learning_rate * 0.1f / sqrt(5e-5f * t + 1.0f); 
  } else {
    alpha = learning_rate * 0.1f / sqrt(5e-5f * UPDATE_LIMIT + 1.0f); 
  }
  (*m) *= beta1;
  (*m) += (1.0f - beta1) * (*g);
  (*v) *= beta2;
  (*v) += (1.0f - beta2) * (*g) * (*g);
  if (t < UPDATE_LIMIT) {
    (*w) -= alpha * (((*m) / (float)(1.0f - pow(beta1, t))) /
        (sqrt((*v) / (float)(1.0f - pow(beta2, t)) + eps)));
  } else {
    (*w) -= alpha * (((*m) / (float)(1.0f - pow(beta1, UPDATE_LIMIT))) /
        (sqrt((*v) / (float)(1.0f - pow(beta2, UPDATE_LIMIT)) + eps)));
  }
}

}

inline LstmLayer::LstmLayer(unsigned int input_size, unsigned int auxiliary_input_size,
    unsigned int output_size, unsigned int num_cells, int horizon,
    float gradient_clip, float learning_rate) :
    state_(num_cells), state_error_(num_cells), stored_error_(num_cells),
    tanh_state_(std::valarray<float>(num_cells), horizon),
    input_gate_state_(std::valarray<float>(num_cells), horizon),
    last_state_(std::valarray<float>(num_cells), horizon),
    gradient_clip_(gradient_clip), learning_rate_(learning_rate),
    num_cells_(num_cells), epoch_(0), horizon_(horizon),
    input_size_(auxiliary_input_size), output_size_(output_size),
    forget_gate_(input_size, num_cells, horizon, output_size_ + input_size_),
    input_node_(input_size, num_cells, horizon, output_size_ + input_size_),
    output_gate_(input_size, num_cells, horizon, output_size_ + input_size_) {
  // Random uniform start in [-val, val]. rand() is seeded identically in the compressor and
  // the decompressor, so both start from the same weights.
  float val = sqrt(6.0f / float(input_size_ + output_size_));
  float low = -val;
  float range = 2 * val;
  for (unsigned int i = 0; i < num_cells_; ++i) {
    for (unsigned int j = 0; j < forget_gate_.weights_[i].size(); ++j) {
      forget_gate_.weights_[i][j] = low + Rand() * range;
      input_node_.weights_[i][j] = low + Rand() * range;
      output_gate_.weights_[i][j] = low + Rand() * range;
    }
    forget_gate_.weights_[i][forget_gate_.weights_[i].size() - 1] = 1;
  }
}

// One time step: compute the three gates, update the cell state and write this layer's
// hidden output into hidden[hidden_start ...].
inline void LstmLayer::ForwardPass(const std::valarray<float>& input, int input_symbol,
    std::valarray<float>* hidden, int hidden_start) {
  last_state_[epoch_] = state_;
  ForwardPass(forget_gate_, input, input_symbol);
  ForwardPass(input_node_, input, input_symbol);
  ForwardPass(output_gate_, input, input_symbol);
  for (unsigned int i = 0; i < num_cells_; ++i) {
    forget_gate_.state_[epoch_][i] = Sigmoid::Logistic(
        forget_gate_.state_[epoch_][i]);
    input_node_.state_[epoch_][i] = FAST_TANH(input_node_.state_[epoch_][i]);
    output_gate_.state_[epoch_][i] = Sigmoid::Logistic(
        output_gate_.state_[epoch_][i]);
  }
  input_gate_state_[epoch_] = 1.0f - forget_gate_.state_[epoch_];
  state_ *= forget_gate_.state_[epoch_];
  state_ += input_node_.state_[epoch_] * input_gate_state_[epoch_];
  tanh_state_[epoch_] = FAST_TANH_VEC(state_);
  std::slice slice = std::slice(hidden_start, num_cells_, 1);
  (*hidden)[slice] = output_gate_.state_[epoch_] * tanh_state_[epoch_];
  ++epoch_;
  if (epoch_ == horizon_) epoch_ = 0;
}

// Pre-activations of one gate: the weight column of the previous symbol (a one-hot input)
// plus the weighted input vector, followed by layer normalization (gamma_, beta_).
inline void LstmLayer::ForwardPass(NeuronLayer& neurons,
    const std::valarray<float>& input, int input_symbol) {
  for (unsigned int i = 0; i < num_cells_; ++i) {
    float f = neurons.weights_[i][input_symbol];
    for (unsigned int j = 0; j < input.size(); ++j) {
      f += input[j] * neurons.weights_[i][output_size_ + j];
    }
    neurons.norm_[epoch_][i] = f;
  }
  neurons.ivar_[epoch_] = 1.0f / sqrt(((neurons.norm_[epoch_] *
      neurons.norm_[epoch_]).sum() / num_cells_) + 1e-5f);
  neurons.norm_[epoch_] *= neurons.ivar_[epoch_];
  neurons.state_[epoch_] = neurons.norm_[epoch_] * neurons.gamma_ +
      neurons.beta_;
}

inline void LstmLayer::ClipGradients(std::valarray<float>* arr) {
  for (unsigned int i = 0; i < arr->size(); ++i) {
    if ((*arr)[i] < -gradient_clip_) (*arr)[i] = -gradient_clip_;
    else if ((*arr)[i] > gradient_clip_) (*arr)[i] = gradient_clip_;
  }
}

// Backpropagation for one time step (called from the last step of the horizon back to the
// first): turn the error of the hidden output into errors of the three gates and of the
// cell state, and pass the rest on to the previous time step and the layer below.
inline void LstmLayer::BackwardPass(const std::valarray<float>&input, int epoch,
    int layer, int input_symbol, std::valarray<float>* hidden_error) {
  if (epoch == (int)horizon_ - 1) {
    stored_error_ = *hidden_error;
    state_error_ = 0;
  } else {
    stored_error_ += *hidden_error;
  }

  output_gate_.error_ = tanh_state_[epoch] * stored_error_ *
      output_gate_.state_[epoch] * (1.0f - output_gate_.state_[epoch]);
  state_error_ += stored_error_ * output_gate_.state_[epoch] * (1.0f -
      (tanh_state_[epoch] * tanh_state_[epoch]));
  input_node_.error_ = state_error_ * input_gate_state_[epoch] * (1.0f -
      (input_node_.state_[epoch] * input_node_.state_[epoch]));
  forget_gate_.error_ = (last_state_[epoch] - input_node_.state_[epoch]) *
      state_error_ * forget_gate_.state_[epoch] * input_gate_state_[epoch];

  *hidden_error = 0;
  if (epoch > 0) {
    state_error_ *= forget_gate_.state_[epoch];
    stored_error_ = 0;
  } else {
    if (update_steps_ < UPDATE_LIMIT) {
      ++update_steps_;
    }
  }

  BackwardPass(forget_gate_, input, epoch, layer, input_symbol, hidden_error);
  BackwardPass(input_node_, input, epoch, layer, input_symbol, hidden_error);
  BackwardPass(output_gate_, input, epoch, layer, input_symbol, hidden_error);

  ClipGradients(&state_error_);
  ClipGradients(&stored_error_);
  ClipGradients(hidden_error);
}

// Backpropagation through one gate: through the layer normalization, into the gradient sums,
// and into the errors for the layer below (hidden_error) and the previous time step
// (stored_error_). At the first time step of the horizon (epoch 0) the summed gradients are
// applied with Adam.
inline void LstmLayer::BackwardPass(NeuronLayer& neurons,
    const std::valarray<float>&input, int epoch, int layer, int input_symbol,
    std::valarray<float>* hidden_error) {
  if (epoch == (int)horizon_ - 1) {
    neurons.gamma_u_ = 0;
    neurons.beta_u_ = 0;
    for (unsigned int i = 0; i < num_cells_; ++i) {
      neurons.update_[i] = 0;
      int offset = output_size_ + input_size_;
      for (unsigned int j = 0; j < neurons.transpose_.size(); ++j) {
        neurons.transpose_[j][i] = neurons.weights_[i][j + offset];
      }
    }
  }
  neurons.beta_u_ += neurons.error_;
  neurons.gamma_u_ += neurons.error_ * neurons.norm_[epoch];
  neurons.error_ *= neurons.gamma_ * neurons.ivar_[epoch];
  neurons.error_ -= ((neurons.error_ * neurons.norm_[epoch]).sum() /
      num_cells_) * neurons.norm_[epoch];
  if (layer > 0) {
    for (unsigned int i = 0; i < num_cells_; ++i) {
      float f = 0;
      for (unsigned int j = 0; j < num_cells_; ++j) {
        f += neurons.error_[j] * neurons.transpose_[num_cells_ + i][j];
      }
      (*hidden_error)[i] += f;
    }
  }
  if (epoch > 0) {
    for (unsigned int i = 0; i < num_cells_; ++i) {
      float f = 0;
      for (unsigned int j = 0; j < num_cells_; ++j) {
        f += neurons.error_[j] * neurons.transpose_[i][j];
      }
      stored_error_[i] += f;
    }
  }
  std::slice slice = std::slice(output_size_, input.size(), 1);
  for (unsigned int i = 0; i < num_cells_; ++i) {
    neurons.update_[i][slice] += neurons.error_[i] * input;
    neurons.update_[i][input_symbol] += neurons.error_[i];
  }
  if (epoch == 0) {
    for (unsigned int i = 0; i < num_cells_; ++i) {
      Adam(&neurons.update_[i], &neurons.m_[i], &neurons.v_[i],
          &neurons.weights_[i], learning_rate_, update_steps_);
    }
    Adam(&neurons.gamma_u_, &neurons.gamma_m_, &neurons.gamma_v_,
        &neurons.gamma_, learning_rate_, update_steps_);
    Adam(&neurons.beta_u_, &neurons.beta_m_, &neurons.beta_v_,
        &neurons.beta_, learning_rate_, update_steps_);
  }
}

inline std::vector<std::valarray<std::valarray<float>>*> LstmLayer::Weights() {
  std::vector<std::valarray<std::valarray<float>>*> weights;
  weights.push_back(&forget_gate_.weights_);
  weights.push_back(&input_node_.weights_);
  weights.push_back(&output_gate_.weights_);
  return weights;
}

