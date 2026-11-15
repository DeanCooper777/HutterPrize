#!/bin/bash
# CPU pod: build the N3 cmix (TF_LINEAR_DUMP), then for base/Afull/ext x chunks 3,7,11,15
# (K=16 positions, 4M warm + 8 MiB scored) dump per-bit (z_preSSE, x_tf, w_eff, p_final)
# for the scored region to /workspace/n3/dump/TAG.cK.f32. Ends with "exit 0".
set -u
W=/workspace; L=/root/n3; mkdir -p $L $W/n3/dump
CLANG=clang++-22
if ! command -v $CLANG > /dev/null; then
  apt-get update > /dev/null; apt-get install -y make wget lsb-release software-properties-common gnupg > /dev/null
  wget -q https://apt.llvm.org/llvm.sh; bash llvm.sh 22 > /dev/null; rm llvm.sh
fi
rm -rf $L/src && mkdir -p $L/src && tar xzf $W/n3/src_n3.tar.gz -C $L/src
(cd $L/src/fx2-cmix-T && make CC=$CLANG CFLAGS_DEFINES="-DSEED=923 -DUPDATE_LIMIT=3000" cmix > $L/build.log 2>&1) || { echo "build failed"; tail -20 $L/build.log; echo "exit 1"; exit 1; }
cp $L/src/fx2-cmix-T/cmix $L/cmix; cp $L/cmix $W/n3/cmix_n3; echo "$(date -u) build ok"
U=$W/upload; N=$(stat -c %s $U/stream.bin); K=16; WARM=4000000; LEN=8388608
declare -A WT=( [base]=$W/split/w/6m-q4-fp32.tfwc2 [Afull]=$W/split/w/6m-q4-fp32-Afull.tfwc2 [ext]=$W/split/w/6m-q4-fp32-ext.tfwc2 )
for tag in base Afull ext; do for k in 3 7 11 15; do
  ( s=$((N * k / K)); from=$((s - WARM)); e=$((s + LEN)); d=$L/$tag.c$k; mkdir -p $d; cd $d
    dd if=$U/stream.bin of=in.bin iflag=skip_bytes,count_bytes skip=$from count=$((e - from)) bs=4M status=none
    TF_LINEAR_DUMP=dump.f32 $L/cmix -n in.bin x.cmix --raw-stream --official-vocab --transformer ${WT[$tag]} > log 2>&1
    rc=$?
    # keep the scored region: bits [8*WARM, end), 16 bytes per bit
    tail -c $((LEN * 8 * 16)) dump.f32 > $W/n3/dump/$tag.c$k.f32
    echo "$(date -u) $tag c$k rc $rc dump $(stat -c %s dump.f32) x $(stat -c %s x.cmix)"
    rm -f dump.f32 in.bin ppm.*temp* ) &
done; done
wait; echo "$(date -u) all done"; echo "exit 0"
