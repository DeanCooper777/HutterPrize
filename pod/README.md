# pod/: what ran on the cloud volume

A snapshot (2026-11-15) of the scripts, records and patched training source that existed only on
the rented cloud volume where the weights of this entry were trained and evaluated. It is kept
as it ran, for the record and for reproduction; it is not part of the submitted programs and it
is not merged into `fx2-cmix-T/pysrc`. Paths inside the scripts (`/workspace/...`) are the
volume's. Key files, the notification topic, logs and checkpoints were left on the volume.

| directory | what it is |
|---|---|
| `train_src/pysrc`, `train_src/training_recipes` | The training source as patched on the volume for the later weight runs. Against `fx2-cmix-T/pysrc` it adds `act16.py` (16-bit activation quantizers for training, matching the C++ kernels' scale / 256), `bits_map.py`, `entpen.py` (entropy penalty on the coded weights, an experiment) and the hooks in `train.py` (`A_MIXER_INIT`, `A_KEEP_EPOCHS`, the `A_GROW_*` width-growth experiment). Its `weights_compress.py` is OLDER than the repository's: use the repository's (it has the INTC coder; `compress3`). |
| `agent/pr` | The recipe that produced the shipped weights: `run_pr.sh` (gentle 3+1 epoch fine-tune with the 16-bit activation groups on), `patch_src.py` (applies the patches above to a source copy), the job scripts for P1c, C1 and C2 (`c2_job.sh`: C2 = the shipped `models/6m-q4-fp32.tfwc2`). |
| `c2exp/make.sh` | Export of a checkpoint to the weights file: CPU export, activation scales x256 for the 16-bit groups, bf16 values, then the weight coder. |
| `agent/tier0` | "Tier 0" proxy: a GPU evaluation that predicts the enwik9 effect of a weight set from the saved cmix bit predictions (`tier0.py`), with its job scripts. Gains above 10 KB were then confirmed by a 16-chunk split evaluation (`scripts/cloud/split_eval.sh`). |
| `agent/lv2`, `agent/l4`, `agent/grow`, `agent/p752`, `agent/n2`, `agent/n3`, `agent/mp`, `agent/up` | Experiments: cooldown variants, per-group 16-bit activation test (the source of the two extra groups in this entry), MLP width growth and pruning, earlier probes. Most did not make it; `agent/RESULTS.md` has every number. |
| `agent/tune`, `agent/tune2`, `agent/s3` | Tuning of the online-adaptation rate (`dyn_lr`) and its split evaluations. |
| `agent/k3`, `agent/k4`, `agent/st1`, `agent/fin` | Build / identity / split-evaluation jobs for the kernel changes and the stacked candidates. |
| `agent/intc` | The repository's `weights_compress.py` as copied to the volume. |
| `agent/notes` | The job instructions sent to the unattended agent, one file per job. |
| `agent/RESULTS.md` | The agent's results log: every experiment with its measured numbers. |
| `agent/CLAUDE.md`, `agent/tick.sh`, `agent/bootstrap.sh`, `agent/notify.sh`, `agent/rp.sh` | The unattended agent's brief and its small supervisor / notification / pod-management helpers (they read their keys from files that are not here). |

Two further scripts from the volume were added to `scripts/cloud/`: `rss_sampler.sh` (memory
sampler used by the full-length runs) and `chain_ext.sh`.
