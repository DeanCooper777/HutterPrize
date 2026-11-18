# neif/: test tooling for cmix-neif 2.0

Our additions to cmix-neif 2.0 (Marcus Woelk, GPL-3, https://github.com/marwoelk/cmix-neif-2.0),
kept as a patch against the commit in `BASE_COMMIT`. Everything is behind the compile-time macro
`NEIF_TEST`; a build without it reproduces the published `comp9` byte for byte
(sha256 976bf2d309707ab555e0c92720da5508ff0e5e6b846fc7082234262b06767f82).

| file | what it is |
|---|---|
| `neif_test.patch` | all test-time additions (diff of `src/` against the base commit): chunk test mode (`cmix -t`), chunk decoder and verification decode (`cmix -u`), multi-process pipeline (`NEIF_PIPE=2` or `3`, also opt-in in the real compress path), packed dense kernels (`NEIF_PACKED`), threaded speculative decoder (`NEIF_MT`), 16-bit activation paths (`NEIF_ACT16`) |
| `neif_tokcount.py` | counts how many transformer steps a coarser tokenisation of their coder stream would save |

Build, run and verification scripts are in `runs/wsl-split/neif_*.sh` (an Ubuntu 24.04 chroot
inside WSL with their pinned toolchain). The model-size and token-step sweep is in
`scripts/cloud/sweep/` (`RESULTS.md`).

The same modifications are published as a full tree with portable scripts, results and
documentation at https://github.com/DeanCooper777/HutterPrize2 . Notes: `runs/neif-par/PROGRESS.md`,
`runs/neif-par/DESIGN.md`, `runs/wsl-split/NEIF_FAST.md`.
