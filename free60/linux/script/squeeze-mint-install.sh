#!/bin/bash
# set the date to anything except 1/1/1970 since this causes issues
# time is now also set after first boot by .bashrc script below
date -s 2/24/2011
dd if=/dev/zero of=/dev/sda bs=512 count=1
sfdisk /dev/sda << EOF
,124,S
,,L
EOF
mkfs.ext3 /dev/sda2
mkswap /dev/sda1
sync; sync; sync
swapon /dev/sda1
mkdir /mnt/debian
mount /dev/sda2 /mnt/debian
cd /mnt/debian
mkdir /mnt/debian/work
cd /mnt/debian/work
wget http://ftp.us.debian.org/debian/pool/main/d/debootstrap/debootstrap_1.0.30_all.deb
ar -xf debootstrap_1.0.30_all.deb
cd /mnt/debian
zcat < /mnt/debian/work/data.tar.gz | tar xv
cp /mnt/debian/usr/sbin/debootstrap /mnt/debian/usr/share/debootstrap     
export DEBOOTSTRAP_DIR=/mnt/debian/usr/share/debootstrap
export PATH=$PATH:/mnt/debian/usr/share/debootstrap
debootstrap --arch powerpc squeeze /mnt/debian ftp://mirrors.kernel.org/debian/
echo Xenon > /mnt/debian/etc/hostname
sed 's/localhost/localhost Xenon/g' /mnt/debian/etc/hosts
echo "This will be a temporary root password."
chroot /mnt/debian passwd
echo "This will be the user password and info."
chroot /mnt/debian adduser xbox
cat > /mnt/debian/etc/fstab << EOF
/dev/sda2     /          ext3     defaults   0   0
/dev/sda1     none    swap    sw           0   0
proc            /proc    proc    defaults  0   0
EOF
cat > /mnt/debian/etc/network/interfaces << EOF
iface lo inet loopback
auto lo
auto eth0
iface eth0 inet dhcp
EOF
cat > /mnt/debian/etc/apt/sources.list << EOF
deb ftp://mirrors.kernel.org/debian/ squeeze main contrib non-free
EOF
mv /mnt/debian/root/.bashrc /mnt/debian/root/.bashrc.orginal
wget -O /mnt/debian/root/.bashrc http://file.libxenon.org/free60/linux/script/.bashrc
echo "Base System Install Complete!"
echo "You may now shutdown the xbox360."
echo "Then continue the install by booting the Xell-Bootloader-sda2."
echo "And log in as user: root"
