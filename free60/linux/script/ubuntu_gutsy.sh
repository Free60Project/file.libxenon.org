#!/bin/bash
# set the date to anything except 1/1/1970 since this causes issues
# time is now also set after first boot by .bashrc script below
date -s 1/1/2009
# if /dev/sda is mounted then paritions get wiped by dd but sfdisk fails!
swapoff /dev/sda1
umount /mnt/ubuntu
# partition and mkfs hdd (all data is lost!)
dd if=/dev/zero of=/dev/sda bs=512 count=1
sfdisk /dev/sda << EOF
,124,S
,,L
EOF
dd if=/dev/zero of=/dev/sda2 bs=512 count=1
mkfs.ext3 /dev/sda2
mkswap /dev/sda1
sync; sync; sync
swapon /dev/sda1
# setup paths
mkdir /mnt/ubuntu
mount /dev/sda2 /mnt/ubuntu
cd /mnt/ubuntu
mkdir /mnt/ubuntu/work
cd /mnt/ubuntu/work
# download extract and run debootstrap
wget ftp://old-releases.ubuntu.com/old-images/ubuntu/pool/main/d/debootstrap/debootstrap_1.0.3build1_all.deb
ar -xf debootstrap_1.0.3build1_all.deb
cd /mnt/ubuntu
zcat < /mnt/ubuntu/work/data.tar.gz | tar xv
export DEBOOTSTRAP_DIR=/mnt/ubuntu/usr/lib/debootstrap
export PATH=$PATH:/mnt/ubuntu/usr/sbin
debootstrap --arch powerpc gutsy /mnt/ubuntu ftp://old-releases.ubuntu.com/old-images/ubuntu/
# create needed files on hdd
echo Falcon > /mnt/ubuntu/etc/hostname
cat > /mnt/ubuntu/etc/fstab << EOF
/dev/sda2     /          ext3     defaults   0   0
/dev/sda1     none    swap    sw           0   0
proc            /proc    proc    defaults  0   0
EOF
cat > /mnt/ubuntu/etc/network/interfaces << EOF
iface lo inet loopback
auto lo
auto eth0
iface eth0 inet dhcp
EOF
cat > /mnt/ubuntu/etc/apt/sources.list << EOF
deb ftp://old-releases.ubuntu.com/old-images/ubuntu/ gutsy main restricted universe multiverse
EOF
#Change root-pwd inside chroot
chroot /mnt/ubuntu echo "root:xbox" | chroot /mnt/ubuntu /usr/sbin/chpasswd
cp /mnt/ubuntu/root/.bashrc /mnt/ubuntu/root/.bashrc.orginal
# create .bashrc script on hdd
cat >> /mnt/ubuntu/root/.bashrc << EOF
date -s 1/1/2009
passwd
mkdir /lib/modules/2.6.24.3
touch /lib/modules/2.6.24.3/modules.dep
apt-get update
apt-get install ntp wget -y --force-yes
apt-get install ubuntu-desktop -y
echo "AVAHI_DAEMON_START=0" > /etc/default/avahi-daemon
/etc/init.d/networking restart
cd /usr/lib/xorg/modules/drivers/
wget -O xenosfb_drv.so http://file.libxenon.org/free60/linux/xenosfb/xenosfb_drv.so_gutsy
cd /etc/X11/
wget http://file.libxenon.org/free60/linux/xenosfb/xorg.conf
mv ubuntu.conf xorg.conf
cd /usr/lib/xorg/modules/linux/
mv libfbdevhw.so libfbdevhw.so.bk
wget -O libfbdevhw.so http://file.libxenon.org/free60/linux/xenosfb/libfbdevhw.so_gutsy
rm -r -f /work/
echo "" > /etc/gdm/gdm.conf-custom
sed -i 's/AllowRoot=false/AllowRoot=true/' /etc/gdm/gdm.conf
rm /root/.bashrc
mv /root/.bashrc.orginal /root/.bashrc
/etc/init.d/gdm start
EOF
# done
echo "Base installation completed."
echo "To finish the installation: Reboot and load the kernel with correct root= params."
echo "The installmay take up to two hours, depending on your internet connection"
