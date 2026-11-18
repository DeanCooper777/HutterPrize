#!/bin/bash
# setup_venv.sh: testing tool (not part of any submitted program).
# Makes a private CPU-only Python 3.11 environment in /root/neif-ft/venv inside WSL for the
# weight round-trip check of the cmix-neif 2.0 transformer (torch CPU build, numpy, jaxtyping,
# and, if they install, flash-linear-attention and triton).  Installs no system packages:
# the "uv" tool and the Python it downloads live under /root/neif-ft only.
set -u
R=/root/neif-ft
mkdir -p $R/bin
export UV_INSTALL_DIR=$R/bin UV_NO_MODIFY_PATH=1 UV_CACHE_DIR=$R/uvcache UV_PYTHON_INSTALL_DIR=$R/python
if [ ! -x $R/bin/uv ]; then
  curl -LsSf https://astral.sh/uv/install.sh -o $R/uv_install.sh || exit 1
  sh $R/uv_install.sh || exit 1
fi
UV="nice -n 19 $R/bin/uv"
[ -x $R/venv/bin/python ] || $UV venv --python 3.11 $R/venv || exit 1
PY=$R/venv/bin/python
echo "== torch (CPU build)"
$UV pip install --python $PY --index-url https://download.pytorch.org/whl/cpu "torch>=2.12.0,<2.13" \
  || $UV pip install --python $PY --index-url https://download.pytorch.org/whl/cpu torch
echo "== numpy, jaxtyping"
$UV pip install --python $PY "numpy>=2.4.6" jaxtyping
echo "== optional: einops, flash-linear-attention 0.5.1 (no deps), triton"
$UV pip install --python $PY einops
$UV pip install --python $PY --no-deps "flash-linear-attention==0.5.1"
$UV pip install --python $PY triton
echo "== result"
$PY -c "import sys, torch, numpy; print(sys.version); print('torch', torch.__version__, 'numpy', numpy.__version__)"
$PY -c "import jaxtyping; print('jaxtyping ok')"
$PY -c "import fla; print('fla', getattr(fla, '__version__', '?'), fla.__file__)"
$PY -c "import triton; print('triton', triton.__version__)"
$PY -c "import fla.ops.attnres as a; print('fla.ops.attnres', a.__file__)"
$PY -c "from fla.ops.kda import chunk_kda; from fla.modules import FusedRMSNormGated; from fla.modules.conv.causal_conv1d import causal_conv1d; print('fla kda imports ok')"
$UV pip list --python $PY 2>/dev/null | head -60
