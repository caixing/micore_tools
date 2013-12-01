source micore_tools/micore.cfg
export ARCH=arm
export CROSS_COMPILE=$CROSS_COMPILE
export LOCALVERSION="-MiCore-$VERSION"

make mrproper
case "$1" in 
   aries) make aries-micore_defconfig;;
esac
make -j2 > kernel.log
