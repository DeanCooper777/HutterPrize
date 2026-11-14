#!/bin/bash
# Unstripped PGO+LTO link of the submission binary, then a size report.
rm -rf /root/symb; cp -r /root/build/fx2-cmix-T /root/symb; cd /root/symb
sed -i 's/ -s -o cmix/ -Wl,-Map=cmix.map -o cmix/' makefile
make CFLAGS_DEFINES="-DSEED=923 -DUPDATE_LIMIT=3000" prof_use -j > make.log 2>&1 || { tail -5 make.log; exit 1; }
ls -la cmix; size cmix
nm -S --size-sort -C cmix | gawk '{s=strtonum("0x"$2); $1="";$2=""; print s, $0}' | sort -rn > syms.txt
gawk '{t+=$1} END {print "symbols total", t, "count", NR}' syms.txt
head -60 syms.txt | cut -c1-120
