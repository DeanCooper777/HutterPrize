# Hutter Prize submission: cmix-T-dwc (fx2-cmix-T with cmix-aware transformer training)

Author: Dean W. Cooper, Claude Code AI
Email: dwc@usa.com

> **Status (2026-11-18): work stopped; this entry was never submitted.** cmix-neif 2.0 (Marcus
> Woelk) has since reached 93,388,956 bytes, about 7% below the record this entry was measured
> against and well below this entry; it is not an official record yet, but the contest's discussion
> group names it as the entry currently in the lead. Our later work is on that code base
> (<https://github.com/DeanCooper777/HutterPrize2>).
>
> The model, the settings and the build described here are final. The sizes below are measured,
> but not in one run: the compressed enwik9 comes from a full-length run of the final model with a
> test build, and the executable sizes come from the official build. The full
> compress-and-decompress run of the official build itself was started on 15 Nov and aborted, so
> the lines marked **not measured** were never filled in, and the cut-down decompressor of the
> final build was never proven end to end. Only the first entry (11-10) was decompressed and
> verified.

## Result

| | bytes |
|---|---:|
| Compressor `comp9` (`run/cmix`, self-contained, includes the transformer weights) | 3,264,852 |
| Self-extracting archive `archive9` (includes the decompressor and the weights) | 96,130,827 |
| **Total S = len(comp9) + len(archive9)** | **99,395,679** |
| Record at the time (fx2-cmix-T, 2026) | 100,424,672 |
| **Improvement** | **1,028,993 bytes = 1.025%** (the claim threshold is 1%: S ≤ 99,420,425) |

What is inside:

| part | comp9 | archive9 |
|---|---:|---:|
| packed executable (compressor form / decompressor form) | 98,440 | 93,392 |
| dictionary, compressed by cmix | 101,022 | 101,022 |
| article order, compressed by cmix | 203,982 | — |
| transformer weights (`models/6m-q4-fp32.tfwc2`) | 2,861,392 | 2,861,392 |
| compressed enwik9 | — | 93,075,005 |
| trailer | 16 | 16 |

| | compress | decompress |
|---|---:|---:|
| Wall time, official build, one core | **not measured** | **not measured** |
| Peak RSS | **not measured** | **not measured** |
| Verified `enwik9_uncompressed` == `enwik9` (md5 e206c3450ac99950df65bf70ef61a12d) | — | **not done** (run aborted) |

Platform: **Linux x86-64**. The binary uses only AVX2/FMA/F16C, which the build script checks. Limits for
the Linux test machine (AMD Ryzen 7, Geekbench 5 T = 1310): 70,000/T ≈ 53 h per program, 10 GB RAM,
100 GB disk, no GPU. See "Time and memory" below for what we measured.

### Full-length runs behind these numbers

All on Linux, each a complete `cmix -e enwik9`.

| run | what | comp9 | archive9 | S | vs record |
|---|---|---:|---:|---:|---:|
| 11-10 | first entry: extension weights, UPX; decompressed and verified (md5) | 3,455,488 | 96,572,770 | 100,028,258 | −0.39% |
| st2, 11-13 | + 16-bit activations (2 groups), P1c weights, new weight coder, UPX | 3,333,077 | 96,263,562 | 99,596,639 | −0.82% |
| 11-14 | + C2 weights, adaptation rate 7.7e-4 (multi-core test mode, UPX) | 3,338,615 | 96,233,919 | 99,572,534 | −0.85% |
| final, 11-15 | + adaptation rate 1.2e-3, 16-bit activations (4 groups) (multi-core test mode, UPX) | 3,340,415 | 96,214,372 | 99,554,787 | −0.87% |
| **final, official build** | the same model in the minimal build with our packer (sizes above) | 3,264,852 | 96,130,827 | **99,395,679** | **−1.025%** |

The last row combines the compressed enwik9 of the run above it (93,075,005 bytes) with the official
build's own parts. The two builds produce the same code stream: over the first 0.19% of enwik9 the
official build (Intel laptop) and the two test builds (AMD cloud machines) wrote exactly the same
number of bytes at every progress mark. The official build differs from the test build only outside
the coded stream: no LSTM for the small side files (dictionary and article order: +4,835 bytes in
S), and the packer.

## What this entry is

This entry, **cmix-T-dwc**, builds on **fx2-cmix-T** (the record when this work was done: fx2-cmix by Kaido Orav and Byron Knoll, with
the LSTM replaced by a 6M-parameter quantized transformer; see `README.md` and `writeup.md`). The
model architecture, the preprocessing and the cmix models are unchanged. The gain comes from:

1. **The transformer is retrained to complement cmix** (mixture loss). Same size, different weights.
   This is most of the gain.
2. **16-bit activations at four matmul inputs.** The weights stay 4-bit; the activations that feed
   the most sensitive matrices are quantized to 65,536 levels instead of 256.
3. **Online adaptation of the transformer's output layer** ("dynamic evaluation"), an extra mixer
   input that compressor and decompressor update identically.
4. **A better coder for the weight file**, and bf16 instead of fp32 for the few float tensors.
5. **Retuned mixer constants.**
6. **A smaller executable.** It is stored twice (in `comp9` and in `archive9`): a minimal official
   build, our own context-mixing packer instead of UPX, and a decompressor copy that leaves out
   everything only the compressor needs.

We also made speed and memory changes that leave the output bit-identical. They keep the entry inside
the time and memory limits despite the extra work of items 2 and 3.

Every source file carries a header that says what it does, how it fits the whole, how it is tested
and what changed against the previous winning entry; our changes are marked `[this entry]` in the
code (`grep -rn "\[this entry\]"`).

### 1. cmix-aware fine-tuning (mixture loss)

**Observation.** cmix mixes the transformer with ~460 other inputs (PPMD, fxcm, match models, …) that
already predict much of what it predicts. On enwik6:

| predictor | bytes |
|---|---:|
| cmix without the transformer (and without the LSTM) | 176,384 |
| the transformer alone, converted to bit predictions | 139,967 |
| real cmix with the transformer | 131,548 |

Making the transformer 4.5% better on its own (through online adaptation) made cmix only 0.24%
better. Capacity spent re-learning what the other models already know is wasted, and the weights are
paid for twice (they are in both `comp9` and `archive9`).

**Loss.** cmix codes bits, so we train against cmix's bits:

1. We run cmix **without the transformer** over the whole preprocessed enwik9 stream (593,343,776
   tokens) and save its final probability for each of the 8 bits of every byte, as fp16 logits
   (9.5 GB). Test-build options: `--no-transformer --save-cmix-bits FILE`; `--raw-stream`
   replays exactly the stream that `-e` codes.
2. During training, the transformer's 205-way distribution is converted to the same 8 bit
   probabilities, the way cmix's `ByteModel::Predict` does it (subtree sums over the 256-leaf tree).
3. Each bit is mixed with cmix's prediction by a small learned logistic mixer, a stand-in for cmix's
   mixer: `p = σ(w_c·st(p_cmix) + w_t·st(p_tf) + b)`. Weights are selected by bit position × a
   cmix-confidence bucket (64 contexts). The mixer is trained jointly and never exported.
4. The loss is the binary cross-entropy of the mixed prediction, plus 0.1 × the plain cross-entropy.
   This keeps the model a sensible predictor where the stand-in is a poor model of the real mixer.

Gradients reach the transformer mainly where it can improve on cmix. The stand-in is close to the real
thing: on enwik6, a 2-input mixer with 64 weight sets gives 133,656 bytes vs 131,548 for real cmix.

Code: `pysrc/cmix_loss.py` (loss and bit conversion, tested against numpy and against the known
enwik6 costs); `pysrc/data.py` (`cmix_bits_filename`); `pysrc/train.py`
(`TrainingConfig.mixture_loss`); recipes `training_recipes/train_A_finetune.py` and
`training_recipes/cooldown_A.py`.

**Schedule of the submitted weights** (`models/6m-q4-fp32.tfwc2`, "C2"; 2,861,392 bytes, md5
d82b5af712c5e442d5c44009e5b36b70):

1. Start from upstream's int4 QAT checkpoint `models/6m-q4.tch`.
2. 24 epochs of int4 QAT fine-tuning with the mixture loss.
3. 24 more QAT epochs from the end of step 2, then a 4-epoch float32 cooldown as upstream. This is
   "ext", the weights of our first full run (100,028,258).
4. "P1c": 3 QAT epochs + 1 cooldown epoch from ext with two activation groups at 16 bits (item 2),
   at ext's final learning rate (2.5e-7) and starting from ext's stand-in mixer. At the usual
   starting rate the same short run made the model worse; at this rate it gains even with nothing
   else changed.
5. "C2": 3 more float32 cooldown epochs from P1c.

Steps 2 and 3 take about 11 h each on one RTX 5090, steps 4 and 5 about 3 h each. The scripts and the
patched training source of steps 4 and 5 are in `../pod/` (`agent/pr/run_pr.sh`, `agent/pr/c2_job.sh`,
`train_src/`, export `c2exp/make.sh`); they are a snapshot of what ran and are not merged into
`pysrc`.

Training data comes from our own build's token stream. That fixes a small mismatch between the
stream upstream trained on and the stream the build actually codes.

### 2. 16-bit activations

Upstream quantizes the input of every matmul to 8 bits. A sensitivity scan showed that most of the
loss from activation quantization sits in a few inputs. Four of them now use 16 bits, with the
stored scale divided by 256 and the weights untouched:

| input | bit of `CMIX_ACT16` | where the gain was measured |
|---|---:|---|
| MLP down-projection input | 1 | with the next: about −104 KB before any training |
| attention output-projection input | 2 | (P1c then adds the fine-tune on top) |
| MLP up-projection input | 4 | with the next: −15,016 bytes on a 16-chunk split of enwik9 |
| query / key / value projection inputs | 8 | |

The first two were trained with (step 4 above). The last two are applied to the finished weights
without retraining. The kernels (`cpp_infer/src/opt/act16.*`) are exact integer arithmetic with
proven overflow bounds, so they are bit-identical on every CPU; `test_act16.cpp` checks them. The
official build fixes the mask (15) at compile time: it does not read the experiment switch from the
environment, and the 8-bit code for these four inputs is not in the binary.

### 3. Online adaptation of the output layer

The predictor keeps an fp32 correction `W` (205 × 192) on the transformer's final hidden state. Its
logits are added to the transformer's logits, and it is trained by SGD on each token once the token
is known. The adapted distribution is an **additional** input to the byte mixer and to the final
mixer; the original transformer input stays. Both sides run the identical float computation, so
the decompressor reproduces it exactly.

The rate is `dyn_lr` = 1.2e-3. On the 16-chunk split of enwik9 that is 19,505 bytes better than the
3e-4 we started with; 2e-3 gains only 702 more. Code: `Predictor::DynApply` and `DynLearn` in
`src/predictor.cpp`.

### 4. Weight file

- The 4-bit integers are coded with adaptive counts per tensor ("INTC" in
  `pysrc/weights_compress.py`; decoder in `cpp_infer/src/weights_io_compressed.cpp`).
- The float tensors that upstream stored as fp32 (convolution and norm weights) are stored as bf16.

Together with the retraining of step 4 the file went from 2,947,485 to 2,861,392 bytes; it is
stored twice.

### 5. Tuning

Every changed constant is read through `src/tune.h`, whose defaults are the submitted values (the
official build compiles the defaults in and reads no tune file).

| constant | upstream | this entry |
|---|---:|---:|
| final mixer learning-rate decay after 25M steps (`decay_d3`, `src/mixer/mixer.cpp`) | 0.2 | 0.08 |
| layer-1 mixer learning rate (`src/predictor.cpp`) | 0.0003 | 0.00015 |
| mixer input clipping epsilon (`input_eps`, `MixerInput`) | 1e-4 | 5e-5 |

### 6. Smaller executable

The executable is in `comp9` and at the head of `archive9`, so each byte counts twice. With UPX the
test build packs to about 173 KB per copy. Now: 98,440 bytes in `comp9` and 93,392 in `archive9`.

- **Official minimal build** (`OFFICIAL=1`, `-DCMIX_OFFICIAL`): only what `comp9` and `archive9`
  use (`-e`, self-extract, plain `-c`/`-d` for the side files, `-h`); no tuning, profiling or
  evaluation options; no LSTM. Without the LSTM the dictionary and the article order compress
  slightly worse (+4,835 bytes in S), which the smaller binary repays several times.
- **Fixed-address link** (non-PIE), no unwind tables, no build-id.
- **Our packer** (`packer/`, replaces UPX): a bitwise context-mixing model for x86-64 code with an
  instruction parser, an address transform for calls and jumps, match models, a two-layer mixer
  and three SSE stages (`pk.cpp`); the model's contexts were chosen by search on this binary
  (`search.py`, `retune.sh`).
- **Compressor / decompressor split.** `packer/enc_only.py` builds the call graph of the linked
  binary and finds the functions only compression can reach (36 functions, 15.6 KB). The build
  links them last and the packer codes them last, so the decompressor in `archive9` is the same
  packed file cut short, with that range left as zeros. `comp9` pays nothing for carrying both.
- **Two-stage stub.** `packer/stage0.S` (285 bytes of hand-written assembly) decodes the unpacker
  proper (`packer/stage1.s`, the assembly form of `pkdec.c`), which decodes cmix into memory and
  executes it. Start-up costs about 5 s and 330 MB, once per process.
- **Built through assembly.** Every object of cmix is produced as x86-64 assembly first
  (`asm/`, 93,096 lines) and assembled from that. `FROM_ASM=asm ./build_and_construct_comp.sh`
  rebuilds the byte-identical `comp9` from the assembly alone.

### Speed and memory changes (output bit-identical)

- **Mixer weights in one arena** (`src/mixer/mixer.*`): one hash lookup per mixer per bit instead of
  two dependent lookups. Mixer update −35%.
- **Vectorized `Mixer::Perceive`**: local bounds and `__restrict` let the update use 8-wide FMAs.
- **Prefetch of the next bit's mixer rows** (`prefetch_mixers`): mixer mix time −60%.
- **Prefetch of fxcm's ContextMap2 buckets** (`fxcm_prefetch`): fxcm −10%.
- **Faster transformer kernels** for the packed 4-bit weights (`cpp_infer/src/opt/qmat_dense.cpp`,
  `act16.cpp`): the 16-chunk split ran in 1.76–1.99 h per chunk against 2.71–3.23 h before.
- **PPMD memory budget** (`src/models/ppmd.cpp`, 8,600 MB): the disk-backed PPMD heap is trimmed
  from RAM when the process approaches the budget, which keeps the peak under 10 GB.

## Time and memory

| run (one core) | machine | compress | decompress | peak RSS |
|---|---|---:|---:|---:|
| first entry, 11-10 | cloud, AMD EPYC 9655 | 33.8 h | 34.3 h | 10.2 GB (before the PPMD budget) |
| st2, 11-13 | cloud, AMD EPYC 9654 | 41.2 h | result not recorded here | 9.10 GB |
| final model, test build | cloud, AMD EPYC 9654 | completed (pace: about 40 h; final time not recorded here) | — | — |
| final, official build | laptop, Intel Core Ultra 9 288V (WSL2) | aborted (started 15 Nov) | not run | not measured |

- The rule is 70,000/T hours per program, with T the Geekbench 5 score of the machine that runs
  it. Measured scores: the EPYC 9655P cloud host 1,762 (39.7 h allowed there), the laptop 1,717
  (40.8 h). We could not get a score for the EPYC 9654 host that ran st2.
- On the machines we have, the run time is close to the allowance, not far below it. The official
  machine (Ryzen 7, T = 1310) allows 53.4 h; we have no measurement on such a machine, and a
  benchmark average does not predict a program that is bound by memory latency and AVX2 throughput.
  **This is the main open risk of the entry.**

## Portability and correctness

- **AVX2 only.** The transformer's AVX-VNNI / AVX512-VNNI matmul kernels (run-time dispatched on
  the development machine) are compiled out with `-DFX2_NO_VNNI`, which the `makefile` sets. Every
  matmul then runs on AVX2 kernels whose results are integer-exact and identical.
  `build_and_construct_comp.sh` disassembles the binary and refuses to build one with instructions
  beyond AVX2, or with `RCPPS`/`RSQRTPS` (`-mrecip=none` keeps results identical on Intel and AMD).
