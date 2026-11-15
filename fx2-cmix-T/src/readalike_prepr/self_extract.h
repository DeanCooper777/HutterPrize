// self_extract.h: how the compressor package (comp9, built as run/cmix) and the
// self-extracting archive (archive9) carry their payload, and the code that unpacks it.
// Both files are an ordinary executable with data appended; the last 16 bytes of the file
// are a HeaderInfo trailer that gives the sizes of the appended sections, so the sections
// are located by counting back from the end of the file.
//
// comp9 = run/cmix, sections in file order (assembled by build_and_construct_comp.sh):
//   1. the executable (packed);       size = file size - (2) - (3) - (4) - 16
//   2. the WRT dictionary, cmix-compressed with plain -c;   dict_size bytes
//   3. the article order, cmix-compressed with plain -c;    new_article_order_size bytes
//   4. the transformer weights file, stored as it is;       tf_weights_size bytes
//   5. HeaderInfo trailer; decomp_input_size = 0.           16 bytes
//
// archive9, sections in file order (assembled by the -e branch of main() in runner.cpp):
//   1. the same executable, byte for byte (section 1 of comp9);
//   2. the compressed dictionary (section 2 of comp9);      dict_size bytes
//   3. the transformer weights (section 4 of comp9);        tf_weights_size bytes
//   4. the cmix-coded enwik9 stream (the OUT file of -e);   decomp_input_size bytes
//   5. HeaderInfo trailer: comp9's trailer with decomp_input_size filled in. Its
//      new_article_order_size field still holds comp9's value, but archive9 has no
//      article-order section and the decompressor does not use the field (it restores
//      the article order by sorting on <id>).                16 bytes
//
// The executable, the dictionary and the weights are therefore paid for twice in the
// score S = size(comp9) + size(archive9); that is why this entry shrinks the binary
// (CMIX_OFFICIAL, custom packer) and the weights file (new weight coder).
//
// The trailer is four 32-bit ints in the machine's byte order (little endian on x86-64),
// so every section must be smaller than 2 GB.
//
// Place in the pipeline: the last stage (self-extracting archive). selfextract_comp() is
// the first step of "cmix -e"; selfextract_decomp() is the first step of running archive9.
// Both call the executable itself as a subprocess ("-d") to decompress the small embedded
// tables with the cmix model.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1): the executable names
// and the subprocess prefix are macros so that the Windows development build works
// (cmix.exe / archive9.exe). The layout itself is unchanged.

#ifndef SELF_EXTRACT_H 
#define SELF_EXTRACT_H 

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <malloc.h>

// [this entry] Portability (Windows development build). The file must be started from its
// own directory under exactly this name, because it re-opens itself by name.
// Executable names. On Windows the self-extracting files must carry an .exe
// extension to be runnable, and subprocesses go through cmd.exe.
#ifdef _WIN32
#define CMIX_EXE "cmix.exe"
#define ARCHIVE_EXE "archive9.exe"
#define RUN_PREFIX ".\\"
#define malloc_trim(x) ((void)0)
#else
#define CMIX_EXE "cmix"
#define ARCHIVE_EXE "archive9"
#define RUN_PREFIX "./"
#endif

#include <string>

// The dictionary is a fixed asset of this submission (dictionary/english.dic).
// It travels in the archive in cmix-compressed form, so recovering it runs the
// full model over 100KB of input -- about a minute -- before anything else
// happens. That makes it a cheap end-to-end self-test of the machine the
// archive is about to be decompressed on: if the model does not reproduce the
// bits the compressor saw, the dictionary comes out wrong, every prediction
// after it is made against different words, and the arithmetic coder
// desynchronises. Without this check that failure surfaces either as a
// segfault in an unrelated place (the codeword table is indexed by words that
// were never loaded) or as thirty hours of decompression producing garbage.
// Update both constants if dictionary/english.dic is ever replaced.
static const long long kExpectedDictSize = 411996;
static const unsigned long long kExpectedDictHash = 0x2c3946082300051aULL;  // FNV-1a 64

// Opens the running executable, which the self-extractor reads its appended
// payload out of. It has to be found under its own name in the working
// directory: bailing out with a message beats the segmentation fault an
// unchecked fopen would produce if the file was renamed or the program was
// started from another directory.
FILE* OpenSelf(const char* name) {
  FILE* f = fopen(name, "rb");
  if (f == NULL) {
    fprintf(stderr, "\ncmix error: cannot open '%s' in the current "
        "directory.\nRun it as ./%s, from the directory the file is in, and "
        "do not rename it.\n", name, name);
    exit(EXIT_FAILURE);
  }
  return f;
}

