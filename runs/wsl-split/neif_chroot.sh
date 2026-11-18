#!/bin/bash
# Ubuntu 24.04 (noble) chroot inside the WSL distro for building cmix-neif 2.0, whose toolchain is
# pinned to 24.04 packages (its install.sh repoints apt to a dated snapshot, which must not happen
# to the WSL system itself).   neif_chroot.sh setup | sh 'command...'
# The chroot is /root/noble; the cmix-neif source is copied to /root/noble/work/neif2.
set -eu
C=/root/noble; P=/mnt/c/Dean/Projects/HutterPrize
mounts() { for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done; cp -f /etc/resolv.conf $C/etc/resolv.conf; }
case ${1:-} in
  setup)
    command -v debootstrap > /dev/null || { apt-get update -q > /dev/null; apt-get install -y -q debootstrap > /dev/null; }
    [ -x $C/bin/bash ] || debootstrap --variant=minbase noble $C http://archive.ubuntu.com/ubuntu > /root/debootstrap.log 2>&1
    mounts
    mkdir -p $C/work; rm -rf $C/work/neif2; git clone --depth 1 -q https://github.com/marwoelk/cmix-neif-2.0.git $C/work/neif2
    chroot $C /bin/bash -c "cat /etc/os-release | grep PRETTY; ls /work/neif2 | head -n 5"
    ;;
  sh) shift; mounts; chroot $C /bin/bash -c "cd /work/neif2 && $*" ;;
  *) echo "usage: neif_chroot.sh setup | sh 'command'"; exit 1 ;;
esac
