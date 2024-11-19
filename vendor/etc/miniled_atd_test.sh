#!/vendor/bin/sh
echo '1' >  /sys/class/leds/miniled/VDD
sleep 0.5
echo '1' >  /sys/class/leds/miniled/miniled_atd_test
result=`cat /sys/class/leds/miniled/miniled_atd_test`
if [ "$result" -eq "0" ]; then
        echo PASS
		setprop vendor.asus.atd.miniledtest 1
else
        echo FAIL
		setprop vendor.asus.atd.miniledtest 0
fi
