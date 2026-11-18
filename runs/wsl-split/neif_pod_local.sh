#!/bin/bash
# neif_pod_local.sh SCRIPT [ARGS...]: run one of the pod scripts (neif_split_eval.sh, neif_pod_scale.sh,
# neif_pod_run.sh, neif_pod_setup.sh) on THIS PC as it would run on a pod: inside the chroot
# /root/noble with NEIF_ROOT=/work/pod, whose build/tbN, build/tbK, build/tbKM point at the local test
# builds /work/tbN, /work/tbK, /work/tbKM and whose stream.bin is /work/bed/stream.bin. The scripts are
# copied from runs/wsl-split on every start. The environment is passed on. For smoke tests only:
# one large cmix at a time on this PC.
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
C=/root/noble
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
mkdir -p $C/work/pod/scripts $C/work/pod/build
for f in neif_pod_setup.sh neif_pod_run.sh neif_split_eval.sh neif_pod_scale.sh neif_cpusets.py; do cp $W/$f $C/work/pod/scripts/; done
for d in tbN:orig tbK:packed tbKM:packed+mt; do
  b=${d%%:*}; ln -sfn /work/$b $C/work/pod/build/$b; echo "${d#*:}" > $C/work/$b/FLAVOUR
done
ln -sf /work/bed/stream.bin $C/work/pod/stream.bin
S=$1; shift
NEIF_ROOT=/work/pod chroot $C /bin/bash /work/pod/scripts/$S "$@"
