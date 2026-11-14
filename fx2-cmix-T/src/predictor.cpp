#include "predictor.h"
#include "prof.h"
#include "tune.h"
#ifdef CMIX_PROFILE
namespace {
long g_tf_steps = 0;
void TfProfReport() { fx2::opt::prof_print(1.0, g_tf_steps); }
struct TfProfRegistrar { TfProfRegistrar() { atexit(TfProfReport); } } g_tf_prof_registrar;
}
#endif
#include <vector>
#ifdef CMIX_PIPE
#include <atomic>
#include <chrono>
#include <condition_variable>
#include <deque>
#include <mutex>
#include <thread>
#endif
#include <stdlib.h>
#include <stdio.h>
#include <cmath>
#include <cstdlib>
#include <cstring>
#include <cstdarg>
#include <immintrin.h>
#include "../cpp_infer/src/opt/vec_math.h"
#ifdef __F16C__
#include <immintrin.h>
#endif

void Fail(const char* fmt, ...) {
  va_list args;
  va_start(args, fmt);
  fprintf(stderr, "\ncmix error: ");
  vfprintf(stderr, fmt, args);
  fprintf(stderr, "\n");
  va_end(args);
  exit(1);
}

namespace {

const size_t kHalfBufferSize = 1 << 22;  // 4M halfs = 8MB per buffer

uint16_t FloatToHalf(float f) {
  uint32_t x;
  memcpy(&x, &f, 4);
  uint32_t sign = (x >> 16) & 0x8000;
  int32_t exp = (int32_t)((x >> 23) & 0xFF) - 112;  // half-biased exponent
  uint32_t mant = x & 0x7FFFFF;
  if (exp >= 31) return sign | 0x7C00;  // overflow, infinity and NaN
  if (exp <= 0) {  // subnormal half (or zero)
    if (exp < -10) return sign;
    mant |= 0x800000;
    int shift = 14 - exp;
    uint16_t h = mant >> shift;
    uint32_t rem = mant & ((1u << shift) - 1), half = 1u << (shift - 1);
    if (rem > half || (rem == half && (h & 1))) ++h;
    return sign | h;
  }
  uint16_t h = sign | (exp << 10) | (mant >> 13);
  uint32_t rem = mant & 0x1FFF;
  if (rem > 0x1000 || (rem == 0x1000 && (h & 1))) ++h;  // round to nearest even
  return h;
}

// Note: subnormal halves (values below 2^-14) decode to HALF their true
// value (the exponent term below would be 113-e in an exact decode). The
// F16C bulk path decodes exactly, so only the last n%8 elements of a
// conversion are affected. This quirk is part of the probability rounding
// contract of --save-ppmd-probs/--load-transformer-probs and of the transformer
// path, which reproduces the file pipeline bit-for-bit; changing it would
// change the coded probabilities.
float HalfToFloat(uint16_t h) {
  uint32_t sign = (uint32_t)(h & 0x8000) << 16;
  uint32_t exp = (h >> 10) & 0x1F;
  uint32_t mant = h & 0x3FF;
  uint32_t x;
  if (exp == 0) {
    if (mant == 0) {
      x = sign;
    } else {  // subnormal half: normalize
      int e = 0;
      while (!(mant & 0x400)) {
        mant <<= 1;
        ++e;
      }
      mant &= 0x3FF;
      x = sign | ((uint32_t)(112 - e) << 23) | (mant << 13);
    }
  } else if (exp == 31) {
    x = sign | 0x7F800000 | (mant << 13);
  } else {
    x = sign | ((exp + 112) << 23) | (mant << 13);
  }
  float f;
  memcpy(&f, &x, 4);
  return f;
}

void FloatsToHalves(const float* src, uint16_t* dst, size_t n) {
  size_t i = 0;
#ifdef __F16C__
  for (; i + 8 <= n; i += 8) {
    _mm_storeu_si128(reinterpret_cast<__m128i*>(dst + i),
        _mm256_cvtps_ph(_mm256_loadu_ps(src + i), _MM_FROUND_TO_NEAREST_INT));
  }
#endif
  for (; i < n; ++i) dst[i] = FloatToHalf(src[i]);
}

void HalvesToFloats(const uint16_t* src, float* dst, size_t n) {
  size_t i = 0;
#ifdef __F16C__
  for (; i + 8 <= n; i += 8) {
    _mm256_storeu_ps(dst + i, _mm256_cvtph_ps(
        _mm_loadu_si128(reinterpret_cast<const __m128i*>(src + i))));
  }
#endif
  for (; i < n; ++i) dst[i] = HalfToFloat(src[i]);
}

// The encoded article separator ("  <page>\n    <title>" after the WRT
// dictionary transform), as vocabulary indices of the enwik9 preprocessed
// stream. Validated against the dictionary encoding by
// SaveArticleBoundaries in runner.cpp; article boundaries correspond
// exactly to the occurrences of this sequence.
const unsigned char kArticleSeparator[15] = {
    0x08, 0x08, 0x25, 0xac, 0x65, 0x27, 0x05,
    0x08, 0x08, 0x08, 0x08, 0x25, 0xac, 0x68, 0x27};

// Articles longer than this are cut into pieces of exactly this many tokens
// (plus a shorter last piece), each a fresh transformer context — the same
// splitting the training data loader applies (split_article_lengths with
// max_article_tokens = 2^17). Must not exceed the transformer's rope table
// (131072 positions).
const unsigned long long kMaxArticleTokens = 1ULL << 17;

}  // namespace

HalfFileWriter::HalfFileWriter(const std::string& path) : path_(path),
    buffer_(kHalfBufferSize) {
  file_ = fopen(path.c_str(), "wb");
  if (!file_) Fail("cannot open %s for writing", path.c_str());
}

HalfFileWriter::~HalfFileWriter() {
  Flush();
  fclose(file_);
}

void HalfFileWriter::Write(const float* values, size_t n) {
  if (used_ + n > buffer_.size()) Flush();
  FloatsToHalves(values, buffer_.data() + used_, n);
  used_ += n;
}

void HalfFileWriter::WriteHalves(const uint16_t* values, size_t n) {
  if (used_ + n > buffer_.size()) Flush();
  memcpy(buffer_.data() + used_, values, n * sizeof(uint16_t));
  used_ += n;
}

void HalfFileWriter::Flush() {
  if (used_ == 0) return;
  if (fwrite(buffer_.data(), sizeof(uint16_t), used_, file_) != used_) {
    Fail("failed writing to %s (disk full?)", path_.c_str());
  }
  used_ = 0;
}

HalfFileReader::HalfFileReader(const std::string& path,
    unsigned long long num_distributions, unsigned int vocab_size)
    : path_(path), buffer_(kHalfBufferSize) {
  file_ = fopen(path.c_str(), "rb");
  if (!file_) Fail("cannot open %s for reading", path.c_str());
  fseeko(file_, 0, SEEK_END);
  unsigned long long size = ftello(file_);
  fseeko(file_, 0, SEEK_SET);
  unsigned long long expected = num_distributions * vocab_size * 2;
  if (size != expected) {
    Fail("--load-transformer-probs: %s has %llu bytes but exactly %llu were "
        "expected (%llu input bytes x %u vocabulary size x 2 bytes per "
        "float16); the file is too %s", path.c_str(), size, expected,
        num_distributions, vocab_size, size < expected ? "short" : "long");
  }
}

