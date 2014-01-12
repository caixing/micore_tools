#!/sbin/sh
# Check MiCore requirements

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

		# WiUi support for MiCore
		if [ "`cat /system/build.prop | grep "ro.product.mod_device=aries_wiui" | wc -l`" -gt 0 ]; then
			sed -i '/# init.d support for WiUi/ d' /system/etc/init.qcom.post_boot.sh
			sed -i '/run-parts /system/etc/init.d// d' /system/etc/init.qcom.post_boot.sh
			rm -f /system/etc/init.d/01_sysctl
			rm -f /system/etc/init.d/03_engine
			rm -f /system/etc/init.d/04_cron_support
			rm -f /system/etc/init.d/05_clean
			rm -f /system/etc/init.d/07_rngd
			rm -f /system/etc/init.d/09_fstrim
			rm -rf /system/etc/cron
		fi
fi

# Thermald.conf
if [ ! -e /system/etc/thermald.conf ]; then
	cp /res/thermald.conf /system/etc/thermald.conf
fi

# Disable MPDecision
if [ -e /system/bin/mpdecision ]; then
     	mv /system/bin/mpdecision /system/bin/mpdecision.bak
fi

# Busybox
if [ ! -e /system/xbin/[ ]; then 
	if [ ! -e /system/xbin/[[ ]; then
		cp /sbin/busybox /system/xbin/busybox
		chmod 755 /system/xbin/busybox
		ln -sf /system/xbin/busybox /system/xbin/[
		ln -sf /system/xbin/busybox /system/xbin/[[
		ln -sf /system/xbin/busybox /system/xbin/ash
		ln -sf /system/xbin/busybox /system/xbin/awk
		ln -sf /system/xbin/busybox /system/xbin/base64
		ln -sf /system/xbin/busybox /system/xbin/basename
		ln -sf /system/xbin/busybox /system/xbin/blkid
		ln -sf /system/xbin/busybox /system/xbin/bunzip2
		ln -sf /system/xbin/busybox /system/xbin/bzcat
		ln -sf /system/xbin/busybox /system/xbin/bzip2
		ln -sf /system/xbin/busybox /system/xbin/cal
		ln -sf /system/xbin/busybox /system/xbin/cat
		ln -sf /system/xbin/busybox /system/xbin/chat
		ln -sf /system/xbin/busybox /system/xbin/cattr
		ln -sf /system/xbin/busybox /system/xbin/chgrp
		ln -sf /system/xbin/busybox /system/xbin/chmod
		ln -sf /system/xbin/busybox /system/xbin/chown
		ln -sf /system/xbin/busybox /system/xbin/chroot
		ln -sf /system/xbin/busybox /system/xbin/chrt
		ln -sf /system/xbin/busybox /system/xbin/cksum
		ln -sf /system/xbin/busybox /system/xbin/clear
		ln -sf /system/xbin/busybox /system/xbin/comm
		ln -sf /system/xbin/busybox /system/xbin/cp
		ln -sf /system/xbin/busybox /system/xbin/crond
		ln -sf /system/xbin/busybox /system/xbin/crontab
		ln -sf /system/xbin/busybox /system/xbin/cut
		ln -sf /system/xbin/busybox /system/xbin/date
		ln -sf /system/xbin/busybox /system/xbin/dd
		ln -sf /system/xbin/busybox /system/xbin/depmod
		ln -sf /system/xbin/busybox /system/xbin/devmem
		ln -sf /system/xbin/busybox /system/xbin/dexdump
		ln -sf /system/xbin/busybox /system/xbin/df
		ln -sf /system/xbin/busybox /system/xbin/diff
		ln -sf /system/xbin/busybox /system/xbin/dirname
		ln -sf /system/xbin/busybox /system/xbin/dmesg
		ln -sf /system/xbin/busybox /system/xbin/dnsd
		ln -sf /system/xbin/busybox /system/xbin/dnsddomainname
		ln -sf /system/xbin/busybox /system/xbin/dos2unix
		ln -sf /system/xbin/busybox /system/xbin/du
		ln -sf /system/xbin/busybox /system/xbin/echo
		ln -sf /system/xbin/busybox /system/xbin/egrep
		ln -sf /system/xbin/busybox /system/xbin/env
		ln -sf /system/xbin/busybox /system/xbin/ether-wake
		ln -sf /system/xbin/busybox /system/xbin/expand
		ln -sf /system/xbin/busybox /system/xbin/expr
		ln -sf /system/xbin/busybox /system/xbin/fakeidentd
		ln -sf /system/xbin/busybox /system/xbin/fbset
		ln -sf /system/xbin/busybox /system/xbin/fdflush
		ln -sf /system/xbin/busybox /system/xbin/fdformat
		ln -sf /system/xbin/busybox /system/xbin/fgrep
		ln -sf /system/xbin/busybox /system/xbin/find
		ln -sf /system/xbin/busybox /system/xbin/fold
		ln -sf /system/xbin/busybox /system/xbin/free
		ln -sf /system/xbin/busybox /system/xbin/freeramdisk
		ln -sf /system/xbin/busybox /system/xbin/fsck
		ln -sf /system/xbin/busybox /system/xbin/fsync
		ln -sf /system/xbin/busybox /system/xbin/ftpd
		ln -sf /system/xbin/busybox /system/xbin/ftpget
		ln -sf /system/xbin/busybox /system/xbin/ftpput
		ln -sf /system/xbin/busybox /system/xbin/fuser
		ln -sf /system/xbin/busybox /system/xbin/getopt
		ln -sf /system/xbin/busybox /system/xbin/grep
		ln -sf /system/xbin/busybox /system/xbin/groups
		ln -sf /system/xbin/busybox /system/xbin/gunzip
		ln -sf /system/xbin/busybox /system/xbin/gzip
		ln -sf /system/xbin/busybox /system/xbin/hd
		ln -sf /system/xbin/busybox /system/xbin/head
		ln -sf /system/xbin/busybox /system/xbin/hexdump
		ln -sf /system/xbin/busybox /system/xbin/hostid
		ln -sf /system/xbin/busybox /system/xbin/hostname
		ln -sf /system/xbin/busybox /system/xbin/httpd
		ln -sf /system/xbin/busybox /system/xbin/hwclock
		ln -sf /system/xbin/busybox /system/xbin/id
		ln -sf /system/xbin/busybox /system/xbin/ifconf
		ln -sf /system/xbin/busybox /system/xbin/ifenslave
		ln -sf /system/xbin/busybox /system/xbin/inotifyd
		ln -sf /system/xbin/busybox /system/xbin/insmod
		ln -sf /system/xbin/busybox /system/xbin/install
		ln -sf /system/xbin/busybox /system/xbin/ionice
		ln -sf /system/xbin/busybox /system/xbin/iostat
		ln -sf /system/xbin/busybox /system/xbin/ip
		ln -sf /system/xbin/busybox /system/xbin/ipaddr
		ln -sf /system/xbin/busybox /system/xbin/ipcalc
		ln -sf /system/xbin/busybox /system/xbin/iplink
		ln -sf /system/xbin/busybox /system/xbin/iproute
		ln -sf /system/xbin/busybox /system/xbin/iprule
		ln -sf /system/xbin/busybox /system/xbin/iptunnel
		ln -sf /system/xbin/busybox /system/xbin/kill
		ln -sf /system/xbin/busybox /system/xbin/killall
		ln -sf /system/xbin/busybox /system/xbin/killall5
		ln -sf /system/xbin/busybox /system/xbin/less
		ln -sf /system/xbin/busybox /system/xbin/ln
		ln -sf /system/xbin/busybox /system/xbin/logname
		ln -sf /system/xbin/busybox /system/xbin/losetup
		ln -sf /system/xbin/busybox /system/xbin/ls
		ln -sf /system/xbin/busybox /system/xbin/lsattr
		ln -sf /system/xbin/busybox /system/xbin/lsmod
		ln -sf /system/xbin/busybox /system/xbin/lsof
		ln -sf /system/xbin/busybox /system/xbin/lsusb
		ln -sf /system/xbin/busybox /system/xbin/lzop
		ln -sf /system/xbin/busybox /system/xbin/lzopcat
		ln -sf /system/xbin/busybox /system/xbin/md5sum
		ln -sf /system/xbin/busybox /system/xbin/microcom
		ln -sf /system/xbin/busybox /system/xbin/mkdir
		ln -sf /system/xbin/busybox /system/xbin/mkdosfs
		ln -sf /system/xbin/busybox /system/xbin/mke2fs
		ln -sf /system/xbin/busybox /system/xbin/mkfifo
		ln -sf /system/xbin/busybox /system/xbin/mkfs.ext2
		ln -sf /system/xbin/busybox /system/xbin/mkfs.vfat
		ln -sf /system/xbin/busybox /system/xbin/mknod
		ln -sf /system/xbin/busybox /system/xbin/mkswap
		ln -sf /system/xbin/busybox /system/xbin/modinfo
		ln -sf /system/xbin/busybox /system/xbin/modprobe
		ln -sf /system/xbin/busybox /system/xbin/more
		ln -sf /system/xbin/busybox /system/xbin/mount
		ln -sf /system/xbin/busybox /system/xbin/mountpoint
		ln -sf /system/xbin/busybox /system/xbin/mt
		ln -sf /system/xbin/busybox /system/xbin/mv
		ln -sf /system/xbin/busybox /system/xbin/nameif
		ln -sf /system/xbin/busybox /system/xbin/nanddump
		ln -sf /system/xbin/busybox /system/xbin/nandwrite
		ln -sf /system/xbin/busybox /system/xbin/nc
		ln -sf /system/xbin/busybox /system/xbin/netstat
		ln -sf /system/xbin/busybox /system/xbin/nice
		ln -sf /system/xbin/busybox /system/xbin/nmeter
		ln -sf /system/xbin/busybox /system/xbin/nohup
		ln -sf /system/xbin/busybox /system/xbin/nslookup
		ln -sf /system/xbin/busybox /system/xbin/ntpd
		ln -sf /system/xbin/busybox /system/xbin/od
		ln -sf /system/xbin/busybox /system/xbin/ota
		ln -sf /system/xbin/busybox /system/xbin/patch
		ln -sf /system/xbin/busybox /system/xbin/pgrep
		ln -sf /system/xbin/busybox /system/xbin/pidof
		ln -sf /system/xbin/busybox /system/xbin/ping
		ln -sf /system/xbin/busybox /system/xbin/pkill
		ln -sf /system/xbin/busybox /system/xbin/pmap
		ln -sf /system/xbin/busybox /system/xbin/powertop
		ln -sf /system/xbin/busybox /system/xbin/printenv
		ln -sf /system/xbin/busybox /system/xbin/printf
		ln -sf /system/xbin/busybox /system/xbin/ps
		ln -sf /system/xbin/busybox /system/xbin/psscan
		ln -sf /system/xbin/busybox /system/xbin/pwd
		ln -sf /system/xbin/busybox /system/xbin/rdate
		ln -sf /system/xbin/busybox /system/xbin/rdev
		ln -sf /system/xbin/busybox /system/xbin/readlink
		ln -sf /system/xbin/busybox /system/xbin/realpath
		ln -sf /system/xbin/busybox /system/xbin/renice
		ln -sf /system/xbin/busybox /system/xbin/reset
		ln -sf /system/xbin/busybox /system/xbin/rev
		ln -sf /system/xbin/busybox /system/xbin/rfkill
		ln -sf /system/xbin/busybox /system/xbin/rm
		ln -sf /system/xbin/busybox /system/xbin/rmdir		
		ln -sf /system/xbin/busybox /system/xbin/rmmod
		ln -sf /system/xbin/busybox /system/xbin/route
		ln -sf /system/xbin/busybox /system/xbin/run-parts
		ln -sf /system/xbin/busybox /system/xbin/script
		ln -sf /system/xbin/busybox /system/xbin/scriptreplay
		ln -sf /system/xbin/busybox /system/xbin/sed
		ln -sf /system/xbin/busybox /system/xbin/seq
		ln -sf /system/xbin/busybox /system/xbin/setkeycodes
		ln -sf /system/xbin/busybox /system/xbin/setlogcons
		ln -sf /system/xbin/busybox /system/xbin/setsid
		ln -sf /system/xbin/busybox /system/xbin/sha1sum
		ln -sf /system/xbin/busybox /system/xbin/sha256sum
		ln -sf /system/xbin/busybox /system/xbin/sha3sum
		ln -sf /system/xbin/busybox /system/xbin/sha512sum
		ln -sf /system/xbin/busybox /system/xbin/shelld
		ln -sf /system/xbin/busybox /system/xbin/showkey
		ln -sf /system/xbin/busybox /system/xbin/sleep
		ln -sf /system/xbin/busybox /system/xbin/smemcap
		ln -sf /system/xbin/busybox /system/xbin/sort
		ln -sf /system/xbin/busybox /system/xbin/split
		ln -sf /system/xbin/busybox /system/xbin/start-stop-deamon
		ln -sf /system/xbin/busybox /system/xbin/stat
		ln -sf /system/xbin/busybox /system/xbin/strace
		ln -sf /system/xbin/busybox /system/xbin/strings
		ln -sf /system/xbin/busybox /system/xbin/stty
		ln -sf /system/xbin/busybox /system/xbin/sum
		ln -sf /system/xbin/busybox /system/xbin/swapoff
		ln -sf /system/xbin/busybox /system/xbin/swapon
		ln -sf /system/xbin/busybox /system/xbin/sync
		ln -sf /system/xbin/busybox /system/xbin/sysctl
		ln -sf /system/xbin/busybox /system/xbin/tac
		ln -sf /system/xbin/busybox /system/xbin/tail
		ln -sf /system/xbin/busybox /system/xbin/tar
		ln -sf /system/xbin/busybox /system/xbin/tee
		ln -sf /system/xbin/busybox /system/xbin/telnet
		ln -sf /system/xbin/busybox /system/xbin/telnetd
		ln -sf /system/xbin/busybox /system/xbin/test
		ln -sf /system/xbin/busybox /system/xbin/tftp
		ln -sf /system/xbin/busybox /system/xbin/tftpd
		ln -sf /system/xbin/busybox /system/xbin/time
		ln -sf /system/xbin/busybox /system/xbin/timeout
		ln -sf /system/xbin/busybox /system/xbin/top
		ln -sf /system/xbin/busybox /system/xbin/touch
		ln -sf /system/xbin/busybox /system/xbin/tr
		ln -sf /system/xbin/busybox /system/xbin/traceroute
		ln -sf /system/xbin/busybox /system/xbin/tty
		ln -sf /system/xbin/busybox /system/xbin/ttysize
		ln -sf /system/xbin/busybox /system/xbin/tunctl
		ln -sf /system/xbin/busybox /system/xbin/umount
		ln -sf /system/xbin/busybox /system/xbin/uname
		ln -sf /system/xbin/busybox /system/xbin/uncompress
		ln -sf /system/xbin/busybox /system/xbin/unexpand
		ln -sf /system/xbin/busybox /system/xbin/uniq
		ln -sf /system/xbin/busybox /system/xbin/unix2dos
		ln -sf /system/xbin/busybox /system/xbin/unlzop
		ln -sf /system/xbin/busybox /system/xbin/unzip
		ln -sf /system/xbin/busybox /system/xbin/uptime
		ln -sf /system/xbin/busybox /system/xbin/usleep
		ln -sf /system/xbin/busybox /system/xbin/uudecode
		ln -sf /system/xbin/busybox /system/xbin/uuencode
		ln -sf /system/xbin/busybox /system/xbin/vconfig
		ln -sf /system/xbin/busybox /system/xbin/vi
		ln -sf /system/xbin/busybox /system/xbin/watch
		ln -sf /system/xbin/busybox /system/xbin/wc
		ln -sf /system/xbin/busybox /system/xbin/wget
		ln -sf /system/xbin/busybox /system/xbin/which
		ln -sf /system/xbin/busybox /system/xbin/whoami
		ln -sf /system/xbin/busybox /system/xbin/whois
		ln -sf /system/xbin/busybox /system/xbin/xargs
		ln -sf /system/xbin/busybox /system/xbin/zcat
	fi
fi

mount -o remount,ro /system
