#!/bin/bash
# step4_cut_ours.sh: cmix-neif packer model on OUR image with the compress-only hole moved to the end
# of the file, to measure the cut (decompressor copy). Addresses are not re-linked, so the address
# transform is slightly off after the move: a pessimistic estimate.
# Testing tool for the packer trial; not part of any submitted program.
set -eu
C=/root/noble; CORE=${CORE:-7}
cat > $C/work/pk_trial/in4.sh <<'EOS'
set -eu
cd /work/pk_trial
python3 -c "
d=open('ours.ss','rb').read(); lo,hi=301382,316959
open('ours_moved.ss','wb').write(d[:lo]+d[hi:]+d[lo:hi])"
ND=$((342900 - 15577))
CR="13264 342900 4194304" ./neif_cost ours_moved.ss $ND - cutstub.s2.bin $(cat s2text.txt)
EOS
nice -n 19 taskset -c $CORE chroot $C /bin/bash /work/pk_trial/in4.sh 2>&1 | tee /mnt/c/Dean/Projects/HutterPrize/runs/neif-pack/step4.log
