#!/bin/bash
# CPU pod: K=16 split evals of ext weights on the natural-order streams, one after the other
W=/workspace
for v in nat_b nat_a; do
  STREAM=$W/n2/$v.bin bash $W/agent/n2/split_eval_stream.sh n2_$v $W/ext/models/6m-q4-fp32-A.tfwc2 16 | grep -v "^exit"
done
echo "exit 0"
