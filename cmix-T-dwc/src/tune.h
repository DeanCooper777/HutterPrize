// Runtime-tunable parameters for experiments.
//
// Every parameter has a built-in default, which is the value this entry ships (not
// always upstream's value). If the environment
// variable CMIX_TUNE names a file, each line "name value" in it overrides the
// parameter of that name ('#' starts a comment). CheckAllUsed() aborts if a
// name in the file was never requested (typo protection). Compression and
// decompression must see the same file.
//
// Place in the pipeline: a side channel. Model code (predictor.cpp, mixer, sse, ppmd,
// fxcm) asks tune::Get("name", default) for its constants while it is being constructed.
//
// Testing: this is the experiment mechanism. An experiment points CMIX_TUNE at a file of
// overrides and runs the compressor on a test file; a winning value is then made the
// default in the source. The submitted run uses no file.
//
// New in this entry. In the official build (-DCMIX_OFFICIAL) Get() returns the default
// and nothing else is compiled, so the file reader, the map and the getenv call add no
// bytes to the submission binary and the environment cannot change the model.
#ifndef CMIX_TUNE_H
#define CMIX_TUNE_H

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <map>
#include <string>

#ifdef CMIX_OFFICIAL
// Official build: every parameter is its built-in default, a compile-time constant.
namespace tune {
inline double Get(const char*, double def) { return def; }
inline double Get(const std::string&, double def) { return def; }
inline void CheckAllUsed() {}
}  // namespace tune
#else

namespace tune {

// The overrides read from the CMIX_TUNE file, loaded on first use.
inline std::map<std::string, double>& Overrides() {
  static std::map<std::string, double>* m = [] {
    auto* m = new std::map<std::string, double>();
    const char* path = getenv("CMIX_TUNE");
    if (!path || !*path) return m;
    FILE* f = fopen(path, "r");
    if (!f) { fprintf(stderr, "CMIX_TUNE: cannot open %s\n", path); exit(1); }
    char line[512];
    while (fgets(line, sizeof line, f)) {
      char* hash = strchr(line, '#');
      if (hash) *hash = 0;
      char name[256];
      double v;
      if (sscanf(line, "%255s %lf", name, &v) == 2) (*m)[name] = v;
    }
    fclose(f);
    fprintf(stderr, "CMIX_TUNE: %zu overrides from %s\n", m->size(), path);
    return m;
  }();
  return *m;
}

// The names requested so far (for CheckAllUsed).
inline std::map<std::string, int>& Used() {
  static std::map<std::string, int> u;
  return u;
}

// Returns the override for `name`, or `def`. Marks the name as used and logs overrides.
inline double Get(const char* name, double def) {
  auto& m = Overrides();
  Used()[name] = 1;
  auto it = m.find(name);
  if (it == m.end()) return def;
  fprintf(stderr, "CMIX_TUNE: %s = %g (default %g)\n", name, it->second, def);
  return it->second;
}

inline double Get(const std::string& name, double def) { return Get(name.c_str(), def); }

// Called once the model is built: a name in the file that nobody asked for is an error.
inline void CheckAllUsed() {
  for (auto& kv : Overrides()) {
    if (!Used().count(kv.first)) {
      fprintf(stderr, "CMIX_TUNE: unknown parameter %s\n", kv.first.c_str());
      exit(1);
    }
  }
}

}  // namespace tune
#endif  // CMIX_OFFICIAL

#endif
