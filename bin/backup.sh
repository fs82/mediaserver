#!/bin/sh

quelle=/mnt/disk1/
ziel=/media/usbdisk/
heute=$(date +%Y-%m-%d)

if [ `id -u` -eq 0 ]; then

  #Mount the external disc
  mount $ziel

  #Check if mounting was successfull
  if [ $? -eq 0 ]; then

    echo "Successfully mounted external disk for backup."

    #Copy backup to external disc
    rsync -avR --delete "${quelle}"  "${ziel}${heute}/" --link-dest="${ziel}last/"
    ln -nsf "${ziel}${heute}" "${ziel}last"

    #Unmount external disc
    umount $ziel

    if [ $? -eq 0 ]; then
      echo "External disk was unmouted successfully."
    else
      echo "Problems occured while unmounting of external disk."
    fi
  else
    echo "Not possible to mount external disk for backup"
  fi 
else
  echo "Please run as root"
fi

exit 0
