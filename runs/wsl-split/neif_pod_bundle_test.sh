#!/bin/bash
# neif_pod_bundle_test.sh [CHECK]: unpack the pod bundle inside the chroot /root/noble (Ubuntu 24.04,
# the compiler is already there) as /work/podtest/neif and run its setup script as a pod would
# (all steps; CHECK=quick by default: the 36 k chunk only). Proves the bundle is complete.
C=/root/noble
W=/mnt/c/Dean/Projects/HutterPrize/runs/wsl-split
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
rm -rf $C/work/podtest; mkdir -p $C/work/podtest
tar xf $W/pod_bundle/neif_pod_bundle.tar -C $C/work/podtest
CHECK=${1:-quick} chroot $C /bin/bash /work/podtest/neif/scripts/neif_pod_setup.sh
rc=$?
rm -f $C/work/podtest/neif/stream.bin
echo "bundle test exit $rc"
