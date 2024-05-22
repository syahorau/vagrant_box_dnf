#!/bin/bash
wget https://download.virtualbox.org/virtualbox/7.0.18/VBoxGuestAdditions_7.0.18.iso
mkdir /virtbox 
mount ./VBoxGuestAdditions_7.0.18.iso /virtbox && \
sh /virtbox/VBoxLinuxAdditions.run & \
umount /virtbox & \
rm -r /virtbox
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY