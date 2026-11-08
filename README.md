# Hutter Prize – fx2-cmix-T on Windows

Local build and test bench for the current Hutter Prize record holder
(<http://prize.hutter1.net/>):

| | |
|---|---|
| Program | **fx2-cmix-T** (fx2-cmix with the LSTM replaced by a 6M-parameter quantized transformer) |
| Author | Vladimir Ivanov, 24 Jul 2026 – 11th prize winner |
| Record | 100,424,672 bytes total (compressor + archive), ratio 9.96, ~10 GB RAM, ~50 h |
| Source | <https://github.com/astOwOlfo/fx2-cmix-transformer-v1> (cloned into `fx2-cmix-T/`, commit `83f2603`) |

## Layout

```
enwik9                  contest file (1,000,000,000 bytes, md5 e206c3450ac99950df65bf70ef61a12d)
data/enwik4..enwik8     first 10^N bytes of enwik9 (scripts/split_enwik9.py)
fx2-cmix-T/             upstream source, branch `windows-port` holds the port (git diff master)
tools/llvm/             portable LLVM/clang 22.1.8 (not checked in; see below)
build.ps1               build: PGO -> build\cmix_orig.exe -> build\run\cmix.exe
test.ps1                round-trip test + results.csv
runs/                   per-run working directories
reference/archive9      official archive (release asset), used to read the official vocabulary
```

## Prerequisites

* Visual Studio 2022+ with the C++ workload (clang uses its headers, libs and Windows SDK).
  MSVC 14.51's STL requires clang >= 20.
* Portable LLVM in `tools\llvm` (no admin needed):
  ```
  curl -L -o llvm.tar.xz https://github.com/llvm/llvm-project/releases/download/llvmorg-22.1.8/clang+llvm-22.1.8-x86_64-pc-windows-msvc.tar.xz
  tar -xf llvm.tar.xz && move clang+llvm-22.1.8-x86_64-pc-windows-msvc tools\llvm
  ```
* Python 3 (only for the split script). 16 GB RAM is enough: PPMD's 14 GB heap is a disk-backed
  file mapping (see the Windows port section); ~15 GB of free disk per running process.
* **Clone with `core.autocrlf=false`.** Otherwise git rewrites `dictionary/english.dic` and
  `new_article_order` with CRLF, and the self-extractor's dictionary hash check fails.

## Build

```powershell
.\build.ps1                 # PGO build + self-extracting compressor (~5 min)
.\build.ps1 -NoPgo          # quicker build, slower binary
.\build.ps1 -SkipConstruct  # only build\cmix_orig.exe
```

Outputs:
* `build\cmix_orig.exe`: general cmix CLI (`-c/-d/-n/-s`, `--transformer`, ...).
* `build\run\cmix.exe`: the enwik9-specialized self-extracting compressor (`cmix.exe -e enwik9 out`
  writes `archive9.exe`, which decompresses to `enwik9_uncompressed` with no arguments).

## Testing on smaller files

```powershell
python scripts\split_enwik9.py   # data\enwik4..enwik8 (already done)
.\test.ps1                       # enwik5 + enwik6, transformer + dictionary
.\test.ps1 -Sizes 7              # enwik7
.\test.ps1 -Sizes 6 -NoTransformer   # LSTM instead of the transformer
.\test.ps1 -Enwik9               # real contest pipeline on the full file (days)
```

Each run compresses, decompresses, verifies byte-for-byte and appends a row to `results.csv`.

Measured on this machine (Core Ultra 9 288V, PGO build, transformer + dictionary):

| file | size | compressed | bits/char | compress | decompress | peak RAM | verified |
|---|---:|---:|---:|---:|---:|---:|:---:|
| enwik5 | 100,000 | 14,747 | 1.180 | 33 s | 33 s | 5.4 GB | yes |
| enwik6 | 1,000,000 | 131,850 | 1.055 | 221 s (now 138 s) | 220 s (now 142 s) | 5.7 GB | yes |

Throughput is about 4.5 KB/s each way, so enwik7 takes ~40 min, enwik8 ~6–7 h and the full
enwik9 ~60 h per direction with the original code (see "Performance work" for the current speed).
Each process maps a 14 GB PPMD heap file (`ppm.<pid>.temp`, deleted on exit) in its working
directory.

**Why the small files don't use `-e`:** the contest mode is hard-wired to the full enwik9.
`src/readalike_prepr/misc.h` splits at fixed line numbers and the article reorder table lists every
article. Partial files therefore go through the generic `-c` mode with the same dictionary, PPMD,
fx2 models and transformer, just without article reordering and the phda9 transform:
`cmix_orig.exe --transformer fx2-cmix-T\models\6m-q4-fp32.tfwc2 -c english.dic <in> <out>`.
enwik4 is too small to store a vocabulary (cmix then uses all 256 byte values), so it falls back
to the LSTM.

Keep in mind that the transformer was *trained on enwik9*, so prefixes of enwik9 compress very
well. Other text will compress poorly with it (`-NoTransformer` is the general-purpose setting).

## Experiment: block-interleaved split (scripts/split_experiment.py)

Split the file into alternating blocks (N1×J1, N2×J2, ...) to produce two files A and B, compress
each with a fresh cmix run, and compare |A|+|B|+schedule with the unsplit file. The schedule was
searched for maximum bigram divergence between A and B, with an lzma proxy as a second criterion.
Python deps live in `tools\venv` (numpy).

| enwik6, 1,000,000 bytes | LSTM | transformer |
|---|---:|---:|
| unsplit | 175,244 | 131,850 |
| most different (1×179,563 + rest×269,345) | 181,305 (+3.46%) | 134,731 (+2.19%) |
| best lzma proxy (1×404,018 + rest×179,563) | 180,882 (+3.22%) | 134,478 (+1.99%) |

## Performance work

Section profile (`.uild.ps1 -ReusePgo -SkipConstruct -Defines CMIX_PROFILE,FX2_PROF -OutName cmix_prof.exe`,
rdtsc timers in `src/prof.h`, printed at exit), enwik6 with the transformer, before the changes:

| section | share | notes |
|---|---:|---|
| transformer step | 53.6% | int8 matmuls 61% of it (memory-bound: ~6 MB of weights per token), sliding-window attention 21%, KDA 16% |
| layer-0 mixers (23 x 484 weights) | 23.8% | mix 9.2% + update 14.6% |
| fxcm (paq8-style model) | 16.5% | |
| PPMD | 1.9% | |
| everything else | ~4% | |

Changes (all keep the output identical; enwik6 still 131,850 bytes, round trip verified):

* **Mixer weights in one arena** (`src/mixer/mixer.*`): rows are contiguous, the hash map stores row
  indices, and the row found by `Mix()` is reused by `Perceive()` (one lookup instead of two
  dependent lookups + pointer chases per mixer per bit). Mixer update time -35%.
* **Vectorized mixer update** (`Mixer::Perceive`): clang targeting MSVC has no strict aliasing,
  so a store to the weight row could change `num_inputs_`; the loop was "uncountable" and ran
  scalar (one load/FMA/store per weight, ~14.5K cycles per bit). Local bounds + `__restrict`
  give 8-wide FMAs, bit-identical.
* **Prefetch of the next bit's mixer rows** right after the model update (`prefetch_mixers`,
  default on): mixer mix time -60%.
