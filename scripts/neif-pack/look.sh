#!/bin/bash
# look.sh: lists the existing official cmix-neif build outputs in the WSL chroot (read-only).
# Testing tool for the packer trial; not part of any submitted program.
cd /root/noble/work || exit 1
ls -d */ | tr '\n' ' '; echo
for d in off b0; do echo "== $d"; ls -la $d | grep -i -v "\.o$" | head -60; ls -la $d/pak_pack 2>/dev/null; done
uptime; free -m | head -2; pgrep -fa "comp9|cmix" | head
