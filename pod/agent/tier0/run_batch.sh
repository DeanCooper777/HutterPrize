#!/bin/bash
# GPU pod: stage the Tier 0 sample locally, then for each spec "TAG CKPT REF [ENV..]":
# export check (exported .tfwc2 md5 vs /workspace/tier0/ckpt/REF.tfwc2) and tier0.py.
# Ends with "exit 0" for selfstop.sh.   usage: bash run_batch.sh SPECFILE
W=/workspace; PY=$W/train/.venv/bin
mkdir -p /root/t0w /root/s64; cp -r $W/opt/pysrc /root/t0w/; cp $W/agent/tier0/tier0.py /root/t0w/
echo "$(date -u) staging"; cp $W/tier0/s64/* /root/s64/; echo "$(date -u) staged"
cd /root/t0w; export PYTHONPATH=. DATA=/root/s64 OMP_NUM_THREADS=16
while read -r tag ck ref envs; do
  [ -z "$tag" ] && continue
  echo "=== $(date -u) $tag $envs"
  [ -s $W/tier0/results/$tag.json ] && { echo "have $tag"; continue; }
  if grep -q "export check $tag: SAME" $W/tier0/export_ok.txt 2>/dev/null; then echo "export check $tag: SAME (earlier)"; else
  env $envs EXPORT_MODEL=$ck EXPORT_OUTPUT=/root/t0w/$tag.tfw $PY/python -m pysrc.export_weights > /root/t0w/$tag.export.log 2>&1 \
   && $PY/python -m pysrc.weights_compress compress /root/t0w/$tag.tfw /root/t0w/$tag.tfwc2 >> /root/t0w/$tag.export.log 2>&1
  a=$(md5sum < /root/t0w/$tag.tfwc2 | cut -c1-32); b=$(md5sum < $W/tier0/ckpt/$ref.tfwc2 | cut -c1-32)
  [ "$a" = "$b" ] && echo "export check $tag: SAME as $ref" | tee -a $W/tier0/export_ok.txt || echo "export check $tag: DIFFERENT from $ref ($(stat -c%s /root/t0w/$tag.tfwc2) vs $(stat -c%s $W/tier0/ckpt/$ref.tfwc2))"
  fi
  env $envs $PY/python tier0.py $ck $tag 2>&1 | grep -v Warning
  echo "rc $?"
done < "$1"
echo "$(date -u) all done"
echo "exit 0"
