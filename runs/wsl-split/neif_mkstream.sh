#!/bin/bash
# neif_mkstream.sh: produce the coder stream of cmix-neif 2.0 once (the file the arithmetic coder
# codes in "-e enwik9": 501,062,281 B, sha256 c35d3073...). Uses the authors' own tool cmix_stream
# (training/tf/1_dump/trainmodes.patch, TRAIN_MODE 1), which runs the whole "-e" preprocessing and
# stops before the coder. Output: /work/bed/stream.bin inside the chroot /root/noble.
# Run in WSL as root:  bash neif_mkstream.sh
set -eu
C=/root/noble
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
cat > $C/work/mkstream_in.sh <<'EOF'
set -eu
command -v patch > /dev/null || { apt-get install -y -q patch > /dev/null; }
mkdir -p /work/tools /work/bed/run
if [ ! -x /work/tools/cmix_stream ]; then
  bash /work/neif2/training/tf/1_dump/build_dump_tools.sh /work/neif2 /work/tools stream
fi
cd /work/bed/run
cp /work/neif2/dictionary/english.dic .dict
cp /work/neif2/src/readalike_prepr/data/new_article_order .new_article_order
ls -la
/usr/bin/time -v /work/tools/cmix_stream -e /work/enwik9 out > run.log 2> run.err || { tail -n 30 run.err; exit 1; }
tail -n 25 run.err
ls -la
mv out.cmix.temp /work/bed/stream.bin
cd /work/bed && sha256sum stream.bin && stat -c %s stream.bin
EOF
chroot $C /bin/bash /work/mkstream_in.sh
