#!/vendor/bin/sh
GRIP_CAL_DATA_READ="/proc/driver/grip_cal_read"
GRIP_FW_INFO_PATH="/sys/class/grip_sensor/snt8100fsr/product_config"
GRIP_CHECK_K_VERSION="322"
COUNT=0
GRIP_GOLDEN_CAL_FILE="/vendor/etc/grip_cal/snt_reg_init_golden_ER"
CAL_DATA_WRITE_PATH="/sys/class/grip_sensor/snt8100fsr/boot_init_reg"
GRIP_CAL_FILE="/vendor/factory/snt_reg_init"

Read_Cal_Data(){
cal_data="`cat $GRIP_CAL_DATA_READ`"
cala_part1=`echo $cal_data | cut -d '&' -f1`
cala_part2=`echo $cal_data | cut -d '&' -f2`
calc=`echo $cal_data | cut -d '&' -f3`
calb=`echo $cal_data | cut -d '&' -f4`
setprop vendor.grip.CalDataA1 $cala_part1
setprop vendor.grip.CalDataA2 $cala_part2
setprop vendor.grip.CalDataC $calc
setprop vendor.grip.CalDataB $calb
setprop vendor.grip.CalData5 1
}

Check_Cal_Version(){
		GRIP_K_VER_STR=`cat $GRIP_FW_INFO_PATH | grep "FW Version"`
		echo $GRIP_K_VER_STR
		GRIP_K_VER_STR=`echo $GRIP_K_VER_STR | cut -d '.' -f3`
		echo $GRIP_K_VER_STR
		TEMP_STR=`echo ${GRIP_K_VER_STR:$COUNT:1}`
		echo $TEMP_STR
		while [ "0" == "$TEMP_STR" ]
		do
			COUNT=`expr $COUNT + 1`
			TEMP_STR=`echo ${GRIP_K_VER_STR:$COUNT:1}`
			echo ===$TEMP_STR
		done
		GRIP_K_VER_STR=`echo ${GRIP_K_VER_STR:$COUNT:3}`
		setprop vendor.grip.cur.version $GRIP_K_VER_STR
		echo $GRIP_K_VER_STR
}

Apply_Golden(){
	cat $GRIP_GOLDEN_CAL_FILE > $CAL_DATA_WRITE_PATH
}

Check_Cal_File(){
	if [ -f $GRIP_CAL_FILE ]; then
		setprop vendor.grip.calibration.file "Exist"
		Read_K_data
	else
		Apply_Golden
		GRIP_APPLY_GOLDEN=`expr $GRIP_APPLY_GOLDEN + 1`
		setprop vendor.grip.calibration.file "None"
	fi
}

Read_K_data(){
	cat $GRIP_CAL_FILE > $CAL_DATA_WRITE_PATH
}

Check_Cal_Version
GRIP_FW_EXPECT_VER=`getprop vendor.grip.cur.version`
echo "$GRIP_CHECK_K_VERSION, $GRIP_FW_EXPECT_VER"
if [ "$GRIP_CHECK_K_VERSION" == "$GRIP_FW_EXPECT_VER" ]; then
    setprop vendor.grip.chip_reset "skip_due_to_find_expect_fw_info"
else
	#reset chip when boot complete to avoid overlap file system 
	echo 1 > /sys/class/grip_sensor/snt8100fsr/chip_reset
	setprop vendor.grip.chip_reset start
	sleep 10
	setprop vendor.grip.chip_reset done
fi


#enable vibrator hw pin
echo 1 1 > /sys/class/leds/aw_vibrator/asus_haptic_trig_control
echo 2 1 > /sys/class/leds/aw_vibrator/asus_haptic_trig_control

VIB_STATUS=`cat /sys/class/leds/aw_vibrator/asus_haptic_trig_control`
setprop vendor.grip.vib.setting "$VIB_STATUS"
echo 110 0x00 > /sys/class/grip_sensor/snt8100fsr/set_sys_param
sleep 0.1

Check_Cal_File
#### Read Cal Data ####
Read_Cal_Data

echo 0x5 4 > /sys/class/grip_sensor/snt8100fsr/set_reg