- **Nothing in the environment changes a prediction.** The official build reads no tune file and
  no experiment switches.
- **10 GB RAM.** PPMD's 14 GB heap is disk-backed (`mmap_to_disk`), as upstream, and trimmed by
  the memory budget above. Measured peak of the st2 full run: 9.10 GB.
- **Upstream bug fixes kept:** the `alloc1` buffer overflow; the `MAP_FIXED` PPMD remap;
  `-mrecip=none`.
- **Same stream on Intel and AMD.** See the note under the table of full-length runs.
- **Decompression verified end to end** for the first entry (11-10: md5 match after 34.3 h). For
  the final official build: **not done**; the run was aborted. That run would also have been the
  end-to-end proof of the cut-down decompressor; without it, the split rests on the call-graph analysis and on start tests
  (the decompressor form starts, extracts and verifies its dictionary, and decodes a small file).
- **Dynamic linking.** As upstream, the binary uses the machine's libc and libstdc++.
- **Also verified on Windows** (first entry). A Windows build of the same code produced an archive
  that decompressed to an identical enwik9 in ~37 h. That build is not the submission: different
  compilers round floats differently, so archives don't cross platforms.

## How to reproduce

### Build (Ubuntu 24.04 or later, clang 17)

```bash
./setup.sh                                  # clang 17, make, binutils (objdump, ld, as, readelf), python3
OFFICIAL=1 ./build_and_construct_comp.sh    # PGO build through assembly, checks, packer -> ./run/cmix
```

