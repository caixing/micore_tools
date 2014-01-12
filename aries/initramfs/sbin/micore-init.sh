#!/sbin/sh

export PATH=/sbin:/system/sbin:/system/bin:/system/xbin

mount -o remount,rw /system
# Modules
if [ ! -d /system/lib/modules ]; then
     	cp -r /res/modules /system/lib/modules
     	chmod -R 755 /system/lib/modules
     	chmod -R 755 /system/lib/modules/prima
     	chmod 644 /system/lib/modules/*.ko
     	chmod 644 /system/lib/modules/prima/prima_wlan.ko
     	ln -s /system/lib/modules/prima/prima_wlan.ko /system/lib/modules/wlan.ko
fi

# Thermald.conf
if [ ! -e /system/etc/thermald.conf ]; then
	cp /res/thermald.conf /system/etc/thermald.conf
fi

# Disable MPDecision
if [ -e /system/bin/mpdecision ]; then
     	mv /system/bin/mpdecision /system/bin/mpdecision.bak
fi
mount -o remount,ro /system

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

# Intellidemand optimizations
MAX_FREQ=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq)
echo "95" > /sys/devices/system/cpu/cpufreq/intellidemand/up_threshold
echo "85" > /sys/devices/system/cpu/cpufreq/intellidemand/up_threshold_any_cpu_load
echo "75" > /sys/devices/system/cpu/cpufreq/intellidemand/up_threshold_multi_core
echo "1134000" > /sys/devices/system/cpu/cpufreq/intellidemand/two_phase_freq
echo "$MAX_FREQ" > /sys/devices/system/cpu/cpufreq/intellidemand/optimal_freq
echo "810000" > /sys/devices/system/cpu/cpufreq/intellidemand/sync_freq
echo "1350000" > /sys/devices/system/cpu/cpufreq/intellidemand/boostfreq

# Sysctl
echo "4096" > /proc/sys/vm/min_free_kbytes
echo "0" > /proc/sys/vm/swappiness
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control
sync; echo "3" > /proc/sys/vm/drop_caches
sync; echo "1" > /proc/sys/vm/drop_caches

# read a head buffer 2mb
echo "2048" > /sys/block/mmcblk0/queue/read_ahead_kb

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
