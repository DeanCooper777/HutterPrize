# The fast flavour of cmix-neif 2.0: builds, switches, how to run every mode

For someone with no context. cmix-neif 2.0 (Marcus Woelk, GPL-3) is a Hutter Prize entry: cmix with a
quantized transformer byte model. Its published compressor `comp9` codes enwik9 in 49.2 h on one
core. We keep a development copy of its source with test tooling added behind compile-time macros;
a build without those macros is still the published `comp9`, byte for byte
(sha256 `976bf2d309707ab555e0c92720da5508ff0e5e6b846fc7082234262b06767f82`).
Nothing here is committed anywhere. Status: 17 Nov 2026.

## 1. Files and where they are

| what | size | sha256 | on this PC |
|---|---|---|---|
| development source tree (with weights and PGO profile) | 16 MB | (git base commit 35d1957a) | `C:\Dean\Projects\HutterPrize\reference\neif2\dev` |
| weights container `weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5` (the binary reads it from its WORKING directory) | 3,744,629 B | `729694cba4969b7d833686ed3f597ff04d3b226da849d5f8004ec020a0ed9563` | in the source tree; copied into every build directory |
| coder stream `stream.bin` = the bytes `comp9 -e enwik9` hands to its arithmetic coder (after all preprocessing) | 501,062,281 B | `c35d3073eeba70f22a2e08a50202b53eb95466e3e9f1f2702f6f9b3f96fd8718` | WSL distro "Ubuntu": `/root/noble/work/bed/stream.bin` |
| pod bundle (source + scripts + compressed stream) | 218,501,120 B (stream.bin.zst inside: 202,622,273 B) | `pod_bundle\neif_pod_bundle.tar.sha256` | `C:\Dean\Projects\HutterPrize\runs\wsl-split\pod_bundle\neif_pod_bundle.tar` |
| scripts | | | `C:\Dean\Projects\HutterPrize\runs\wsl-split\` (`neif_*.sh`, `neif_cpusets.py`) |

Nothing else is needed: the dictionary and the article order are inside the stream; a run writes
`./.dict` and a sparse 14.7 GB paging file `./ppm.page` into its working directory (one directory
per process, on a LOCAL disk). Memory: 7 to 10 GiB per run (10 GiB is the program's own ceiling).

The stream can also be made again from enwik9 (`neif_mkstream.sh`: builds the authors' tool
`cmix_stream` from `training/tf/1_dump/trainmodes.patch` and runs the preprocessing; needs the
1 GB enwik9 and was not timed here). Uploading the compressed stream in the bundle is the quicker
and safer way; the setup script checks its sha256.

On this PC everything runs inside an Ubuntu 24.04 chroot in WSL (`/root/noble`, source copies under
`/work`); `neif_pod_local.sh SCRIPT ARGS` runs a pod script there with `NEIF_ROOT=/work/pod`.

## 2. Compiler and builds

The entry is compiled with **clang 18.1.3 and lld 18 (Ubuntu 24.04 packages `1:18.1.3-1ubuntu1`),
not gcc**; gcc 13 only supplies the libstdc++ headers. Its `install.sh` pins every package to the
Ubuntu archive of 2026-09-27 through snapshot.ubuntu.com, which needs Ubuntu 24.04 (apt 2.7+).
The build is profile-guided (the profile is shipped in `pgo_data/`) with LTO.
**Whether the model output depends on the compiler version is not known.** A plain `make cmix`
(no profile) of the same source already gives another coder output, so treat any other compiler as
a different program until the self-check passes: the reference values below.

A test build = the entry's own recipe `make prof_use` in a directory that holds copies of `src/`,
`makefile`, `encoder_split.lds`, `runtime_exports.map`, `pgo_data/` and the weights container, with
the macros added through `CC`:

```
mkdir B && cd dev && cp -a src makefile encoder_split.lds runtime_exports.map pgo_data weights-*.c5 ../B/ && cd ../B
make -j8 prof_use CC="clang++-18 -DNEIF_TEST=1"                               # tbN: original test build
make -j8 prof_use CC="clang++-18 -DNEIF_TEST=1 -DNEIF_PACKED=1"               # tbK: packed (fast flavour)
make -j8 prof_use CC="clang++-18 -DNEIF_TEST=1 -DNEIF_MT=1 -DNEIF_PACKED=1"   # tbKM: packed + threads
```

(one directory per build; result `B/cmix`, about 2 min). `neif_pod_setup.sh` does all three.

| macro | what it adds | default build |
|---|---|---|
| `NEIF_TEST` | chunk modes `-t` / `-u`, the pipeline (`NEIF_PIPE`), the verification decode, bit counting, the 16-bit activation experiment (`NEIF_ACT16`) | not defined |
| `NEIF_PACKED` | dense transformer matmuls on nibble-packed weights (`src/tf1/opt/qmat_dense.cpp`): half the weight bytes per token, plain AVX2, same integer sums and floats, so the same coder output. Usable with or without `NEIF_TEST` | not defined |
| `NEIF_MT` (inside `NEIF_TEST`) | threads: the speculative transformer step and threads inside the step (`src/neif_mt.h`) | not defined |
| `NEIF_PFD=n` | prefetch distance of the dense kernels (entry: 6144); measured: no gain | not defined |
| `FX2_PROF` | per-site time table of the transformer at the end of a one-process `-t` run | not defined |

Reference values (identical for tbN, tbK, tbKM, with any `NEIF_PIPE` / `NEIF_MT` setting):

| chunk | `NEIF_T_START` | `NEIF_T_END` | `NEIF_T_WARM` | sha256 of the coder output (first 16 hex) |
|---|---|---|---|---|
| quick | 60000000 | 60030000 | 10000 | `9e925d7846f34983` |
| 60 M window | 60000000 | 60500000 | 100000 | `e3c7340dce4cef65` |
| reference chunk | 250000000 | 250300000 | 1200000 | `727e97767d69fb56` (total_bits 2508178.191) |

**AVX512-VNNI:** there is no AVX-512 or VNNI kernel in the program. The 512-bit forms exist only in
the micro-benchmark `neif_vnni_bench.cpp` (kernels C5 and D5, compiled with `-DBENCH_AVX512`); it is
in the bundle. On a machine with AVX512-VNNI:
`clang++-18 -O3 -march=x86-64-v3 -mtune=znver2 -mavxvnni -mavx512f -mavx512bw -mavx512dq -mavx512vnni -DBENCH_AVX512 neif_vnni_bench.cpp -o vb && taskset -c 2 ./vb 0 2 4 8`
(without AVX-VNNI on the CPU drop `-mavxvnni`; kernels C and D then are left out). It prints
microseconds per transformer row for every kernel; the arguments are MB of other memory touched
between rows. On the laptop the packed AVX2 kernel (E) beat both VNNI forms.

## 3. Running one chunk (`neif_pod_run.sh`, or by hand)

Every mode is a chunk run on the coder stream; positions are stream bytes. By hand, in an empty
working directory that has the weights container (a symlink will do):

```
export NEIF_T_START=60000000 NEIF_T_END=60500000 NEIF_T_WARM=100000 NEIF_T_JSON=score.json
B/cmix -t stream.bin out.cmix        # code: structure-only pass up to the warm-up start, then the model
B/cmix -u stream.bin out.cmix        # decode out.cmix and compare every byte with the stream (exit 0 = all equal)
```

The model starts at the first page start at or behind START - WARM (at byte 0 if WARM >= START;
there is no page start before about 15.28 M, so a window there must start at 0). Only the bits of
[START, END) are counted as `kept_bits`.

| mode | command line | environment |
|---|---|---|
| compress, one process | `cmix -t` | - |
| compress, pipeline of processes (same output) | `cmix -t` | `NEIF_PIPE=2` or `3`; `NEIF_PIPE_SPLIT=l` = first transformer layer of the second stage (default 8, measured best with the packed build) |
| **real compress command, pipeline of processes** (opt-in convenience, NOT the official single-core run; only smoke-tested, see below) | `cmix -e enwik9 OUT` | `NEIF_PIPE=3` (or 2); `NEIF_E_STOP=n` stops behind n stream bytes (test) |
| decode, one thread (the real decoder) | `cmix -u` | - |
| **verification decode**: the front stages walk the EXPECTED stream, the coder stage decodes and compares | `cmix -u` | `NEIF_PIPE=3` (or 2) |
| threaded decode test (NEIF_MT build): speculative transformer step, guess taken from the stream | `cmix -u` | `NEIF_MT=n NEIF_MT_SPEC=2` (n = transformer thread + n-1 workers, beside the main thread); `NEIF_MT_FAULT=p` forces p per mille wrong guesses; `NEIF_MT_CPUS=a,b,c` binds main, transformer thread, workers; `NEIF_MT_PIN=0` no binding |
| compress with the speculative step (NEIF_MT build) | `cmix -t` | `NEIF_MT=n NEIF_MT_SPEC=1` |
| threads inside the step only | `-t` / `-u` | `NEIF_MT=n` (n >= 2), no `NEIF_MT_SPEC` |
| 16-bit activations (chosen setting) | any | `NEIF_ACT16=162 NEIF_ACT16_DNBITS=10 NEIF_ACT16_DNMIN=2` (changes the coded bits: compressor and decoder need the same setting; not combined with the speculative step: the step then runs unspeculated) |
| time table | any | `NEIF_PROF=1` |

The threaded decode test is NOT yet a decoder that works without the stream (a real one must guess
the byte; that stage, "S5", is not built). The verification decode needs the expected stream by
design. `NEIF_PIPE` and `NEIF_MT` exclude each other.

**Multi-process compression in the real path** (added 17 Nov evening; details and the list of what
is not verified: `runs\neif-par\PROGRESS.md`, "Multi-process compression"). Default off. With
`NEIF_PIPE=2|3` the normal `cmix -e enwik9 OUT` of a NEIF_TEST build runs its coder as the forked
pipeline from stream byte 0; it prints `neif_pipe: MULTI-PROCESS COMPRESSION ... NOT the official
single-core run` at the start and at the end, and a `neif_e:` line with time and peak memory. If
the pipeline breaks, OUT is removed, no archive9 is written, exit code 3. A test build must carry
the embedded blocks of comp9 to run `-e`: `neif_e_build.sh` (-> `/work/tbKe/e/cmix`), one run
`neif_e_run.sh NAME STOP PIPE`, all checks `neif_e_batch.sh`. Verified so far: identical output
(sha256 5b3750d2...) for one process and `NEIF_PIPE=3` on the first 200,000 stream bytes, and a
killed front stage leaves no output. Page text, speed, memory and the end of the stream in the
real path are NOT verified yet (the run was stopped by the host for lack of memory).

`neif_pod_run.sh NAME t|u START END WARM BUILD_DIR [CODED]` wraps one run: own run directory under
`$OUT`, optional binding (`CPUS=0,1,2`), one line per run in `$OUT/results.tsv` (wall, model
seconds, cpu seconds, peak memory, pipe, threads, binary sha256, sha of the coder output, OK/PASS).

## 4. Split evaluation (`neif_split_eval.sh`)

K splits of the stream, several at a time; per split a `-t` run with warm-up (coded output and
JSON kept) and, as a second step, a decode of that output checked against the stream. Read the head
of the script for all switches. Typical pod use (16 splits, 3-process pipeline, packed build,
verification decode of every split, 8 splits at a time, each bound to its own CPUs):

```
cd /root/neif
PIN=1 SLOTS=8 SPLITS=0-7 STEPS="compress decode" DECODE=verify EMIT_DIR=/workspace/neif_res \
  bash scripts/neif_split_eval.sh build/tbK stream.bin 16 4000000 out/k16 3
