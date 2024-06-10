#!/bin/bash
if [ -f "/etc/rc.d/rc.local" ]; then
  sed -i '/\/root\/part3\.sh/d' /etc/rc.d/rc.local
  chmod -x /etc/rc.d/rc.local
else 
  rm -rf /etc/rc.local
fi
rm -rf /root/part3.sh
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
shutdown -h +0