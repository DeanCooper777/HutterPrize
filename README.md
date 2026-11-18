# cmix-T-dwc: a Hutter Prize entry

**cmix-T-dwc** compresses enwik9 (the first 10^9 bytes of the English Wikipedia, the file of the
[Hutter Prize](http://prize.hutter1.net/)) to **99,395,679 bytes** in total (compressor +
self-extracting archive), **1.025% below fx2-cmix-T (100,424,672 bytes)**, the record it was built
to beat. It was never submitted: cmix-neif 2.0 has since reached 93,388,956 bytes, about 7% below
that record and well below this entry. cmix-neif 2.0 is not an official record yet, but the
contest's discussion group names it as the entry currently in the lead (status as of 18 Nov 2026).

| | |
|---|---|
| Program | **cmix-T-dwc** |
| Authors | Dean W. Cooper, Claude Code AI |
| Total size S = comp9 + archive9 | 3,264,852 + 96,130,827 = **99,395,679 bytes** |
| Record it was measured against | 100,424,672 bytes: fx2-cmix-T (Vladimir Ivanov, 24 Jul 2026, 11th prize winner) |
| Smaller since | 93,388,956 bytes: cmix-neif 2.0 (Marcus Woelk), not official yet; see the related repository below |
| Platform | Linux x86-64 (AVX2), one core, under 10 GB RAM |
| Status (18 Nov 2026) | work stopped, never submitted. Sizes are measured, but the end-to-end compress / decompress / md5 run of the final official build was started on 15 Nov and aborted; only the first version (10 Nov, S = 100,028,258) was decompressed and verified end to end (see `cmix-T-dwc/SUBMISSION.md`) |
| License | GPL-3.0 (`LICENSE`) |

> **Related repository: [HutterPrize2](https://github.com/DeanCooper777/HutterPrize2).** Our later
> work on cmix-neif 2.0 (by Marcus Woelk; total size 93,388,956 bytes) is published there:
> cmix-neif 2.0 with test-time speed modes (packed dense kernels, a multi-process pipeline, a
> verification decode and a parallel split evaluation) that turn a four-day compress-and-check
> cycle into a few hours. It does not change the compressed size and is not a contest entry. The
> patch and working notes for that work are also kept here under `neif/` and `runs/neif-par/`.

## What it is

cmix-T-dwc is built on **fx2-cmix-T**, the record holder when this work was done: fx2-cmix by Kaido Orav and Byron
Knoll (the cmix family of context-mixing compressors) with its LSTM replaced by a 6M-parameter
quantized transformer (<https://github.com/astOwOlfo/fx2-cmix-transformer-v1>, imported at commit
`83f2603`). The model architecture, the preprocessing and the cmix models are theirs and unchanged.
What this entry adds:

1. **The transformer is retrained to complement cmix.** It is fine-tuned on the loss of cmix's
   mixed prediction instead of its own cross-entropy, so it spends its capacity where the other
   models are weak. Same size, different weights. Most of the gain.
2. **16-bit activations** at the four most sensitive matmul inputs (the weights stay 4-bit), with
   exact integer kernels.
3. **Online adaptation** of the transformer's output layer during compression and decompression.
4. **A better coder for the weight file.**
5. **Retuned mixer constants.**
6. **A smaller executable**, which counts twice: a minimal official build, our own context-mixing
   executable packer instead of UPX, and a decompressor copy without the compress-only code.
7. **Speed and memory work** with bit-identical output, to stay inside the contest limits.

`cmix-T-dwc/SUBMISSION.md` is the full write-up: results of every full-length run, how each gain
was measured, how to reproduce the build and the weights, and the experiments that did not make it.
Every source file has a header that says what it does and how it differs from the previous winning
entry; our changes are tagged `[this entry]` in the code.

## Layout

```
cmix-T-dwc/             the entry: source, weights, packer, build scripts, write-up
  SUBMISSION.md         write-up of the entry (start here)
  writeup.md, README.md the previous winner's own documents (fx2-cmix-T)
  src/                  cmix: preprocessing, context models, PPMD, mixers, coder, self-extractor
  cpp_infer/            transformer inference (kernels, tests, benches)
  pysrc/, training_recipes/   transformer training (PyTorch)
  packer/               executable packer: model (pk.cpp), decoder (pkdec.c), assembly stub
  asm/                  the whole program as x86-64 assembly (the build goes through it)
  models/               transformer weights (6m-q4-fp32.tfwc2 is the shipped file)
  build_and_construct_comp.sh, makefile   Linux build
pod/                    snapshot of the scripts, results log and patched training source that ran
                        on the cloud volume (see pod/README.md)
scripts/                tuning and split-evaluation tools; scripts/cloud/ = cloud run scripts
runs/                   helper scripts and logs of local runs (runs/wsl-split: WSL build and tests)
docs/                   training notes
build.ps1, test.ps1     Windows development build and round-trip test
enwik9, data/, tools/, reference/   inputs and tools, not checked in (see below)
```

`scripts/cloud/linux_sub*.sh`, `full_pipe_*.sh` and `make_fin.sh` are kept as they ran: they unpack
source tarballs made before the rename, in which the source directory is still called
`fx2-cmix-T/`. The same holds for everything under `pod/`.

## Build and run (Linux)

Ubuntu 24.04 or later, clang 17:

```bash
cd cmix-T-dwc
./setup.sh                                  # clang 17, make, binutils, python3
OFFICIAL=1 ./build_and_construct_comp.sh    # -> run/cmix  (= comp9, 3,264,852 bytes)

mkdir c9 && cd c9 && cp ../run/cmix . && cp /path/to/enwik9 .
./cmix -e enwik9 enwik9.comp                # about 1.5 days on one core; writes ./archive9

mkdir ../d9 && cd ../d9 && cp ../c9/archive9 .
./archive9                                  # about 1.5 days; writes enwik9_uncompressed
md5sum enwik9_uncompressed                  # e206c3450ac99950df65bf70ef61a12d
```

Without `OFFICIAL=1` the script builds the test binary, which has the evaluation modes used during
development (`-n`, `--raw-stream`, `--transformer FILE`, tuning via `CMIX_TUNE`, ...).
`FROM_ASM=asm ./build_and_construct_comp.sh` rebuilds the identical binary from the assembly in
`asm/` without compiling any C++. Under WSL2 the same commands work; `runs/wsl-split/` has the
helper scripts we used (`build_fin_off.sh`, `verify_official.sh`).

Archives are **not portable between builds**: a different compiler or C library rounds floats
differently, so an archive must be decompressed by the build that made it. Within one build the
output is identical on Intel and AMD CPUs (the build script enforces AVX2-only code and exact
divisions).

# Windows development build

The rest of this file describes the Windows build used for development (profiling, tuning, small
tests). It is not the submission.

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

The numbers in this section and the next were measured early in the project, with the previous
winner's weights; they describe the tools, not the entry's results.

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
`cmix_orig.exe --transformer cmix-T-dwc\models\6m-q4-fp32.tfwc2 -c english.dic <in> <out>`.
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

## Windows port

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

Archives are self-consistent but **not bit-compatible** with the Linux build: a different
compiler and libm give different float rounding. The submission is the Linux build above.
