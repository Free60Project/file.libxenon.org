#!/bin/bash

wget http://file.libxenon.org/free60/linux/xenosfb_drv.so_squeeze
mv xenosfb_drv.so_squeeze /usr/lib/xorg/modules/drivers/xenosfb_drv.so

wget http://file.libxenon.org/latest_kern
mv latest_kern /boot/vmlinux

wget http://file.libxenon.org/free60/linux/xorg.conf
mv xorg.conf /etc/X11/xorg.conf

cat > /boot/kboot.conf << EOF
#KBOOTCONFIG
; #KBOOTCONFIG (and nothing else) has to stay in FIRST line of the file

# General XeLL options
; netconfig - only if the ip= is valid and isnt the same as eventually in the previously parsed kboot.conf, the netconfig gets set
; ip=192.168.1.99
; netmask=255.255.255.0
; gateway=192.168.1.98

; set custom tftp server IP
; tftp_server=192.168.11.40

; XeLL's videomode - valid modes:
;  0: VIDEO_MODE_VGA_640x480
;  1: VIDEO_MODE_VGA_1024x768
;  2: VIDEO_MODE_PAL60
;  3: VIDEO_MODE_YUV_480P
;  4: VIDEO_MODE_PAL50
;  5: VIDEO_MODE_VGA_1280x768
;  6: VIDEO_MODE_VGA_1360x768
;  7: VIDEO_MODE_VGA_1280x720
;  8: VIDEO_MODE_VGA_1440x900
;  9: VIDEO_MODE_VGA_1280x1024
; 10: VIDEO_MODE_HDMI_720P
; 11: VIDEO_MODE_YUV_720P
; 12: VIDEO_MODE_NTSC
; videomode=10

; speed up cpu - valid modes:
; 1: XENON_SPEED_FULL
; 2: XENON_SPEED_3_2
; 3: XENON_SPEED_1_2
; 4: XENON_SPEED_1_3
; speedup=1


# Linux/ELF BootMenu
# Supplying boot-entries is optional - you can delete those from the config to just set "General XeLL options"

; label of the default bootenty - if none is set, it default to first bootentry
default=debian_hdd

; timeout of the bootmenu in seconds - timeout=0 skips user input completely!
timeout=30

; Kernel / Bootentries
; ! first parameter: kernel path !

ubuntu_usb="uda:/vmlinux console=tty0 console=ttyS0,115200n8 video=xenonfb panic=60 maxcpus=3"
ubuntu_hdd="sda:/vmlinux console=tty0 console=ttyS0,115200n8 video=xenonfb panic=60 maxcpus=3"
EOF

update-alternatives --set editor /usr/bin/vim.tiny
echo "xbox	ALL=(ALL) ALL">>/target/etc/sudoers

sync
