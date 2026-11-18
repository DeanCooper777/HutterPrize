#!/bin/bash
# look2.sh: searches the WSL chroot for leftover packer intermediates of official cmix-neif builds (read-only).
# Testing tool for the packer trial; not part of any submitted program.
cd /root/noble/work || exit 1
cat neif2/build.sh | tail -40
echo ==== ; tail -30 b0/build.log
echo ==== ; find / -xdev \( -name "cmix.unpacked" -o -name "cmix.ss" -o -name "pak_pack" -o -name "cmix.cutguard" -o -name "cmix.map" -o -name "cutstub.s2.bin" \) 2>/dev/null | head -40
which gcc clang-18 python3; chroot /root/noble which gcc clang-18 python3 upx
