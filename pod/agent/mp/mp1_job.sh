#!/bin/bash
# GPU pod: mixed-precision QAT test 1 (5 most tolerant groups from the scan at 3-bit)
RUN_DIR=/workspace/mp1 A_BITS_MAP="L10.attn=7,L11.mlp=7,L08.attn=7,L06.mlp=7,L02.mlp=7" bash /workspace/agent/mp/run_mp.sh
echo "rc $?"; echo "$(date -u) done"; echo "exit 0"
