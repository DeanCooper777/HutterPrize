// preprocessor.h: the generic cmix preprocessor. It cuts the input into segments, tags
// each as TEXT or DEFAULT, and applies the WRT dictionary transform to TEXT segments.
// For enwik9 the input is already the reordered, phda9-transformed file (.ready4cmix)
// and the whole of it is one TEXT segment.
//
// Place in the pipeline: [preprocess -> dictionary] -> models. Called by runner.cpp:
// Encode / NoPreprocess before coding, Decode after decoding, Pretrain before both.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): g_vocab_safe_lengths
// (Windows development build only; the Linux submission never sets it).

#ifndef PREPROCESSOR_H
#define PREPROCESSOR_H

#include <stdio.h>
#include <string>

#include "../predictor.h"

namespace preprocessor {

// Segment types: DEFAULT (0) = bytes stored as they are, TEXT (7) = text, optionally
// dictionary-transformed.
typedef enum {DEFAULT, TEXT=7} Filetype;

// [this entry]
// Windows port: when set, segment lengths are written as 8 letters 'a'..'p'
// (one per nibble) instead of 4 raw bytes, so that the length -- which
// differs between builds, see README -- never adds a byte outside the
// 205-byte vocabulary the transformer was trained on. Encoder and decoder
// must agree; runner.cpp sets it whenever the transformer is enabled.
extern bool g_vocab_safe_lengths;

// Encode: input -> preprocessed stream. NoPreprocess: input -> one DEFAULT segment per
// 2 GB. Pretrain: feed the dictionary text to the predictor's context models. Decode:
// preprocessed stream -> original bytes.
void Encode(FILE* in, FILE* out, unsigned long long n, const std::string&
    temp_path, FILE* dictionary);

void NoPreprocess(FILE* in, FILE* out, unsigned long long n);

void Pretrain(Predictor* p, FILE* dictionary);

void Decode(FILE* in, FILE* out, FILE* dictionary);

}

#endif
