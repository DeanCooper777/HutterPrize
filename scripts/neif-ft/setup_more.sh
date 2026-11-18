#!/bin/bash
# setup_more.sh: testing tool (not part of any submitted program).
# Adds the small pure-Python packages the authors' trainer modules import at load time
# (packaging, tqdm, pytorch-optimizer) to the private venv, then tries the imports the
# weight round trip needs.
R=/root/neif-ft
PY=$R/venv/bin/python
export UV_CACHE_DIR=$R/uvcache
$R/bin/uv pip install --python $PY packaging tqdm "triton==3.7.1" 2>&1 | tail -4   # triton 3.9 breaks fla-core 0.5.1; 3.7.1 is the version of the authors
$R/bin/uv pip install --python $PY --no-deps pytorch-optimizer 2>&1 | tail -2
export TFT_TREE=$R/tft PYTHONDONTWRITEBYTECODE=1 OMP_NUM_THREADS=1
cd /mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev/training/tf/3_train/tree
$PY -c "
import torch
from fla.ops.attnres import fused_attnres; print('fla.ops.attnres ok')
import rx3a, rx3, arch; print('rx3a, rx3, arch ok')
from tft import export_weights_poc; print('export_weights_poc ok')
" 2>&1 | tail -8
