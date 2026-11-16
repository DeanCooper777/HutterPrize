#!/bin/bash
# neif_pgo_probe.sh FILE [SED_EXPR...]: compile one source file of the "fast" group of the test
# build tree /work/tbp (chroot /root/noble) as `make prof_use` does, once per sed expression applied
# to a copy of it (none = the file as it is), and list the functions whose profile is discarded
# beyond the baseline (/work/tbp_base_build.log). A quick check (seconds) that an edit inside a
# profiled function leaves its profile entry valid.
C=/root/noble
F=${1:?file, e.g. src/predictor.cpp}; shift
[ $# -gt 0 ] || set -- ''
cat > $C/work/pgo_probe_in.sh <<'EOF'
cd /work/tbp
F=$1; shift
FL=$(make -n -p 2> /dev/null | grep '^CPPFLAGS_PART-THAT-SHOULD-BE-FAST :=' | head -n 1 | cut -d= -f2-)
grep -o 'hash mismatch) [^ ]*' /work/tbp_base_build.log | sort -u > /tmp/mm_base.txt
cp $F /tmp/probe_orig.cpp
for e in "$@"; do
  if [ -n "$e" ]; then sed "$e" /tmp/probe_orig.cpp > $F; fi
  clang++-18 -DNEIF_TEST=1 $FL -fprofile-use=/work/tbp/pgo_data -flto -c $F -o /tmp/probe.o 2> /tmp/probe.err
  echo "expr '$e': rc $? new mismatches: $(grep -o 'hash mismatch) [^ ]*' /tmp/probe.err | sort -u | comm -13 /tmp/mm_base.txt - | tr '\n' ' ')"
  grep "error" /tmp/probe.err | head -n 5
  cp /tmp/probe_orig.cpp $F
done
EOF
chroot $C /bin/bash /work/pgo_probe_in.sh "$F" "$@"
