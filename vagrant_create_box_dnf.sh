#!/bin/bash
conf_folder='//192.168.100.100/docs/itm/'

dnf install -y mc zsh openssh-server sudo tree chrony bash-completion git tmux curl cifs-utils epel-release   
dnf install -y ntfs-3g dkms gpm gpg firewalld util-linux-user wget vim nano
dnf install -y groupinstall 'Development Tools'

# Change config's files for useradd and adduser ( no exist in Rocky)
sed -i \
-e 's/^ .SKEL=.*/SKEL=\/etc\/skel/g' \
-e 's/^SKEL=.*/SKEL=\/etc\/skel/g' \
-e 's/^ .SHELL=.*/SHELLL=\/bin\/zsh/g' \
-e 's/^SHELL=.*/SHELL=\/bin\/zsh/g' /etc/default/useradd

#mount conf_folder
mount -t cifs "$conf_folder" /mnt -o guest

# Copy come config for users and new users
tar -xf /mnt/confs/linux_users/base_user.tar.gz -C /home/siarhei/
tar -xf /mnt/confs/linux_users/base_user.tar.gz -C /etc/skel/
tar -xf /mnt/confs/linux_users/base_user.tar.gz -C /root/

unaliase cp

cp -rf /mnt/confs/ssh/ssh-etc/. /etc/ssh/
cp -rf /mnt/confs/ssh/ssh-siarhei/. /home/siarhei/.ssh/

chown -R siarhei:siarhei /home/siarhei
chown -R root:root /root

chsh -s $(which zsh)
chsh -s $(which zsh) siarhei

useradd -m vagrant
echo "vagrant:vagrant" | chpasswd
echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant
echo "siarhei ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/siarhei

sed -i \
-e 's/^.AuthorizedKeysFile.*/AuthorizedKeysFile \.ssh\/authorized_keys \.ssh\/authorized_keys2/g' /etc/ssh/sshd_config \
-e 's/^AuthorizedKeysFile.*/AuthorizedKeysFile \.ssh\/authorized_keys \.ssh\/authorized_keys2/g' /etc/ssh/sshd_config

mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh

wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys

chmod 0600 /home/vagrant/.ssh/authorized_keys && \
chown -R vagrant /home/vagrant/.ssh

firewall-cmd --permanent --new-zone=my-zone
firewall-cmd --reload
firewall-cmd --permanent --zone=my-zone --add-service={ssh,dhcp,dns}
firewall-cmd --permanent --zone=my-zone --add-interface=enp0s8
firewall-cmd --permanent --zone=my-zone --add-icmp-block-inversion
firewall-cmd --permanent --zone=my-zone --add-icmp-block={echo-reply,echo-request,destination-unreachable,time-exceeded}

hostnamectl set-hostname rocky9
echo '127.0.0.1 rocky9
::1 rocky9' > /etc/hosts

mkdir /virtbox && mount /dev/cdrom /virtbox && \
sh /virtbox/VBoxLinuxAdditions.run & \
umount /virtbox & \
rm -r /virtbox

#sudo dd if=/dev/zero of=/EMPTY bs=1M
#sudo rm -f /EMPTY