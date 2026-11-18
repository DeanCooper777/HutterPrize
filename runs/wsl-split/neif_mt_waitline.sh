#!/bin/bash
# neif_mt_waitline.sh PATTERN [MAX_SECONDS]: wait until a line matching PATTERN is in
# /root/noble/work/mt_results.txt (or the time is over), then print the lines of the last hour's batch
# that match PREFIX (default: the pattern).
P=${1:?}; MAX=${2:-1800}; t=0
until grep -aq "$P" /root/noble/work/mt_results.txt || [ $t -ge $MAX ]; do sleep 10; t=$((t + 10)); done
grep -a "${PREFIX:-$P}" /root/noble/work/mt_results.txt | tail -n 12 | cut -c1-300
