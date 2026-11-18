#!/bin/bash
# CPU pod: score cmix tune settings on truncated split-eval chunks (step 2 of option b).
# For each setting NAME (file /workspace/tune/settings/NAME.tune, CMIX_TUNE format; "ref" =
# empty file) and each chunk k in CHUNKS (K=16 split positions), code
# stream[s_k - WARM, s_k + LEN) with ext weights and count the bits of [s_k, s_k + LEN).
# Results /workspace/tune/res/NAME/c$k.json. Runs up to PAR processes at once.
#   bash tune_eval.sh NAME [NAME ...]   (env CHUNKS="3 7 11 15" LEN=8388608 PAR=16)
set -u
W=/workspace; U=$W/upload; K=16; WARM=4000000
CHUNKS=${CHUNKS:-3 7 11 15}; LEN=${LEN:-8388608}; PAR=${PAR:-16}
L=/root/tune; mkdir -p $L; cp $W/split/bin/cmix $L/cmix; cp $W/ext/models/6m-q4-fp32-A.tfwc2 $L/w.tfwc2
N=$(stat -c %s $U/stream.bin)
echo "$(date -u) tune eval: $* chunks=[$CHUNKS] LEN=$LEN nproc=$(nproc) mem=$(free -g | awk '/Mem/{print $2}')G"
run() {  # name k
  local name=$1 k=$2; local s=$((N * k / K)); local from=$((s - WARM)); local e=$((s + LEN))
  local d=$L/$name.c$k o=$W/tune/res/$name; mkdir -p $d $o; cd $d || return 1
  [ -s $o/c$k.json ] && return 0
  dd if=$U/stream.bin of=in.bin iflag=skip_bytes,count_bytes skip=$from count=$((e - from)) bs=4M status=none
  local t0=$(date +%s)
  CMIX_TUNE=$W/tune/settings/$name.tune $L/cmix -n in.bin x.cmix --raw-stream --official-vocab \
      --transformer $L/w.tfwc2 --save-cmix-bits bits.f16 > log 2>&1 || { echo "$name c$k rc $?"; tail -3 log; return 1; }
  python3 - $from $s $e $(( $(date +%s) - t0 )) $o/c$k.json <<'PY'
import json, sys, numpy as np
frm, s, e, secs = map(int, sys.argv[1:5])
data = np.fromfile("in.bin", np.uint8); logit = np.fromfile("bits.f16", np.float16).astype(np.float64)
assert data.size == e - frm and logit.size == 8 * data.size
y = np.where(np.unpackbits(data) == 1, 1.0, -1.0)
pb = (np.logaddexp(0.0, -y * logit) / np.log(2)).reshape(-1, 8).sum(1)
B = 1 << 20
json.dump(dict(start=s, end=e, warm_from=frm, seconds=secs, kept_bytes=float(pb[s - frm:].sum() / 8),
               bins=np.add.reduceat(pb, np.arange(0, pb.size, B)).tolist()), open(sys.argv[5], "w"))
PY
  rm -f bits.f16 in.bin ppm.*temp*; echo "$(date -u) $name c$k done"
}
for name in "$@"; do [ -f $W/tune/settings/$name.tune ] || { echo "no settings file $name"; exit 1; }; done
for name in "$@"; do for k in $CHUNKS; do
  while [ $(jobs -rp | wc -l) -ge $PAR ]; do sleep 20; done
  run $name $k &
done; done
wait
echo "$(date -u) all done"
