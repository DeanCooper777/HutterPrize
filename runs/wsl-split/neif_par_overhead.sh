#!/bin/bash
# neif_par_overhead.sh [CPU]: the cost of the NEIF_PAR instrumentation on the short timing window
# (60.0-60.5 M, warm 100 k; the window of neif_a16_time.sh): the build without the per-site table
# (/work/tbpar0) with NEIF_PAR off, on, off again, and the measuring build (/work/tbpar, FX2_PROF)
# with NEIF_PAR on.  One line per run in /root/noble/work/par_results.txt.  About 20 min.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
CPU=${1:-2}
bash $W/neif_par_one.sh par_ov_a 60000000 60500000 100000 /work/tbpar0 0 $CPU
bash $W/neif_par_one.sh par_ov_b 60000000 60500000 100000 /work/tbpar0 1 $CPU
bash $W/neif_par_one.sh par_ov_c 60000000 60500000 100000 /work/tbpar 1 $CPU
bash $W/neif_par_one.sh par_ov_d 60000000 60500000 100000 /work/tbpar0 0 $CPU
