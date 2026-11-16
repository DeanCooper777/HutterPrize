#!/bin/bash
# Run cmix-neif 2.0's install.sh inside the 24.04 chroot (adds the universe/updates components first).
C=/root/noble
cat > $C/etc/apt/sources.list <<'EOF'
deb http://archive.ubuntu.com/ubuntu noble main universe
deb http://archive.ubuntu.com/ubuntu noble-updates main universe
deb http://security.ubuntu.com/ubuntu noble-security main universe
EOF
bash /mnt/c/Dean/Projects/HutterPrize/runs/wsl-split/neif_chroot.sh sh "apt-get update -q > /dev/null 2>&1; apt-get install -y -q --no-install-recommends ca-certificates time file > /dev/null 2>&1; bash install.sh > /work/install.log 2>&1; echo install rc \$?; tail -n 12 /work/install.log; clang-18 --version | head -n 1; ld.lld-18 --version"
