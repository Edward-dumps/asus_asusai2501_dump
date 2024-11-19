#!/system/bin/sh
#store log file
#LOG_FILE="/data/WifiTest_service.log"

logi () {
  echo "`date` I $@" >> $LOG_FILE
}

logd () {
  echo "`date` D $@" >> $LOG_FILE
}

loge () {
  echo "`date` E $@" >> $LOG_FILE
}
setprop vendro.wlan.root_run.ret ""
cmd=`getprop vendor.wlan.root_run.cmd`
#log -t wifitest_runcmd cmd=$cmd
#echo $cmd >> $LOG_FILE
#logi "> run command $cmd"
ret=`$cmd`
#logi "> run result $ret"
log -t wifitest_runcmd ret=$ret
setprop vendor.wlan.root_run.ret "$ret"
