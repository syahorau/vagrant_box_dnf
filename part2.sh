#!/bin/bash
#create folder
sleep 10s
wget https://download.virtualbox.org/virtualbox/7.0.18/VBoxGuestAdditions_7.0.18.iso && mount ./VBoxGuestAdditions_7.0.18.iso /mnt
sh /mnt/VBoxLinuxAdditions.run 
sleep 10s
umount /mnt
sleep 10s
if [ -f "/etc/rc.d/rc.local" ]; then
  sed -i '/part2/part3/g' /etc/rc.d/rc.local
else 
  sed -i '/part2/part3/g' /etc/rc.local
fi
rm -rf ./VBoxGuestAdditions_7.0.18.iso 
rm -rf /root/part2.sh
shutdown -r +0