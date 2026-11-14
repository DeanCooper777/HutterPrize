#!/bin/bash
# Start the real `cmix -e enwik9` with the packed compressor, check the self-extract stage, stop once coding starts.
P=/mnt/c/Dean/Projects/HutterPrize; R=/root/etest; rm -rf $R; mkdir -p $R; cd $R
cp /root/build/fx2-cmix-T/run/cmix . ; cp /root/build/fx2-cmix-T/run/cmix_orig ref_orig; ln -s $P/enwik9 enwik9
free -g | sed -n 2p
( ./cmix -e enwik9 enwik9.comp > log.txt 2>&1 & echo $! > pid )
for i in $(seq 1 120); do sleep 10; [ -s progress.log ] && break; kill -0 $(cat pid) 2>/dev/null || break; done
sleep 20; kill $(cat pid) 2>/dev/null; pkill -f "cmix -e" 2>/dev/null
ls -la . | awk '{print $5, $9}' | tr '\n' ';'; echo
cmp .decomp_bin ref_orig && echo DECOMP_BIN_IS_THE_PACKED_BINARY
md5sum .dict $P/fx2-cmix-T/dictionary/english.dic | cut -c1-12 | tr '\n' ' '; echo
tr '\r' '\n' < log.txt | grep -v "^$" | tail -4 | cut -c1-160; head -3 progress.log 2>/dev/null | tr '\n' ' '
