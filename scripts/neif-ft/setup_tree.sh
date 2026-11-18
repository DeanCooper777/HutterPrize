#!/bin/bash
# setup_tree.sh: testing tool (not part of any submitted program).
# (1) adds fla-core 0.5.1 (the package that holds fla.ops / fla.modules) to the private venv, without
#     its dependencies, and reports whether fla.ops.attnres and the three names pysrc/model.py imports exist;
# (2) assembles the authors' training tree as training/README.md section 1 says
#     (tree_upstream + tree_overlay + patch_paket11.py) in /root/neif-ft/tft, from the dev tree (read only).
set -u
R=/root/neif-ft
N=/mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev
PY=$R/venv/bin/python
export UV_CACHE_DIR=$R/uvcache
SP=$R/venv/lib/python3.11/site-packages
$R/bin/uv pip install --python $PY --no-deps "fla-core==0.5.1" 2>&1 | tail -3
ls $SP/fla
ls $SP/fla/ops | tr '\n' ' '; echo
ls $SP/fla/ops/attnres 2>/dev/null || echo "NO fla/ops/attnres in fla-core 0.5.1"
grep -i '^Requires-Dist' $SP/fla_core-0.5.1.dist-info/METADATA
$PY -c "from fla.ops.kda import chunk_kda; print('fla.ops.kda ok')" 2>&1 | tail -1
$PY -c "from fla.modules import FusedRMSNormGated; print('fla.modules ok')" 2>&1 | tail -1
$PY -c "from fla.modules.conv.causal_conv1d import causal_conv1d; print('causal_conv1d ok')" 2>&1 | tail -1
$PY -c "from fla.ops.attnres import fused_attnres; print('fla.ops.attnres ok')" 2>&1 | tail -1

echo "== training tree"
rm -rf $R/tft
mkdir -p $R/tft
cp -a $N/training/tf/tree_upstream/. $R/tft/
cp -a $N/training/tf/tree_overlay/. $R/tft/
( cd $R/tft && $PY $N/training/tf/2_package/patch_paket11.py $R/tft 2>&1 | tail -15 )
ls $R/tft | tr '\n' ' '; echo
