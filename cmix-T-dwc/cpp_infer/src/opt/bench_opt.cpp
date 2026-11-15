// bench_opt: throughput benchmark of TransformerOpt over the test set.
// Clean build = zero instrumentation inside the model; bench_opt_prof
// (-DFX2_PROF, same source) additionally prints the per-part rdtsc profile.
//
// Pinning: --cpu N (default 42; the measured idle CCX is {40-43,104-107},
// see MACHINE.md). Core cycles are computed from the measured tsc->core
// ratio (bench_common.h calibration, AVX2-warm).
//
// What it measures: tokens per second and core cycles per token of
// fx2::opt::TransformerOpt (model_opt.cpp), the transformer byte model that
// cmix runs once per coded byte. Compare with ../bench.cpp (naive model).
// No reference and no pass/fail: after a warm-up pass it prints one line per
// repeat and a "MEDIAN:" line. The -DFX2_PROF build also prints the time
// spent in each part of the model (the accumulators live in model_opt.cpp).
//
// Testing: build with `make bench_opt bench_opt_prof` in cpp_infer/
// (-> bin/bench_opt, bin/bench_opt_prof), run as
//   bin/bench_opt [--data DIR] [--articles N] [--repeats R] [--cpu C|-1]
//                 [--attn f32|int8] [--kda-pf M]
// Linux only (sched_setaffinity). --cpu -1 disables pinning; the default CPU
// number belongs to the previous authors' build machine. It protects nothing
// by itself; it is how speed changes to model_opt.cpp and the kernels were
// judged.
//
// Changes from the previous winning entry (fx2-cmix-transformer-v1):
// this file is unchanged. [this entry] The model it times now takes the
// 16-bit activation path by default (CMIX_ACT16 = 15; set CMIX_ACT16=0 for
// the original 8-bit path), and the link needs act16.cpp, which
// cpp_infer/Makefile (unchanged) does not yet list among the opt objects.
#include <sched.h>

#include <cstdio>
#include <cstring>
#include <string>
#include <vector>

#include "../../bench/bench_common.h"
#include "../testdata.h"
#include "kda.h"
#include "model_opt.h"

int main(int argc, char** argv) {
  const char* data_dir = nullptr;
  int n_articles = -1;
  int repeats = 3;
  int cpu = 42;
  fx2::opt::AttnKind kind = fx2::opt::AttnKind::KVF32;
  for (int i = 1; i < argc; i++) {
    if (std::strcmp(argv[i], "--data") == 0 && i + 1 < argc)
      data_dir = argv[++i];
    else if (std::strcmp(argv[i], "--articles") == 0 && i + 1 < argc)
      n_articles = std::atoi(argv[++i]);
    else if (std::strcmp(argv[i], "--repeats") == 0 && i + 1 < argc)
      repeats = std::atoi(argv[++i]);
    else if (std::strcmp(argv[i], "--cpu") == 0 && i + 1 < argc)
      cpu = std::atoi(argv[++i]);
    else if (std::strcmp(argv[i], "--attn") == 0 && i + 1 < argc) {
      ++i;
      kind = std::strcmp(argv[i], "int8") == 0 ? fx2::opt::AttnKind::KVI8
                                               : fx2::opt::AttnKind::KVF32;
    } else if (std::strcmp(argv[i], "--kda-pf") == 0 && i + 1 < argc) {
      fx2::opt::kda_set_pf_mode(std::atoi(argv[++i]));  // perf experiment knob
    } else {
      std::fprintf(stderr,
                   "usage: %s [--data DIR] [--articles N] [--repeats R] "
                   "[--cpu C|-1] [--attn f32|int8] [--kda-pf M]\n",
                   argv[0]);
      return 2;
    }
  }

  if (cpu >= 0) {
    cpu_set_t s;
    CPU_ZERO(&s);
    CPU_SET(cpu, &s);
    if (sched_setaffinity(0, sizeof(s), &s) != 0) perror("sched_setaffinity");
  }
  Calib cal = calibrate();  // AVX2 warm-up + tsc/core measurement
  std::printf("pinned cpu %d (now on %d); tsc %.4f GHz, core %.4f GHz, "
              "ratio %.4f\n",
              cpu, sched_getcpu(), cal.tsc_hz / 1e9, cal.core_hz / 1e9,
              cal.ratio());
  std::printf("build: %s\n", fx2::opt::prof_enabled()
                                 ? "INSTRUMENTED (-DFX2_PROF)"
                                 : "clean (no instrumentation)");

  std::string dir = fx2::find_data_dir(data_dir);
  fx2::TestData td;
  td.load(dir, /*with_ref_probs=*/false);
  if (n_articles < 0 || n_articles > td.n_articles)
    n_articles = td.n_articles;

  fx2::opt::TransformerOpt model((dir + "/weights.bin").c_str(), kind);
  std::printf("attention KV variant: %s\n",
              kind == fx2::opt::AttnKind::KVF32 ? "f32-V (2.81 MB KV)"
                                                : "int8-V (1.125 MB KV)");

  std::vector<float> probs(205);
  volatile float sink = 0.0f;

  auto run_pass = [&](int arts) -> long {
    long count = 0;
    for (int a = 0; a < arts; a++) {
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
    return count;
  };

  // warm-up: touch weights/KV/priors once (subset)
  run_pass(n_articles < 48 ? n_articles : 48);

  std::vector<double> tps(repeats), cpt(repeats);
  long count = 0;
  for (int r = 0; r < repeats; r++) {
    fx2::opt::prof_reset();
    uint64_t n0 = now_ns();
    uint64_t r0 = rdtsc_ser();
    count = run_pass(n_articles);
    uint64_t r1 = rdtsc_ser();
    uint64_t n1 = now_ns();
    double dt = double(n1 - n0) * 1e-9;
    tps[r] = count / dt;
    cpt[r] = ticks_to_cycles(double(r1 - r0)) / double(count);
    std::printf("run %d: %d articles, %ld tokens, %.2f s, %.0f tokens/s, "
                "%.0f cyc/token\n",
                r + 1, n_articles, count, dt, tps[r], cpt[r]);
    std::fflush(stdout);
  }
  std::vector<double> ts = tps, cs = cpt;
  std::sort(ts.begin(), ts.end());
  std::sort(cs.begin(), cs.end());
  std::printf("MEDIAN: %.0f tokens/s, %.0f cycles/token (core %.4f GHz)\n",
              ts[ts.size() / 2], cs[cs.size() / 2], cal.core_hz / 1e9);

  if (fx2::opt::prof_enabled())
    fx2::opt::prof_print(cal.ratio(), count);  // last run's accumulators

  (void)sink;
  return 0;
}
