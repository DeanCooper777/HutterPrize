// sigmoid.cpp: Sigmoid, see sigmoid.h.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

#include "sigmoid.h"

#include <math.h>

// Tabulate the logit at the centre of each of logit_size equal steps of p in (0, 1).
Sigmoid::Sigmoid(int logit_size) : logit_size_(logit_size),
    logit_table_(logit_size, 0) {
  for (int i = 0; i < logit_size_; ++i) {
    logit_table_[i] = SlowLogit((i + 0.5f) / logit_size_);
  }
}

// Table lookup; p outside [0, 1) uses the first or the last entry.
float Sigmoid::Logit(float p) const {
  int index = p * logit_size_;
  if (index >= logit_size_) index = logit_size_ - 1;
  else if (index < 0) index = 0;
  return logit_table_[index];
}

float Sigmoid::Logistic(float p) {
  return 1 / (1 + exp(-p));
}

// Cheap approximation of Logistic; not the one the mixers use.
float Sigmoid::FastLogistic(float p) {
  return (0.5f * (p / (1.0f + abs(p)) + 1.0f));
}

float Sigmoid::SlowLogit(float p) {
  return log(p / (1 - p));
}
