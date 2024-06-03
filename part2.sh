#!/bin/bash
mkdir /virtbox 
wget https://download.virtualbox.org/virtualbox/7.0.18/VBoxGuestAdditions_7.0.18.iso
mount ./VBoxGuestAdditions_7.0.18.iso /virtbox 
sh /virtbox/VBoxLinuxAdditions.run && umount /virtbox 
rm -r /virtbox
rm -r ./VBoxGuestAdditions_7.0.18.iso 
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY