#!/bin/bash
# neif_e_batch.sh STEP...: the checks of the opt-in multi-process compression in the real path (`cmix -e`
# with NEIF_PIPE; runs/neif-par/PROGRESS.md, "Multi-process compression") and the validation decode of an
# OFFICIAL prefix that reaches page text.  One run at a time; hours in all.  Build: neif_e_build.sh.
#   kill      a front stage killed 8 s into a 3-process run: exit code 3, no output file
#   single    `-e` in one process, stopped behind E_STOP stream bytes (default 17 M: metadata, dictionary
#             slot, the passage into page text near 15.28 M, 1.7 M of page text)
#   pipe3     the same with NEIF_PIPE=3 (and a trace line every 100 k stream bytes); sha256 compared
#   pipe2     NEIF_PIPE=2, stopped behind 3 M stream bytes; compared with the prefix of `single`
#   official  the official comp9 until its coder output has 3 MiB (/work/off3/out9.prefix), compared with
#             the output of `single` over the bytes both have
#   sv        NEIF_PIPE=3 cmix -u: the validation decode of that official prefix from stream byte 0 up to
#             the last traced position that lies 128 KiB inside the prefix
#   quick     the quick reference chunk in mode -t, one process and NEIF_PIPE=3 (sha 9e925d7846f34983)
# Log: /root/noble/work/e_batch.log.  Run in WSL as root.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
C=/root/noble
B=${E_BUILD:-/work/tbKe}
ES=${E_STOP:-17000000}
L=$C/work/e_batch.log
say() { echo "$(date '+%F %T') $*" | tee -a $L; }
for step in "$@"; do
  say "=== step $step"
  case $step in
    kill)
      KILL_AFTER=8 bash $W/neif_e_run.sh k_p3 2000000 3 $B 2>&1 | tee -a $L
      say "kill test: rc $(cat $C/work/e/k_p3/rc), output file: $([ -e $C/work/e/k_p3/out ] && echo PRESENT || echo none), archive9: $([ -e $C/work/e/k_p3/archive9 ] && echo PRESENT || echo none)" ;;
    single)
      bash $W/neif_e_run.sh e_p0 $ES 0 $B 2>&1 | tee -a $L ;;
    pipe3)
      NEIF_T_TRACE=100000 bash $W/neif_e_run.sh e_p3 $ES 3 $B 2>&1 | tee -a $L
      a=$(sha256sum < $C/work/e/e_p0/out); b=$(sha256sum < $C/work/e/e_p3/out)
      say "single $(stat -c %s $C/work/e/e_p0/out) B $a"
      say "pipe3  $(stat -c %s $C/work/e/e_p3/out) B $b"
      [ "$a" = "$b" ] && say "REAL PATH, NEIF_PIPE=3 against one process, stream bytes [0, $ES): IDENTICAL" || say "REAL PATH NEIF_PIPE=3: DIFFERENT" ;;
    pipe2)
      bash $W/neif_e_run.sh e_p2 3000000 2 $B 2>&1 | tee -a $L
      n=$(( $(stat -c %s $C/work/e/e_p2/out) - 8 ))   # without the flush bytes of the shorter run
      if cmp -n $n $C/work/e/e_p2/out $C/work/e/e_p0/out; then say "REAL PATH, NEIF_PIPE=2, stream bytes [0, 3000000): first $n output bytes IDENTICAL to the one-process run"
      else say "REAL PATH NEIF_PIPE=2: DIFFERENT"; fi ;;
    official)
      bash $W/neif_official_prefix2.sh 3145728 /work/off3 6000 2>&1 | tee -a $L
      a=$(stat -c %s $C/work/off3/out9.prefix); b=$(stat -c %s $C/work/e/e_p0/out); n=$((a < b ? a : b)); [ $b -le $a ] && n=$((b - 8))
      if cmp -n $n $C/work/off3/out9.prefix $C/work/e/e_p0/out; then say "OFFICIAL comp9 output ($a B) against the test build's one-process -e output ($b B): first $n bytes IDENTICAL"
      else say "OFFICIAL against test build -e: DIFFERENT: $(cmp -n $n $C/work/off3/out9.prefix $C/work/e/e_p0/out 2>&1 | head -n 1)"; fi ;;
    sv)
      a=$(stat -c %s $C/work/off3/out9.prefix)
      E=$(tr '\r' '\n' < $C/work/e/e_p3/log | grep -ao "neif_trace [0-9]* [0-9.]* [0-9]* [0-9.]*" | awk -v lim=$((a - 131072)) '$4 <= lim { e = $2 } END { print e + 0 }')
      say "official prefix $a B; validation decode of stream bytes [0, $E)"
      mkdir -p $C/work/chunks/off3_prefix/run
      ln -sf /work/off3/out9.prefix $C/work/chunks/off3_prefix/run/out.cmix
      NEIF_PIPE=3 NEIF_SV_LOG=300 bash $W/neif_mt_one.sh o3_sv3 u 0 $E 0 $B 0 2 off3_prefix 2>&1 | tee -a $L
      say "sv rc $(cat $C/work/chunks/o3_sv3/rc)"
      tr '\r' '\n' < $C/work/chunks/o3_sv3/log | grep -a "neif_sv" | tail -n 4 | tee -a $L ;;
    quick)
      bash $W/neif_mt_one.sh eq_t0 t 60000000 60030000 10000 $B 0 2 2>&1 | tee -a $L
      NEIF_PIPE=3 bash $W/neif_mt_one.sh eq_tp3 t 60000000 60030000 10000 $B 0 2 2>&1 | tee -a $L ;;
  esac
done
say "e batch done"
