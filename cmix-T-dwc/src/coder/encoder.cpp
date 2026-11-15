// encoder.cpp: implementation of the arithmetic encoder (see encoder.h).
// Unchanged from the previous winning entry.

#include "encoder.h"

Encoder::Encoder(std::ofstream* os, Predictor* p) : os_(os), x1_(0),
    x2_(0xffffffff), p_(p) {}

void Encoder::WriteByte(unsigned int byte) {
  out_.push_back(byte);
}

// Probability -> 16-bit integer in 1..65535, so neither bit ever has probability zero.
unsigned int Encoder::Discretize(float p) {
  return 1 + 65534 * p;
}

// xmid divides [x1_, x2_] so that the lower part is p/65536 of it (computed in two
// halves to avoid 32-bit overflow). Bit 1 takes the lower part, bit 0 the upper part.
// The Predictor is updated before any byte is shifted out; the Decoder does the same.
void Encoder::Encode(int bit) {
  const unsigned int p = Discretize(p_->Predict());
  const unsigned int xmid = x1_ + ((x2_ - x1_) >> 16) * p +
      (((x2_ - x1_) & 0xffff) * p >> 16);
  if (bit) {
    x2_ = xmid;
  } else {
    x1_ = xmid + 1;
  }
  p_->Perceive(bit);

  while (((x1_^x2_) & 0xff000000) == 0) {
    WriteByte(x2_ >> 24);
    x1_ <<= 8;
    x2_ = (x2_ << 8) + 255;
  }
}

// End of stream: emit enough of x2_ to identify the final interval, then write the file.
void Encoder::Flush() {
  while (((x1_^x2_) & 0xff000000) == 0) {
    WriteByte(x2_ >> 24);
    x1_ <<= 8;
    x2_ = (x2_ << 8) + 255;
  }
  WriteByte(x2_ >> 24);

  auto* data = reinterpret_cast<const char*>(out_.data());
  os_->write(data, out_.size());
}

