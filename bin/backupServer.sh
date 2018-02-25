#!/bin/sh

# check if we are superuser
if [ `id -u` -ne 0 ]; then
  echo "Error: Please run with sudo."
  exit 1
fi

# sync data to usbdisk
quelle=/mnt/disk1/
ziel=/media/usbdisk/
heute=$(date +%Y-%m-%d)

mount $ziel

if [ $? -eq 0 ]; then

  rsync -avR --delete "${quelle}"  "${ziel}${heute}/" --link-dest="${ziel}last/"
  ln -nsf "${ziel}${heute}" "${ziel}last"
  umount $ziel

else

  echo "Error: $ziel could not be mounted."

fi

exit 0
