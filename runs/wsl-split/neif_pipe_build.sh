#!/bin/bash
# neif_pipe_build.sh: keep the build log of the previous test build as the baseline for the count of
# profile mismatches (once), then build the PGO test binary into /work/tbp and list the functions
# whose profile is discarded now and was not in the baseline.
C=/root/noble
[ -f $C/work/tbp_base_build.log ] || cp $C/work/tbp/build.log $C/work/tbp_base_build.log
bash /mnt/c/Dean/Projects/HutterPrize/runs/wsl-split/neif_build_test.sh /work/tbp pgo || exit 1
grep -o 'hash mismatch) [^ ]*' $C/work/tbp_base_build.log | sort > /tmp/neif_mm_base.txt
grep -o 'hash mismatch) [^ ]*' $C/work/tbp/build.log | sort > /tmp/neif_mm_new.txt
echo "profile mismatches: baseline $(wc -l < /tmp/neif_mm_base.txt), now $(wc -l < /tmp/neif_mm_new.txt); new ones:"
comm -13 /tmp/neif_mm_base.txt /tmp/neif_mm_new.txt
grep -n "warning:" $C/work/tbp/build.log | grep -v "hash mismatch\|no profile data\|profile data may be" | head -n 20
