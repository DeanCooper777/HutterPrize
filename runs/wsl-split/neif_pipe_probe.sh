#!/bin/bash
# neif_pipe_probe.sh: copy the sources of the development copy into the test build tree /work/tbp
# and check the profiled files the NEIF_TEST code touches (neif_pgo_probe.sh): no function may
# lose its profile entry beyond the baseline.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
(cd /mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev && tar cf - src) | tar xf - -C /root/noble/work/tbp
for f in src/predictor.cpp src/coder/encoder.cpp src/models/ppmd.cpp; do
  echo "== $f"; bash $W/neif_pgo_probe.sh $f
done
