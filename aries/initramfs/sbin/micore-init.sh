#!/sbin/sh

export PATH=/sbin:/system/sbin:/system/bin:/system/xbin

chmod -R 755 /res
chmod 755 /res/check_requirements.sh
. /res/check_requirements.sh

# fstrim
/sbin/fstrim -v /cache
/sbin/fstrim -v /persist
/sbin/fstrim -v /data
/sbin/fstrim -v /system

# Intelli-thermal
echo "Y" > /sys/module/msm_thermal/parameters/enabled

# CPU Overclocking safety
AVAILABLE_FREQS=/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
if [ $(cat $AVAILABLE_FREQS | grep "1566000" | wc -l) -gt 0 ]; then
	if [ $(cat $AVAILABLE_FREQS | grep "1944000" | wc -l) -gt 0 ]; then
		echo "Xiami Mi2S detected | Overclocking enabled"
		echo "1566000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	fi
elif [ $(cat $AVAILABLE_FREQS | grep "1512000" | wc -l) -gt 0 ]; then
	if [ $(cat $AVAILABLE_FREQS | grep "1728000" | wc -l) -gt 0 ]; then
		echo "Xiami Mi2 detected | Overclocking enabled"
		echo "1512000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
	fi
fi

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