HalfFileReader::~HalfFileReader() {
  fclose(file_);
}

void HalfFileReader::Read(float* values, size_t n) {
  if (available_ < n) {
    memmove(buffer_.data(), buffer_.data() + pos_,
        available_ * sizeof(uint16_t));
    pos_ = 0;
    available_ += fread(buffer_.data() + available_, sizeof(uint16_t),
        buffer_.size() - available_, file_);
    if (available_ < n) {
      Fail("unexpected end of file while reading %s", path_.c_str());
    }
  }
  HalvesToFloats(buffer_.data() + pos_, values, n);
  pos_ += n;
  available_ -= n;
}

#ifdef CMIX_PIPE
// ---------------------------------------------------------------------------
// Multi-thread compression (PredictorOptions::tf_threads).
//
// While compressing, every byte is known in advance, and the transformer's
// output for a token depends only on the tokens and ppmd distributions of
// its own article piece. So the transformer need not run in step with the
// coder:
//   - the ppmd runs ahead of the coder (in the coder's thread, in bursts, up
//     to W tokens ahead) and its distribution after each token is kept in a
//     ring; the coder reads its ppmd inputs back from the ring;
//   - each completed article piece goes to a worker thread, which runs its
//     own transformer instance (shared weights) over it and stores, per
//     token, what TransformerByteUpdate needs: the output row, the logits and
//     the hidden state (for the online adaptation, which stays in the coder's
//     thread because it carries state across pieces);
//   - the coder takes each token's record when it gets there, waiting if the
//     worker has not reached it yet.
// Every value the coder sees is computed by the same code from the same
// inputs as in the single-thread path, so the output is byte-identical.
// The decompressor cannot do this (it learns each token only by decoding).
// ---------------------------------------------------------------------------
struct Predictor::TfPipe {
  static constexpr int kV = 205, kRec = 608;  // probs @0, logits @208, hidden @416
  struct Piece {
    unsigned long long start = 0;
    std::vector<uint8_t> tok;
    std::atomic<uint32_t> done{0};  // tokens whose records are complete
  };
  FILE* file = nullptr;
  unsigned long long n = 0;      // tokens in the stream
  unsigned long long pos = 0;    // the coder's token
  unsigned long long ahead = 0;  // tokens the ppmd has consumed
  unsigned long long W = 0, cap = 0;
  std::vector<float> prior;      // [cap][kV] ppmd distributions
  std::vector<float> rec;        // [cap][kRec] transformer records
  std::vector<uint8_t> bytes;    // [cap] the stream's bytes (sanity check)
  std::deque<std::unique_ptr<Piece>> pieces;  // dispatched, in order
  std::unique_ptr<Piece> open;                // being collected
  unsigned char window[15];
  unsigned long long article_tokens = 0;
  std::vector<unsigned char> rbuf;
  size_t rpos = 0, ravail = 0;

  std::mutex mu;
  std::condition_variable cv;
  std::deque<Piece*> queue;
  bool stop = false;
  std::vector<std::unique_ptr<fx2::opt::TransformerOpt>> tfs;
  std::vector<std::thread> threads;
  double wait_seconds = 0;
  unsigned long long waits = 0;

  void Enqueue() {
    Piece* p = open.get();
    pieces.push_back(std::move(open));
    {
      std::lock_guard<std::mutex> lk(mu);
      queue.push_back(p);
    }
    cv.notify_one();
  }

  void Work(fx2::opt::TransformerOpt* tf) {
    uint16_t half[208];
    for (;;) {
      Piece* p;
      {
        std::unique_lock<std::mutex> lk(mu);
        cv.wait(lk, [this] { return stop || !queue.empty(); });
        if (queue.empty()) return;
        p = queue.front();
        queue.pop_front();
      }
      // the piece may be freed as soon as its last record is published
      const unsigned long long start = p->start;
      const uint32_t len = (uint32_t)p->tok.size();
      const uint8_t* tok = p->tok.data();
      tf->begin_article();
      for (uint32_t j = 0; j < len; ++j) {
        const size_t slot = (size_t)((start + j) % cap);
        FloatsToHalves(&prior[slot * kV], half, kV);
        float* r = &rec[slot * kRec];
        const uint8_t t = tok[j];
        tf->step(t, half, r);
        memcpy(r + 208, tf->last_logits(), sizeof(float) * kV);
        memcpy(r + 416, tf->last_hidden(), sizeof(float) * 192);
        p->done.store(j + 1, std::memory_order_release);
      }
    }
  }

  ~TfPipe() {
    {
      std::lock_guard<std::mutex> lk(mu);
      stop = true;
      queue.clear();
    }
    cv.notify_all();
    for (auto& t : threads) t.join();
    if (file) fclose(file);
  }
};

Predictor::~Predictor() {
  if (pipe_) {
    fprintf(stderr, "\ntf pipeline: %zu threads, coder waited %.1f s in %llu "
        "waits\n", pipe_->threads.size(), pipe_->wait_seconds, pipe_->waits);
  }
}

void Predictor::PipeStart(const PredictorOptions& options) {
  if (vocab_size_ != TfPipe::kV) Fail("tf pipeline: vocabulary is not 205");
  pipe_.reset(new TfPipe());
  TfPipe& P = *pipe_;
  P.file = fopen(options.lookahead_path.c_str(), "rb");
  if (!P.file) Fail("tf pipeline: cannot open %s", options.lookahead_path.c_str());
  P.n = options.num_input_bytes;
  // A piece is dispatched once the ppmd has passed its end, and the coder
  // refills the look-ahead when less than W/2 is left, so W/2 must exceed
  // the longest piece.
  const unsigned long long min_w = 2 * (kMaxArticleTokens + 64);
  P.W = options.tf_ahead ? options.tf_ahead : 400000;
  if (P.W < min_w) P.W = min_w;
  P.cap = P.W + 16;
  P.prior.assign((size_t)P.cap * TfPipe::kV, 0.0f);
  P.rec.assign((size_t)P.cap * TfPipe::kRec, 0.0f);
  P.bytes.assign((size_t)P.cap, 0);
  P.rbuf.resize(1 << 20);
  memset(P.window, 0xFF, sizeof(P.window));
  // One step on the (otherwise unused) main instance, so that anything the
  // kernels initialize on first use is set up before the threads start.
  {
    std::vector<float> u(208, 1.0f / TfPipe::kV);
    std::vector<uint16_t> h(208, 0);
    FloatsToHalves(u.data(), h.data(), TfPipe::kV);
    std::vector<float> out(208, 0.0f);
    transformer_->begin_article();
    transformer_->step(0, h.data(), out.data());
  }
  for (int i = 0; i < options.tf_threads; ++i) {
    P.tfs.emplace_back(new fx2::opt::TransformerOpt(
        *transformer_, fx2::opt::TransformerOpt::ShareWeights()));
  }
  for (int i = 0; i < options.tf_threads; ++i) {
    P.threads.emplace_back(&TfPipe::Work, &P, P.tfs[i].get());
  }
  fprintf(stderr, "tf pipeline: %d threads, look-ahead %llu tokens\n",
      options.tf_threads, P.W);
}

// Called at each byte boundary in place of the ppmd's ByteUpdate: lets the
// ppmd run ahead if the look-ahead is low, then puts the distribution that
// follows the byte just coded back into the byte model.
void Predictor::PipeAdvance() {
  TfPipe& P = *pipe_;
  const unsigned long long i = P.pos;
  if (i >= P.n) Fail("tf pipeline: more bytes coded than the stream holds");
  if (P.ahead < P.n && P.ahead < i + 1 + P.W / 2) {
    unsigned long long target = i + 1 + P.W;
    if (target > P.n) target = P.n;
    while (P.ahead < target) {
      if (P.rpos == P.ravail) {
        P.ravail = fread(P.rbuf.data(), 1, P.rbuf.size(), P.file);
        P.rpos = 0;
        if (P.ravail == 0) Fail("tf pipeline: look-ahead stream ended early");
      }
      const unsigned int c = P.rbuf[P.rpos++];
      const int t = byte_to_index_[c];
      if (t < 0) Fail("transformer: byte 0x%02x is not in the vocabulary", c);
      const size_t slot = (size_t)(P.ahead % P.cap);
      ppmd_byte_ = c;
      byte_model_->ByteUpdate();
      const std::valarray<float>& p = byte_model_->BytePredict();
      float* d = &P.prior[slot * TfPipe::kV];
      for (unsigned int v = 0; v < vocab_size_; ++v) d[v] = p[vocab_bytes_[v]];
      P.bytes[slot] = (uint8_t)c;
      // the same piece boundaries as TransformerByteUpdate
      memmove(P.window, P.window + 1, sizeof(P.window) - 1);
      P.window[sizeof(P.window) - 1] = (unsigned char)t;
      ++P.article_tokens;
      const bool last =
          memcmp(P.window, kArticleSeparator, sizeof(kArticleSeparator)) == 0 ||
          P.article_tokens >= kMaxArticleTokens;
      if (last) {
        if (P.open) P.Enqueue();
        P.article_tokens = 0;
      } else {
        if (P.article_tokens == 1) {
          P.open.reset(new TfPipe::Piece());
          P.open->start = P.ahead;
        }
        P.open->tok.push_back((uint8_t)t);
      }
      ++P.ahead;
    }
    if (P.ahead == P.n && P.open) P.Enqueue();
  }
  const size_t slot = (size_t)(i % P.cap);
  if (P.bytes[slot] != manager_.bit_context_) {
    Fail("tf pipeline: byte %llu of the look-ahead stream is 0x%02x, but "
        "0x%02x was coded", i, P.bytes[slot], manager_.bit_context_);
  }
  byte_model_->LoadVocabProbs(&P.prior[slot * TfPipe::kV], vocab_bytes_);
}

// The transformer step of the coder's current token: waits for its record
// and points transformer_probs_ / the dyn sources at it.
void Predictor::PipeFetch() {
  TfPipe& P = *pipe_;
  const unsigned long long i = P.pos;
  while (!P.pieces.empty() &&
         i >= P.pieces.front()->start + P.pieces.front()->tok.size()) {
    P.pieces.pop_front();
  }
  if (P.pieces.empty() || i < P.pieces.front()->start) {
    Fail("tf pipeline: token %llu is not in a dispatched piece", i);
  }
  TfPipe::Piece* p = P.pieces.front().get();
  const uint32_t need = (uint32_t)(i - p->start) + 1;
  if (p->done.load(std::memory_order_acquire) < need) {
    const auto t0 = std::chrono::steady_clock::now();
    unsigned spins = 0;
    while (p->done.load(std::memory_order_acquire) < need) {
      if (++spins < 4000) _mm_pause();
      else std::this_thread::yield();
    }
    P.wait_seconds += std::chrono::duration<double>(
        std::chrono::steady_clock::now() - t0).count();
    ++P.waits;
  }
  const float* r = &P.rec[(size_t)(i % P.cap) * TfPipe::kRec];
  memcpy(transformer_probs_.data(), r, sizeof(float) * vocab_size_);
  dyn_z_src_ = r + 208;
  dyn_h_src_ = r + 416;
}
#endif  // CMIX_PIPE

Predictor::Predictor(const std::vector<bool>& vocab,
    const PredictorOptions& options) : manager_(),
    sigmoid_(100001), vocab_(vocab), ppmd_only_(options.ppmd_only),
    transformer_only_(options.transformer_only),
    num_input_bytes_(options.num_input_bytes) {
  for (int i = 0; i < 256; ++i) {
    if (vocab_[i]) vocab_bytes_.push_back(i);
  }
  vocab_size_ = vocab_bytes_.size();
  // Uniform, so that the loss of the first byte — predicted before the
  // transformer has produced anything — is counted the same way the byte
  // mixer's initial state makes it count outside --transformer-only.
  probs_scratch_.assign(vocab_size_, 1.0f);
  if (options.transformer_only && options.transformer_weights.empty()) {
    Fail("--transformer-only runs the transformer, but no transformer "
        "weights are available");
  }
  if (!options.save_ppmd_probs.empty()) {
    ppmd_probs_writer_.reset(new HalfFileWriter(options.save_ppmd_probs));
  }
  if (!options.load_transformer_probs.empty()) {
    // The loaded distributions stand in for the transformer's output, so the
    // transformer must be the model that would otherwise have run.
    if (options.transformer_weights.empty() && !ppmd_only_) {
      Fail("--load-transformer-probs replaces the transformer's output "
          "distributions, but no transformer is enabled: the lstm would be "
          "run instead");
    }
    transformer_probs_reader_.reset(new HalfFileReader(
        options.load_transformer_probs, options.num_input_bytes, vocab_size_));
    // The loss of the loaded distributions is the transformer's loss.
    print_transformer_loss_ = true;
  }
  neutral_transformer_ = options.neutral_transformer;
#ifdef CMIX_OFFICIAL
  // Official build: no lstm. Without transformer weights (the embedded dictionary and article
  // order, coded with plain -c/-d) the byte mixer carries a uniform distribution instead. That
  // costs about 4.8 KB on those two tables and saves the lstm's code in both binaries.
  if (options.transformer_weights.empty()) neutral_transformer_ = true;
#endif
  if (neutral_transformer_) uniform_probs_.assign(vocab_size_, 1.0f);
  if (!options.save_cmix_bits.empty()) {
    cmix_bits_writer_.reset(new HalfFileWriter(options.save_cmix_bits));
  }
  if (!options.transformer_weights.empty() && !ppmd_only_ &&
      !transformer_probs_reader_ && !neutral_transformer_) {
    if (vocab_size_ != 205) {
      Fail("the transformer was trained on the enwik9 vocabulary of 205 "
          "bytes, but this input has a vocabulary of %u bytes", vocab_size_);
    }
    transformer_.reset(new fx2::opt::TransformerOpt(
        options.transformer_weights.c_str(),
        tune::Get("attn_f32", 0) ? fx2::opt::AttnKind::KVF32 : fx2::opt::AttnKind::KVI8));
    half_scratch_.resize(vocab_size_);
    transformer_probs_.resize(vocab_size_);
    print_transformer_loss_ = true;
    dyn_lr_ = tune::Get("dyn_lr", 3e-4);
    dyn_blr_ = tune::Get("dyn_blr", 0);
    dyn_decay_ = tune::Get("dyn_decay", 0);
    dyn_mode_ = (int)tune::Get("dyn_mode", 1);
    dyn_l1_ = tune::Get("dyn_l1", 1) != 0;
    dyn_fx_ = tune::Get("dyn_fx", 0) != 0;
    dyn2_lr_ = tune::Get("dyn2_lr", 0);
    dyn2_layers_ = (uint32_t)tune::Get("dyn2_layers", 2048);
    if (dyn2_lr_ != 0) {
      transformer_->set_capture_layers(dyn2_layers_);
      dyn2_W_.assign((size_t)12 * 768 * kDynPad, 0.0f);
      dyn2_row_.reserve(12 * 768);
      dyn2_f_.reserve(12 * 768);
    }
    if (dyn_lr_ != 0 || dyn_blr_ != 0 || dyn2_lr_ != 0) {
      dyn_g_.assign(kDynPad, 0.0f);
      dyn_W_.assign((size_t)vocab_size_ * kDynHidden, 0.0f);
      dyn_b_.assign(vocab_size_, 0.0f);
      dyn_h_.assign(kDynHidden, 0.0f);
      dyn_hp_.assign(kDynHidden, 0.0f);
      dyn_s_.assign(vocab_size_, 0.0f);
      dyn_q_.assign(kDynPad, 0.0f);
      dyn_z_.assign(kDynPad, 0.0f);
    }
    if (!options.save_transformer_probs.empty()) {
      transformer_probs_writer_.reset(
          new HalfFileWriter(options.save_transformer_probs));
    }
  }
  for (int i = 0; i < 256; ++i) byte_to_index_[i] = -1;
  for (unsigned int i = 0; i < vocab_size_; ++i) {
    byte_to_index_[vocab_bytes_[i]] = i;
  }
#ifdef CMIX_PIPE
  if (options.tf_threads > 0 && transformer_ && !ppmd_only_ &&
      !transformer_only_) {
    if (dyn2_lr_ != 0) Fail("tf pipeline: not available with dyn2_lr");
    PipeStart(options);
  }
#endif
  // 0xFF is not a vocabulary index, so the window cannot match the
  // separator before 15 real tokens have been seen.
  memset(separator_window_, 0xFF, sizeof(separator_window_));
  if (ppmd_only_ || transformer_only_) {
    AddPPMD();
    return;
  }
  AddBracket();
  // With load_transformer_probs the ppmd is not run: its mixer input is a
  // constant and the transformer's distributions come from the file.
  if (!transformer_probs_reader_) AddPPMD();
  fxcm_model_.emplace();
  AddWord();
  AddMatch();
  AddDoubleIndirect();
  AddMixers();
  auxiliary_size_ = 2;
}

unsigned long long Predictor::GetNumModels() {
  unsigned long long num = 0;

  // models
  num += bracket_model_->NumOutputs(); // bracket
  num += fxcm_model_->NumOutputs();
  num += direct_models_.size();
  num += match_models_.size();
  num += indirect_ns_models_.size();
  num += indirect_r_models_.size();
  num += 1;  // ppmd byte model (a constant input with
             // --load-transformer-probs)
  num += byte_mixer_->NumOutputs();
  if (dyn_mixer_) num += dyn_mixer_->NumOutputs();
  return num;
}

void Predictor::AddMixer(int layer, const unsigned long long& context,
    float learning_rate) {
  learning_rate = tune::Get("lr" + std::to_string(layer) + "_" +
      std::to_string(layer == 0 ? mixer_0_.size() : mixer_1_.size()),
      learning_rate);
  if (layer == 0) {
    mixer_0_.emplace_back(
        layers_[layer].Inputs(), layers_[layer].ExtraInputs(), context,
      learning_rate, mixer_0_.size());
  } else {
    mixer_1_.emplace_back(
        layers_[layer].Inputs(), layers_[layer].ExtraInputs(), context,
      learning_rate, mixer_1_.size());
  }
}

void Predictor::AddBracket() {
  bracket_model_.emplace(manager_.bit_context_, 200, 10, 100000, vocab_);
  const Context& context = manager_.AddBracketContext(manager_.bit_context_, 256, 15);
  direct_models_.emplace_back(context.GetContext(), manager_.bit_context_, 30, 0,
      context.Size());
  indirect_ns_models_.emplace_back(manager_.nonstationary_, context.GetContext(),
      manager_.bit_context_, 300, manager_.shared_map_);
}

void Predictor::AddPPMD() {
#ifdef CMIX_PIPE
  if (pipe_) {
    byte_model_.emplace(25, (int)tune::Get("ppmd_mb", 14000), ppmd_byte_, vocab_);
    return;
  }
#endif
  byte_model_.emplace(25, (int)tune::Get("ppmd_mb", 14000), manager_.bit_context_, vocab_);
}

void Predictor::AddWord() {
  float delta = 200;
  std::vector<std::vector<unsigned int>> model_params = {
  {0},
   {0, 1}, 
      {1}, 
      {1, 2},
      {1, 3}, 
       {2, 3},
       {3, 4},
      {1, 2, 4},
      {2, 3, 4},
       {2}
      };
  for (const auto& params : model_params) {
    const Context& context = manager_.AddSparseContext(manager_.words_, params);
    indirect_ns_models_.emplace_back(manager_.nonstationary_, context.GetContext(),
        manager_.bit_context_, delta, manager_.shared_map_);
  }

  std::vector<std::vector<unsigned int>> model_params2 = {
  {0}, 
  {1}, 
      {1, 3},
       {1, 2, 3}, 
       {7, 2}};
  for (const auto& params : model_params2) {
    const Context& context = manager_.AddSparseContext(manager_.words_, params);
    match_models_.emplace_back(manager_.history_, context.GetContext(),
        manager_.bit_context_, 200, 0.5, 2000000, &(manager_.longest_match_));
    if (params[0] == 1 && params.size() == 1) {
      indirect_r_models_.emplace_back(manager_.run_map_, context.GetContext(),
          manager_.bit_context_, delta, manager_.shared_map_);
    }
  }
}

void Predictor::AddMatch() {
  float delta = 0.5;
  int limit = 200;
  unsigned long long max_size = 2000000;
  std::vector<std::vector<int>> model_params = {
  {0, 8}, 
  {1, 8}, 
  {7, 4},
      {11, 3}, 
      {13, 2}, 
  };

  for (const auto& params : model_params) {
    const Context& context = manager_.AddContextHashContext(manager_.bit_context_,params[0], params[1]);
    match_models_.emplace_back(manager_.history_, context.GetContext(),
        manager_.bit_context_, limit, delta, std::min(max_size, context.Size()),
        &(manager_.longest_match_));
  }
}

void Predictor::AddDoubleIndirect() {
  float delta = 400;
  indirect_ns_models_.emplace_back(manager_.nonstationary_, manager_.ind1,  manager_.bit_context_, delta, manager_.shared_map_);
  indirect_ns_models_.emplace_back(manager_.nonstationary_, manager_.ind2,  manager_.bit_context_, delta, manager_.shared_map_);
  indirect_ns_models_.emplace_back(manager_.nonstationary_, manager_.ind3,  manager_.bit_context_, delta, manager_.shared_map_);
  indirect_ns_models_.emplace_back(manager_.nonstationary_, manager_.ind5,  manager_.bit_context_, delta, manager_.shared_map_);
}
unsigned int Discretize(float p) {
  return 1 + 4094 * p;
}
void Predictor::AddMixers() {
  unsigned int vocab_size = 0;
  for (unsigned int i = 0; i < vocab_.size(); ++i) {
    if (vocab_[i]) ++vocab_size;
  }
  // With the transformer the lstm is never run: the byte mixer only carries
  // the externally set distribution, so the lstm (and its memory) is not
  // allocated. Nothing after this point draws from rand(), so skipping the
  // lstm's initialization does not shift any other model's random state.
  byte_mixer_.emplace(1, manager_.bit_context_, vocab_,
#ifdef CMIX_OFFICIAL
      vocab_size, nullptr);
#else
      vocab_size, (transformer_ || neutral_transformer_) ? nullptr :
      new Lstm(vocab_size, vocab_size, 200, 1, 128, 0.03, 10));
