#!/sbin/sh

export PATH=/sbin:/system/sbin:/system/bin:/system/xbin

mount -o remount,rw /system
if [ ! -e /system/etc/kernel.cfg ]; then
     cp /sbin/kernel.cfg /system/etc/kernel.cfg
fi
if [ ! -e /system/bin/configure ]; then
     cp /sbin/configure.sh /system/bin/configure
     chmod 775 /system/bin/configure
fi
if [ ! -d /system/lib/modules ]; then
     cp -r /lib/modules /system/lib/modules
     chmod -R 755 /system/lib/modules
     chmod -R 755 /system/lib/modules/prima
     chmod 644 /system/lib/modules/*.ko
     chmod 644 /system/lib/modules/prima/prima_wlan.ko
     ln -s /system/lib/modules/prima/prima_wlan.ko /system/lib/modules/wlan.ko
fi
source /system/etc/kernel.cfg
mount -o remount,ro /system

case "$SCALING_GOVERNOR" in
     ondemand) echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;;
  interactive) echo "interactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;;
  performance) echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;;
     msm-dcvs) echo "msm-dcvs" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;;
esac

case "$SCHEDULER" in
      sio) echo "sio" > /sys/block/mmcblk0/queue/scheduler;;
     noop) echo "noop" > /sys/block/mmcblk0/queue/scheduler;;
 deadline) echo "deadline" > /sys/block/mmcblk0/queue/scheduler;;
      cfq) echo "cfq" > /sys/block/mmcblk0/queue/scheduler
           echo "0" > /sys/block/mmcblk0/queue/rotational
           echo "1" > /sys/block/mmcblk0/queue/iosched/low_latency
           echo "1" > /sys/block/mmcblk0/queue/iosched/back_seek_penalty
           echo "1000000000" > /sys/block/mmcblk0/queue/iosched/back_seek_max
           echo "3" > /sys/block/mmcblk0/queue/iosched/slice_idle;;
esac

if [ "$FSTRIM" = "y" ]; then
     /sbin/fstrim -v /cache
     /sbin/fstrim -v /data
fi

echo "4096" > /proc/sys/vm/min_free_kbytes

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
