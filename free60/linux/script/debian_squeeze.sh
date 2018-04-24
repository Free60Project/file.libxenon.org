#!/bin/bash
# set the date to anything except 1/1/1970 since this causes issues
# time is now also set after first boot by .bashrc script below
date -s 1/1/2009
# if /dev/sda is mounted then paritions get wiped by dd but sfdisk fails!
swapoff /dev/sda1
umount /mnt/debian
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
mkdir /mnt/debian
mount /dev/sda2 /mnt/debian
cd /mnt/debian
mkdir /mnt/debian/work
cd /mnt/debian/work
# download extract and run debootstrap
wget http://ftp.nl.debian.org/debian/pool/main/d/debootstrap/debootstrap_1.0.38_all.deb
ar -xf debootstrap_1.0.38_all.deb
cd /mnt/debian
zcat < /mnt/debian/work/data.tar.gz | tar xv
export DEBOOTSTRAP_DIR=/mnt/debian/usr/share/debootstrap
export PATH=$PATH:/mnt/debian/usr/sbin
debootstrap --arch powerpc squeeze /mnt/debian ftp://mirrors.kernel.org/debian/
# create needed files on hdd
echo Xenon > /mnt/debian/etc/hostname
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
#Change root-pwd to "xbox" inside chroot
chroot /mnt/debian echo "root:xbox" | chroot /mnt/debian /usr/sbin/chpasswd
# Add user: xbox with password: xbox
chroot /mnt/debian /usr/sbin/useradd -m -d /home/xbox -p paRRy2CC47LXY xbox
# create .second_stage script on hdd
cat >> /mnt/debian/root/.second_stage << EOF
#!/bin/bash
date -s 1/1/2009
apt-get update
apt-get install ntp wget openssh-server locales -y --force-yes
dpkg-reconfigure locales
apt-get install gnome -y
echo "AVAHI_DAEMON_START=0" > /etc/default/avahi-daemon
/etc/init.d/networking restart
cd /usr/lib/xorg/modules/drivers/
wget -O xenosfb_drv.so http://file.libxenon.org/free60/linux/xenosfb/xenosfb_drv.so_squeeze
cd /etc/X11/
wget http://file.libxenon.org/free60/linux/xenosfb/xorg.conf
rm -r -f /work/
echo "Installation completed."
echo "To boot the system: Reboot and load the kernel with correct root= params."
echo "You should be greeted by a fresh install of Debian 6 Squeeze"
EOF
chmod a+x /mnt/debian/root/.second_stage
# Execute second part of installation in the chroot environment
mount -t proc none /mnt/debian/proc
mount --rbind /dev /mnt/debian/dev
cp -L /etc/resolv.conf /mnt/debian/etc/resolv.conf
chroot /mnt/debian /root/.second_stage
umount /mnt/debian/dev /mnt/debian/proc /mnt/debian
