// mixer-input.h: the input vector of one mixer layer.
//
// Predictor (src/predictor.cpp) has two: layers_[0] holds the stretched predictions of all
// models (the inputs of every first-layer mixer), layers_[1] holds the outputs of the
// first-layer mixers plus a few direct inputs (the inputs of the final mixer). The Mixer
// objects keep references to these arrays.
// The "extra inputs" of layer 0 are the outputs of the first-layer mixers themselves: mixer i
// also sees the outputs of mixers 0..i-1 of the same bit.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.
// (The clipping epsilon passed to the constructor is now set in src/predictor.cpp, tune key
// input_eps.)

#ifndef MIXER_INPUT_H
#define MIXER_INPUT_H

#include "sigmoid.h"

#include <valarray>
#include <vector>

class MixerInput {
 public:
  MixerInput(const Sigmoid& sigmoid, float eps);
  void SetNumModels(int num_models);
  void SetInput(int index, float p);
  void SetStretchedInput(int index, float p);
  void SetZero(int index);
  void SetExtraInput(size_t index, float p);
  void SetExtraInputSize(size_t size) { extra_inputs_.resize(size);};
  //void ClearExtraInputs() { extra_inputs_.clear(); }
  const std::valarray<float>& Inputs() const { return inputs_; }
  //const std::vector<float>& ExtraInputs() const { return extra_inputs_; }
  const auto& ExtraInputs() const { return extra_inputs_; }

 private:
  std::valarray<float> inputs_;
  //std::vector<float> extra_inputs_;
  std::valarray<float> extra_inputs_;
  const Sigmoid& sigmoid_;
  // [min_, max_] = [eps, 1 - eps]: probabilities are clipped to this before stretching.
  // [stretched_min_, stretched_max_]: the range of the logit table, used to clip values that
  // are already stretched.
  float min_, max_, stretched_min_, stretched_max_;
};

#endif

