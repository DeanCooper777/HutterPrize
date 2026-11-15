#!/bin/bash
# End-to-end START test of the split build (run after build_fin_off.sh):
#  1. real `cmix -e enwik9` with the packed compressor until coding has started, then stop it;
#     check that .decomp_bin is the decompressor form (cut length, flag byte, program-header size);
#  2. assemble an archive9 from .decomp_bin + dictionary + weights + the coded bytes written so far
#     + trailer, run it until it has started decoding, then stop it.
# One cmix at a time (memory).
P=/mnt/c/Dean/Projects/HutterPrize; B=/root/b_fin/cmix-T-dwc/run; R=/root/etest2; rm -rf $R; mkdir -p $R/c $R/d; cd $R/c
cp $B/cmix . ; ln -s $P/enwik9 enwik9
( ./cmix -e enwik9 enwik9.comp > log.txt 2>&1 & echo $! > pid )
for i in $(seq 1 150); do sleep 10; [ -s progress.log ] && break; kill -0 $(cat pid) 2>/dev/null || break; done
sleep 240; kill $(cat pid) 2>/dev/null; pkill -f "cmix -e" 2>/dev/null; sleep 3
echo "compressor log tail: $(tr '\r' '\n' < log.txt | grep -v '^$' | tail -n 2 | cut -c1-120 | tr '\n' '|')"
echo "progress: $(tail -c 60 progress.log 2>/dev/null | tr '\r\n' '  ')"
python3 - $B/cmix_orig <<'EOF'
import struct, sys, os
full = open(sys.argv[1], "rb").read(); d = open(".decomp_bin", "rb").read()
comp = open("cmix", "rb").read(); t = struct.unpack("<4i", comp[-16:])
cut = t[2]
print("trailer of comp9:", t, " packed exe", len(full), " .decomp_bin", len(d))
ok = len(d) == cut and d[9] == 1 and struct.unpack_from("<Q", d, 96)[0] == cut
same = all(d[i] == full[i] for i in range(cut) if i != 9 and not 96 <= i < 104)
print("DECOMP_BIN_IS_DECOMPRESSOR_FORM" if ok and same else "DECOMP_BIN WRONG", ok, same)
pay = open("enwik9.comp", "rb").read() if os.path.exists("enwik9.comp") else b""
dic = open(".dict.comp", "rb").read(); w = open(".tfweights", "rb").read()
open("../d/archive9", "wb").write(d + dic + w + pay + struct.pack("<4i", len(dic), t[1], len(pay), len(w)))
print("test archive9:", len(d) + len(dic) + len(w) + len(pay) + 16, "bytes, payload", len(pay))
EOF
md5sum .dict $P/cmix-T-dwc/dictionary/english.dic | cut -c1-12 | tr '\n' ' '; echo
cd $R/d; chmod +x archive9; rm -f $R/c/*.temp $R/c/ppm* 2>/dev/null
( ./archive9 > log.txt 2>&1 & echo $! > pid )
for i in $(seq 1 150); do sleep 10; [ -s progress.log ] && break; kill -0 $(cat pid) 2>/dev/null || break; done
sleep 240; alive=no; kill -0 $(cat pid) 2>/dev/null && alive=yes
kill $(cat pid) 2>/dev/null; pkill -f archive9 2>/dev/null; sleep 2
echo "decompressor alive after start of decoding: $alive"
echo "decompressor log tail: $(tr '\r' '\n' < log.txt | grep -v '^$' | tail -n 2 | cut -c1-120 | tr '\n' '|')"
echo "progress: $(tail -c 60 progress.log 2>/dev/null | tr '\r\n' '  ')"
ls -la | awk '{print $5, $9}' | tr '\n' ';'; echo
# the bytes decoded so far must equal the start of the compressor's preprocessed input
f=$(ls -S .main_decomp* .ready4cmix_decomp_out* un1_d* 2>/dev/null | head -n 1); echo "largest decoded temp: $f"
