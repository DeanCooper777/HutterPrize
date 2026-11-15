// sigmoid.h: the two functions that connect probabilities and the mixers' "stretched" domain.
//
// Logit(p) = ln(p / (1 - p)) ("stretch"), from a lookup table; Logistic(x) = 1 / (1 + e^-x)
// ("squash"), computed exactly. The mixers (mixer.*) add up stretched model predictions and
// squash the sum back into a probability. Used by MixerInput, Mixer, Predictor and the lstm.
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#ifndef SIGMOID_H
#define SIGMOID_H

#include <vector>

class Sigmoid {
 public:
  Sigmoid(int logit_size);
  float Logit(float p) const;
  static float Logistic(float p);
  static float FastLogistic(float p);

 private:
  float SlowLogit(float p);
  int logit_size_;
  std::vector<float> logit_table_;
};

#endif