#endif
  if (!dyn_W_.empty() && dyn_mode_ == 1) {
    dyn_mixer_.emplace(1, manager_.bit_context_, vocab_, vocab_size, nullptr);
    dyn_scratch_.assign(vocab_size, 1.0f);
  }

  for (int i = 0; i < 2; ++i) {
    layers_.emplace_back(sigmoid_,
        tune::Get("input_eps", 5.0e-5));
  }

  unsigned long long input_size = GetNumModels();
  std::cout << "num models " << input_size << "\n";
  layers_[0].SetNumModels(input_size);

  AddMixer(0, manager_.mx9, 0.005); 
  AddMixer(0, manager_.mx10, 0.0005); 
  AddMixer(0, manager_.mx11, 0.005); 
  AddMixer(0, manager_.mx12, 0.0005); 
  AddMixer(0, manager_.mx13, 0.005); 
  AddMixer(0, manager_.mxx, 0.001);
  AddMixer(0, manager_.recent_bytes_[2], 0.002);
  AddMixer(0, manager_.line_break_, 0.0007);
  AddMixer(0, manager_.longest_match_, 0.0005);
  AddMixer(0, manager_.mx19cxt, 0.002);
  AddMixer(0, manager_.auxiliary_context_, 0.0005);
  AddMixer(0, manager_.mx18, 0.001);
  AddMixer(0,manager_.mx7, 0.001);
  AddMixer(0, manager_.wordscxt, 0.005);
  AddMixer(0, manager_.b2streamcxt, 0.001);
  AddMixer(0, manager_.mx5, 0.001);
  AddMixer(0, manager_.mx6, 0.005);
  AddMixer(0, manager_.b3streamcxt, 0.001);
  AddMixer(0, manager_.mx8, 0.001);
  AddMixer(0, manager_.mx17, 0.005);
  AddMixer(0, manager_.mx16, 0.005);
  AddMixer(0, manager_.mx14, 0.005);
  AddMixer(0, manager_.mx15, 0.005);
  tf_mixer_buckets_ = (int)tune::Get("tf_mixer_buckets", 0);
  tf_mixer_mode_ = (int)tune::Get("tf_mixer_mode", 0);
  if (tf_mixer_buckets_ > 0 && tune::Get("tf_mixer_l0", 1)) {
    AddMixer(0, tf_ctx_, tune::Get("tf_mixer_lr", 0.002));
  }

  input_size = mixer_0_.size() + auxiliary_size_ + (dyn_mixer_ && dyn_l1_ ? 1 : 0);
  layers_[1].SetNumModels(input_size);

  // l1_ctx 1: the final mixer selects its weights by the transformer
  // confidence context (needs tf_mixer_buckets > 0)
  AddMixer(1, tune::Get("l1_ctx", 0) ? tf_ctx_ : manager_.zero_context_, 0.00015);

  layers_[0].SetExtraInputSize(mixer_0_.size());
  prefetch_mixers_ = tune::Get("prefetch_mixers", 1) != 0;
  tune::CheckAllUsed();

}
int lstmpr=0, lstmex=0;
float byte_mixer_output=0.0f;
float Predictor::Predict() {
  if (ppmd_only_ || transformer_only_) {
    float p = byte_model_->Predict()[0];
    // Keep the prediction away from 0 and 1 for the arithmetic coder.
    if (p < 0.001f) p = 0.001f;
    if (p > 0.999f) p = 0.999f;
    return p;
  }
  PROF_BEGIN();
  unsigned int input_index = 0;
  auto bracket_model_output = bracket_model_->Predict()[0];
  layers_[0].SetInput(input_index++, bracket_model_output);
  PROF_MARK(bracket_pred);

  const auto& fxcm_model_outputs = fxcm_model_->Predict();
  for (unsigned int j = 0; j < fxcm_model_outputs.size(); ++j) {
    layers_[0].SetInput(input_index, fxcm_model_outputs[j]);
    ++input_index;
  }
  auto fxcm_model_index = input_index - 1;
  PROF_MARK(fxcm_pred);
  

  for (unsigned int i = 0; i < direct_models_.size(); ++i) {
    const std::valarray<float>& outputs = direct_models_[i].Predict();
    for (unsigned int j = 0; j < outputs.size(); ++j) {
      layers_[0].SetInput(input_index, outputs[j]);
      ++input_index;
    }
  }

  PROF_MARK(direct_pred);
  for (unsigned int i = 0; i < match_models_.size(); ++i) {
    const std::valarray<float>& outputs = match_models_[i].Predict();
    for (unsigned int j = 0; j < outputs.size(); ++j) {
      layers_[0].SetInput(input_index, outputs[j]);
      ++input_index;
    }
  }
 
  PROF_MARK(match_pred);
  for (unsigned int i = 0; i < indirect_ns_models_.size(); ++i) {
    const std::valarray<float>& outputs = indirect_ns_models_[i].Predict();
    for (unsigned int j = 0; j < outputs.size(); ++j) {
      layers_[0].SetInput(input_index, outputs[j]);
      ++input_index;
    }
  }
 
  PROF_MARK(indirect_pred);
 for (unsigned int i = 0; i < indirect_r_models_.size(); ++i) {
    const std::valarray<float>& outputs = indirect_r_models_[i].Predict();
    for (unsigned int j = 0; j < outputs.size(); ++j) {
      layers_[0].SetInput(input_index, outputs[j]);
      ++input_index;
    }
  }
  PROF_MARK(indirect_r_pred);
  layers_[0].SetInput(input_index++,
      byte_model_ ? byte_model_->Predict()[0] : 0.5f);
  PROF_MARK(ppmd_pred);

  float byte_mixer_override = -1;

  if (byte_mixer_output == 0 || byte_mixer_output == 1) byte_mixer_override = byte_mixer_output;
  layers_[0].SetInput(input_index++, byte_mixer_output);
  auto byte_mixer_index = input_index - 1;
  if (dyn_mixer_) layers_[0].SetInput(input_index++, dyn_output_);

  float auxiliary_average = Sigmoid::Logistic(layers_[0].Inputs()[fxcm_model_index]) + Sigmoid::Logistic(layers_[0].Inputs()[byte_mixer_index]);
  auxiliary_average /= auxiliary_size_;
  manager_.auxiliary_context_ =auxiliary_average * 15;

  for (unsigned int i = 0; i < mixer_0_.size(); ++i) {
    float p = mixer_0_[i].Mix();
    layers_[0].SetExtraInput(i, p);
    layers_[1].SetStretchedInput(i, p);
  }
  PROF_MARK(mixer0_mix);
  layers_[1].SetStretchedInput(mixer_0_.size(), layers_[0].Inputs()[fxcm_model_index]);
  layers_[1].SetStretchedInput(mixer_0_.size() + 1, layers_[0].Inputs()[byte_mixer_index]);
  if (dyn_mixer_ && dyn_l1_)
    layers_[1].SetStretchedInput(mixer_0_.size() + 2, layers_[0].Inputs()[byte_mixer_index + 1]);

  float p = Sigmoid::Logistic(mixer_1_[0].Mix());
  PROF_MARK(mixer1_mix);
  p = sse_.Predict(p);
  PROF_MARK(sse_pred);
  if (byte_mixer_override >= 0) {
    return last_pred_ = byte_mixer_override;
  }
  return last_pred_ = p;
}

