#!/bin/bash
# neif_a16_proftab.sh NAME: the per-site time table (FX2_PROF build) of chunk run NAME.
L=/root/noble/work/chunks/${1:?name}/log
grep -a -A 45 "per-part profile" $L
grep -a "tf_rows\|model_seconds" /root/noble/work/chunks/$1/score.json
