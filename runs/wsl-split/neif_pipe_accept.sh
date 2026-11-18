#!/bin/bash
# neif_pipe_accept.sh: the acceptance runs of the pipeline, one after the other, with the test
# binary in /work/tbp: chunk (a) from stream byte 0 into page text (0..15,400,000; the first page
# starts at about 15.28 M) and chunk (b) in the middle of the stream, each with NEIF_PIPE = 3, 0, 2;
# then the comparison of the (a) outputs with the prefix of the official comp9's coder output.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
sha256sum /root/noble/work/tbp/cmix
bash $W/neif_pipe_seq.sh 0 15400000 0 a "3 0 2" 501070
bash $W/neif_cmp_off.sh a3 a0 a2
bash $W/neif_trace_cmp.sh a0 AP
bash $W/neif_pipe_seq.sh 250000000 250300000 1200000 b "3 0 2"
