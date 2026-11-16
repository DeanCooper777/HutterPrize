# neif/: test tooling for cmix-neif 2.0

Our additions to cmix-neif 2.0 (Marcus Woelk, GPL-3, https://github.com/marwoelk/cmix-neif-2.0),
kept as a patch against the commit in `BASE_COMMIT`. Everything is behind the compile-time macro
`NEIF_TEST`; a build without it reproduces the published `comp9` byte for byte
(sha256 976bf2d309707ab555e0c92720da5508ff0e5e6b846fc7082234262b06767f82).

| file | what it is |
|---|---|
| `neif_test.patch` | chunk test mode (`cmix -t STREAM OUT`, env `NEIF_T_START/END/WARM/JSON/TRACE`) and the multi-stage compress-only pipeline (`NEIF_PIPE=2` or `3`, forked stages, byte-identical output) |
| `neif_tokcount.py` | counts how many transformer steps a coarser tokenisation of their coder stream would save |

Build, run and verification scripts are in `runs/wsl-split/neif_*.sh` (an Ubuntu 24.04 chroot
inside WSL with their pinned toolchain). The model-size and token-step sweep is in
`scripts/cloud/sweep/` (`RESULTS.md`).