# second machine: SPLITS=8-15. Afterwards copy both machines' out/k16/c* into one directory and
bash scripts/neif_split_eval.sh --summary DIR 16
```

* `SPLITS` / `DEC_SPLITS` select splits (`0-7`, `0,8,15`); `DECODE=verify|plain|spec`
  (verification decode / real one-thread decoder / threaded test with `DEC_BUILD=build/tbKM`,
  `DEC_MT=2`); per-split mode one process = last argument 0.
* Resumable; every finished run appends a line to `OUT/results.tsv` and, with `EMIT_DIR`, copies
  its small result files there at once. `OUT/session_*.txt` records lscpu, cgroup cpu.max /
  memory.max, cpu.stat and memory.events before and after, the environment, the file system.
* The summary gives total kept bytes; with `BASE_TOTAL=<total of the reference run>` also the
  estimated S = 93,388,956 + (total - BASE_TOTAL). **There is no K=16 total of the unmodified test
  build on this PC or in the repository** (searched for `total.json` / `total_kept_bytes`): the
  packed build codes the same bits as the original, so its own K=16 run IS that baseline; a
  16-bit run is then compared with it.
* WARM must reach a page start in front of every split: the summary says "raise WARM" otherwise
  (4 MB was the value planned for K=16).
* Local smoke test (done, 17 Nov): `STEPS="compress decode summary" CHUNK_BYTES=30000 SLOTS=1 PIN=1
  bash neif_pod_local.sh neif_split_eval.sh /work/pod/build/tbK /work/pod/stream.bin 2 10000
  /work/pod/out/smoke1 3`; then `DECODE=plain` and `DECODE=spec DEC_BUILD=/work/pod/build/tbKM`.

## 5. Scaling test (`neif_pod_scale.sh`)

`bash scripts/neif_pod_scale.sh [OUT_DIR]`: one run at a time on 60.0-60.3 M (original single,
packed single `-t` and `-u`, pipeline 2 and 3, verification decode, threaded decode test with
`NEIF_MT` 1/2/3/4 and with 23 % forced wrong guesses at 1/2/3, the first run again), each bound to
its own physical cores; then the loaded-throughput test on 60.0-60.1 M (`LOADED="16:0 16:2 8:3
16:3 5:3"` = runs at once : processes per run), all slots busy at once. Results: `results.tsv`,
`loaded.tsv`, `summary.txt`, `session_*.txt` in OUT_DIR. About 35 min + 15 min on the laptop's
speed. Resumable.

