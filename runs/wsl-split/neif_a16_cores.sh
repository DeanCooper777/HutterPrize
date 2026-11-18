#!/bin/bash
# neif_a16_cores.sh: which logical CPUs are the fast (P) cores: the same small integer loop pinned to each.
for c in $(seq 0 $(($(nproc) - 1))); do
  s=$(date +%s%N)
  taskset -c $c bash -c 'i=0; while [ $i -lt 400000 ]; do i=$((i+1)); done'
  echo "cpu $c: $(( ($(date +%s%N) - s) / 1000000 )) ms"
done