// Reads the whole of `f` (already sized at `size`) into a fresh buffer.
unsigned char* ReadWholeFile(FILE* f, size_t size, const char* name) {
  unsigned char* buffer = (unsigned char*)malloc(size);
  if (buffer == NULL) {
    fprintf(stderr, "\ncmix error: cannot allocate %zu bytes to read '%s'.\n",
        size, name);
    exit(EXIT_FAILURE);
  }
  if (fread(buffer, 1, size, f) != size) {
    fprintf(stderr, "\ncmix error: '%s' is %zu bytes long but could not be "
        "read in full. The file is truncated or the disk returned an error.\n",
        name, size);
    exit(EXIT_FAILURE);
  }
  return buffer;
}

// Runs a decompression subprocess and aborts if it did not exit cleanly.
void RunSubprocess(const char* command) {
  int status = system(command);
  if (status != 0) {
    fprintf(stderr, "\ncmix error: '%s' failed (exit status %d).\n", command,
        status);
    exit(EXIT_FAILURE);
  }
}

// Aborts unless `path` holds exactly the expected dictionary.
void VerifyDictionary(const char* path) {
  FILE* f = fopen(path, "rb");
  if (f == NULL) {
    fprintf(stderr, "\ncmix error: the dictionary (%s) was not produced. The "
        "archive is truncated or corrupt.\n", path);
    exit(EXIT_FAILURE);
  }
  unsigned long long hash = 0xcbf29ce484222325ULL;
  long long size = 0;
  unsigned char buffer[1 << 16];
  size_t n;
  while ((n = fread(buffer, 1, sizeof(buffer), f)) > 0) {
    for (size_t i = 0; i < n; ++i) {
      hash = (hash ^ buffer[i]) * 0x100000001b3ULL;
    }
    size += (long long)n;
  }
  fclose(f);
  if (size != kExpectedDictSize || hash != kExpectedDictHash) {
    fprintf(stderr,
        "\ncmix error: the dictionary decompressed to %lld bytes with hash "
        "%016llx, expected %lld bytes with hash %016llx.\n"
        "This machine does not reproduce the model the archive was built "
        "with, so decompression cannot succeed. The usual cause is "
        "floating-point results that are not bit-identical across CPUs -- see "
        "the -mrecip=none note in the makefile.\n",
        size, hash, kExpectedDictSize, kExpectedDictHash);
    exit(EXIT_FAILURE);
  }
}

// The 16-byte trailer at the very end of comp9 and archive9 (see the top of this file).
// All sizes in bytes.
struct HeaderInfo {
  int dict_size;
  int new_article_order_size;
  int decomp_input_size;
  // Size of the compressed transformer weights (FX2TFWC2 format, appended
  // as-is and loaded directly — never run through cmix itself).
  int tf_weights_size;
};

// Raw read / write of a trailer as a 16-byte file (header.dat, test.dat,
// header4archive.dat).
void write(const std::string& file_name, HeaderInfo& data) {
  FILE *out = fopen(file_name.c_str() , "wb" );
  fwrite(&data , 1 , sizeof(HeaderInfo) , out );
  fclose(out);
}

void read(const std::string& file_name, HeaderInfo& data) {
  FILE *in = fopen(file_name.c_str() , "rb" );
  fread(&data , 1 , sizeof(HeaderInfo) , in );
  fclose(in);
}


