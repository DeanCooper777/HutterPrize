#!/bin/bash
# env_probe.sh: testing tool (not part of any submitted program).
# Shows which Python, torch and numpy the WSL host has, free disk and memory, and running large processes.
which python3 python3.11 python3.12 uv 2>/dev/null
python3 --version
python3 -c "import numpy; print('numpy', numpy.__version__)" 2>&1 | tail -1
python3 -c "import torch; print('torch', torch.__version__)" 2>&1 | tail -1
python3 -c "import venv, ensurepip; print('venv ok')" 2>&1 | tail -1
ls /root/noble/usr/bin/python3* 2>/dev/null
df -h / /mnt/c 2>/dev/null
free -g | head -2
pgrep -fa 'comp9|cmix' | head
ls /root/neif-ft 2>/dev/null