* **AVX-VNNI matmul kernels** (`cpp_infer/src/opt/qmat_dense.cpp`, picked at run time via CPUID,
  `CMIX_NO_VNNI=1` disables): bit-identical, but only -4% on the matmuls because they are
  bandwidth-bound, not compute-bound.
* **Packed int4 weights for the dense matmuls** (`qmat_dense.cpp`, `QDense::packed`, used whenever
  VNNI is available; `CMIX_QMAT_UNPACKED=1` disables). The model's weights are int4 anyway;
  upstream unpacked them to int8 because Zen 2 has a single int8-dot pipe. On this CPU the
  matmuls are bound by L3 bandwidth (~50 GB/s, measured), so halving the 4.2 MB dense weight
  stream wins: weights are stored as w+7 nibbles (two rows per byte) and the kernels subtract the
  exact 7*sum(act). Matmuls -45%, transformer -31% per token, enwik6 -20%; bit-identical (unit
  test against the naive dot for every shape, and round trips).
* **AVX512-VNNI variant** of the packed kernels (EVEX `vpdpbusd` on ymm), selected on CPUs without
  AVX-VNNI but with AVX512-VNNI+VL, i.e. the contest's Tiger Lake i7-1165G7. Verified under Intel
  SDE 10.13.1 (`tools\sde`, `sde.exe -tgl -- ...`): the instruction mix shows EVEX vpdpbusd
  (VEX under `-adl`), the kernel unit test reproduces the native hash, and an enwik5 round trip of
  the PGO `cmix_orig.exe` gives a compressed file byte-identical to the native one (~6 min each
  way under emulation).
