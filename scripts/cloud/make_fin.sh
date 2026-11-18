#!/bin/bash
# make_fin.sh: assemble a source tarball for a full-length test in which the chosen experiment
# settings are written into the source as defaults, so that the run needs neither CMIX_ACT16
# nor a CMIX_TUNE file (the official build ignores both). It patches three defaults of the
# snapshot it unpacks: the 16-bit-activation mask, dyn_lr and dyn_fx. The grep -c lines print
# how many places each pattern matched, as a check that the patch applied.
#
# Testing: an experiment / testing tool for rented cloud machines; not part of the submitted
# programs. New in this entry.
# (Original notes follow.)
# Assemble the "fin" source tarball on the volume (run on a pod):
#   k3 source + k4 overlay (16-bit mlp.up and q/k/v inputs) + C2 weights, with the chosen
#   settings folded into the DEFAULTS (no CMIX_ACT16 / CMIX_TUNE needed at run time).
#   make_fin.sh ACT16 DYN_LR DYN_FX      e.g.  make_fin.sh 7 7.7e-4 1
# Output /workspace/sub/fin_src.tar.gz and /workspace/sub/fin_src.txt (what went in).
set -eu
ACT=${1:?act16}; LR=${2:?dyn_lr}; FX=${3:?dyn_fx}
S=/workspace/sub; T=/root/fin_mk
rm -rf $T && mkdir -p $T && cd $T
tar xzf $S/k3_src.tar.gz
(cd fx2-cmix-T && tar xzf $S/k4_overlay.tar.gz)
cp /workspace/split/w/c2.tfwc2 fx2-cmix-T/models/6m-q4-fp32.tfwc2
cd fx2-cmix-T
grep -c "int act16 = 3;" cpp_infer/src/opt/arena_build.h
sed -i "s/int act16 = 3;/int act16 = $ACT;/" cpp_infer/src/opt/arena_build.h
grep -c 'tune::Get("dyn_lr", 3e-4)' src/predictor.cpp
sed -i "s/tune::Get(\"dyn_lr\", 3e-4)/tune::Get(\"dyn_lr\", $LR)/" src/predictor.cpp
grep -c 'tune::Get("dyn_fx", 0)' src/predictor.cpp
sed -i "s/tune::Get(\"dyn_fx\", 0)/tune::Get(\"dyn_fx\", $FX)/" src/predictor.cpp
grep -n "int act16 = " cpp_infer/src/opt/arena_build.h
grep -n 'tune::Get("dyn_lr"\|tune::Get("dyn_fx"' src/predictor.cpp
cd $T
tar czf $S/fin_src.tar.gz fx2-cmix-T
{ date -u; echo "act16 $ACT dyn_lr $LR dyn_fx $FX"; md5sum fx2-cmix-T/models/6m-q4-fp32.tfwc2; md5sum $S/fin_src.tar.gz; } | tee $S/fin_src.txt
