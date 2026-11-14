cd /tmp && S=/mnt/c/Dean/Projects/HutterPrize/fx2-cmix-T/packer/pkdec.c
F="-w -ffreestanding -fno-stack-protector -fno-asynchronous-unwind-tables -fno-unwind-tables -fno-pic -mcmodel=small -fno-builtin -fno-ident"
t() { n=$1; shift; "$@" -c $S -o st.o 2>/dev/null && printf "%-44s %s\n" "$n" "$(size st.o | tail -1 | awk '{print $1+$2}')" || echo "$n: failed"; }
t "clang-17 -Oz" clang-17 -Oz $F
t "clang-17 -Oz -mno-sse" clang-17 -Oz $F -mno-sse
t "clang-17 -Oz -fno-jump-tables" clang-17 -Oz $F -fno-jump-tables
t "clang-17 -Oz -fomit-frame-pointer -march=haswell" clang-17 -Oz $F -fomit-frame-pointer -march=haswell
command -v gcc > /dev/null || apt-get install -y -q gcc > /dev/null 2>&1
G="-w -ffreestanding -fno-stack-protector -fno-asynchronous-unwind-tables -fno-unwind-tables -fno-pic -fno-pie -mcmodel=small -fno-builtin -fno-ident"
t "gcc -Os" gcc -Os $G
t "gcc -Os -mno-sse" gcc -Os $G -mno-sse
t "gcc -Os -fno-jump-tables -fwhole-program" gcc -Os $G -fno-jump-tables -fwhole-program
t "gcc -Oz" gcc -Oz $G
t "gcc -Oz -fwhole-program -fno-jump-tables" gcc -Oz $G -fwhole-program -fno-jump-tables
gcc --version | head -1
