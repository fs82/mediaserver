#!/bin/sh

quelle=/mnt/disk1/share/
ziel=/media/usbdisc/
heute=$(date +%Y-%m-%d)

if [ `id -u` -eq 0 ]; then

  #Mount the external disc
  mount $ziel

  #Check if mounting was successfull
  if [ $? -eq 0 ]; then
  
    echo "Successfully mounted external disc for backup."
  
    #Copy backup to external disc
    rsync -avR --delete "${quelle}"  "${ziel}${heute}/" --link-dest="${ziel}last/"
    ln -nsf "${ziel}${heute}" "${ziel}last"
  
    #Unmount external disc
    umount $ziel

    if [ $? -eq 0 ]; then
      echo "External disc was unmouted successfully."
    else
      echo "Problems occured while unmounting of external disc."
    fi
  else
    echo "Not possible to mount external disc for backup"
  fi 
else
  echo "Please run as root"
fi

exit 0
