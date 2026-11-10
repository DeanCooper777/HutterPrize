# Hutter Prize submission: fx2-cmix-T with cmix-aware transformer training

> **Status (2026-11-10):** draft. The official Linux compression of enwik9 is running. Numbers
> marked **TBD** come from that run (`/workspace/sub/out/` on the build pod). Fill them in
> before sending.

## Result

| | bytes |
|---|---:|
| Compressor `comp9` (`run/cmix`, self-contained, includes the transformer weights) | **TBD** (pre-UPX build: 3,455,488) |
| Self-extracting archive `archive9` (includes the decompressor and the weights) | **TBD** |
| **Total S = len(comp9) + len(archive9)** | **TBD** (estimate ≈ 97.3–97.5 M) |
| Previous record (fx2-cmix-T, 2026) | 100,424,672 |
| **Improvement** | **TBD** (estimate −2.9% to −3.1%; the claim threshold is 1%) |

| | compress | decompress |
|---|---:|---:|
| Wall time, build machine (AMD EPYC 9655, 1 core used) | **TBD** | **TBD** |
| Peak RSS | **TBD** | **TBD** |
| Verified `enwik9_uncompressed` == `enwik9` (md5 e206c3450ac99950df65bf70ef61a12d) | — | **TBD** |

Platform: **Linux x86-64**. The binary uses only AVX2/FMA/F16C, which the build script checks. Limits for
the Linux test machine (AMD Ryzen 7, Geekbench 5 T = 1310): 70,000/T ≈ 53 h per program, 10 GB RAM,
100 GB disk, no GPU.

## What this entry is

This entry builds on **fx2-cmix-T** (the current record: fx2-cmix by Kaido Orav and Byron Knoll, with
the LSTM replaced by a 6M-parameter quantized transformer; see `README.md` and `writeup.md`). The
model architecture, the inference code, the preprocessing and the cmix models are unchanged. The gain
comes from three things:

1. **The transformer is retrained to complement cmix.** Upstream trained it on plain next-byte
   cross-entropy. We fine-tune it with a loss that measures how much it improves *cmix's own
   prediction* (below). Same size, same speed, different weights. This is most of the gain.
2. **Online adaptation of the transformer's output layer** ("dynamic evaluation"). It is an extra
   mixer input that compressor and decompressor update identically.
3. **Retuned mixer constants.**

We also made a set of speed changes that leave the output bit-identical. They keep the entry inside
the time limit despite the extra work from item 2.

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
   (9.5 GB). New compressor options: `--no-transformer --save-cmix-bits FILE`; `--raw-stream`
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

**Schedule of the submitted weights** (`models/6m-q4-fp32-ext.tfwc2`, shipped as
`models/6m-q4-fp32.tfwc2`; 2,947,485 bytes, md5 f7979e84088bf7673c5958025af51474):

1. Start from upstream's int4 QAT checkpoint `models/6m-q4.tch`.
2. 24 epochs of int4 QAT fine-tuning with the mixture loss (peak LR 2.5e-6). This alone is
   `Afull`, after its own cooldown.
3. 24 more QAT epochs from the end of step 2 (the QAT checkpoint before `Afull`'s cooldown).
4. A 4-epoch float32 cooldown (as upstream), then export.

On one RTX 5090 this takes about 11 h for each block.

Training data comes from our own build's token stream. That fixes a small mismatch between the
stream upstream trained on and the stream the build actually codes.

### 2. Online adaptation of the output layer

The predictor keeps an fp32 correction `W` (205 × 192) on the transformer's final hidden state. Its
logits are added to the transformer's logits, and it is trained by SGD (lr 3e-4) on each token once
the token is known. The adapted distribution is an **additional** input to the byte mixer and to the
final mixer; the original transformer input stays. Both sides run the identical float computation,
so the decompressor reproduces it exactly.

Measured effect (with the upstream weights): enwik7 −0.19% at about +6% time. Code:
`Predictor::DynApply` and `DynLearn` in `src/predictor.cpp`. Parameters `dyn_lr`, `dyn_mode`,
`dyn_l1`.

### 3. Tuning

Every changed constant is read through `src/tune.h`, whose defaults are the submitted values. The
changes found by search on enwik7:

| constant | upstream | this entry |
|---|---:|---:|
| final mixer learning-rate decay after 25M steps (`decay_d3`, `src/mixer/mixer.cpp`) | 0.2 | 0.05 |
| layer-1 mixer learning rate (`lr1_0`, `src/predictor.cpp`) | 0.0003 | 0.00015 |
| mixer input clipping epsilon (`input_eps`, `MixerInput`) | 1e-4 | 5e-5 |

### Speed changes (output bit-identical)

- **Mixer weights in one arena** (`src/mixer/mixer.*`): one hash lookup per mixer per bit instead of
  two dependent lookups. Mixer update −35%.
- **Vectorized `Mixer::Perceive`**: local bounds and `__restrict` let the update use 8-wide FMAs.
- **Prefetch of the next bit's mixer rows** (`prefetch_mixers`): mixer mix time −60%.
- **Prefetch of fxcm's ContextMap2 buckets** (`fxcm_prefetch`): fxcm −10%.

Overall, enwik6 went from 221 s to 138 s on the development laptop (Core Ultra 9 288V). That figure
includes AVX-VNNI kernels the Linux build does not use.

## Portability and correctness

- **AVX2 only.** The transformer's AVX-VNNI / AVX512-VNNI matmul kernels (run-time dispatched on
  the development machine) are compiled out with `-DFX2_NO_VNNI`, which the `makefile` sets. Every
  matmul then runs on upstream's AVX2 kernels, whose results are integer-exact and identical.
  `build_and_construct_comp.sh` disassembles the binary and refuses to build one with instructions
  beyond AVX2, or with `RCPPS`/`RSQRTPS` (`-mrecip=none` keeps results identical on Intel and AMD).