The script builds with profile-guided optimization, checks the instruction set, finds and moves the
compress-only functions, rebuilds once from `./asm` to confirm the assembly is complete, packs, and
assembles `run/cmix` (= `comp9`). `FROM_ASM=asm` skips the C++ compilation. Without `OFFICIAL=1`
it builds the test binary with all evaluation options. `PACKER=upx` packs with UPX as before.

### Compress

```bash
mkdir c9 && cd c9 && cp ../run/cmix . && cp /path/to/enwik9 .
./cmix -e enwik9 enwik9.comp    # writes the self-extracting ./archive9
```

### Decompress

```bash
mkdir d9 && cd d9 && cp ../c9/archive9 .
./archive9                      # writes enwik9_uncompressed
md5sum enwik9_uncompressed      # e206c3450ac99950df65bf70ef61a12d
```

The build-compress-verify scripts used for the cloud runs are `../scripts/cloud/linux_sub*.sh`.

### Retrain the weights

1. `./make_training_data.sh` (PPMD outputs, ~300 GB).
2. Generate the cmix bit dump with the test build: `cmix -n stream.bin out --raw-stream
   --official-vocab --no-transformer --save-cmix-bits bits.f16`, in parallel chunks with a
   4M-token warm-up (`../scripts/cloud/datagen.sh`).
