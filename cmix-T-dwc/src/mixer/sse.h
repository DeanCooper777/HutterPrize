// sse.h: final probability refinement ("secondary symbol estimation", SSE / APM).
//
// The final mixer's probability is passed through SSE::Predict() before it goes to the
// arithmetic coder; SSE::Perceive() then learns from the coded bit. SSE corrects systematic
// errors of the mixer: it learns, per small context, what the real frequency of a 1 is when
// the mixer says p. Called from Predictor::Predict / Perceive (src/predictor.cpp).
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.
// (See sse.cpp.)

#ifndef SSE_H
#define SSE_H

namespace SSE_sh {
  struct M_T1;
}

class SSE {
 public:
  SSE();
  ~SSE();
  float Predict(float input);
  void Perceive(int bit);

 private:
  SSE_sh::M_T1* sse_;
};

#endif
