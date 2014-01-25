check_cfg () {
if [ -e micore_tools/micore.cfg ]; then
     	MICORE_CFG=micore_tools/micore.cfg
     	source $MICORE_CFG
else 
     	. micore_tools/micore_setup.sh
     	check_cfg
fi 
}


# Specific arguments
show_argument_help () { 
echo 
echo "MiCore kernel build scripts"
echo "By redmaner - MIUIAndroid.com"
echo 
echo "Usage: make_micore.sh [option]"
echo 
echo " [option]:"
echo " 		--help					This help"
echo "		--boot [device]				Make a boot.img"
echo "							device = aries or blank (if blank default device will be used)"
echo "		--busybox [device]			Install busybox in initramfs"
echo "							device = aries or blank (if blank default device will be used)"
echo "		--kernel [defconfig]			Make kernel"
echo "							if defconfig is blank default defconfig will be used)"
echo "		--version [version]			Update version number"
echo "							version = can be anything (e.g. v0.8.0)"
echo 
exit 
}

check_cfg
if [ $# -gt 0 ]; then
     	if [ $1 == "--help" ]; then
          	show_argument_help
     	elif [ $1 == "--boot" ]; then
            	micore_tools/scripts/make_boot_$DEVICE.sh $DEVICE
     	elif [ $1 == "--busybox" ]; then
            	case "$2" in
                 	aries) micore_tools/scripts/install_busybox_initramfs.sh aries;;
                     	    *) micore_tools/scripts/install_busybox_initramfs.sh $DEVICE;;
            	esac
     	elif [ $1 == "--kernel" ]; then
            	if [ "$2" != "" ]; then
			if [ -e arch/arm/configs/$2 ]; then
                      		micore_tools/scripts/make_kernel.sh $2
                	else
                      		echo "Error: defconfig not found: $2"
			fi
            	else  
                 	micore_tools/scripts/make_kernel.sh $DEFCONFIG  
            	fi
     	elif [ $1 == "--version" ]; then
            	sed -i '/VERSION=*/ d' $MICORE_CFG
            	echo "VERSION=$2" >> $MICORE_CFG
     	fi
else
     	show_argument_help
fi 
