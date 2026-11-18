# setup.sh -- installs the build tools on a fresh Ubuntu machine (uses sudo):
# make, upx-ucl (only needed for PACKER=upx) and clang/LLVM 17 through the
# official apt.llvm.org script. Run once before build_and_construct_comp.sh.
# It does not install binutils: without objdump the build script skips its
# AVX2-only and reciprocal-estimate checks (with a warning), and the default
# packer (packer/pack.sh) also needs ld and readelf from binutils. Install
# binutils as well for a submission build.
#
# Unchanged from the previous winning entry.
set -euo pipefail

sudo apt-get update
# [this entry] binutils (objdump for the instruction-set checks; ld, as, readelf, nm, strip for the
# link and the packer), python3 (packer/enc_only.py) and gcc (compiles the unpacking stub when it
# is regenerated; optional) are needed by build_and_construct_comp.sh. upx-ucl only for PACKER=upx.
sudo apt-get install upx-ucl make binutils python3 gcc -y

# clang++-17, llvm-profdata-17 and the other LLVM 17 tools
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 17
rm llvm.sh
