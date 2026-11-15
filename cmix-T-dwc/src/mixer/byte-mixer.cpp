// byte-mixer.cpp: ByteMixer, see byte-mixer.h.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
//   - In the official build (CMIX_OFFICIAL) the lstm branch of ByteUpdate() is compiled out.
//     That build always runs the transformer, so the branch is dead; removing it removes the
//     last call into the lstm code and keeps it out of the submitted binary (size).

#include "byte-mixer.h"

ByteMixer::ByteMixer(unsigned int num_models, const unsigned int& bit_context,
    const std::vector<bool>& vocab, unsigned int vocab_size, Lstm* lstm) :
    ByteModel(vocab), lstm_(lstm), byte_(bit_context), byte_map_(0, 256),
    inputs_(0.0, vocab_size), num_models_(num_models), vocab_size_(vocab_size),
    offset_(0) {
  for (int i = 0; i < 256; ++i) {
    byte_map_[i] = offset_;
    if (vocab_[i]) ++offset_;
  }
  offset_ = 0;
}

// lstm path: add one byte probability of a byte model to the lstm's input vector. Called for
// index 0..255 in order; bytes outside the vocabulary are skipped.
void ByteMixer::SetInput(int index, float val) {
  if (!vocab_[index]) return;
  inputs_[offset_] += val;
  ++offset_;
  if (offset_ == vocab_size_) offset_ = 0;
}

// Transformer path: take the distribution as given (see byte-mixer.h).
void ByteMixer::SetProbs(const float* vocab_probs) {
  unsigned int k = 0;
  for (int i = 0; i < 256; ++i) {
    if (vocab_[i]) {
      probs_[i] = vocab_probs[k];
      ++k;
    } else {
      probs_[i] = 0;
    }
  }
  ByteModel::ByteUpdate();
}

// lstm path, once per byte: train the lstm on the byte just coded and read its prediction
// for the next byte.
void ByteMixer::ByteUpdate() {
// [this entry] The official build has no lstm: see the header of this file.
#ifdef CMIX_OFFICIAL
  ByteModel::ByteUpdate();  // never reached: the official build has no lstm (see predictor.cpp)
#else
  inputs_ *= 2 / num_models_;
  lstm_->SetInput(inputs_);
  inputs_ = 0;
  const auto& output = lstm_->Perceive(byte_map_[byte_]);
  offset_ = 0;
  for (int i = 0; i < 256; ++i) {
    if (vocab_[i]) {
      probs_[i] = output[offset_];
      ++offset_;
    } else {
      probs_[i] = 0;
    }
  }
  offset_ = 0;
  ByteModel::ByteUpdate();
#endif
}
