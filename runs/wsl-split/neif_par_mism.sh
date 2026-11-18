#!/bin/bash
# neif_par_mism.sh BUILD_DIR...: the functions whose PGO profile entry was discarded (hash mismatch) in each test build
for b in "$@"; do
  echo "== $b: $(grep -c 'hash mismatch' /root/noble$b/build.log) mismatches"
  grep 'hash mismatch' /root/noble$b/build.log | sed 's/.*(hash mismatch) //; s/ Hash.*//' | sort | tr '\n' ' '; echo
done
