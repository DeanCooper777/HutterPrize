#!/bin/bash
# step2_roundtrip.sh: testing tool (not part of any submitted program).
# Weight-level identity round trip of the cmix-neif 2.0 transformer, CPU only, one thread:
#   shipped_as_v5.c5 (from step1_tov5.sh)
#     -> container_to_tch.py --strict start.tch --qrow alloc.npz        (the trainable form)
#     -> export_v3_ar.py (reference weight file FX2TFW01)               (the authors' export, on CPU)
#     -> export4/export.sh (bf16, v3, prune, v4) -> convert_container_v5.py
#     -> np2_container.py np ... k fw np2 dead                           (NP2 again)
#   and compares each container with the shipped one.
# Usage: step2_roundtrip.sh [tch] [export] [rope] [c5] [np2] [cmp]   (default: all)
set -u
D=/mnt/c/Dean/Projects/HutterPrize
N=$D/reference/neif2/dev
T3=$N/training/tf/3_train
W=$D/runs/neif-ft
S=$D/scripts/neif-ft
R=/root/neif-ft
PY=$R/venv/bin/python
SHIP=$N/weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5
STAGES="${*:-tch export rope c5 np2 cmp}"

# the environment of the shipped chain (reproduce.sh), without a training package
mkdir -p $W/pkgstub
cp -f $N/training/tf/2_package/vocab-bitmap.u8 $W/pkgstub/
export TFT_TREE=$R/tft
export TFT_GEOMETRY=poc8m_w2048 TFT_DATA_DIR=$W/pkgstub TFT_MMAP=1 ZCTX_ARM=pkd ZCTX_SEED=20260901 \
  PK_LAST_X0ROW=1 PK_REDIRMERGE=1 PK_SLOT_DIM=16 TFT_OPTIMIZER_BATCH_TOKENS=1048576 TFT_MICRO_BATCH_TOKENS=131072 \
  OMP_NUM_THREADS=1 MKL_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 NUMEXPR_NUM_THREADS=1
export CUDA_VISIBLE_DEVICES=
# no package here: the manifest fields of the sidecar come from the environment (not used by the container)
export PK_EXPORT_OHNE_PAKET=1
export PYTHONDONTWRITEBYTECODE=1

for s in $STAGES; do
  echo "===== stage $s  $(date '+%F %T')"
  case $s in
  tch)
    ( cd $T3 && nice -n 19 $PY container_to_tch.py --container $W/shipped_as_v5.c5 \
        --cfg $T3/chain/00_start_arch.json --strict $W/start.tch --qrow $W/alloc.npz \
        --report $W/start_conv.json ) || exit 1
    grep -q '"mismatch": 0' $W/start_conv.json && echo "integer check: mismatch 0" || { echo "INTEGER CHECK FAILED"; exit 1; }
    ;;
  export)
    mkdir -p $W/export/raw
    # 08_export.json with <W> replaced and "mixed" = the allocation rebuilt from the container
    $PY - $T3/chain/08_export.json $W/export/cfg.json $W <<'PYEOF' || exit 1
import json, sys
c = json.load(open(sys.argv[1]))
c["out"] = sys.argv[3] + "/export"
c["mixed"] = sys.argv[3] + "/alloc.npz"
json.dump(c, open(sys.argv[2], "w"), indent=1)
PYEOF
    ( cd $T3/export && EXPORT_DEVICE=cpu nice -n 19 $PY export_v3_ar.py $W/export/cfg.json $W/start.tch $W/export/raw ) || exit 1
    ;;
  rope)
    # the export ran on a CPU: its RoPE tables are not the CUDA tables the container format expects
    # (see rope_fix.py); replace them by the authors' own emulation of the CUDA tables
    mkdir -p $W/export/rawfix
    nice -n 19 $PY -I $S/rope_fix.py $W/export/raw/weights-poc8m_w2048.bin $W/export/rawfix/weights-poc8m_w2048.bin $W/shipped_as_v5.c5 || exit 1
    cp -f $W/export/raw/weights-poc8m_w2048.bin.json $W/export/rawfix/
    ;;
  c5)
    rm -rf $W/export/c4; mkdir -p $W/export/c4
    TREE=$TFT_TREE PYTHON=$PY nice -n 19 bash $T3/export/export4/export.sh $W/export/rawfix/weights-poc8m_w2048.bin $W/export/c4 || exit 1
    rm -f $W/export/v5.c5
    PYTHONPATH=$TFT_TREE nice -n 19 $PY $T3/export/export4/convert_container_v5.py $W/export/c4/weights-poc8m_w2048_pruned_v4.c4 $W/export/v5.c5 || exit 1
    ;;
  np2)
    rm -f $W/roundtrip_np2.c5
    nice -n 19 $PY $T3/export/np2/np2_container.py np $W/export/v5.c5 $W/roundtrip_np2.c5 k fw np2 dead || exit 1
    ;;
  cmp)
    ( cd $W && sha256sum shipped_as_v5.c5 export/raw/weights-poc8m_w2048.bin export/rawfix/weights-poc8m_w2048.bin export/c4/*.c3 export/c4/*.c4 export/v5.c5 roundtrip_np2.c5 )
    sha256sum $SHIP
    cmp $SHIP $W/roundtrip_np2.c5 && echo "roundtrip_np2.c5 BYTE IDENTICAL to the shipped container"
    echo "-- v5 from the export against the shipped tensors"
    nice -n 19 $PY -I $S/np2_roundtrip.py cmp $W/shipped_as_v5.c5 $W/export/v5.c5
    echo "-- NP2 from the export against the shipped container"
    nice -n 19 $PY -I $S/np2_roundtrip.py cmp $SHIP $W/roundtrip_np2.c5
    ;;
  esac
done
echo "===== done $(date '+%F %T')"
