#!/bin/bash
# Local (WSL) version of the pod's K=16 split eval for chosen chunks.
#   split_local.sh TAG WEIGHTS.tfwc2 "CHUNKS"     (CHUNKS e.g. "15" or "0 1 2")
# Same binary (pod's split/bin_k3/cmix), same command line, same scoring as agent/k3/split_eval_k3.sh.
set -u
TAG=$1; WEIGHTS=$2; CHUNKS=$3; K=16; WARM=4000000
P=/mnt/c/Dean/Projects/HutterPrize; SRC=$P/runs/wsl-split; L=/root/split; OUT=$SRC/out/$TAG
mkdir -p $L $OUT
[ -x $L/cmix ] || { cp $SRC/cmix_k3 $L/cmix; chmod +x $L/cmix; }
[ -s $L/stream.bin ] || gunzip -c $P/runs/upload/stream.bin.gz > $L/stream.bin
cp $WEIGHTS $L/$TAG.tfwc2
N=$(stat -c %s $L/stream.bin)
for k in $CHUNKS; do
  s=$((N * k / K)); e=$((N * (k + 1) / K)); from=$((s > WARM ? s - WARM : 0))
  (
    d=$L/$TAG/c$k; rm -rf $d; mkdir -p $d $OUT/c$k; cd $d || exit 1
    dd if=$L/stream.bin of=in.bin iflag=skip_bytes,count_bytes skip=$from count=$((e - from)) bs=4M status=none || exit 1
    t0=$(date +%s)
    CMIX_TF_THREADS=1 $L/cmix -n in.bin x.cmix --raw-stream --official-vocab --transformer $L/$TAG.tfwc2 --save-cmix-bits bits.f16 > log 2>&1
    rc=$?; secs=$(( $(date +%s) - t0 )); cp log $OUT/c$k/log
    [ $rc -eq 0 ] || { echo "chunk $k: cmix exit $rc"; exit 1; }
    python3 - "$from" "$s" "$e" "$(stat -c %s x.cmix)" "$secs" "$OUT/c$k" <<'PY' || exit 1
import json, sys
import numpy as np
frm, s, e, xsize, secs = map(int, sys.argv[1:6])
out = sys.argv[6]
data = np.fromfile("in.bin", np.uint8)
logit = np.fromfile("bits.f16", np.float16).astype(np.float64)
assert data.size == e - frm and logit.size == 8 * data.size, (data.size, logit.size)
bits = np.unpackbits(data)
y = np.where(bits == 1, 1.0, -1.0)
cost = np.logaddexp(0.0, -y * logit) / np.log(2)
per_byte = cost.reshape(-1, 8).sum(1)
keep = s - frm
r = dict(start=s, end=e, warm_from=frm, seconds=secs, cmix_bytes=xsize, all_bits=float(per_byte.sum()),
         kept_bits=float(per_byte[keep:].sum()), kept_bytes_est=float(per_byte[keep:].sum() / 8))
json.dump(r, open(out + "/score.json", "w"), indent=1); print(json.dumps(r))
PY
    rm -f bits.f16 in.bin ppm.*temp*
  ) > $OUT/c$k.runlog 2>&1 &
done
wait
echo "$(date) $TAG done"; cat $OUT/c*/score.json 2>/dev/null | tr -d '\n'; echo