## 6. Pod: bundle and commands

Make the bundle on this PC (WSL, root): `bash /mnt/c/Dean/Projects/HutterPrize/runs/wsl-split/neif_pod_bundle.sh`
-> `C:\Dean\Projects\HutterPrize\runs\wsl-split\pod_bundle\neif_pod_bundle.tar` (size and sha256
next to it). The pod must run **Ubuntu 24.04** (x86-64 with AVX2; root; 40 GB local disk per ~2
concurrent runs; 10 GiB RAM per run). On the pod:

```
tar xf neif_pod_bundle.tar -C /root            # -> /root/neif  (LOCAL disk, not the network volume)
bash /root/neif/scripts/neif_pod_setup.sh      # compiler, stream, 3 builds, self-check (about 20 min)
#   must end with "SELF-CHECK PASSED" (9e925d7846f34983, e3c7340dce4cef65, 727e97767d69fb56)
bash /root/neif/scripts/neif_pod_scale.sh      # scaling + loaded throughput -> /root/neif/out/scale
# split evaluation: section 4
```

## 7. Measured on the laptop (Core Ultra 9 288V, WSL2; model seconds, 17 Nov)

| window | original, one process | packed, one process | packed + pipeline 3 (compress) | packed + verification decode | packed + threaded decode test |
|---|---|---|---|---|---|
| 60.0-60.5 M (598,569 model bytes) | 258.8, 259.1 | -t 197.3, 207.5; -u 197.6, 202.6 | 97.3, 87.6 | 91.3 | 2 threads 159.1, 157.6; 3 threads 154.0, 180.2; with 23 % wrong guesses 174.0, 174.9 (2) and 181.4, 181.6 (3) |
| 250.0-250.3 M (1,495,402 model bytes) | 681.0 | -t 525.8; -u 528.7 | 226.9 | 224.6 | 3 threads 419.3 (419.7 with 10 % wrong guesses) |

All runs of a window gave the reference sha / decoded every byte. Raw lines:
`runs\wsl-split\neif_fast_results.txt`. Not measured anywhere but this laptop.
