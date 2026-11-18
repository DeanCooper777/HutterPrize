#!/bin/bash
# neif_trace_cmp.sh NAME REF: compare the "neif_trace POS BITS OUT" lines (NEIF_T_TRACE) of the
# chunk run /work/chunks/NAME (may still be running) with those of the finished run REF, over the
# positions both have: coded bits (3 decimals) and coder output bytes must agree at every one.
C=/root/noble/work/chunks
grep neif_trace $C/$1/log > /tmp/tr_a.txt; grep neif_trace $C/$2/log > /tmp/tr_b.txt
n=$(wc -l < /tmp/tr_a.txt); m=$(wc -l < /tmp/tr_b.txt); k=$((n < m ? n : m))
if cmp -s <(head -n $k /tmp/tr_a.txt) <(head -n $k /tmp/tr_b.txt); then
  echo "$1 vs $2: the first $k trace lines are IDENTICAL; last: $(head -n $k /tmp/tr_a.txt | tail -n 1)"
else
  echo "$1 vs $2: trace lines DIFFER:"; diff <(head -n $k /tmp/tr_a.txt) <(head -n $k /tmp/tr_b.txt) | head -n 6
fi
