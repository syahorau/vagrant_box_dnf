#!/bin/bash
rm -rf /etc/rc.local
rm -rf /root/part3.sh
rm -rf /etc/rc.d/rc.local
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
shutdown -h +0