#!/bin/bash
# One-off (2026-11-07): run chunks 0-10 of `datagen.sh bits 12` while the
# already-running chunk 11 (pid $1) finishes, mark it done, then concatenate.
cd /workspace
ONLY="0 1 2 3 4 5 6 7 8 9 10" bash scripts/datagen.sh bits 12 > logs/bits_job.txt 2>&1 &
c=/root/run/bits/c11
while kill -0 "$1" 2> /dev/null; do sleep 30; done
read -r from s e < $c/range
if [ "$(stat -c %s $c/bits.f16)" -eq $(((e - from) * 16)) ]; then
  touch $c/done
else
  echo "chunk 11 incomplete" >> logs/bits_job.txt
fi
wait
bash scripts/datagen.sh concat 12 >> logs/bits_job.txt 2>&1
echo "exit $?" >> logs/bits_job.txt
