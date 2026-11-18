#!/bin/bash
# neif_mt_batch.sh STEP...: the timing and identity runs of stages S1 and S4 (runs/neif-par/PROGRESS.md), build
# /work/tbmt, one run after the other; one line per run in /root/noble/work/mt_results.txt.
#   s4speed  60.0-60.5 M (warm 100 k): -t with the speculative step (the compressor knows the byte) with 1, 2, 3
#            threads for the step beside the main thread; -u with the guess taken from the stream likewise
#   s1a/s1b  60.0-60.5 M: threads inside the step only (no speculation): -t off, 2, 3 threads; -u off, 2, 3
#   ident    the reference chunk 250.0-250.3 M (warm 1.2 M; sha 727e97767d69fb56, total_bits 2508178.191):
#            -t with 3 threads; -t speculated with 10 % wrong guesses; -u of that chunk with 3 threads; -u
#            speculated from the stream with 10 % wrong guesses
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
B=/work/tbmt; S=60000000; E=60500000; WM=100000
for step in "$@"; do
  unset NEIF_MT_SPEC NEIF_MT_FAULT
  case $step in
    s4speed)
      bash $W/neif_mt_one.sh w_t0a t $S $E $WM $B 0 2
      export NEIF_MT_SPEC=1
      bash $W/neif_mt_one.sh w_ts1 t $S $E $WM $B 1 2,3
      bash $W/neif_mt_one.sh w_ts2 t $S $E $WM $B 2 1,2,3
      bash $W/neif_mt_one.sh w_ts3 t $S $E $WM $B 3 0,1,2,3
      unset NEIF_MT_SPEC
      bash $W/neif_mt_one.sh w_u0a u $S $E $WM $B 0 2 w_t0a
      export NEIF_MT_SPEC=2
      bash $W/neif_mt_one.sh w_us1 u $S $E $WM $B 1 2,3 w_t0a
      bash $W/neif_mt_one.sh w_us2 u $S $E $WM $B 2 1,2,3 w_t0a
      bash $W/neif_mt_one.sh w_us3 u $S $E $WM $B 3 0,1,2,3 w_t0a ;;
    s1a|s1b)
      bash $W/neif_mt_one.sh w_t0$step t $S $E $WM $B 0 2
      bash $W/neif_mt_one.sh w_t2$step t $S $E $WM $B 2 2,3
      bash $W/neif_mt_one.sh w_t3$step t $S $E $WM $B 3 1,2,3
      bash $W/neif_mt_one.sh w_u0$step u $S $E $WM $B 0 2 w_t0$step
      bash $W/neif_mt_one.sh w_u2$step u $S $E $WM $B 2 2,3 w_t0$step
      bash $W/neif_mt_one.sh w_u3$step u $S $E $WM $B 3 1,2,3 w_t0$step ;;
    s4c)   # the speculative step, interleaved with single-thread runs (the machine drifts by 10 % over an hour)
      for r in a b; do
        unset NEIF_MT_SPEC
        bash $W/neif_mt_one.sh x_t0$r t $S $E $WM $B 0 2
        export NEIF_MT_SPEC=1
        bash $W/neif_mt_one.sh x_ts1$r t $S $E $WM $B 1 2,3
        bash $W/neif_mt_one.sh x_ts2$r t $S $E $WM $B 2 1,2,3
        if [ $r = a ]; then
          unset NEIF_MT_SPEC
          bash $W/neif_mt_one.sh x_u0$r u $S $E $WM $B 0 2 x_t0a
          export NEIF_MT_SPEC=2
          bash $W/neif_mt_one.sh x_us1$r u $S $E $WM $B 1 2,3 x_t0a
          bash $W/neif_mt_one.sh x_us2$r u $S $E $WM $B 2 1,2,3 x_t0a
        fi
      done ;;
    s4prof)   # where the main thread's time goes while the transformer thread works (NEIF_PROF=1)
      export NEIF_PROF=1 NEIF_MT_SPEC=1
      bash $W/neif_mt_one.sh x_prof t $S $E $WM $B 1 2,3
      tr '\r' '\n' < /root/noble/work/chunks/x_prof/log | grep -a "neif_prof" | cut -c1-120
      unset NEIF_PROF ;;
    identb)   # the reference chunk with faults, coder and decoder
      R0=250000000; R1=250300000; RW=1200000
      export NEIF_MT_SPEC=1 NEIF_MT_FAULT=100
      bash $W/neif_mt_one.sh r_ts2g t $R0 $R1 $RW $B 2 1,2,3
      export NEIF_MT_SPEC=2 NEIF_MT_FAULT=100
      bash $W/neif_mt_one.sh r_us2g u $R0 $R1 $RW $B 2 1,2,3 r_ts2g ;;
    meta)     # a window where the speculation is refused for some bytes (metadata rows, gate zones): MS ME MW in
              # the environment; single thread, then coder and decoder speculated with 10 % wrong guesses, then
              # the decoder as it would really run (NEIF_MT_SPEC=1: forced bytes only)
      T=${MT_TAG:-m}
      bash $W/neif_mt_one.sh ${T}_t0 t $MS $ME $MW $B 0 2
      export NEIF_MT_SPEC=1 NEIF_MT_FAULT=100
      bash $W/neif_mt_one.sh ${T}_ts2f t $MS $ME $MW $B 2 1,2,3
      export NEIF_MT_SPEC=2 NEIF_MT_FAULT=100
      bash $W/neif_mt_one.sh ${T}_us2f u $MS $ME $MW $B 2 1,2,3 ${T}_t0
      unset NEIF_MT_FAULT; export NEIF_MT_SPEC=1
      bash $W/neif_mt_one.sh ${T}_us1 u $MS $ME $MW $B 1 2,3 ${T}_t0 ;;
    bracket)  # a lower bound for a guessing decoder: the miss rates of the transformer's best byte (23 % at
              # 60 M, 32 % at 250 M) injected as faults, which are found only at the byte's last bit
      bash $W/neif_mt_one.sh y_t0a t $S $E $WM $B 0 2
      export NEIF_MT_SPEC=1
      NEIF_MT_FAULT=230 bash $W/neif_mt_one.sh y_ts1f230 t $S $E $WM $B 1 2,3
      NEIF_MT_FAULT=230 bash $W/neif_mt_one.sh y_ts2f230 t $S $E $WM $B 2 1,2,3
      unset NEIF_MT_SPEC
      bash $W/neif_mt_one.sh y_t0b t $S $E $WM $B 0 2
      export NEIF_MT_SPEC=1
      NEIF_MT_FAULT=320 bash $W/neif_mt_one.sh y_ts1f320 t $S $E $WM $B 1 2,3
      NEIF_MT_FAULT=320 bash $W/neif_mt_one.sh y_ts2f320 t $S $E $WM $B 2 1,2,3
      unset NEIF_MT_SPEC
      bash $W/neif_mt_one.sh y_t0c t $S $E $WM $B 0 2 ;;
    ident)
      R0=250000000; R1=250300000; RW=1200000
      bash $W/neif_mt_one.sh r_t3 t $R0 $R1 $RW $B 3 1,2,3
      export NEIF_MT_SPEC=1 NEIF_MT_FAULT=100
      bash $W/neif_mt_one.sh r_ts2f t $R0 $R1 $RW $B 2 1,2,3
      unset NEIF_MT_SPEC NEIF_MT_FAULT
      bash $W/neif_mt_one.sh r_u3 u $R0 $R1 $RW $B 3 1,2,3 r_t3
      export NEIF_MT_SPEC=2 NEIF_MT_FAULT=100
      bash $W/neif_mt_one.sh r_us2f u $R0 $R1 $RW $B 2 1,2,3 r_t3 ;;
  esac
done
echo "batch done"
