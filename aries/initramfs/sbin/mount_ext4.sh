#!/system/bin/sh
export PATH=/system/bin:/system/xbin:/sbin:$PATH
BLOCK_DEVICE=$1
MOUNT_POINT=$2
LOG_FILE="/dev/null"
LOG_LOCATION="/data/.fsck_log/"

# get syspart-flag from cmdline
set -- $(cat /proc/cmdline)
for x in "$@"; do
    case "$x" in
        syspart=*)
        SYSPART=$(echo "${x#syspart=}")
        ;;
    esac
done

if [ "${MOUNT_POINT}" == "/storage_int" ]; then
    	mkdir ${LOG_LOCATION}
    	busybox find /data/.fsck_log/ -type f -mtime +7  -exec rm {} \;
    	TIMESTAMP=`date +%F_%H-%M-%S`
    	LOG_FILE=${LOG_LOCATION}/storage_${TIMESTAMP}.log
fi

mount_partition () {
if [ "$BLOCK_DEVICE" = "/dev/block/platform/msm_sdcc.1/by-name/userdata" ]; then
	# Mount as /data_root
	mkdir -p /data_root
	chmod 0775 /data_root
	mount -t ext4 -o noatime,nosuid,nodev,barrier=1,commit=60,noauto_da_alloc,delalloc ${BLOCK_DEVICE} /data_root

	# TrueDualBoot support
	if [ -e /data_root/.truedualboot ]; then
		if [ "${SYSPART}" == "system" ]; then
			BINDMOUNT_PATH="/data_root/system0"
			TDB="enabled"
		elif [ "${SYSPART}" == "system1" ]; then
			BINDMOUNT_PATH="/data_root/system1"
			TDB="enabled"
		else
			reboot recovery
		fi
	else
		BINDMOUNT_PATH="/data_root"
		TDB="disabled"
	fi

	# bind mount
	mkdir -p ${BINDMOUNT_PATH}
	chmod 0755 ${BINDMOUNT_PATH}
	mount -o bind ${BINDMOUNT_PATH} ${MOUNT_POINT}

	if [ $TDB = "enabled" ]; then
		if [ -e /data_root/validate_data.sh ]; then
			exec /system/bin/sh /data_root/validate_data.sh
		fi
	fi
else
	mount -t ext4 -o noatime,nosuid,nodev,barrier=1,commit=60,noauto_da_alloc,delalloc ${BLOCK_DEVICE} ${MOUNT_POINT}
fi
}

if [ -e ${BLOCK_DEVICE} ]; then

    	/system/bin/dumpe2fs -h ${BLOCK_DEVICE} 2>&1 >${LOG_FILE}
    	ret1=$?
    	if [ $ret1 -ne 0 ];then
        	mke2fs -T ext4 -j -L ${MOUNT_POINT} ${BLOCK_DEVICE}
        	ret2=$?
        	echo "${PART_ALIAS} partition format ret = $ret2"
        	if [ $ret2 -ne 0 ];then
            		exit 1
        	fi
    	fi

    	e2fsck -y ${BLOCK_DEVICE} 2>&1 >>${LOG_FILE}
    	ret3=$?
    	echo "e2fsck on ${BLOCK_DEVICE} ret = $ret3" 2>&1 >>${LOG_FILE}

	mount_partition

    	if [ -e ${MOUNT_POINT}/extend_size.userdata -o -e ${MOUNT_POINT}/extend_size.storage ]; then
        	umount ${MOUNT_POINT}
       		e2fsck -f -y ${BLOCK_DEVICE}
        	ret4=$?
        	echo "Forced e2fsck on ${BLOCK_DEVICE} ret = $ret4"
        	if [ $ret4 -eq 4 ]; then
            		e2fsck -y ${BLOCK_DEVICE}
        	fi
        	resize2fs ${BLOCK_DEVICE}
        	ret5=$?
        	echo "resize ${BLOCK_DEVICE} ret = $ret5"
        	e2fsck -y ${BLOCK_DEVICE}
        	ret6=$?
       		echo "e2fsck on ${BLOCK_DEVICE} ret = $ret6"
        	mount_partition
        	if [ $ret5 -eq 0 -o $ret5 -eq 2 ]; then
            		rm ${MOUNT_POINT}/extend_size*
        	fi
    	fi
fi

# hide recovery partition
RECOVERY_NODE="$(busybox readlink -f /dev/block/platform/msm_sdcc.1/by-name/recovery)"
busybox mv "${RECOVERY_NODE}" /dev/recovery_moved
busybox mknod -m 0600 "${RECOVERY_NODE}" b 1 3
