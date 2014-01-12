#!/sbin/sh

export PATH=/sbin:/system/sbin:/system/bin:/system/xbin

chmod -R 755 /res
chmod 755 /res/check_requirements.sh
. /res/check_requirements.sh

# Remount all partitions with noatime
for k in $(busybox mount | grep relatime | cut -d " " -f3); do
sync
busybox mount -o remount,noatime $k
done

# fstrim
/sbin/fstrim -v /cache
/sbin/fstrim -v /persist
/sbin/fstrim -v /data
/sbin/fstrim -v /system

# Intelli-thermal
echo "Y" > /sys/module/msm_thermal/parameters/enabled

# Krait retention
echo "1" > /sys/module/pm_8x60/modes/cpu0/retention/idle_enabled
echo "1" > /sys/module/pm_8x60/modes/cpu0/retention/suspend_enabled
echo "1" > /sys/module/pm_8x60/modes/cpu1/retention/idle_enabled
echo "1" > /sys/module/pm_8x60/modes/cpu1/retention/suspend_enabled
echo "1" > /sys/module/pm_8x60/modes/cpu2/retention/idle_enabled
echo "1" > /sys/module/pm_8x60/modes/cpu2/retention/suspend_enabled
echo "1" > /sys/module/pm_8x60/modes/cpu3/retention/idle_enabled
echo "1" > /sys/module/pm_8x60/modes/cpu3/retention/suspend_enabled

# Sysctl
echo "4096" > /proc/sys/vm/min_free_kbytes
echo "0" > /proc/sys/vm/swappiness
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control
sync; echo "3" > /proc/sys/vm/drop_caches
sync; echo "1" > /proc/sys/vm/drop_caches

# read a head buffer 2mb
echo "2048" > /sys/block/mmcblk0/queue/read_ahead_kb

# Disable some debug
echo "0" > /sys/module/wakelock/parameters/debug_mask
echo "0" > /sys/module/userwakelock/parameters/debug_mask
echo "0" > /sys/module/earlysuspend/parameters/debug_mask
echo "0" > /sys/module/alarm/parameters/debug_mask
echo "0" > /sys/module/alarm_dev/parameters/debug_mask
echo "0" > /sys/module/binder/parameters/debug_mask

# sysctl 
if [ -e /system/etc/sysctl.conf ]; then
     	syctl -p /system/etc/sysctl.conf
fi

# init.d
if [ -d /system/etc/init.d ]; then
    	chmod -R 755 /system/etc/init.d
    	chmod 755 /system/etc/init.d/*
    	/system/bin/logwrapper /sbin/run-parts /system/etc/init.d 
else
	mkdir /system/etc/init.d
fi
