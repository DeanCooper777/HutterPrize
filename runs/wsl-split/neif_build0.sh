#!/bin/bash
# Reference build of cmix-neif 2.0 as published, inside the 24.04 chroot; compares comp9 with the
# sha256 in its environment.txt.
bash /mnt/c/Dean/Projects/HutterPrize/runs/wsl-split/neif_chroot.sh sh "mkdir -p /work/b0 && cd /work/b0 && s=\$(date +%s) && bash /work/neif2/build.sh > /work/b0/build.log 2>&1; echo build rc \$? in \$(( \$(date +%s) - s )) s; tail -n 3 /work/b0/build.log; ls -la /work/b0/comp9; sha256sum /work/b0/comp9; grep -i -A1 'sha256' /work/neif2/environment.txt | head -n 6"
