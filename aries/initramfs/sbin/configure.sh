#!/system/bin/sh

export PATH=/sbin:/system/sbin:/system/bin:/system/xbin
SETTINGS=/system/etc/kernel.cfg

header () {
source $SETTINGS
clear
echo "-----------------------"
echo " MiCore $VERSION - Configurator"
echo "-----------------------"
}

start_menu () {
header
echo " 1 - Set CPU governor"
echo " 2 - Set I/O scheduler"
#echo " 3 - Set mc_sched_power_savings"
if [ $(cat $SETTINGS | grep "FSTRIM=y" | wc -l) -gt 0 ]; then
     echo " 3 - Disable FSTRIM"
else
     echo " 3 - Enable FSTRIM"
fi
echo
echo " a - Appy changes"
echo " e - Exit"
echo
echo -n "Type your choice: "; read menu_input

case "$menu_input" in
   1) scaling_governor_menu;; 
   2) scheduler_menu;;
#   3) mc_sched_menu;;
   3) if [ $(cat $SETTINGS | grep "FSTRIM=y" | wc -l) -gt 0 ]; then
           write_cfg "FSTRIM" "n"
      else
           write_cfg "FSTRIM" "y"
      fi; start_menu;;
   a) . /sbin/post_init.sh; echo -e "\nDone!"; start_menu;;
   e) clear; exit;;
   *) echo -e "\nWrong input"; start_menu;;
esac
}

scaling_governor_menu () {
header
echo " 1 - Set intellidemand governor as default"
echo " 2 - Set interactive governor as default"
echo " 3 - Set msm-dcvs governor as default"
echo " 4 - Set ondemand governor as default"
echo " 5 - Set performance governor as default"
echo
echo " b - Back"
echo "-----------------------"
echo "CPU governor = $SCALING_GOVERNOR"
echo
echo -n "Type your choice: "; read menu_input

case "$menu_input" in
   1) write_cfg "SCALING_GOVERNOR" "intellidemand"; scaling_governor_menu;;
   2) write_cfg "SCALING_GOVERNOR" "interactive"; scaling_governor_menu;;
   3) write_cfg "SCALING_GOVERNOR" "msm-dcvs"; scaling_governor_menu;;
   4) write_cfg "SCALING_GOVERNOR" "ondemand"; scaling_governor_menu;;
   5) write_cfg "SCALING_GOVERNOR" "performance"; scaling_governor_menu;;
   b) start_menu;;
   *) echo -e "\nWrong input"; scaling_governor_menu;;
esac
}

scheduler_menu () {
header
echo " 1 - Set cfq scheduler as default"
echo " 2 - Set deadline scheduler as default"
echo " 3 - Set noop scheduler as default"
echo " 4 - Set row scheduler as default"
echo " 5 - Set sio scheduler as default"
echo
echo " b - Back"
echo "-----------------------"
echo "I/O scheduler = $SCHEDULER"
echo
echo -n "Type your choice: "; read menu_input

case "$menu_input" in
   1) write_cfg "SCHEDULER" "cfq"; scheduler_menu;;
   2) write_cfg "SCHEDULER" "deadline"; scheduler_menu;;
   3) write_cfg "SCHEDULER" "noop"; scheduler_menu;;
   4) write_cfg "SCHEDULER" "row"; scheduler_menu;;
   5) write_cfg "SCHEDULER" "sio"; scheduler_menu;;
   b) start_menu;;
   *) echo -e "\nWrong input"; scheduler_menu;;
esac
}

mc_sched_menu () {
header
echo " 0 - Power savings disabled"
echo " 1 - Power savings normal"
echo " 2 - Power savings aggresive"
echo
echo " b - Back"
echo "-----------------------"
echo "Power savings = $MC_SCHED"
echo
echo -n "Type your choice: "; read menu_input

case "$menu_input" in
   0) write_cfg "MC_SCHED" "0"; mc_sched_menu;;
   1) write_cfg "MC_SCHED" "1"; mc_sched_menu;;
   2) write_cfg "MC_SCHED" "2"; mc_sched_menu;;
   b) start_menu;;
   *) echo -e "\nWrong input"; mc_sched_menu;;
esac
}

write_cfg () {
mount -o remount,rw /system
sed -i "/$1=*/ d" $SETTINGS
echo "$1=$2" >> $SETTINGS
mount -o remount,ro /system
}

start_menu

