#!/bin/bash
# neif_pk_ident.sh BUILD...: the reference chunk 250.0-250.3 M (1.2 MB warm-up, 3-stage pipeline)
# with every BUILD; all must give the coder output sha 727e97767d69fb56 of the test build.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
for B in "$@"; do
  NEIF_ACT16=0 bash $W/neif_a16_run.sh 250000000 250300000 1200000 $B 3 0 0:id_$(basename $B) | cut -c1-330
done
echo "ident done"