void Predictor::WritePpmdProbs() {
  const std::valarray<float>& p = byte_model_->BytePredict();
  for (unsigned int i = 0; i < vocab_size_; ++i) {
    probs_scratch_[i] = p[vocab_bytes_[i]];
  }
  ppmd_probs_writer_->Write(probs_scratch_.data(), vocab_size_);
}

void Predictor::LoadTransformerProbs() {
  transformer_probs_reader_->Read(probs_scratch_.data(), vocab_size_);
  for (unsigned int i = 0; i < vocab_size_; ++i) {
    // Guard against zero (and NaN) probabilities, which would degenerate the
    // bit-level predictions fed to the arithmetic coder. Only probability
    // ratios matter downstream, so no renormalization is needed.
    if (!(probs_scratch_[i] >= 1e-6f)) probs_scratch_[i] = 1e-6f;
  }
  byte_mixer_->SetProbs(probs_scratch_.data());
}

// Replaces the lstm's byte-level update: feeds the completed byte and the
// ppmd's distribution to the pretrained transformer and passes the
// transformer's output distribution (over the next byte) to the byte mixer.
//
// The distributions cross the model boundary exactly as they did in the
// offline pipeline the transformer was trained and evaluated on
// (--save-ppmd-probs -> float16 file -> training / --load-transformer-probs):
// the
// ppmd's prior is rounded to float16 the way WritePpmdProbs writes it, and
// the output row goes through the same float16 rounding and >= 1e-6 guard
// LoadTransformerProbs applies to a file row.
//
// Articles (delimited by kArticleSeparator, and cut at kMaxArticleTokens
// like the training data loader splits them) are independent transformer
// contexts: the KV caches and recurrent states are reset at each piece's
// first token, the piece's last token is never fed (its successor starts a
// fresh context), and at the tokens the transformer therefore cannot
// predict — the first token of each piece — the ppmd's (float16-rounded)
// distribution is passed downstream instead.
void Predictor::TransformerByteUpdate() {
  const std::valarray<float>& p = byte_model_->BytePredict();
  for (unsigned int i = 0; i < vocab_size_; ++i) {
    probs_scratch_[i] = p[vocab_bytes_[i]];
  }
  FloatsToHalves(probs_scratch_.data(), half_scratch_.data(), vocab_size_);

  int token = byte_to_index_[manager_.bit_context_];
  if (token < 0) {
    Fail("transformer: byte 0x%02x is not in the vocabulary",
        manager_.bit_context_);
  }
  if (dyn_valid_) DynLearn(token);
  memmove(separator_window_, separator_window_ + 1,
      sizeof(separator_window_) - 1);
  separator_window_[sizeof(separator_window_) - 1] = (unsigned char)token;
  ++article_tokens_;

  bool last_of_piece =
      memcmp(separator_window_, kArticleSeparator, sizeof(kArticleSeparator))
          == 0 ||
      article_tokens_ >= kMaxArticleTokens;
  if (last_of_piece) {
    // The next token starts a fresh context; its distribution is the ppmd's.
    HalvesToFloats(half_scratch_.data(), probs_scratch_.data(), vocab_size_);
    article_tokens_ = 0;
    dyn_valid_ = false;
  } else {
#ifdef CMIX_PIPE
    if (pipe_) {
      PipeFetch();
    } else
#endif
    {
      if (article_tokens_ == 1) transformer_->begin_article();
      transformer_->step((uint8_t)token, half_scratch_.data(),
          transformer_probs_.data());
      dyn_z_src_ = transformer_->last_logits();
      dyn_h_src_ = transformer_->last_hidden();
    }
#ifdef CMIX_PROFILE
    ++g_tf_steps;
#endif
    if (!dyn_W_.empty()) DynApply();  // mode 0: replaces transformer_probs_
    FloatsToHalves(transformer_probs_.data(), half_scratch_.data(),
        vocab_size_);
    HalvesToFloats(half_scratch_.data(), probs_scratch_.data(), vocab_size_);
  }
  if (transformer_probs_writer_) {
    transformer_probs_writer_->WriteHalves(half_scratch_.data(), vocab_size_);
  }
  for (unsigned int i = 0; i < vocab_size_; ++i) {
    if (!(probs_scratch_[i] >= 1e-6f)) probs_scratch_[i] = 1e-6f;
  }
  // With --transformer-only there is no byte mixer: probs_scratch_ is the
  // final destination of the distribution (and what the loss is measured on).
  if (byte_mixer_) byte_mixer_->SetProbs(probs_scratch_.data());
  if (dyn_mixer_) {
    // the adapted distribution, or (no transformer step) the same as above
    const float* src = dyn_valid_ ? dyn_q_.data() : probs_scratch_.data();
    for (unsigned int i = 0; i < vocab_size_; ++i)
      dyn_scratch_[i] = src[i] >= 1e-6f ? src[i] : 1e-6f;
    dyn_mixer_->SetProbs(dyn_scratch_.data());
  }
}

