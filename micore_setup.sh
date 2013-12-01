MICORE_CFG=micore_tools/micore.cfg
MICORE_MAIN=make_micore.sh

if [ ! -d micore_tools/out ]; then
    mkdir micore_tools/out
fi

check_cfg () {
if [ -e $MICORE_CFG ]; then
     echo -en "Micore build enivonment is already configured\nThe following configurartion has been found:\n\n`cat $MICORE_CFG`\n\nDo you want to reconfigure the build environement (y,n)?"; read check_cfg_option
     case "$check_cfg_option" in
         y) rm $MICORE_CFG; make_cfg_toolchain;;
         n) clear; exit;;
     esac
else 
    make_cfg_toolchain;
fi
}

make_cfg_toolchain () {
echo -en "Which toolchain do you use (1,2)?\n 1 - GCC (default)\n 2 - Linaro\n "; read toolchain_option
case "$toolchain_option" in 
    1) TOOLCHAIN=gcc;;
    2) TOOLCHAIN=linaro;;
    *) TOOLCHAIN=gcc;;
esac
}

make_cfg_toolchain_path () {
echo -en "Please enter the path to your $TOOLCHAIN toolchain\ne.g. /opt/toolchains/arm-eabi-4.7/bin/arm-eabi-: "; read toolchain_path_option
if [ ! -e "$toolchain_path_option"gcc ]; then
     echo "The path: $toolchain_path_option\nDoes not exsist\nRe-enter your path"; make_cfg_toolchain_path
else
     CROSS_COMPILE=$toolchain_path_option
fi
make_micore_invironment
}
make_micore_environment () {
echo "TOOLCHAIN=$TOOLCHAIN" > $MICORE_CFG
echo "CROSS=$CROSS_COMPILE" >> $MICORE_CFG

chmod 755 micore_tools/scripts/*
chmod 755 micore_tools/bootimage_tools/*
ln -sf micore_tools/scripts/$MICORE_MAIN $MICORE_MAIN
}

clear; check_cfg; exit

