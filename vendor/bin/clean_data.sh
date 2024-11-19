#!/vendor/bin/sh

echo "[Factory][WA] Clean /data/data abnormal symlink." > /dev/kmsg
rm /data/data/*==deleted==
echo "[Factory][WA] Clean /data/data done." > /dev/kmsg

