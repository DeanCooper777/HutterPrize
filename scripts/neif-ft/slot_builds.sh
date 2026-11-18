#!/bin/bash
# slot_builds.sh: testing tool (not part of any submitted program).
# The two builds of the edited cmix-neif 2.0 development tree, one after the other:
#   1. the official build (no NEIF_TEST): comp9 must be the published file;
#   2. the PGO test build (-DNEIF_TEST=1) into /work/tbtap inside the chroot.
# Uses the existing helpers in runs/wsl-split.  Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
pgrep -fa 'comp9|/cmix' | head -5
echo "== official build  $(date '+%T')"
bash $W/neif_build_official_dev.sh
echo "== test build  $(date '+%T')"
bash $W/neif_build_test.sh /work/tbtap pgo
echo "== done  $(date '+%T')"
