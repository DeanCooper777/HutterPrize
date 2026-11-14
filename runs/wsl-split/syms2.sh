cd /root/symb
nm -S --size-sort -C cmix | gawk '$3 ~ /^[tTwW]$/ {s=strtonum("0x"$2); $1="";$2="";$3=""; print s, $0}' | sort -rn > text.txt
gawk '{t+=$1} END {print "text symbols total", t, "count", NR}' text.txt
sed -n 1,400p text.txt | cut -c1-105 | gawk '{c+=$1; printf "%6d %7d %s\n", $1, c, substr($0, index($0,$2))}' | sed -n '1,25p;26,400p' | gawk 'NR<=25 || /Help|Usage|Extract|extract|Save|Dump|Compress|Encode|encode|split4|reorder|phda|prepr|Train|Pretrain|tune|Tune|Bench|bench|prof|Prof|cat\(|Run|Verify|Dictionary|dictionary|WRT|wrt|sort|remap|main/'
readelf -SW cmix | gawk '/\.text|\.rodata|\.data |\.eh_frame|\.rela|\.dyn/ {print $2, $3, strtonum("0x"$6)}' | tr '\n' ';'
strings -n 8 cmix | wc -c; strings -n 12 cmix | grep -c .
