### If one disk gets un-added:

mdadm /dev/md0 --manage --add /dev/sdc1 # Replace with correct /dev/ devices


### Info:

mdadm --detail /dev/md0