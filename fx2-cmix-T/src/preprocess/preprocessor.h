#ifndef PREPROCESSOR_H
#define PREPROCESSOR_H

#include <stdio.h>
#include <string>

#include "../predictor.h"

namespace preprocessor {

typedef enum {DEFAULT, TEXT=7} Filetype;

// Windows port: when set, segment lengths are written as 8 letters 'a'..'p'
// (one per nibble) instead of 4 raw bytes, so that the length -- which
// differs between builds, see README -- never adds a byte outside the
// 205-byte vocabulary the transformer was trained on. Encoder and decoder
// must agree; runner.cpp sets it whenever the transformer is enabled.
extern bool g_vocab_safe_lengths;

void Encode(FILE* in, FILE* out, unsigned long long n, const std::string&
    temp_path, FILE* dictionary);

void NoPreprocess(FILE* in, FILE* out, unsigned long long n);

void Pretrain(Predictor* p, FILE* dictionary);

void Decode(FILE* in, FILE* out, FILE* dictionary);

}

#endif
