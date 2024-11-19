#!/vendor/bin/sh
if [ -e /batinfo/battery_activate_date ] ; then
data=`cat /batinfo/battery_activate_date`
setprop vendor.battery.activate_date "$data"
echo "[BAT][CHG][bq28z610] battery_activate_date_restore.sh: /batinfo/battery_activate_date: $data" > /dev/kmsg
else
echo "[BAT][CHG][bq28z610] battery_activate_date_restore.sh: /batinfo/battery_activate_date is not exist" > /dev/kmsg
fi
