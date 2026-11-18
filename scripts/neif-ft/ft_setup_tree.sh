#!/bin/bash
# ft_setup_tree.sh: testing tool (not part of any submitted program).
# Makes the patched copies for the fine-tune pilot of the cmix-neif 2.0 transformer and runs
# the CPU unit tests (small, one thread):
#   $R/ft/tft    copy of the assembled training tree ($R/tft, see setup_tree.sh)
#   $R/ft/tree   copy of training/tf/3_train/tree with mixloss.py
# Usage: ft_setup_tree.sh [test]     (R, N, S from the environment; defaults for this PC's WSL)
set -eu
R=${R:-/root/neif-ft}
N=${N:-/mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev}
S=${S:-/mnt/c/Dean/Projects/HutterPrize/scripts/neif-ft}
PY=${PY:-$R/venv/bin/python}
export OMP_NUM_THREADS=1 MKL_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 PYTHONDONTWRITEBYTECODE=1 CUDA_VISIBLE_DEVICES=
rm -rf $R/ft
mkdir -p $R/ft
cp -a $R/tft $R/ft/tft
cp -a $N/training/tf/3_train/tree $R/ft/tree
$PY -I $S/patch_ft_tree.py $R/ft/tft $R/ft/tree
$PY -I $S/patch_ft_tree.py $R/ft/tft $R/ft/tree --check     # second pass: nothing left to do
( cd $R/ft && diff -ru $R/tft tft > ft_tft.diff || true; diff -ru $N/training/tf/3_train/tree tree > ft_tree.diff || true
  grep -c '^[+-][^+-]' ft_tft.diff ft_tree.diff )
$PY -m py_compile $R/ft/tree/rx7r.py $R/ft/tree/rx3a.py $R/ft/tree/mixloss.py $R/ft/tft/pysrc/train.py \
  $R/ft/tft/pysrc/data.py $R/ft/tft/zctx/zpdump.py && echo "patched files compile"
if [ "${1:-}" = test ]; then
  cp -f $S/test_mixloss.py $S/test_loader_bits.py $R/ft/tree/
  ( cd $R/ft/tree && TFT_TREE=$R/ft/tft nice -n 19 $PY test_mixloss.py $N/training/tf/2_package/vocab-bitmap.u8 )
  ( cd $R/ft/tree && TFT_TREE=$R/ft/tft nice -n 19 $PY test_loader_bits.py 2>&1 | grep -v "^articles\|^dump loader" )
fi
