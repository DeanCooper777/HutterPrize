// Windows portability shims. Force-included (clang -include) by the Windows
// build script (../build.ps1); not used by the Linux makefile.
//
// Place in the pipeline: none; it only supplies POSIX names the sources use (fseeko,
// ftello, S_ISDIR, fmemopen) when compiling with clang on Windows.
//
// New in this entry. The Windows build is a development convenience: the submission is
// the Linux build, and archives are not portable between the two builds.
#ifndef FX2_WIN_COMPAT_H
#define FX2_WIN_COMPAT_H
#ifdef _WIN32

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>

// 64-bit file offsets
#define fseeko _fseeki64
#define ftello _ftelli64

#ifndef S_ISDIR
#define S_ISDIR(m) (((m) & _S_IFMT) == _S_IFDIR)
#endif
#ifndef S_ISREG
#define S_ISREG(m) (((m) & _S_IFMT) == _S_IFREG)
#endif

// Read-only fmemopen replacement: copies the buffer into an anonymous
// temporary file. Only used for small, read-only buffers in this code base.
static inline FILE* fmemopen(void* buf, size_t size, const char* /*mode*/) {
  FILE* f = tmpfile();
  if (f == NULL) return NULL;
  if (size && fwrite(buf, 1, size, f) != size) {
    fclose(f);
    return NULL;
  }
  rewind(f);
  return f;
}

#endif  // _WIN32
#endif  // FX2_WIN_COMPAT_H