// This function splits the ./cmix binary file into 4 parts:
// 1) actual compressor/decompressor binary
// 2) dictionary (get's it in compressed form and decompresses it)
// 3) new order of articles (get's it in compressed form and decompresses it)
// 4) transformer weights (compressed FX2TFWC2 file, used as extracted)
// Files written into the working directory:
//   test.dat                 a copy of the trailer (reused when archive9 is assembled)
//   .decomp_bin              section 1, the executable; becomes the head of archive9
//   .dict.comp               section 2;  decompressed to .dict (and verified)
//   .new_article_order.comp  section 3;  decompressed to .new_article_order
//   .tfweights               section 4, loaded directly by the transformer
int selfextract_comp() {
  HeaderInfo header;

// open itslef to read auxilary data (dictionary and neworder)
  FILE *f = NULL, *fo = NULL;
  f = OpenSelf(CMIX_EXE);

  // get the size of the whole binary
  fseek(f, 0, SEEK_END);
  size_t fsize = ftell(f);
  fseek(f, 0, SEEK_SET);

  // read the whole binary to memory
  unsigned char *p1 = ReadWholeFile(f, fsize, CMIX_EXE);
  fclose(f);

  // read header info
  fo = fopen("test.dat", "wb");
  memcpy(&header, p1 + fsize - sizeof(HeaderInfo), sizeof(HeaderInfo));
  fwrite(p1 + fsize - sizeof(HeaderInfo), sizeof(HeaderInfo), 1, fo);
  fclose(fo);

  //Remove dictionary if present
  remove(".dict");
  
  // Everything in front of the appended sections is the executable.
  size_t decmpressor_binary_size = fsize - header.dict_size - header.new_article_order_size - header.tf_weights_size - sizeof(HeaderInfo);

// produce actual decompressor binary
  // [this entry] Decompressor form of the packed executable. In comp9's trailer the field
  // decomp_input_size is otherwise unused (0); the build stores there the "cut": the number of
  // leading bytes of the packed executable that the decompressor needs. The packer codes the
  // compress-only functions last (packer/pk.cpp, "hole"), so the decompressor is this same file
  // cut short, with two header fields changed: byte 9 of the ELF header (padding) is set to 1,
  // which tells the unpacking stub to stop before the hole, and the file size of its one
  // program header (p_filesz, 8 bytes at offset 96: the stub's ELF header is followed directly
  // by a single program header, packer/stub.ld) is set to the new length, because the kernel
  // refuses to load a segment that claims more bytes than the file has. 0 (or a value that is
  // not smaller than the executable): the whole executable is copied, as in the previous entry.
  size_t decomp_copy_size = decmpressor_binary_size;
  if (header.decomp_input_size > 128 && (size_t)header.decomp_input_size < decmpressor_binary_size) {
    decomp_copy_size = header.decomp_input_size;
    p1[9] = 1;
    uint64_t filesz = decomp_copy_size;
    memcpy(p1 + 96, &filesz, 8);
  }
  fo = fopen(".decomp_bin", "wb");
  fwrite(p1, decomp_copy_size, 1, fo);
  fclose(fo);

// produce dictionary and decompress it
  fo = fopen(".dict.comp", "wb");
  fwrite(p1 + decmpressor_binary_size, header.dict_size, 1, fo);
  fclose(fo);


// produce article order and decompress it
  fo = fopen(".new_article_order.comp", "wb");
  fwrite(p1 + decmpressor_binary_size + header.dict_size, header.new_article_order_size, 1, fo);
  fclose(fo);

// produce the transformer weights (already in their loadable compressed
// format, so no decompression subprocess is run on them)
  fo = fopen(".tfweights", "wb");
  fwrite(p1 + decmpressor_binary_size + header.dict_size + header.new_article_order_size, header.tf_weights_size, 1, fo);
  fclose(fo);
//  std::cout << "Decompressing the file with the new article order..." << std::endl;
  RunSubprocess(RUN_PREFIX CMIX_EXE " -d .new_article_order.comp .new_article_order");

//  std::cout << "Decompressing dictionary..." << std::endl;
  RunSubprocess(RUN_PREFIX CMIX_EXE " -d .dict.comp .dict");
  VerifyDictionary(".dict");
  free(p1);
  malloc_trim(0);
  return 0;
}

// Same as previous function, but used in decompressor
// This function splits the ./archive9 binary file into 4 parts:
// 1) actual decompressor binary
// 2) dictionary (get's it in compressed form and decompresses it)
// 3) transformer weights (compressed FX2TFWC2 file, used as extracted)
// 4) the cmix-compressed enwik9 payload
// Files written into the working directory:
//   test.dat             a copy of the trailer
//   .dict.comp_decomp    section 2;  decompressed to .dict (and verified)
//   .tfweights           section 3, loaded directly by the transformer
//   .ready4cmix_decomp   section 4, the coded enwik9 stream
int selfextract_decomp() {
  HeaderInfo header;
  FILE *f = NULL, *fo = NULL;
  f = OpenSelf(ARCHIVE_EXE);

  fseek(f, 0, SEEK_END);
  size_t fsize = ftell(f);
  fseek(f, 0, SEEK_SET);

  unsigned char *p1 = ReadWholeFile(f, fsize, ARCHIVE_EXE);
  fclose(f);

  // read header info
  fo = fopen("test.dat", "wb");
  fwrite(p1 + fsize - sizeof(HeaderInfo), sizeof(HeaderInfo), 1, fo);
  fclose(fo);
  read("test.dat", header);

  //Remove dictionary if present
  remove(".dict");
  
  // The executable is what precedes the three appended sections. new_article_order_size is
  // not subtracted: archive9 has no article-order section.
  size_t decmpressor_binary_size = fsize - header.dict_size - header.tf_weights_size - header.decomp_input_size - sizeof(HeaderInfo);

  fo = fopen(".dict.comp_decomp", "wb");
  fwrite(p1 + decmpressor_binary_size, header.dict_size, 1, fo);
  fclose(fo);

  RunSubprocess(RUN_PREFIX ARCHIVE_EXE " -d .dict.comp_decomp .dict");//_decomp
  VerifyDictionary(".dict");

  fo = fopen(".tfweights", "wb");
  fwrite(p1 + decmpressor_binary_size + header.dict_size, header.tf_weights_size, 1, fo);
  fclose(fo);

  fo = fopen(".ready4cmix_decomp", "wb");
  fwrite(p1 + decmpressor_binary_size + header.dict_size + header.tf_weights_size, header.decomp_input_size, 1, fo);
  fclose(fo);

  free(p1);
  malloc_trim(0);
  return 0;
}

#endif // PREPR_H
