source micore_tools/micore.cfg
DEVICE=$2
export ARCH=arm
export CROSS_COMPILE=$CROSS_COMPILE
export LOCALVERSION="MiCore-$VERSION"

make mrproper
make "$DEVICE"-micore_defconfig
make -j2 > kernel.log