3. Run the first fine-tune with `RUN_DIR=/workspace/full A_EPOCHS=24 COOLDOWN_EPOCHS=4 bash
   run_A_opt.sh`, and again with `A_INIT=/workspace/full/models/6m-q4-A.tch` (the QAT checkpoint
   before the cooldown) and the same epochs (`../scripts/cloud/run_A_opt.sh`). This gives "ext".
4. P1c and C2: `../pod/agent/pr/run_pr.sh` and `../pod/agent/pr/c2_job.sh` with the patched source
   in `../pod/train_src/`; export with `../pod/c2exp/make.sh`, then
   `python -m pysrc.weights_compress compress3 IN.tfw OUT.tfwc2` (this repository's version).

### How candidates were judged

Small files mislead (the extension weights looked flat on enwik6/7 and gained on enwik9), and a
full run takes days. Two tools stand in for it:

- **Tier 0**: a GPU pass that mixes the transformer's predictions with the saved cmix bit
  predictions through a refit stand-in mixer (`../pod/agent/tier0/`). Minutes per weight set.
- **Split evaluation**: the preprocessed enwik9 stream in 16 chunks, each coded by real cmix after
  a 4M-token warm-up (`../scripts/cloud/split_eval.sh`). About 2 hours on 32 cores. It predicted
  −583 KB for the extension weights (real: −539 KB), and the gains of the final version (−20.0 KB
  predicted, −21.3 KB real).

`../pod/agent/RESULTS.md` has every experiment with its numbers.

## Experiments that did not make it

| variant | result | verdict |
|---|---|---|
| richer stand-in mixer (512 contexts), 3+1 epochs | −0.2% vs 64 contexts | not carried into the long run |
| CE weight 0.3 / 0 | ±0.05% | no effect |
| MLP width 768 → 384 / 512 by pruning + fine-tune | enwik7 +16% / +9% for −0.85 / −0.57 MB of weights | rejected |
| MLP width 768 → 752 (16 least useful units per layer) | net +643 KB | rejected: shrinking loses even in small steps |
| MLP width 768 → 784 / 832 (function-preserving growth) | gains 8–11% of the bytes the new weights cost | rejected |
| 3-bit MLP weights; 3-bit for the five most tolerant groups | enwik7 +1.9%; net loss | rejected |
| 5-bit weights (31 levels) for all groups | net loss | rejected |
| entropy penalty on the coded weights during training | corrupts the weight scales; net loss | rejected |
| 4.1M model from scratch with the mixture loss (128+24+4 epochs) | enwik7 +4.7% for −0.91 MB | rejected |
| 12 more gentle QAT epochs from P1c; further cooldowns from C2 | no gain | C2 is where this recipe ends |
| 16-bit activations at the remaining inputs (gates, unembedding, attention cache) | about 7 KB together before any time cost | not built |
| dropping the article-order table | costs far more than its 204 KB | kept |
| retuning cmix's other constants on enwik9-like chunks | within noise | stopped |

The model's size is close to optimal for this budget: every shrink we tried lost more in archive
size than it saved in weight bytes, and every growth cost more than it gained.

## Credits

- Kaido Orav and Byron Knoll: fx2-cmix.
- The fx2-cmix-T authors: the transformer, its training code, the inference kernels and the
  submission pipeline (<https://github.com/astOwOlfo/fx2-cmix-transformer-v1>).
- This entry's changes are listed above. Licensed under GPL-3.0, as the original (`LICENSE`).

## Not sent

This entry was never submitted (see the status note at the top). What was still open when work
stopped:

- The full compress-and-decompress run of the official build: times, peak RSS, the md5
  verification, and confirmation that its `comp9` and `archive9` sizes equal the Result table
  (3,264,852 and 96,130,827).
- `comp9` and `archive9` as downloadable assets (the source is public in this repository; the
  submitted weights are committed as `models/6m-q4-fp32.tfwc2`, C2, 2026-11-15).
