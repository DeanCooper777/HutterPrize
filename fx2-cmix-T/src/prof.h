// Section timing for performance work. Compiled in only with -DCMIX_PROFILE;
// otherwise every macro expands to nothing. Times are rdtsc ticks, reported
// as percentages of the instrumented total at process exit.
//
// Place in the pipeline: none; Predictor::Predict / Perceive (predictor.cpp) carry
// PROF_BEGIN / PROF_MARK marks between their stages.
//
// Testing: build with -DCMIX_PROFILE (Windows: build.ps1 -Defines CMIX_PROFILE) and run
// any compression; the table is printed to stderr when the process exits.
//
// New in this entry. It was used for the speed work; the submitted binary is built
// without it.
#ifndef CMIX_PROF_H
#define CMIX_PROF_H

#ifdef CMIX_PROFILE
#include <cstdio>
#include <cstdlib>
#ifdef _MSC_VER
#include <intrin.h>
#else
#include <x86intrin.h>
#endif

namespace prof {
// The timed sections, in the order they occur in Predict() and then Perceive().
#define PROF_SECTIONS(X) \
  X(bracket_pred) X(fxcm_pred) X(direct_pred) X(match_pred) X(indirect_pred) \
  X(indirect_r_pred) X(ppmd_pred) X(mixer0_mix) X(mixer1_mix) X(sse_pred) \
  X(bracket_perc) X(direct_perc) X(match_perc) X(indirect_perc) \
  X(indirect_r_perc) X(ppmd_perc) X(bytemixer_perc) X(mixer0_perc) \
  X(mixer1_perc) X(sse_perc) X(ctx_update) X(models_byteupd) \
  X(ppmd_byteupd) X(transformer) X(bytemixer_pred) X(fxcm_update)
enum Sec {
#define PROF_ENUM(n) n,
  PROF_SECTIONS(PROF_ENUM)
#undef PROF_ENUM
  kNumSec
};
inline unsigned long long t[kNumSec];
inline const char* names[kNumSec] = {
#define PROF_NAME(n) #n,
  PROF_SECTIONS(PROF_NAME)
#undef PROF_NAME
};
inline void Report() {
  unsigned long long total = 0;
  for (int i = 0; i < kNumSec; ++i) total += t[i];
  if (!total) return;
  fprintf(stderr, "\n== profile (%% of instrumented ticks, total %.3e)\n", (double)total);
  for (int i = 0; i < kNumSec; ++i)
    fprintf(stderr, "  %-16s %6.2f%%\n", names[i], 100.0 * t[i] / total);
}
struct Registrar { Registrar() { atexit(Report); } };
inline Registrar registrar;
}  // namespace prof

// PROF_BEGIN() starts the clock in a function; PROF_MARK(s) charges the ticks since the
// previous mark to section s.
#define PROF_BEGIN() unsigned long long _prof_t0 = __rdtsc(), _prof_t1
#define PROF_MARK(s) (_prof_t1 = __rdtsc(), prof::t[prof::s] += _prof_t1 - _prof_t0, _prof_t0 = _prof_t1)
#else
#define PROF_BEGIN() ((void)0)
#define PROF_MARK(s) ((void)0)
#endif

#endif
