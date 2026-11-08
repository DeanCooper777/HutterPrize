// Runtime-tunable parameters for experiments.
//
// Every parameter has its built-in (upstream) default. If the environment
// variable CMIX_TUNE names a file, each line "name value" in it overrides the
// parameter of that name ('#' starts a comment). CheckAllUsed() aborts if a
// name in the file was never requested (typo protection). Compression and
// decompression must see the same file.
#ifndef CMIX_TUNE_H
#define CMIX_TUNE_H

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <map>
#include <string>

namespace tune {

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

// Returns the override for `name`, or `def`. Marks the name as used.
inline std::map<std::string, int>& Used() {
  static std::map<std::string, int> u;
  return u;
}

inline double Get(const char* name, double def) {
  auto& m = Overrides();
  Used()[name] = 1;
  auto it = m.find(name);
  if (it == m.end()) return def;
  fprintf(stderr, "CMIX_TUNE: %s = %g (default %g)\n", name, it->second, def);
  return it->second;
}

inline double Get(const std::string& name, double def) { return Get(name.c_str(), def); }

inline void CheckAllUsed() {
  for (auto& kv : Overrides()) {
    if (!Used().count(kv.first)) {
      fprintf(stderr, "CMIX_TUNE: unknown parameter %s\n", kv.first.c_str());
      exit(1);
    }
  }
}

}  // namespace tune

#endif
