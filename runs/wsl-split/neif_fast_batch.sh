#!/bin/bash
# neif_fast_batch.sh STEP...: tests and timings of the "fast flavour" of cmix-neif 2.0 (NEIF_PACKED;
# runs/wsl-split/NEIF_FAST.md). Builds: /work/tbN = test build (-DNEIF_TEST=1), /work/tbK = packed
# (+ -DNEIF_PACKED=1), /work/tbKM = packed with threads (+ -DNEIF_MT=1). Every run goes through
# neif_mt_one.sh: one line per run in /root/noble/work/mt_results.txt (names f_*).
#   a16id   reference chunk 250.0-250.3 M, 16-bit setting (mask 162, 10 bits, threshold 2), 3-stage
#           pipeline: unpacked and packed build must give the same sha
#   dec     reference chunk, packed: -t (pipeline), -u single thread, validation decode (NEIF_PIPE=3 -u)
#   ref1    reference chunk, single process -t: original and packed (for the table of wall times)
#   mtid    packed + threads: quick identity chunks (neif_mt_quick.sh, neif_mt_s4quick.sh), then the
#           reference chunk: -t speculated with 10 % wrong guesses (3 threads), -u speculated from the
#           stream with 10 % wrong guesses, -u speculated without faults (for the table)
#   speed   60.0-60.5 M, two interleaved rounds: original single -t, packed single -t, packed single -u,
#           packed -u speculated (guess from the stream) with 2 and 3 threads, without and with 23 % wrong
#   pipe    60.0-60.5 M, packed, NEIF_PIPE=3 -t with the split at layer 8 (default), 6, 10, 4, 8 again,
#           and the validation decode with split 8 and 6
#   a16t    60.0-60.5 M, packed single process: off / 16-bit setting, two rounds and one more off
# Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
S=60000000; E=60500000; WM=100000
R0=250000000; R1=250300000; RW=1200000
one() { bash $W/neif_mt_one.sh "$@"; }
a16() { NEIF_ACT16=162 NEIF_ACT16_DNBITS=10 NEIF_ACT16_DNMIN=2 "$@"; }
for step in "$@"; do
  unset NEIF_MT_SPEC NEIF_MT_FAULT NEIF_PIPE NEIF_PIPE_SPLIT NEIF_ACT16 NEIF_ACT16_DNBITS NEIF_ACT16_DNMIN
  case $step in
    a16id)
      NEIF_PIPE=3 a16 one f_r16N t $R0 $R1 $RW /work/tbN 0 2
      NEIF_PIPE=3 a16 one f_r16K t $R0 $R1 $RW /work/tbK 0 2 ;;
    dec)
      NEIF_PIPE=3 one f_rtK t $R0 $R1 $RW /work/tbK 0 2
      one f_ruK u $R0 $R1 $RW /work/tbK 0 2 f_rtK
      NEIF_PIPE=3 one f_rsvK u $R0 $R1 $RW /work/tbK 0 2 f_rtK ;;
    ref1)
      one f_rtN1 t $R0 $R1 $RW /work/tbN 0 2
      one f_rtK1 t $R0 $R1 $RW /work/tbK 0 2 ;;
    mtid)
      bash $W/neif_mt_quick.sh /work/tbKM
      bash $W/neif_mt_s4quick.sh /work/tbKM
      unset NEIF_MT_SPEC NEIF_MT_FAULT
      [ -f /root/noble/work/chunks/f_rtK/run/out.cmix ] || NEIF_PIPE=3 one f_rtK t $R0 $R1 $RW /work/tbK 0 2
      NEIF_MT_SPEC=1 NEIF_MT_FAULT=100 one f_rts2f t $R0 $R1 $RW /work/tbKM 2 1,2,3
      NEIF_MT_SPEC=2 NEIF_MT_FAULT=100 one f_rus2f u $R0 $R1 $RW /work/tbKM 2 1,2,3 f_rtK
      NEIF_MT_SPEC=2 one f_rus2 u $R0 $R1 $RW /work/tbKM 2 1,2,3 f_rtK ;;
    speed)
      for r in a b; do
        one f_n0$r t $S $E $WM /work/tbN 0 2
        one f_k0$r t $S $E $WM /work/tbKM 0 2
        one f_ku0$r u $S $E $WM /work/tbKM 0 2 f_k0a
        NEIF_MT_SPEC=2 one f_kus1$r u $S $E $WM /work/tbKM 1 2,3 f_k0a
        NEIF_MT_SPEC=2 one f_kus2$r u $S $E $WM /work/tbKM 2 1,2,3 f_k0a
        NEIF_MT_SPEC=2 NEIF_MT_FAULT=230 one f_kus1f$r u $S $E $WM /work/tbKM 1 2,3 f_k0a
        NEIF_MT_SPEC=2 NEIF_MT_FAULT=230 one f_kus2f$r u $S $E $WM /work/tbKM 2 1,2,3 f_k0a
      done ;;
    pipe)
      [ -f /root/noble/work/chunks/f_k0a/run/out.cmix ] || one f_k0a t $S $E $WM /work/tbKM 0 2
      for sp in 8 6 10 4 8; do
        n=f_kp$sp; [ -d /root/noble/work/chunks/$n ] && n=${n}b
        NEIF_PIPE=3 NEIF_PIPE_SPLIT=$sp one $n t $S $E $WM /work/tbK 0 2
        tr '\r' '\n' < /root/noble/work/chunks/$n/log | grep -a "neif_pipe" | cut -c1-160
      done
      NEIF_PIPE=3 NEIF_PIPE_SPLIT=8 one f_ksv8 u $S $E $WM /work/tbK 0 2 f_k0a
      NEIF_PIPE=3 NEIF_PIPE_SPLIT=6 one f_ksv6 u $S $E $WM /work/tbK 0 2 f_k0a ;;
    a16t)
      for r in a b; do
        one f_k16off$r t $S $E $WM /work/tbK 0 2
        a16 one f_k16on$r t $S $E $WM /work/tbK 0 2
      done
      one f_k16offc t $S $E $WM /work/tbK 0 2 ;;
  esac
done
cp /root/noble/work/mt_results.txt $W/neif_fast_results.txt
echo "fast batch done"
