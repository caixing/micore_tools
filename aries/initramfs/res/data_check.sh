#!/system/bin/sh
export PATH=/sbin:/system/xbin:/system/bin:$PATH

if [ -e /data_root/.truedualboot ]; then
	if [ -d /data_root/app ]; then
		if [ -d /data_root/dalvik-cache ]; then
			if [ -d /data_root/system ]; then
				clear
				echo " #################################"
				echo "       MiCore DATA check"
				echo " #################################"
				echo
				echo " MiCore found some old data on your /data partition"
				echo " You can do two things with this data"
				echo
				echo "   1 - Remove the old data"
				echo "   2 - Restore old data (replaces current data)"
				echo
				echo "   3 - Cancel"
				echo
				echo -en " Please enter a choice: "; read data_choice

				case "$data_choice" in
					1) cp /res/data_remove.sh /data_root/validate_data.sh
					   chmod 777 /data_root/validate_data.sh
					   echo -e "\nPhone will restart and the old data will be removed"; sleep 2
					   reboot;;
					2) cp /res/data_restore.sh /data_root/validate_data.sh
					   chmod 777 /data_root/validate_data.sh
					   echo -e "\nPhone will restart and the old data will be restored"; sleep 2
					   reboot;;
					3) clear; exit;;
				esac
			else
				echo "/data is clean"; sleep 2; clear; exit
			fi
		else
			echo "/data is clean"; sleep 2; clear; exit
		fi
	else
		echo "/data is clean"; sleep 2; clear; exit
	fi
else
	echo "TrueDualBoot is not enabled"; sleep 2; clear; exit
fi
