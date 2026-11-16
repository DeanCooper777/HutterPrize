#!/bin/bash
# neif_build_official_dev.sh: official build (build.sh: PGO + LTO + packer, no NEIF_TEST) of the
# EDITED development copy, inside the chroot /root/noble, and comparison of its comp9 with the
# published sha256. Proves that the NEIF_TEST additions leave the entry unchanged.
# Run in WSL as root (about 7 min; not while a cmix process runs: the profile pass needs memory).
set -eu
C=/root/noble
WANT=976bf2d309707ab555e0c92720da5508ff0e5e6b846fc7082234262b06767f82
if pgrep -x cmix > /dev/null || pgrep -x comp9 > /dev/null; then echo "another cmix/comp9 is running"; exit 1; fi
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
rm -rf $C/work/dev_off $C/work/b1 && mkdir -p $C/work/dev_off $C/work/b1
(cd /mnt/c/Dean/Projects/HutterPrize/reference/neif2/dev && tar cf - --exclude=.git .) | tar xf - -C $C/work/dev_off
cat > $C/work/build_off_in.sh <<'EOF'
cd /work/b1
s=$(date +%s)
bash /work/dev_off/build.sh > /work/b1/build.log 2>&1
echo "build rc $? in $(( $(date +%s) - s )) s"
tail -n 2 /work/b1/build.log
sha256sum /work/b1/comp9 /work/b0/comp9
EOF
chroot $C /bin/bash /work/build_off_in.sh
h=$(sha256sum $C/work/b1/comp9 | cut -d' ' -f1)
[ "$h" = "$WANT" ] && echo "OFFICIAL BUILD OF THE EDITED TREE: IDENTICAL to the published comp9" || echo "DIFFERENT from the published comp9"
