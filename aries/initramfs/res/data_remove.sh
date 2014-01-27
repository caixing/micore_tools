#!/system/bin/sh
export PATH=/sbin:/system/xbin:/system/bin:$PATH

# get syspart-flag from cmdline
set -- $(cat /proc/cmdline)
for x in "$@"; do
    case "$x" in
        syspart=*)
        SYSPART=$(echo "${x#syspart=}")
        ;;
    esac
done

if [ -e /data_root/.truedualboot ]; then
	if [ -d /data_root/app ]; then
		if [ -d /data_root/dalvik-cache ]; then
			if [ -d /data_root/system ]; then
				cd /data_root
				ls -a > structure.log
				sed -i '/structure.log/ d' structure.log
				sed -i '/.truedualboot/ d' structure.log 
				sed -i '/system0/ d' structure.log 
				sed -i '/system1/ d' structure.log 
				sed -i '/lost+found/ d' structure.log 
				rm -rf /data
				mkdir -p /data
				chmod 0775 /data
				cat structure.log | while read all_line; do
					rm -rf /data_root/$all_line 
					rm -f /data_root/$all_line 
				done
				rm /data_root/structure.log
				rm /data/validate_data.sh
			fi
		fi
	fi
else
	rm /data_root/validate_data.sh
fi
exit
