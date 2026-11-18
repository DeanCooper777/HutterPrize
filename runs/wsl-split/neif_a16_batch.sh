#!/bin/bash
# neif_a16_batch.sh [STEP ...]: the measurement runs of the 16-bit activation experiment, one
# after the other (neif_a16_run.sh; PGO test build /work/tb16, 3-stage pipeline). Windows of
# 1 MB of the coder stream with 1 MB warm-up in front.
#   main:   every window with the 8-bit path (0) and with all groups (4095)
#   groups: windows 250 M and 60 M with one family of groups at a time:
#           3 = MLP (up + down input), 160 = output projections (KDA + window), 68 = q/k/v
#           projection inputs (KDA + window), 24 = KDA gate projections (up + down),
#           3840 = unembedding (both heads), prior embedding, side-channel projections
#   pairs:  window 250 M: 163 = MLP + output projections, 231 = those + q/k/v
# Run in WSL as root; several hours.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
run() { bash $W/neif_a16_run.sh $1 $(($1 + 1000000)) 1000000 /work/tb16 3 0 "${@:2}"; }
for step in "${@:-main}"; do
  case $step in
    main)
      run 250000000 0 4095
      run 60000000 0 4095
      run 420000000 0 4095
      ;;
    groups)
      run 250000000 3 160 68 24 3840
      run 60000000 3 160 68 24 3840
      ;;
    pairs)
      run 250000000 163 231
      ;;
    w4)
      run 150000000 0 4095
      ;;
  esac
done
echo "batch done"
