#!/bin/bash
# neif_sv_batch.sh STEP...: the runs of the validation decode (SV; runs/neif-par/PROGRESS.md): `cmix -u STREAM CHUNK`
# with NEIF_PIPE=2|3.  The front stages of the pipeline walk the expected stream, the coder stage decodes CHUNK and
# compares every byte.  Build /work/tbmt (neif_mt_build.sh); one line per run in /root/noble/work/mt_results.txt.
#   quick     60.00-60.03 M (warm 10 k): -t single and -t NEIF_PIPE=2 (same sha: the pipeline's records are the single
#             process's values), -u single, -u NEIF_PIPE=2 and 3 (must pass)
#   neg       negative tests on the same chunk: (1) one byte of the coded input changed, (2) one byte of the expected
#             stream changed; each with the plain decoder (which names the position) and with NEIF_PIPE=2 and 3
#             (must fail at the same position)
#   speed60   60.0-60.5 M (warm 100 k), two rounds: -u single, NEIF_PIPE=2, NEIF_PIPE=3
#   speed250  250.0-250.3 M (warm 1.2 M), ROUNDS rounds (default 1): the same
#   official  the first OFF_END (default 10 M) stream bytes decoded from the prefix of the OFFICIAL coder output
#             (/work/off/out9.prefix, written by the official comp9), from stream byte 0: NEIF_PIPE=3, then single
#   head      from stream byte 0 to HEAD_END (default 1.5 M), chunk of the test flavour: -t, -u single, NEIF_PIPE=2, 3
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
C=/root/noble
B=${SV_BUILD:-/work/tbmt}
unset NEIF_MT_SPEC NEIF_MT_FAULT NEIF_PIPE MT_STREAM
one() { bash $W/neif_mt_one.sh "$@"; }
for step in "$@"; do
  case $step in
    quick)
      S=60000000; E=60030000; WM=10000
      one q_t0 t $S $E $WM $B 0 2
      NEIF_PIPE=2 one q_tp2 t $S $E $WM $B 0 2
      one q_u0 u $S $E $WM $B 0 2 q_t0
      NEIF_PIPE=2 one q_sv2 u $S $E $WM $B 0 2 q_t0
      NEIF_PIPE=3 one q_sv3 u $S $E $WM $B 0 2 q_t0 ;;
    neg)
      S=60000000; E=60030000; WM=10000
      [ -f $C/work/chunks/q_t0/run/out.cmix ] || one q_t0 t $S $E $WM $B 0 2
      # (1) the coded input: the byte in the middle of the chunk gets one bit turned
      mkdir -p $C/work/chunks/q_bad/run
      python3 - $C/work/chunks/q_t0/run/out.cmix $C/work/chunks/q_bad/run/out.cmix <<'EOF'
import sys
b = bytearray(open(sys.argv[1], 'rb').read())
k = len(b) // 2
b[k] ^= 0x10
open(sys.argv[2], 'wb').write(b)
print('coded input: %d bytes, byte %d changed' % (len(b), k))
EOF
      one q_cb0 u $S $E $WM $B 0 2 q_bad
      NEIF_PIPE=2 one q_cbsv2 u $S $E $WM $B 0 2 q_bad
      NEIF_PIPE=3 one q_cbsv3 u $S $E $WM $B 0 2 q_bad
      # (2) the expected stream: byte 60,015,000 gets one bit turned
      cp $C/work/bed/stream.bin $C/work/bed/stream_bad.bin
      python3 - $C/work/bed/stream_bad.bin 60015000 <<'EOF'
import sys
f = open(sys.argv[1], 'r+b')
k = int(sys.argv[2])
f.seek(k); c = f.read(1)[0]
f.seek(k); f.write(bytes([c ^ 0x01]))
f.close()
print('expected stream: byte %d changed from %d to %d' % (k, c, c ^ 1))
EOF
      export MT_STREAM=/work/bed/stream_bad.bin
      one q_sb0 u $S $E $WM $B 0 2 q_t0
      NEIF_PIPE=2 one q_sbsv2 u $S $E $WM $B 0 2 q_t0
      NEIF_PIPE=3 one q_sbsv3 u $S $E $WM $B 0 2 q_t0
      unset MT_STREAM
      rm -f $C/work/bed/stream_bad.bin ;;
    neg2)     # more failures: (3) the coded input cut in half; (4) a change of the expected stream that changes
              # its structure (the last byte of a page-end anchor), so the front stages write other records;
              # (5) a front stage killed in the middle of a run (the official prefix from byte 0, 3 processes)
      S=60000000; E=60030000; WM=10000
      [ -f $C/work/chunks/q_t0/run/out.cmix ] || one q_t0 t $S $E $WM $B 0 2
      mkdir -p $C/work/chunks/q_cut/run
      python3 - $C/work/chunks/q_t0/run/out.cmix $C/work/chunks/q_cut/run/out.cmix <<'EOF'
