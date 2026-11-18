#!/bin/bash
# fla_probe.sh: testing tool (not part of any submitted program).
# Lists what the PyPI package flash-linear-attention 0.5.1 installed (open question 1 of the plan:
# does it contain fla.ops.attnres?).
SP=/root/neif-ft/venv/lib/python3.11/site-packages
ls $SP | head -50
cat $SP/flash_linear_attention-0.5.1.dist-info/RECORD | head -40
grep -c . $SP/flash_linear_attention-0.5.1.dist-info/RECORD
grep -i 'attnres\|kda\|causal_conv\|ops/__init__\|modules/__init__' $SP/flash_linear_attention-0.5.1.dist-info/RECORD | head -40
grep -i '^Requires\|^Version\|^Home\|^Project' $SP/flash_linear_attention-0.5.1.dist-info/METADATA
