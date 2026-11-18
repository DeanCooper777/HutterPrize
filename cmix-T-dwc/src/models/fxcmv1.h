// fxcmv1.h: interface of the fxcm model (fxcmv1.cpp), a complete paq8-style context-mixing
// predictor by Kaido Orav that fx2-cmix runs as one large model inside cmix.
//
// fxcmv1::Predictor is the fxcm engine (update() = learn the coded bit and compute the
// predictions for the next bit). FXCM wraps it as a cmix Model. Its outputs are not one
// probability but several hundred: every input of fxcm's own mixers, the outputs of those
// mixers and of its final refinement stages. All of them become inputs of the cmix mixers
// (Predictor::fxcm_model_ in src/predictor.cpp).
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.

//#ifndef FXCM_H
//#define FXCM_H

#include "model.h"
#include <vector>
#include <memory>

namespace fxcmv1 {
  class Predictor{

public:
  Predictor();
  int p() ;
  void update();
};
}

class FXCM : public Model {
 public:
  FXCM();
  const std::valarray<float>& Predict() const;
  unsigned int NumOutputs();
  void Perceive(int bit);
  void ByteUpdate() {};

 private:
  std::unique_ptr<fxcmv1::Predictor> predictor_;
};

//#endif
