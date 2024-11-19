#!/vendor/bin/sh

TAG="UDID"

SSN_FILE="/vendor/factory/SSN"

if [ ! -r $SSN_FILE ]; then
  log -t $TAG "$SSN_FILE isn't exist"
  echo ""
  exit
fi
serial_number=$(cat $SSN_FILE)

log -t $TAG "$serial_number"

mixed_number="$serial_number$RANDOM"

udid_number=$(echo $mixed_number | sha256sum | cut -d' ' -f1)

echo "$udid_number"