* **fxcm bucket prefetch** (`src/models/fxcmv1.cpp`, `fxcm_prefetch`, default on): all ContextMap2
  hash-bucket lookups of a bit are prefetched up front (bpos 0 after the contexts are set, bpos
  2/5 one bit early). fxcm -10%, ~1.5% overall: fxcm turned out to be mostly compute, not misses.
* Tried and rejected: fp32 V cache (`attn_f32=1`, attention 2x slower: L3 traffic), non-temporal
  prefetch of the weight stream (`CMIX_QMAT_PF_NTA=1`, matmuls +70%).

Measured machine characteristics that drove these choices (scratch microbenchmarks): L2 110-130
GB/s, L3 only 45-55 GB/s, DRAM ~32 GB/s; a random DRAM access 161 ns serialized vs 8 ns with 16
in flight; 1 TSC tick = ~1.3 core cycles (the FX2_PROF "cyc/token" tables are TSC ticks).

| | enwik6 compress | enwik6 decompress |
|---|---:|---:|
| before | 220.8 s | 219.6 s |
| after | 197.5 s (-10.6%) | 203.4 s |
| + vectorized mixer update | 177.8 s (-19.5%) | 192.6 s (-12.3%) |
| + packed int4, fxcm prefetch, disk-backed PPMD | **137.7 s (-37.6%)** | **142.3 s (-35.2%)** |

About 10 s of each run is fixed start-up (dictionary + model pretraining). Profile now (enwik6):
transformer ~64% (matmuls 51%, attention 27%, KDA 19% of it), fxcm ~15%, layer-0 mixers ~5%.
Attention is bound by its int8->fp32 V conversions (PV) and K loads (QK); KDA is near upstream's
estimated floor.

## Windows port (branch `windows-port` in fx2-cmix-T)

* `src/win_compat.h` (force-included): `fseeko/ftello` -> `_fseeki64/_ftelli64`, `S_ISDIR`, `fmemopen`.
* `ppmd.cpp`: the PPMD heap is disk-backed as upstream's Linux build (needed for the contest's
  10 GB limit): a view of a file mapping on `ppm.<pid>.temp` (FILE_ATTRIBUTE_TEMPORARY,
  delete-on-close), so it is not charged to the process commit (enwik7: 15.3 GB -> 1.3 GB).
  Upstream remaps the file every 20000 bytes to drop its pages; here every 20000 bytes the process
  working set is checked and the view is trimmed (VirtualUnlock) only above `ppmd_ws_mb` (default
  8500 MB), because trimming every time costs +25% PPMD time. Contents and output are identical
  to the RAM heap (`ppmd_disk=0`); enwik8 with a 1500 MB budget stayed at 1.2-1.6 GB.
* `arena_build.cpp`: `mmap` -> `VirtualAlloc`.
* Self-extractor: `cmix.exe` / `archive9.exe` names, `.\` subprocess prefix, `malloc_trim` no-op.
* **Transformer vocabulary** (`runner.cpp`, `preprocessor.cpp`; Windows-only, active only when the
  transformer runs). The transformer's token IDs are indices into the official build's exact
  205-byte vocabulary, which is stored in the published `archive9` header. Our preprocessed stream
  has the same content bytes, but upstream also writes the raw 4-byte stream length into the
  stream, and those bytes join the vocabulary. The length differs between builds (see next item),
  so we got 0x00/0x18 where the official build got 0x12, giving 206 symbols, and `-e` aborted. Fix:
  segment lengths are written as 8 letters `a`-`p`, and the official vocabulary is used whenever
  the transformer runs. The same fix lets the transformer run on the partial files.
  `--save-vocab <file>` dumps the vocabulary derived from the input (diagnostic).
* **phda9 depends on uninitialized memory (upstream issue).** `encode_txt_wit` scans
  `*(int*)&s[i]` past the end of shortened lines into stale/uninitialized stack. The same source
  gives 934,209,251 bytes at `-O0`, 941,094,003 at `-O1`..`-O3` (our build), and ~940.7 M in the
  official Linux build. Encode/decode still round-trip (verified on the full file), so only the
  compression ratio and the length header are affected.
* Build differences vs the upstream makefile: clang 22 instead of 17, MSVC STL/UCRT, no
  `-fno-exceptions`, no UPX, 64 MB stack. Flags that affect results (`-ffp-model=fast`,
  `-mrecip=none`, x86-64-v3, SEED=923, UPDATE_LIMIT=3000) are kept.

Archives are self-consistent but **not bit-compatible** with the Linux reference build: a
different compiler and libm give different float rounding. For an official-equivalent build use
Ubuntu 20.04 + clang-17 (`setup.sh` and `build_and_construct_comp.sh` upstream, e.g. under WSL2).
