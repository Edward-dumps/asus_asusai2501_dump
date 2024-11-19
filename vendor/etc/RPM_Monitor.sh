#!/vendor/bin/sh

dongle_type=`getprop vendor.asus.dongletype`

while [ $dongle_type -eq 9 -o $dongle_type -eq 10 ]
do
	sleep 30
	# Check Sreen status
	screen_state=`getprop debug.tracing.screen_state`
	if [ "$screen_state" != "2" ]; then
		echo "[ROG8_INBOX][FanMonitor] Screen State $screen_state, skip monitor!!" > /dev/kmsg
		continue
	fi

	is_csc_testing=`getprop persist.vendor.asus.coolerstage_csc`
	if [ "$is_csc_testing" != "-1" ]; then
		echo "[ROG8_INBOX][FanMonitor] CSC tool is testing ($is_csc_testing), skip monitor!!" > /dev/kmsg
		continue
	fi

	dongle_type=`getprop vendor.asus.dongletype`

	if [ "$dongle_type" == "9" ] || [ "$dongle_type" == "10" ]; then
		FAN_RPM=`getprop persist.vendor.asus.userfanrpm`
		fan_rpm=`cat /sys/class/leds/aura_inbox/fan_RPM`
		fan_pwm=`cat /sys/class/leds/aura_inbox/fan_PWM`
		cooling_setting=`getprop persist.vendor.asus.coolerstage`
		cooling_current=`cat /sys/class/leds/aura_inbox/cooling_stage`

		echo "[ROG8_INBOX][FanMonitor] RPM=$fan_rpm , PWM=$fan_pwm , FAN setting=$FAN_RPM , Cooler setting=$cooling_setting, Cooler current=$cooling_current" > /dev/kmsg
		mic_type=`getprop vendor.asus.fan.mic`
		if [ "$mic_type" != "1" ]; then
			#work when mic off
			sleep 0.1
			#echo "[ROG8_INBOX][FanMonitor] FAM RPM = $FAN_RPM, cooling setting = $cooling_setting" > /dev/kmsg
			echo $FAN_RPM > /sys/class/leds/aura_inbox/fan_RPM

			if [ $cooling_setting -eq $cooling_current ]; then
				#echo "[ROG8_INBOX][FanMonitor] Cooler setting the same." > /dev/kmsg
				continue
			fi

			if [ $cooling_setting -gt 0 ]; then
				echo 1 > /sys/class/leds/aura_inbox/cooling_en
			else
				echo 0 > /sys/class/leds/aura_inbox/cooling_en
			fi
			echo $cooling_setting > /sys/class/leds/aura_inbox/cooling_stage
		fi
	else
		echo "[ROG8_INBOX][FanMonitor] DongleType $dongle_type, FANDG not exist." > /dev/kmsg
		exit
	fi
done

echo "[ROG8_INBOX][FanMonitor] DongleType $dongle_type, FANDG not exist." > /dev/kmsg
exit