// Adds the learned correction to the transformer's last logits and replaces
// transformer_probs_ with the softmax of the result.
void Predictor::DynApply() {
  const float* __restrict z = dyn_z_src_;
  const float* __restrict hs = dyn_h_src_;
  float* __restrict h = dyn_h_.data();
  float* __restrict zz = dyn_z_.data();
  float* __restrict q = dyn_q_.data();
  float* __restrict W = dyn_W_.data();
  const float* __restrict b = dyn_b_.data();
  const float* __restrict hp = dyn_hp_.data();
  const float* __restrict sg = dyn_s_.data();
  const int n = (int)vocab_size_;
  const bool pending = dyn_pending_;
  const __m256 vk = _mm256_set1_ps(1.0f - dyn_decay_);
  for (int j = 0; j < kDynHidden; ++j) h[j] = hs[j];
  float mx = -1e30f;
  for (int i = 0; i < n; ++i) {
    float* __restrict w = W + (size_t)i * kDynHidden;
    if (pending) {
      // the SGD step DynLearn deferred (one pass over W instead of two)
      const __m256 vs = _mm256_set1_ps(sg[i]);
      for (int j = 0; j < kDynHidden; j += 8)
        _mm256_storeu_ps(w + j, _mm256_fmadd_ps(vs, _mm256_loadu_ps(hp + j),
                                                _mm256_mul_ps(vk, _mm256_loadu_ps(w + j))));
    }
    // fixed-order 4-accumulator dot product (192 = 6 x 32)
    __m256 a0 = _mm256_setzero_ps(), a1 = a0, a2 = a0, a3 = a0;
    for (int j = 0; j < kDynHidden; j += 32) {
      a0 = _mm256_fmadd_ps(_mm256_loadu_ps(w + j), _mm256_loadu_ps(h + j), a0);
      a1 = _mm256_fmadd_ps(_mm256_loadu_ps(w + j + 8), _mm256_loadu_ps(h + j + 8), a1);
      a2 = _mm256_fmadd_ps(_mm256_loadu_ps(w + j + 16), _mm256_loadu_ps(h + j + 16), a2);
      a3 = _mm256_fmadd_ps(_mm256_loadu_ps(w + j + 24), _mm256_loadu_ps(h + j + 24), a3);
    }
    __m256 a = _mm256_add_ps(_mm256_add_ps(a0, a1), _mm256_add_ps(a2, a3));
    __m128 r = _mm_add_ps(_mm256_castps256_ps128(a), _mm256_extractf128_ps(a, 1));
    r = _mm_add_ps(r, _mm_movehl_ps(r, r));
    r = _mm_add_ss(r, _mm_movehdup_ps(r));
    zz[i] = z[i] + b[i] + _mm_cvtss_f32(r);
  }
  if (!dyn2_W_.empty()) {
    dyn2_row_.clear();
    dyn2_f_.clear();
    for (int l = 0; l < 12; ++l) {
      if (!((dyn2_layers_ >> l) & 1)) continue;
      const uint16_t* idx;
      const uint8_t* qa;
      const int nnz = transformer_->mlp_acts(l, &idx, &qa);
      for (int k = 0; k < nnz; ++k) {
        const int u = idx[k];
        if (!qa[u]) continue;
        const float f = qa[u] * (1.0f / 16);
        const uint32_t row = (uint32_t)(l * 768 + u);
        dyn2_row_.push_back(row);
        dyn2_f_.push_back(f);
        const float* __restrict w2 = &dyn2_W_[(size_t)row * kDynPad];
        const __m256 vf = _mm256_set1_ps(f);
        for (int i = 0; i < kDynPad; i += 8)
          _mm256_storeu_ps(zz + i, _mm256_fmadd_ps(vf, _mm256_loadu_ps(w2 + i),
                                                   _mm256_loadu_ps(zz + i)));
      }
    }
  }
  for (int i = 0; i < n; ++i)
    if (zz[i] > mx) mx = zz[i];
  // own polynomial exp (not the CRT's, whose code path may depend on the
  // CPU), so that compressor and decompressor agree on any machine
  const __m256 vmx = _mm256_set1_ps(mx);
  for (int i = n; i < kDynPad; ++i) zz[i] = mx;
  __m256 vsum = _mm256_setzero_ps();
  for (int i = 0; i < kDynPad; i += 8) {
    __m256 e = fx2::exp256_ps(_mm256_sub_ps(_mm256_loadu_ps(zz + i), vmx));
    _mm256_storeu_ps(q + i, e);
  }
  for (int i = n; i < kDynPad; ++i) q[i] = 0;
  for (int i = 0; i < kDynPad; i += 8) vsum = _mm256_add_ps(vsum, _mm256_loadu_ps(q + i));
  __m128 r = _mm_add_ps(_mm256_castps256_ps128(vsum), _mm256_extractf128_ps(vsum, 1));
  r = _mm_add_ps(r, _mm_movehl_ps(r, r));
  r = _mm_add_ss(r, _mm_movehdup_ps(r));
  const float inv = 1.0f / _mm_cvtss_f32(r);
  for (int i = 0; i < n; ++i) q[i] *= inv;
  if (dyn_mode_ == 0) {
    for (int i = 0; i < n; ++i) transformer_probs_[i] = q[i];
  }
  dyn_pending_ = false;
  dyn_valid_ = true;
}

// One SGD step on -ln q(token) for the prediction DynApply made last. The
// bias is updated here; the update of W is deferred to the next DynApply,
// which applies it in the same pass as its dot products (bit-identical: the
// same operations on the same values, W is not read in between).
void Predictor::DynLearn(int token) {
  float* __restrict b = dyn_b_.data();
  const float* __restrict q = dyn_q_.data();
  const int n = (int)vocab_size_;
  const float keep = 1.0f - dyn_decay_;
  for (int i = 0; i < n; ++i) {
    const float g = q[i] - (i == token ? 1.0f : 0.0f);
    b[i] = b[i] * keep - dyn_blr_ * g;
    dyn_s_[i] = -(dyn_lr_ * g);
    dyn_g_[i] = g;
  }
  for (size_t k = 0; k < dyn2_row_.size(); ++k) {
    float* __restrict w2 = &dyn2_W_[(size_t)dyn2_row_[k] * kDynPad];
    const float* __restrict g = dyn_g_.data();
    const __m256 vs = _mm256_set1_ps(-(dyn2_lr_ * dyn2_f_[k]));
    for (int i = 0; i < kDynPad; i += 8)
      _mm256_storeu_ps(w2 + i, _mm256_fmadd_ps(vs, _mm256_loadu_ps(g + i),
                                               _mm256_loadu_ps(w2 + i)));
  }
  dyn_hp_.swap(dyn_h_);
  dyn_pending_ = true;
  dyn_valid_ = false;
}

// Accumulates -ln p(byte) for the byte that just completed, where p is the
// distribution (normalized over the vocabulary) the byte mixer used to
// predict it: the transformer's output, or the loaded one with
// --load-transformer-probs.
// Must run before that distribution is replaced with the next byte's.
// Prints the running average every million tokens and at the last token.
void Predictor::AccumulateTransformerLoss() {
  double sum = 0, prob = 0;
  if (byte_mixer_) {
    const std::valarray<float>& p = byte_mixer_->BytePredict();
    for (int byte : vocab_bytes_) sum += p[byte];
    prob = p[manager_.bit_context_];
  } else {
    // --transformer-only: the distribution was left in probs_scratch_.
    for (unsigned int i = 0; i < vocab_size_; ++i) sum += probs_scratch_[i];
    int index = byte_to_index_[manager_.bit_context_];
    if (index >= 0) prob = probs_scratch_[index];
  }
  double ratio = sum > 0 ? prob / sum : 0;
  if (!(ratio > 1e-38)) ratio = 1e-38;  // avoid inf from zero probabilities
  transformer_loss_sum_ -= std::log(ratio);
  ++transformer_tokens_;
  if (transformer_tokens_ % 1000000 == 0 ||
      transformer_tokens_ == num_input_bytes_) {
    fprintf(stderr, "\r%*s\r", 70, "");  // clear the progress line
    printf("transformer loss: %.6f nats/token over %llu tokens\n",
        transformer_loss_sum_ / transformer_tokens_, transformer_tokens_);
    fflush(stdout);
  }
}

