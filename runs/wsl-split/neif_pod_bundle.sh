#!/bin/bash
# neif_pod_bundle.sh: make the bundle for a rented Linux machine (NEIF_FAST.md): one tar with
#   neif/dev/             the development source tree of cmix-neif 2.0 as it is (no .git), with the
#                         weights container and the entry's PGO profile
#   neif/scripts/         neif_pod_setup.sh, neif_pod_run.sh, neif_split_eval.sh, neif_pod_scale.sh,
#                         neif_cpusets.py, neif_vnni_bench.cpp (micro-benchmark with the AVX-512 forms),
#                         NEIF_FAST.md
#   neif/stream.bin.zst   the coder stream (501,062,281 B), zstd --long=27
#   neif/SHA256SUMS
# Output: runs/wsl-split/pod_bundle/neif_pod_bundle.tar (+ .sha256). Run in WSL as root (uses zstd
# of the chroot /root/noble if the distro has none).
set -eu
P=/mnt/c/Dean/Projects/HutterPrize
W=$P/runs/wsl-split
C=/root/noble
T=/root/neif_bundle
rm -rf $T; mkdir -p $T/neif/scripts $T/neif/dev
(cd $P/reference/neif2/dev && tar cf - --exclude=.git --exclude=__pycache__ .) | tar xf - -C $T/neif/dev
for f in neif_pod_setup.sh neif_pod_run.sh neif_split_eval.sh neif_pod_scale.sh neif_cpusets.py neif_vnni_bench.cpp NEIF_FAST.md; do
  cp $W/$f $T/neif/scripts/
done
chmod +x $T/neif/scripts/*.sh
if [ ! -f /root/stream.bin.zst ] || [ /root/stream.bin.zst -ot $C/work/bed/stream.bin ]; then
  if command -v zstd > /dev/null; then zstd -q -f -12 -T0 --long=27 $C/work/bed/stream.bin -o /root/stream.bin.zst
  else
    chroot $C /bin/bash -c "command -v zstd > /dev/null || apt-get install -y -q zstd > /dev/null 2>&1; zstd -q -f -12 -T0 --long=27 /work/bed/stream.bin -o /work/bed/stream.bin.zst"
    mv $C/work/bed/stream.bin.zst /root/stream.bin.zst
  fi
fi
cp /root/stream.bin.zst $T/neif/stream.bin.zst
(cd $T/neif && sha256sum stream.bin.zst dev/weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5 scripts/* > SHA256SUMS
 echo "$(sha256sum < $C/work/bed/stream.bin | cut -c1-64)  stream.bin (after zstd -d)" >> SHA256SUMS)
mkdir -p $W/pod_bundle
tar cf $W/pod_bundle/neif_pod_bundle.tar -C $T neif
(cd $W/pod_bundle && sha256sum neif_pod_bundle.tar > neif_pod_bundle.tar.sha256)
ls -la $W/pod_bundle/ $T/neif/
cat $T/neif/SHA256SUMS
