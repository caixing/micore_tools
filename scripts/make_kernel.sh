source micore_tools/micore.cfg
BUILD=$(expr $BUILD + 1)
sed -i '/BUILD=*/ d' micore_tools/micore.cfg
echo "BUILD=$BUILD" >> micore_tools/micore.cfg
export ARCH=arm
export CROSS_COMPILE=$CROSS_COMPILE
export LOCALVERSION="-MiCore-$VERSION-$BUILD"

make mrproper
if [ "$1" != "" ]; then
  	make $1
else
     	make $DEFCONFIG
fi
make -j2 $CUSTOM_FLAGS > kernel.log
