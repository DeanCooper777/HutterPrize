#!/bin/bash
# look3.sh: finds the hole range and packer output lines of our own official build (read-only).
# Testing tool for the packer trial; not part of any submitted program.
ls -la /root/b_fin | head -40; ls -la /root/b_fin/cmix-T-dwc | grep -v "\.o$" | head -60
grep -rn "pack.sh:\|hole\|PACK_HOLE\|enc_only" /root/b_fin/*.log /root/b_fin/cmix-T-dwc/*.log /root/b_fin/cmix-T-dwc/*.txt 2>/dev/null | head -20
grep -n "pack.sh:\|enc_only\|hole" /mnt/c/Dean/Projects/HutterPrize/runs/verify-official/log.txt | head
grep -n "PACK_HOLE\|enc_only\|PACK_KEEP_ELF" /mnt/c/Dean/Projects/HutterPrize/cmix-T-dwc/build_and_construct_comp.sh | head -20
sha256sum /mnt/c/Dean/Projects/HutterPrize/packer/cmix_fin_off.elf
readelf -lSW /mnt/c/Dean/Projects/HutterPrize/packer/cmix_fin_off.elf | grep -E "LOAD|\.text|\.fini|\.rodata|\.data|\.bss|Type:|INTERP|\.init|eh_frame"
which clang++-17 clang-17 g++ upx