- **10 GB RAM.** PPMD's 14 GB heap is disk-backed (`mmap_to_disk`, tune key `ppmd_disk`, default
  1), as upstream. Measured peak: **TBD** (Linux). The Windows development build peaked at 8.6 GB.
- **Upstream bug fixes kept:**
  - the `alloc1` buffer overflow;
  - the `MAP_FIXED` PPMD remap;
  - `-mrecip=none`.
- **Determinism.** The archive was produced and decoded on Linux with this exact build. The
  decompression was verified byte-for-byte (**TBD**).
- **Also verified on Windows.** A Windows build of the same code produced an archive that
  decompressed to an identical enwik9 in ~37 h. That build is not the submission: different
  compilers round floats differently, so archives don't cross platforms.

## How to reproduce

### Build (Ubuntu 24.04, clang 17)

```bash
./setup.sh                      # or: apt install upx-ucl make binutils; llvm.sh 17
./build_and_construct_comp.sh   # PGO build, AVX2/no-recip checks, UPX -> ./run/cmix
```

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

The exact build-compress-verify script used for this entry is `../scripts/cloud/linux_sub.sh`.

### Retrain the weights

1. `./make_training_data.sh` (PPMD outputs, ~300 GB).
2. Generate the cmix bit dump with `cmix -n stream.bin out --raw-stream --official-vocab
   --no-transformer --save-cmix-bits bits.f16`, in parallel chunks with a 4M-token warm-up
   (`../scripts/cloud/datagen.sh`).
3. Run the first fine-tune with `RUN_DIR=/workspace/full A_EPOCHS=24 COOLDOWN_EPOCHS=4 bash
   run_A_opt.sh`.
4. Run it again with `A_INIT=/workspace/full/models/6m-q4-A.tch` (the QAT checkpoint before the
   cooldown) and the same epochs. Each run exports a `.tfwc2` (`../scripts/cloud/run_A_opt.sh`).

## Experiments that did not make it

These were all measured with full cmix on enwik6 and enwik7, and some also on enwik9 (split runs).

| variant | weights | result | verdict |
|---|---:|---|---|
| richer stand-in mixer (512 contexts), 3+1 epochs | same | −0.2% vs 64 contexts | not carried into the long run |
| CE weight 0.3 / 0 | same | ±0.05% | no effect |
| MLP width 768 → 384 / 512 by pruning + fine-tune | −0.85 / −0.57 MB | enwik7 +16% / +9% | rejected |
| 3-bit MLP weights | −0.48 MB | enwik7 +1.9% | rejected (net +0.3%) |
| 4.1M model from scratch with the mixture loss (128+24+4 epochs) | −0.91 MB | enwik7 +4.7% | rejected |

The model's size is close to optimal for this budget: every shrink we tried lost more in archive
size than it saved in weight bytes.

## Credits

- Kaido Orav and Byron Knoll: fx2-cmix.
- The fx2-cmix-T authors: the transformer, its training code, the inference kernels and the
  submission pipeline (<https://github.com/astOwOlfo/fx2-cmix-transformer-v1>).
- This entry's changes are listed above. Licensed under GPL-3.0, as the original (`LICENSE`).

## Before sending (checklist)

- [ ] Fill in the **TBD** sizes, times, peak RSS and the verification line from
      `/workspace/sub/out/{comp9,archive9,comp.time,decomp.time}` and `logs/linux_sub.txt`.
- [x] Commit the submitted weights as `models/6m-q4-fp32.tfwc2` (done 2026-11-10). Upstream's
      weights are kept as `models/6m-q4-fp32-upstream.tfwc2`.
- [ ] Publish the source (public repo or release), with `comp9` and `archive9` as downloadable
      assets.
- [ ] Add the author's name and contact details, and email the entry as described on
      <http://prize.hutter1.net/hrules.htm>.
