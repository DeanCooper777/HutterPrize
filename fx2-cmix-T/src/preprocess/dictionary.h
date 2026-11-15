// dictionary.h: the WRT (word replacing transform) dictionary. Words of the input that
// occur in the dictionary file are replaced by 1 to 3 byte codes (bytes >= 0x80), with
// separate flag bytes for capitalized and upper-case words. Shorter, more regular input
// for the models, and word identities become explicit.
//
// Place in the pipeline: preprocess -> [dictionary] -> models. Used by
// preprocessor.cpp (encode_text / decode_text) and by runner.cpp's
// --save-article-boundaries check.
//
// Unchanged from the previous winning entry.

#ifndef DICTIONARY_H
#define DICTIONARY_H

#include <stdio.h>
#include "../ds/emhash_map.hpp"
#include <string>
#include <array>
#include <list>

namespace preprocessor {

class Dictionary {
 public:
  Dictionary(FILE* dictionary, bool encode, bool decode);
  void Encode(FILE* input, int len, FILE* output);
  unsigned char Decode(FILE* input);

 private:
  void EncodeWord(const std::string& word, int num_upper, bool next_lower,
      FILE* output);
  bool EncodeSubstring(const std::string& word, FILE* output);
  void AddToBuffer(FILE* input);

  emhash6::HashMap<std::string, unsigned int> byte_map_;
  emhash6::HashMap<unsigned int, std::string> reverse_map_;
  std::list<unsigned char> output_buffer_;
  bool decode_upper_ = false, decode_capital_ = false;
  unsigned int longest_word_ = 0;
};

}

#endif
