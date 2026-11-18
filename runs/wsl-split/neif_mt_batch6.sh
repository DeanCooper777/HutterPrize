#!/bin/bash
# neif_mt_batch6.sh: the runs the review of the S4 result asked for (runs/neif-par/PROGRESS.md): two windows
# outside the plain page text, where some bytes cannot be speculated (identity with faults, coder and
# decoder), then the fault-rate bracket on the 60 M window.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
rep() { for n in "$@"; do echo "$n: $(tr '\r' '\n' < /root/noble/work/chunks/$n/log | grep -a 'neif_mt spec' | cut -c1-200)"; done; }
MT_TAG=m MS=12950000 ME=13050000 MW=50000 bash $W/neif_mt_batch.sh meta
rep m_ts2f m_us2f m_us1
MT_TAG=n MS=2000000 ME=2100000 MW=50000 bash $W/neif_mt_batch.sh meta
rep n_ts2f n_us2f n_us1
bash $W/neif_mt_batch.sh bracket
rep y_ts1f230 y_ts2f230 y_ts1f320 y_ts2f320
