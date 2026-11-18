// bench: minimal throughput benchmark over the test set (no comparisons)
//
// What it measures: tokens per second and ns per token of the NAIVE reference
// transformer (fx2::Transformer in model.cpp / kernels.cpp), streaming the
// test articles exactly as test_e2e does but without any checking. It is the
// speed baseline that the optimized model (opt/model_opt.cpp, timed by
// opt/bench_opt.cpp) is compared with.
//
// Where it sits: development tool only. cmix links the optimized model in
// opt/, never this reference model, so nothing here reaches the submitted
// binary (preprocess -> dictionary -> context models / PPMD / transformer byte
// model -> mixers -> SSE -> arithmetic coder).
//
// Testing: build with `make bench` in cpp_infer/ (-> bin/bench), run as
//   bin/bench [--data DIR] [--articles N] [--repeats R]
// DIR must hold weights.bin and the test-set files read by testdata.h (the
// default search is cpp_infer/data, data, ../data, ../cpp_infer/data).
// There is no pass/fail: it prints one timing line per repeat.
//
// Unchanged from the previous winning entry.
#include <cstdio>
#include <cstring>
#include <ctime>
#include <string>
#include <vector>

#include "model.h"
#include "testdata.h"

namespace {

double now_s() {
  timespec ts;
  clock_gettime(CLOCK_MONOTONIC, &ts);
  return double(ts.tv_sec) + 1e-9 * double(ts.tv_nsec);
}

}  // namespace

int main(int argc, char** argv) {
  const char* data_dir = nullptr;
  int n_articles = -1;
  int repeats = 1;
  for (int i = 1; i < argc; i++) {
    if (std::strcmp(argv[i], "--data") == 0 && i + 1 < argc)
      data_dir = argv[++i];
    else if (std::strcmp(argv[i], "--articles") == 0 && i + 1 < argc)
      n_articles = std::atoi(argv[++i]);
    else if (std::strcmp(argv[i], "--repeats") == 0 && i + 1 < argc)
      repeats = std::atoi(argv[++i]);
    else {
      std::fprintf(stderr, "usage: %s [--data DIR] [--articles N] [--repeats R]\n",
                   argv[0]);
      return 2;
    }
  }

  std::string dir = fx2::find_data_dir(data_dir);
  fx2::TestData td;
  td.load(dir, /*with_ref_probs=*/false);
  if (n_articles < 0 || n_articles > td.n_articles)
    n_articles = td.n_articles;

  fx2::Transformer model((dir + "/weights.bin").c_str());
  std::vector<float> probs(205);
  // sink keeps the compiler from discarding the model's output
  volatile float sink = 0.0f;

  // One pass = every article from a fresh state; the last token of an article
  // has no successor to predict, hence len - 1 steps.
  for (int r = 0; r < repeats; r++) {
    long count = 0;
    double t0 = now_s();
    for (int a = 0; a < n_articles; a++) {
      long g0 = td.bounds[a];
      long len = td.bounds[a + 1] - g0;
      if (len < 2) continue;
      model.begin_article(td.rope_offsets[a]);
      for (long t = 0; t < len - 1; t++) {
        model.step(td.tokens[g0 + t], td.prior_row(g0 + t), probs.data());
        count++;
      }
      sink += probs[0];
    }
    double dt = now_s() - t0;
    std::printf("run %d: %d articles, %ld tokens, %.2f s, %.0f tokens/s, "
                "%.0f ns/token\n",
                r + 1, n_articles, count, dt, count / dt, 1e9 * dt / count);
  }
  (void)sink;
  return 0;
}
