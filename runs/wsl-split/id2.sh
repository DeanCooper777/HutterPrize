cd /root/idtest; W=/mnt/c/Dean/Projects/HutterPrize/cmix-T-dwc/models/6m-q4-fp32.tfwc2
cp /root/build/cmix-T-dwc/run/cmix_orig old; chmod +x old
./old -n in.bin old.cmix --raw-stream --official-vocab --transformer $W > old.log 2>&1; echo "old rc $? $(stat -c %s old.cmix)"; rm -f ppm.temp
cmp old.cmix new.cmix && echo SAME_TOOLCHAIN_BEFORE_AFTER_IDENTICAL
cmp -l new.cmix ref.cmix | wc -l
