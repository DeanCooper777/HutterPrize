#!/bin/bash
# rerun on the existing N3 pod (cmix already built in /root/n3/cmix): dumps stay local, analysis local
set -u
W=/workspace; L=/root/n3; D=$L/dump; mkdir -p $D
U=$W/upload; N=$(stat -c %s $U/stream.bin); K=16; WARM=4000000; LEN=8388608
declare -A WT=( [base]=$W/split/w/6m-q4-fp32.tfwc2 [Afull]=$W/split/w/6m-q4-fp32-Afull.tfwc2 [ext]=$W/split/w/6m-q4-fp32-ext.tfwc2 )
for tag in base Afull ext; do for k in 3 7 11 15; do
  ( s=$((N * k / K)); from=$((s - WARM)); e=$((s + LEN)); d=$L/r.$tag.c$k; rm -rf $d; mkdir -p $d; cd $d
    dd if=$U/stream.bin of=in.bin iflag=skip_bytes,count_bytes skip=$from count=$((e - from)) bs=4M status=none
    TF_LINEAR_DUMP=dump.f32 $L/cmix -n in.bin x.cmix --raw-stream --official-vocab --transformer ${WT[$tag]} > log 2>&1
    rc=$?
    tail -c $((LEN * 8 * 16)) dump.f32 > $D/$tag.c$k.f32
    echo "$(date -u) $tag c$k rc $rc dump $(stat -c %s dump.f32) kept $(stat -c %s $D/$tag.c$k.f32)"
    rm -f dump.f32 in.bin ppm.*temp* ) &
done; done
wait
DUMP=$D /workspace/train/.venv/bin/python $W/agent/n3/n3_analyze.py
echo "$(date -u) all done"; echo "exit 0"
