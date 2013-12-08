source micore_tools/micore.cfg
export ARCH=arm
export CROSS_COMPILE=$CROSS_COMPILE
export LOCALVERSION="-MiCore-$VERSION"

make mrproper
if [ "$1" = != "" ]; then
     make $1
else
     make $DEFCONFIG
fi
make -j2 > kernel.log