import sys
b = open(sys.argv[1], 'rb').read()
open(sys.argv[2], 'wb').write(b[:len(b) // 2])
print('coded input: cut from %d to %d bytes' % (len(b), len(b) // 2))
EOF
      one q_tr0 u $S $E $WM $B 0 2 q_cut
      NEIF_PIPE=3 one q_trsv3 u $S $E $WM $B 0 2 q_cut
      cp $C/work/bed/stream.bin $C/work/bed/stream_bad.bin
      python3 - $C/work/bed/stream_bad.bin <<'EOF'
import sys
f = open(sys.argv[1], 'r+b')
f.seek(60005000); w = f.read(25000)
a = bytes([0x20, 0x20, 0x4c, 0x2f, 0xdf, 0x98, 0x4e, 0x0a])   # the page-end anchor
k = w.find(a)
if k < 0:
    print('no page-end anchor in the window'); sys.exit(1)
p = 60005000 + k + 7
f.seek(p); f.write(bytes([0x0b])); f.close()
print('expected stream: last byte of the page-end anchor at %d changed from 10 to 11' % p)
EOF
      export MT_STREAM=/work/bed/stream_bad.bin
      one q_rb0 u $S $E $WM $B 0 2 q_t0
      NEIF_PIPE=2 one q_rbsv2 u $S $E $WM $B 0 2 q_t0
      NEIF_PIPE=3 one q_rbsv3 u $S $E $WM $B 0 2 q_t0
      unset MT_STREAM
      rm -f $C/work/bed/stream_bad.bin
      mkdir -p $C/work/chunks/off_prefix/run
      ln -sf /work/off/out9.prefix $C/work/chunks/off_prefix/run/out.cmix
      ( NEIF_PIPE=3 NEIF_SV_LOG=10 one k_sv3 u 0 3000000 0 $B 0 2 off_prefix ) &
      sleep 60
      echo "killing the newest cmix process: $(pgrep -n -x cmix) of $(pgrep -x cmix | tr '\n' ' ')"
      kill -9 $(pgrep -n -x cmix)
      wait
      tr '\r' '\n' < $C/work/chunks/k_sv3/log | grep -a "neif_sv\|neif_pipe: " | tail -n 4 | cut -c1-200 ;;
    speed60)
      S=60000000; E=60500000; WM=100000
      [ -f $C/work/chunks/x_t0a/run/out.cmix ] || one x_t0a t $S $E $WM $B 0 2
      for r in a b; do
        one v_u0$r u $S $E $WM $B 0 2 x_t0a
        NEIF_PIPE=2 one v_sv2$r u $S $E $WM $B 0 2 x_t0a
        NEIF_PIPE=3 one v_sv3$r u $S $E $WM $B 0 2 x_t0a
      done ;;
    speed250)
      S=250000000; E=250300000; WM=1200000
      [ -f $C/work/chunks/r_ts2g/run/out.cmix ] || one r_ts2g t $S $E $WM $B 0 2
      for r in $(seq 1 ${ROUNDS:-1}); do
        one z_u0_$r u $S $E $WM $B 0 2 r_ts2g
        NEIF_PIPE=2 one z_sv2_$r u $S $E $WM $B 0 2 r_ts2g
        NEIF_PIPE=3 one z_sv3_$r u $S $E $WM $B 0 2 r_ts2g
      done ;;
    official)
      E=${OFF_END:-10000000}
      mkdir -p $C/work/chunks/off_prefix/run
      ln -sf /work/off/out9.prefix $C/work/chunks/off_prefix/run/out.cmix
      NEIF_PIPE=3 one o_sv3 u 0 $E 0 $B 0 2 off_prefix
      one o_u0 u 0 $E 0 $B 0 2 off_prefix ;;
    mixed)    # from stream byte 0 across the metadata blocks into page text (starts near 15.28 M): the chunk of
              # the test flavour, the validation decode, then the speculative decoder of stage S4 with 10 % wrong
              # guesses (bytes that can and cannot be speculated alternate here)
      E=${MIX_END:-15600000}
      one g_t0 t 0 $E 0 $B 0 2
      NEIF_PIPE=3 one g_sv3 u 0 $E 0 $B 0 2 g_t0
      NEIF_MT_SPEC=2 NEIF_MT_FAULT=100 one g_us2f u 0 $E 0 $B 2 1,2,3 g_t0 ;;
    head)
      E=${HEAD_END:-1500000}
      one h_t0 t 0 $E 0 $B 0 2
      one h_u0 u 0 $E 0 $B 0 2 h_t0
      NEIF_PIPE=2 one h_sv2 u 0 $E 0 $B 0 2 h_t0
      NEIF_PIPE=3 one h_sv3 u 0 $E 0 $B 0 2 h_t0 ;;
  esac
done
echo "sv batch done"
