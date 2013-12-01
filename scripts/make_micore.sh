check_cfg () {
if [ -e micore_tools/micore.cfg ]; then
     MICORE_CFG=micore_tools/micore.cfg
else 
     . micore_tools/micore_setup.sh
     check_cfg
fi 
}

check_cfg
if [ $# -gt 0 ]; then
     if [ $1 == "--help" ]; then
          show_argument_help
     elif [ $1 == "--boot" ]; then
            case "$2" in
                 aries) . micore_tools/scripts/make_boot.sh aries;;
            esac
     elif [ $1 == "--busybox" ]; then
            case "$2" in
                 aries) . micore_tools/scripts/install_busybox_initramfs.sh aries;;
            esac
     elif [ $1 == "--kernel" ]; then
            case "$2" in
                 aries) . micore_tools/scripts/make_kernel.sh aries;;
            esac
     elif [ $2 == "--version" ]; then
            sed -i '/VERSION=*/ d' $MICORE_CFG
            echo "VERSION=$4" >> $MICORE_CFG
fi 