void Predictor::Perceive(int bit) {
  if (ppmd_only_ || transformer_only_) {
    byte_model_->Perceive(bit);
    // Mirrors how ContextManager::UpdateContexts maintains bit_context_,
    // which the ppmd reads the completed byte from.
    bool byte_update = manager_.bit_context_ >= 128;
    manager_.bit_context_ += manager_.bit_context_ + bit;
    if (byte_update) {
      manager_.bit_context_ -= 256;
      // Before WritePpmdProbs and TransformerByteUpdate overwrite the
      // distribution the completed byte was predicted with.
      if (print_transformer_loss_) AccumulateTransformerLoss();
      byte_model_->ByteUpdate();
      if (ppmd_probs_writer_) WritePpmdProbs();
      if (transformer_) TransformerByteUpdate();
      manager_.bit_context_ = 1;
    }
    return;
  }
  if (cmix_bits_writer_) {
    float q = last_pred_;
    if (q < 1e-6f) q = 1e-6f;
    if (q > 1 - 1e-6f) q = 1 - 1e-6f;
    const float logit = std::log(q / (1 - q));
    cmix_bits_writer_->Write(&logit, 1);
  }
  PROF_BEGIN();
  bracket_model_->Perceive(bit);
  PROF_MARK(bracket_perc);

  for (unsigned int i = 0; i < direct_models_.size(); ++i) {
    direct_models_[i].Perceive(bit);
  }
  PROF_MARK(direct_perc);
  for (unsigned int i = 0; i < match_models_.size(); ++i) {
    match_models_[i].Perceive(bit);
  }
  PROF_MARK(match_perc);
  for (unsigned int i = 0; i < indirect_ns_models_.size(); ++i) {
    indirect_ns_models_[i].Perceive(bit);
  }
  PROF_MARK(indirect_perc);
  for (unsigned int i = 0; i < indirect_r_models_.size(); ++i) {
    indirect_r_models_[i].Perceive(bit);
  }
  PROF_MARK(indirect_r_perc);

  if (byte_model_) byte_model_->Perceive(bit);
  PROF_MARK(ppmd_perc);

  byte_mixer_->Perceive(bit);
  if (dyn_mixer_) dyn_mixer_->Perceive(bit);
  PROF_MARK(bytemixer_perc);

  for (auto& mixer: mixer_0_) {
    mixer.Perceive(bit);
  }
  PROF_MARK(mixer0_perc);
  for (auto& mixer: mixer_1_) {
    mixer.Perceive(bit);
  }
  PROF_MARK(mixer1_perc);

  sse_.Perceive(bit);
  PROF_MARK(sse_perc);

  bool byte_update = false;
  if (manager_.bit_context_ >= 128) byte_update = true;

  manager_.UpdateContexts(bit);
  PROF_MARK(ctx_update);
  if (byte_update) {
    if (print_transformer_loss_) AccumulateTransformerLoss();
    bracket_model_->ByteUpdate();

    for (unsigned int i = 0; i < direct_models_.size(); ++i) {
      direct_models_[i].ByteUpdate();
    }
    for (unsigned int i = 0; i < match_models_.size(); ++i) {
      match_models_[i].ByteUpdate();
    }
    for (unsigned int i = 0; i < indirect_ns_models_.size(); ++i) {
      indirect_ns_models_[i].ByteUpdate();
    }

    for (unsigned int i = 0; i < indirect_r_models_.size(); ++i) {
      indirect_r_models_[i].ByteUpdate();
    }

    PROF_MARK(models_byteupd);
    if (byte_model_) {
#ifdef CMIX_PIPE
      if (pipe_) PipeAdvance();
      else
#endif
      byte_model_->ByteUpdate();
      if (ppmd_probs_writer_) WritePpmdProbs();
      PROF_MARK(ppmd_byteupd);

      if (transformer_) {
        TransformerByteUpdate();
#ifdef CMIX_PIPE
        if (pipe_) ++pipe_->pos;
#endif
      } else if (neutral_transformer_) {
        byte_mixer_->SetProbs(uniform_probs_.data());
      } else {
        const std::valarray<float>& p = byte_model_->BytePredict();
        for (unsigned int j = 0; j < 256; ++j) {
          byte_mixer_->SetInput(j,p[j]);
        }

        byte_mixer_->ByteUpdate();
      }
    } else {
      // --load-transformer-probs: the ppmd and the transformer are not run;
      // the byte-level distribution comes from the file instead.
      LoadTransformerProbs();
    }
    PROF_MARK(transformer);
  }
  byte_mixer_output = byte_mixer_->Predict()[0];
  if (dyn_mixer_) dyn_output_ = dyn_mixer_->Predict()[0];
  lstmpr=Discretize(dyn_fx_ && dyn_mixer_ ? dyn_output_ : byte_mixer_output);
  lstmex=dyn_fx_ && dyn_mixer_ ? dyn_mixer_->ex : byte_mixer_->ex;
  PROF_MARK(bytemixer_pred);
  fxcm_model_->Perceive(bit);
  PROF_MARK(fxcm_update);
  if (prefetch_mixers_) {
    for (auto& mixer : mixer_0_) mixer.Prefetch();
  }
  if (tf_mixer_buckets_ > 0) {
    int b = (int)(byte_mixer_output * tf_mixer_buckets_);
    if (b >= tf_mixer_buckets_) b = tf_mixer_buckets_ - 1;
    if (b < 0) b = 0;
    unsigned long long ctx = b;
    // mode 1: also the bit position; mode 2: also the partial byte
    unsigned int partial = byte_update ? 1 : manager_.bit_context_;
    if (tf_mixer_mode_ == 1) {
      int pos = 0;
      while ((1u << (pos + 1)) <= partial) ++pos;
      ctx = ctx * 8 + pos;
    } else if (tf_mixer_mode_ == 2) {
      ctx = ctx * 256 + partial;
    }
    tf_ctx_ = ctx;
  }
  if (byte_update)manager_.bit_context_ = 1;
}

void Predictor::Pretrain(int bit) {
  bracket_model_->Predict();
  fxcm_model_->Predict();
    
  for (unsigned int i = 0; i < direct_models_.size(); ++i) {
    direct_models_[i].Predict();
  }
  for (unsigned int i = 0; i < match_models_.size(); ++i) {
    match_models_[i].Predict();
  }
  for (unsigned int i = 0; i < indirect_ns_models_.size(); ++i) {
    indirect_ns_models_[i].Predict();
  }
  for (unsigned int i = 0; i < indirect_r_models_.size(); ++i) {
    indirect_r_models_[i].Predict();
  }


  bracket_model_->Perceive(bit);
  fxcm_model_->Perceive(bit);
    
  for (unsigned int i = 0; i < direct_models_.size(); ++i) {
    direct_models_[i].Perceive(bit);
  }
  for (unsigned int i = 0; i < match_models_.size(); ++i) {
    match_models_[i].Perceive(bit);
  }
  for (unsigned int i = 0; i < indirect_ns_models_.size(); ++i) {
    indirect_ns_models_[i].Perceive(bit);
  }
  for (unsigned int i = 0; i < indirect_r_models_.size(); ++i) {
    indirect_r_models_[i].Perceive(bit);
  }


  bool byte_update = false;
  if (manager_.bit_context_ >= 128) byte_update = true;
  manager_.UpdateContexts(bit);
  if (byte_update) {
    bracket_model_->ByteUpdate();

    for (unsigned int i = 0; i < direct_models_.size(); ++i) {
      direct_models_[i].ByteUpdate();
    }
    for (unsigned int i = 0; i < match_models_.size(); ++i) {
      match_models_[i].ByteUpdate();
    }
    for (unsigned int i = 0; i < indirect_ns_models_.size(); ++i) {
      indirect_ns_models_[i].ByteUpdate();
    }
    for (unsigned int i = 0; i < indirect_r_models_.size(); ++i) {
      indirect_r_models_[i].ByteUpdate();
    }
    manager_.bit_context_ = 1;
  }
}

