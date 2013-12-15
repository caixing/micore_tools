#!/sbin/sh

export PATH=/sbin:/system/sbin:/system/bin:/system/xbin

mount -o remount,rw /system
# modules permissions
if [ ! -e /system/lib/modules/wlan.ko ]; then
     chmod -R 755 /system/lib/modules
     chmod -R 755 /system/lib/modules/prima
     chmod 644 /system/lib/modules/*.ko
     chmod 644 /system/lib/modules/prima/prima_wlan.ko
     ln -s /system/lib/modules/prima/prima_wlan.ko /system/lib/modules/wlan.ko
fi

# disable MPDecision
if [ -e /system/bin/mpdecision ]; then
     mv /system/bin/mpdecision /system/bin/mpdecision.bak
fi
mount -o remount,ro /system

# Limit frequency driver
insmod /system/lib/modules/cpufreq_limit.ko

# CPU freq optimizations
MAX_FREQ=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq)
echo "384000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo "95" > /sys/devices/system/cpu/cpufreq/intellidemand/up_threshold
echo "85" > /sys/devices/system/cpu/cpufreq/intellidemand/up_threshold_any_cpu_load
echo "75" > /sys/devices/system/cpu/cpufreq/intellidemand/up_threshold_multi_core
echo "1134000, 1134000, 1134000, 1134000" > /sys/devices/system/cpu/cpufreq/intellidemand/two_phase_freq
echo "$MAX_FREQ" > /sys/devices/system/cpu/cpufreq/intellidemand/optimal_freq
echo "810000" > /sys/devices/system/cpu/cpufreq/intellidemand/sync_freq
echo "1350000, 1350000, 1350000, 1350000" > /sys/devices/system/cpu/cpufreq/intellidemand/input_event_min_freq

# KGSL simple
echo "simple" > /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0/pwrscale/trustzone/governor
echo "10000" > /sys/module/msm_kgsl_core/parameters/simple_ramp_threshold

# VM optimizations
echo "4096" > /proc/sys/vm/min_free_kbytes
echo "0" > /proc/sys/vm/swappiness

# fstrim
/sbin/fstrim -v /cache
/sbin/fstrim -v /data

# sysctl 
if [ -e /system/etc/sysctl.conf ]; then
     syctl -p /system/etc/sysctl.conf
fi

# init.d
if [ -d /system/etc/init.d ]; then
    chmod -R 755 /system/etc/init.d
    chmod 755 /system/etc/init.d/*
    /system/bin/logwrapper /sbin/run-parts /system/etc/init.d 
fi
