#!/bin/bash
# neif_a16_look.sh: state of the chroot before the 16-bit activation test (read-only).
C=/root/noble
pgrep -fa comp9; pgrep -fa cmix
free -g | head -n 2
ls -la $C/work/ | head -n 60
ls -la $C/work/bed/ 2>/dev/null
ls -la $C/work/tbp/cmix 2>/dev/null; sha256sum $C/work/tbp/cmix 2>/dev/null
ls -lat $C/work/chunks 2>/dev/null | head -n 30
for d in $(ls -t $C/work/chunks | head -n 4); do echo "== $d"; cat $C/work/chunks/$d/score.json; grep -E "neif_prof|neif_pipe" $C/work/chunks/$d/log | head -n 30; done
diff -rq $C/work/dev/src /mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev/src 2>&1 | head
