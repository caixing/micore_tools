#!/bin/bash
source micore_tools/micore.cfg
DEVICE=$1
INITRAMFS_TMP=/tmp/initramfs-source
INITRAMFS_SOURCE=micore_tools/$DEVICE/initramfs

#remove previous initramfs files
rm -rf $INITRAMFS_TMP
rm -f /micore_tools/initrd.img

#copy initramfs files to tmp directory
cp -ax $INITRAMFS_SOURCE $INITRAMFS_TMP

#clear git repositories in initramfs
find $INITRAMFS_TMP -name ".git*" -exec rm -rf {} \;

#remove empty directory placeholders
find $INITRAMFS_TMP -name EMPTY_DIRECTORY -exec rm -rf {} \;
rm -rf $INITRAMFS_TMP/tmp/*

#copy modules into system folder
MICORE_MODULES=/tmp/micore_modules
rm -rf micore_tools/aries/zip_template/system/lib $MICORE_MODULES
mkdir -p $MICORE_MODULES/prima
mkdir -p micore_tools/aries/zip_template/system/lib
find -name '*.ko' -exec cp -av {} $MICORE_MODULES \;
"$CROSS_COMPILE"strip --strip-unneeded $MICORE_MODULES/*
rm -f $MICORE_MODULES/ansi_cprng.ko
rm -f $MICORE_MODULES/mcdrvmodule.ko
rm -f $MICORE_MODULES/mckernelapi.ko
rm -f $MICORE_MODULES/qce40.ko
rm -f $MICORE_MODULES/qcedev.ko
rm -f $MICORE_MODULES/qcrypto.ko 
mv $MICORE_MODULES/wlan.ko $MICORE_MODULES/prima/prima_wlan.ko
chmod 644 $MICORE_MODULES/*
chmod 644 $MICORE_MODULES/prima/prima_wlan.ko
cp -r $MICORE_MODULES micore_tools/aries/zip_template/system/lib/modules

cp /home/jake/android_kernel_aries/arch/arm/boot/zImage zImage
micore_tools/bootimage_tools/mkbootfs /tmp/initramfs-source | gzip > micore_tools/initrd.img

# create new boot.img
micore_tools/bootimage_tools/mkbootimg --kernel arch/arm/boot/zImage --ramdisk micore_tools/initrd.img --cmdline "console=null androidboot.hardware=qcom ehci-hcd.park=3 maxcpus=2" --base 0x80200000 --pagesize 2048 --ramdisk_offset 0x02000000 -o micore_tools/aries/zip_template/boot.img

# add updater-script
cat > micore_tools/$DEVICE/zip_template/META-INF/com/google/android/updater-script << EOF
assert(getprop("ro.product.device") == "$DEVICE" ||
       getprop("ro.build.product") == "$DEVICE");
show_progress(0.500000, 0);
ui_print(" ");
ui_print("MiCore Kernel $VERSION");
ui_print("For Xiaomi MI-2/S (aries)");
mount("ext4", "EMMC", "/dev/block/platform/msm_sdcc.1/by-name/system", "/system");
delete_recursive("/system/lib/modules");
package_extract_dir("system", "/system");
package_extract_file("boot.img", "/dev/block/platform/msm_sdcc.1/by-name/boot");
unmount("/system");
EOF

# make zip archive
rm -f micore_tools/$DEVICE/zip_template/kernel.zip
cd micore_tools/$DEVICE/zip_template
zip -r kernel.zip *
cd ../../..
java -jar micore_tools/signapk/signapk.jar micore_tools/signapk/testkey.x509.pem micore_tools/signapk/testkey.pk8 micore_tools/$DEVICE/zip_template/kernel.zip micore_tools/out/MiCore_"$VERSION"_"$DEVICE".zip
