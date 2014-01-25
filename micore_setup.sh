MICORE_CFG=micore_tools/micore.cfg
MICORE_MAIN=make_micore.sh

if [ ! -d micore_tools/out ]; then
    mkdir micore_tools/out
fi

check_cfg () {
if [ -e $MICORE_CFG ]; then
     echo -en "Micore build enivonment is already configured\nThe following configurartion has been found:\n\n`cat $MICORE_CFG`\n\nDo you want to reconfigure the build environement (y,n)?"; read check_cfg_option
     case "$check_cfg_option" in
         y) rm $MICORE_CFG; make_cfg_toolchain; make_cfg_toolchain_path; make_cfg_device; make_cfg_defconfig; make_cfg_version; make_micore_environment;;
         n) clear;;
     esac
else 
    make_cfg_toolchain; make_cfg_toolchain_path; make_cfg_device; make_cfg_defconfig; make_cfg_version; make_micore_environment
fi
}

make_cfg_toolchain () {
echo -en "\nWhich toolchain do you use (1,2)?\n 1 - Linaro (default)\n 2 - GCC\n "; read toolchain_option
case "$toolchain_option" in 
    1) TOOLCHAIN=Linaro;;
    2) TOOLCHAIN=gcc;;
    *) TOOLCHAIN=linaro;;
esac
}

make_cfg_toolchain_path () {
echo -en "\nEnter the path to your $TOOLCHAIN toolchain\ne.g. /opt/toolchains/linaro-4.7/bin/arm-linux-androideabi-: "; read toolchain_path_option
if [ ! -e "$toolchain_path_option"g++ ]; then
     echo -en "\nError: the path: $toolchain_path_option\nDoes not exsist, re-enter your path"; make_cfg_toolchain_path
else
     CROSS_COMPILE=$toolchain_path_option
fi
}

make_cfg_device () {
echo -en "\nEnter main device which will be used as default (aries): "; read device_option
DEVICE=$device_option
}

make_cfg_defconfig () {
echo -en "\nEnter defconfig which will be used by default: "; read defconfig_option
if [ -e arch/arm/configs/$defconfig_option ]; then 
     DEFCONFIG=$defconfig_option
else 
     echo -en "\nError: defconfig not found: $defconfig_option\nRe-enter defconfig"
     make_cfg_defconfig

fi
}

make_cfg_version () {
echo -en "\nEnter a version for MiCore build: "; read version_option
VERSION=$version_option
echo -en "Version can be updated with: ./make_micore.sh --version [version]"
}

make_micore_environment () {
echo "TOOLCHAIN=$TOOLCHAIN" > $MICORE_CFG
echo "CROSS_COMPILE=$CROSS_COMPILE" >> $MICORE_CFG
echo "DEVICE=$DEVICE" >> $MICORE_CFG
echo "DEFCONFIG=$DEFCONFIG" >> $MICORE_CFG
echo "VERSION=$VERSION" >> $MICORE_CFG
echo "BUILD=0" >> $MICORE_CFG

chmod 755 micore_tools/scripts/*
chmod 755 micore_tools/bootimage_tools/*
ln -sf micore_tools/scripts/$MICORE_MAIN $MICORE_MAIN
echo -en "\n\nConfiguration of MiCore build environment succesfully complete!\n"; sleep 2; clear
}

clear; check_cfg
