#!/bin/bash
# neif_mt_batch7.sh: (1) quick check of the validation decode; (2) the speculation with faults from stream byte 0
# (the head of the stream is metadata: forced bytes, prompt rows, gate zones, PPMd restarts, where a speculation
# is refused or a plain step cannot follow; a window cannot start there, the model must start at byte 0);
# (3) the fault-rate bracket on the 60 M window.  Asked for by the review of the S4 result (PROGRESS.md).
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
rep() { for n in "$@"; do echo "$n: $(tr '\r' '\n' < /root/noble/work/chunks/$n/log | grep -a 'neif_mt spec: launched' | cut -c1-200)"; done; }
bash $W/neif_sv_batch.sh quick
MT_TAG=n MS=0 ME=1500000 MW=0 bash $W/neif_mt_batch.sh meta
rep n_ts2f n_us2f n_us1
bash $W/neif_mt_batch.sh bracket
rep y_ts1f230 y_ts2f230 y_ts1f320 y_ts2f320
