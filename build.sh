#!/bin/bash

export ARCH=arm64
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s

<<<<<<< HEAD:build_kernel.sh
make ARCH=arm64 exynos9820-beyondxks_defconfig
make ARCH=arm64 -j16
=======
if [ -z "$DEVICE" ]; then
export DEVICE=S10_5G
fi

ARGS='
CC=clang
LD='${LLVM_DIR}/ld.lld'
ARCH=arm64
CROSS_COMPILE='${LLVM_DIR}/aarch64-linux-gnu-'
CROSS_COMPILE_ARM32='${LLVM_DIR}/arm-linux-gnueabi-'
CLANG_TRIPLE='${LLVM_DIR}/aarch64-linux-gnu-'
AR='${LLVM_DIR}/llvm-ar'
NM='${LLVM_DIR}/llvm-nm'
AS='${LLVM_DIR}/llvm-as'
OBJCOPY='${LLVM_DIR}/llvm-objcopy'
OBJDUMP='${LLVM_DIR}/llvm-objdump'
READELF='${LLVM_DIR}/llvm-readelf'
OBJSIZE='${LLVM_DIR}/llvm-size'
STRIP='${LLVM_DIR}/llvm-strip'
LLVM_AR='${LLVM_DIR}/llvm-ar'
LLVM_DIS='${LLVM_DIR}/llvm-dis'
LLVM_NM='${LLVM_DIR}/llvm-nm'
LLVM=1
'

make distclean
make ${ARGS} KCFLAGS=-w ${DEVICE}_defconfig lpos.config
make ${ARGS} KCFLAGS=-w -j$(nproc)

echo "  CLEANING"
rm -rf AIK/Image
rm -rf config
echo "  COPYING"

# Define potential locations for the image binary
locations=(
  "$PWD/arch/arm64/boot"
  "$PWD/out/arch/arm64/boot"
)

# Check each location sequentially
found=false
for location in "${locations[@]}"; do
  if test -f "$location/Image"; then
    found=true
    break # Stop iterating after finding the binary
  fi
done

# Handle the case where image binary wasn't found
if ! $found; then
  echo "  ERROR : image binary not found in any of the specified locations!"
  exit 1
fi

cp -r arch/arm64/boot/Image AIK/Image
cp -r .config AIK/config
kver=$(make kernelversion)
kmod=$(echo ${kver} | awk -F'.' '{print $3}')
echo "  ZIPPING"
cd AIK
rm -rf lpos.*.zip
zip -r1 lpos.${kmod}_${DEVICE}.zip * -x .git README.md *placeholder
cd ..
echo "  DONE"
>>>>>>> f526f0481 (Import other devices and Adapt build script and workflow):build.sh
