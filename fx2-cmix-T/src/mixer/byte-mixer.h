// byte-mixer.h: the byte-level predictor slot of cmix, seen by the mixers as one ByteModel.
//
// In fx2-cmix this was an LSTM trained while coding (lstm*.h): it read the PPMD byte
// distribution and the previous byte and produced its own byte distribution. In the previous
// winning entry and in this one the transformer (cpp_infer/) takes its place: Predictor calls
// SetProbs() with the transformer's distribution once per byte and the lstm is not created.
// ByteModel then turns the distribution into one bit probability per bit, which is a mixer
// input and also feeds fxcm (lstmpr / lstmex in src/predictor.cpp). This entry adds a second
// instance that carries the online-adapted transformer output (dyn_mixer_ in
// src/predictor.cpp).
// How it fits: preprocess -> dictionary -> [context models / PPMD / transformer byte model]
// -> mixers -> SSE -> arithmetic coder -> self-extracting archive.
//
// Testing: the lstm path still runs in non-official builds when no transformer is loaded.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): unchanged.
// (See byte-mixer.cpp.)

#ifndef BYTE_MIXER_H
#define BYTE_MIXER_H

#include <vector>
#include <memory>

#include "../models/byte-model.h"
#include "lstm.h"

class ByteMixer : public ByteModel {
 public:
  ByteMixer(unsigned int num_models, const unsigned int& bit_context,
      const std::vector<bool>& vocab, unsigned int vocab_size, Lstm* lstm);
  void SetInput(int index, float val);
  void ByteUpdate();
  // Sets the byte-level probability distribution directly (one float per
  // vocabulary byte, in vocabulary order) instead of running the lstm.
  void SetProbs(const float* vocab_probs);

 private:
  // lstm_: null when the transformer is used. byte_: the byte just coded. byte_map_: byte ->
  // index in the vocabulary. inputs_: the lstm's input vector (sum of the SetInput values).
  std::unique_ptr<Lstm> lstm_;
  const unsigned int& byte_;
  std::valarray<int> byte_map_;
  std::valarray<float> inputs_;
  unsigned int num_models_, vocab_size_, offset_;
};

#endif
