#!/bin/bash
# step1_repro.sh: obtains the stripped cmix-neif 2.0 image exactly as its packer receives it and
# reproduces the published packed sizes, without rebuilding cmix.
# Testing tool for the packer trial; not part of any submitted program.
#
# How: the official build output /work/off/comp9 (chroot /root/noble) is started with the authors'
# own LD_PRELOAD capture helper (tools_src/packer/stub_capture.c, the build's check (d)): the stub
# unpacks the image into a memory file and the helper copies it and exits before the program runs.
# Then the stub is rebuilt and the image re-packed with the steps of tools_src/packer/build_packer.sh
# (its call-graph guard is left out: it needs the unstripped link, which no longer exists) and the
# result is compared with the first bytes of comp9 and with .decomp_bin.
# One core (taskset), nice 19. Work directory /root/noble/work/pk_trial; nothing else is touched.
set -eu
C=/root/noble; CORE=${CORE:-7}
for m in proc sys dev dev/pts; do mountpoint -q $C/$m || mount --bind /$m $C/$m; done
mkdir -p $C/work/pk_trial
cat > $C/work/pk_trial/in.sh <<'EOF'
set -eu
cd /work/pk_trial
SRC=/work/pk_trial/packer; rm -rf packer; cp -r /work/neif2/tools_src/packer packer
cp -f /work/off/comp9 comp9; chmod +x comp9
gcc -O2 -w -shared -fPIC -o stub_capture.so $SRC/stub_capture.c
rm -f cap.bin
/usr/bin/time -v -o cap.time env LD_PRELOAD=$PWD/stub_capture.so STUB_CAPTURE=$PWD/cap.bin ./comp9 -h > cap.out 2>&1 || echo "capture rc $?"
grep -E "Elapsed|Maximum resident" cap.time
echo "captured $(stat -c %s cap.bin) B"
NF=619918
head -c $NF cap.bin > cmix.ss
echo "tail after Nf: $(tail -c +$((NF + 1)) cap.bin | tr -c '[:print:]' '.' )"
sha256sum cmix.ss
readelf -hlW cmix.ss | grep -E "Type:|Entry|LOAD|INTERP|DYNAMIC|GNU_|There are"
# cut point as in build_packer.sh: file offset of the last file-backed PT_LOAD
read ND SZ < <(readelf -lW cmix.ss | awk '$1=="LOAD" && strtonum($5)>0 {o=$2;s=$5} END{print strtonum(o), strtonum(s)}')
echo "Nd $ND  encoder block $SZ  Nd+SZ $((ND + SZ))"
# --- the packing steps of build_packer.sh, verbatim apart from names ---
N=cmix; CC=clang-18; OBJCOPY_SS=llvm-objcopy-18
sstrip() { cp "$1" "$2" && "$OBJCOPY_SS" --strip-sections "$2"; }
gcc -O2 -w -o cmcut_tool "$SRC/pack_tool.c"
./cmcut_tool xform "$N.ss" "$N.x"
S2BASE=0x10000000
CFL="-nostdlib -static -Oz -ffreestanding -fno-asynchronous-unwind-tables \
     -fno-stack-protector -fcf-protection=none -fno-pic -fno-pie -no-pie \
     -ffunction-sections -fdata-sections -w -I$SRC"
S2FLAGS="-fno-schedule-insns2 -fno-caller-saves -fno-if-conversion -fno-tree-vrp -fno-tree-forwprop -fno-dse \
     -fno-forward-propagate -fira-algorithm=priority -fno-tree-loop-im -fno-ssa-phiopt -fno-move-loop-invariants -fno-expensive-optimizations"
CFL2="-nostdlib -static -Os -ffreestanding -fno-asynchronous-unwind-tables \
     -fno-stack-protector -fcf-protection=none -fno-pic -fno-pie -no-pie \
     -ffunction-sections -fdata-sections -w $S2FLAGS -I$SRC"
gcc $CFL2 -fno-inline-functions -fno-jump-tables \
    -Wl,-T,"$SRC/s2.lds" -Wl,--build-id=none -Wl,--gc-sections \
    -e s2_main "$SRC/stub.c" -o cutstub.s2.elf
"$OBJCOPY_SS" -O binary --only-section=.text --only-section=.rodata --only-section=.data cutstub.s2.elf cutstub.s2.bin
len=$(stat -c%s cutstub.s2.bin)
end=$(nm cutstub.s2.elf | awk '$3=="s2_end"{print strtonum("0x"$1)}')
tend=$(nm cutstub.s2.elf | awk '$3=="s2_textend"{print strtonum("0x"$1)}')
mem=$(( (end - S2BASE + 4095) / 4096 * 4096 )); S2TEXT=$((tend - S2BASE))
./cmcut_tool boot cutstub.s2.bin cutstub.s2.cm
$CC $CFL -DS2BASE=$S2BASE -DS2MEM=$mem -DS2LEN=$len -DS2CM="\"$PWD/cutstub.s2.cm\"" \
    -Wl,-T,"$SRC/s1.lds" -Wl,--build-id=none -Wl,--gc-sections -e _start "$SRC/stub_boot.c" -o cutstub.elf
strip -s cutstub.elf 2>/dev/null || true
objcopy --remove-section=.comment --remove-section=.note.gnu.property --remove-section=.note.gnu.build-id cutstub.elf 2>/dev/null || true
sstrip cutstub.elf cutstub.ss
echo "$S2TEXT" > s2text.txt
s=$(date +%s)
/usr/bin/time -v -o comp.time ./cmcut_tool compress "$N.x" "$N.p" cutstub.s2.bin "$S2TEXT"
grep -E "Elapsed|Maximum resident" comp.time
./cmcut_tool pack cutstub.ss "$N.p" "$NF" "$ND" "$N.cut" cutstub.s2.bin "$S2TEXT"
./cmcut_tool cut "$N.cut" "$N.cut.dec"
echo "stage2 flat $len, compressed $(stat -c %s cutstub.s2.cm); stub $(stat -c %s cutstub.ss); stream $(stat -c %s $N.p)"
echo "package $(stat -c %s $N.cut)  decomp_bin $(stat -c %s $N.cut.dec)  ($(( $(date +%s) - s )) s)"
cmp <(head -c $(stat -c %s $N.cut) comp9) $N.cut && echo "PACKAGE IDENTICAL to the head of the official comp9"
cmp /work/off/.decomp_bin $N.cut.dec && echo "DECOMP_BIN IDENTICAL to the official .decomp_bin"
EOF
nice -n 19 taskset -c $CORE chroot $C /bin/bash /work/pk_trial/in.sh
