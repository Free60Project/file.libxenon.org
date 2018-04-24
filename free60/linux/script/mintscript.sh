date -s 2/25/2011
mkdir /lib/modules/$(uname -r)
touch /lib/modules/$(uname -r)/modules.dep
#ntpdate -b pool.ntp.org
#ntpd -b pool.ntp.org
apt-get update
apt-get install ntp wget -y --force-yes
apt-get install xorg -y --force-yes
aptitude install gdm -y
echo "" > /etc/gdm/gdm.conf-custom
sed -i '/security/ a\AllowRoot=true' /etc/gdm/gdm.conf
cd /etc/X11
rm -r -f xorg.conf
wget http://file.libxenon.org/free60/linux/xorg.conf
cd /home
# Setting up log
_LOG=/var/log/mintppc9_install.log
echo "Begining installation" >> /var/log/mintppc9_install.log
date >> /var/log/mintppc9_install.log
_pkgdir=/usr/local/src
#
_welcomemsg()
{
echo "_welcomemsg" >> /var/log/mintppc9_install.log
	clear
	echo "Welcome to MintPPC 9.2 GNU/Linux installer."
	echo ""
	echo "This shell script has been designed to run after a minimal"
	echo "\"CLI\" netinstall installation of Debian Squeeze. The script"
	echo "will attempt to configure the required repositories and"
	echo "install the necessary packages needed to transform a"
	echo "Standard System install into a usable Linux MintPPC system."
	echo ""
	echo "non-free software disclaimer"
	echo "Make note; this installer will probably install packages"
	echo "from the non-free catagory of software. That doesn't mean"
	echo "that you will be installing anything pirated or illegal."
	echo "Most average users probably couldn't care less. But some"
	echo "organizations are very strict about what software they are"
	echo "able to use."
	echo ""
	echo "rerun this script with the -y argument to run this in an"
	echo "an unattended mode"
	echo ""
	echo "(We are pausing for 30 seconds to allow time to read"
	echo "the above information)"
	echo ""
	sleep 30s
}

_installnopromptmsg()
{
        echo "Automated install assuming yes to all questions and auto-reboots when finished"
        echo "Note: There are 3 packages that when installing ask for some input."
        echo "These three packages (xorg, wicd, & samba) were placed as far forward"
        echo "as possible. After these packages you can go have a beer."
        echo "Note, also: The autoreboot at the end has been disabled for testing and"
        echo "troubleshooting purposes."
	echo "(The installation will proceed in 20 seconds.)"
	sleep 20s
}

_installprompt()
{
echo "_installprompt" >> /var/log/mintppc9_install.log
  echo -n "Run installer now? (Y|n) > "
  read a
  #scrapping below in favor or N responses
  #if [ "$a" = "y" ] || [ "$a" = "Y" ] || \
  #  [ "$a" = "" ]; then
  if [ "$a" = "n" ] || [ "$a" = "N" ]
	then
		echo you have chosen to exit this installer
		echo goodbye
		exit 0
	else
		echo continuing
	fi
}

_upgradeRepo()
{
echo "_upgradeRepo" >> /var/log/mintppc9_install.log
  echo "backing up sources.list"
  sleep 2s
  if [ -f /etc/apt/sources.list ]; then
        cp -f /etc/apt/sources.list /etc/apt/sources.list~prebuildscript
	chmod -w /etc/apt/sources.list~prebuildscript
 fi
    #Update Repositories
    #---------------
    clear
    echo "Upgrading new repositories before install..."
    echo ""
    apt-get update
    echo ""
    echo "All packages updated..."
    echo ""
    sleep 2s
    #Perform Upgrade
    #---------------
    clear
    echo "Upgrading existing packages before install..."
    echo "  executing: apt-get upgrade -y --force-yes" >> /var/log/mintppc9_install.log
    echo ""
    apt-get upgrade -y --force-yes
    echo ""
    echo "All packages upgraded..."
    echo ""
    sleep 2s
 }

_installhugepackages()
{
echo "installhugepackages" >> /var/log/mintppc9_install.log
echo "  executing: apt-get install -y desktop-base lxde cups totem " >> /var/log/mintppc9_install.log
    clear
    echo "Installing huge packages"
    echo "This may take awhile."
    echo ""
    sleep 2s
    apt-get install -y desktop-base lxde cups totem
    echo ""
    sleep 2s
}

_motd()
{
echo "_motd" >> /var/log/mintppc9_install.log
    if [ -f /etc/motd.tail ]; then
        cp -f /etc/motd.tail /etc/motd.tail~prebuildscript
	chmod -w /etc/motd.tail~prebuildscript
    fi
    echo "" > /etc/motd.tail
    echo "" >> /etc/motd.tail
    echo "The programs included with this build of MintPPC GNU/Linux are free software;" >> /etc/motd.tail
    echo "the exact distribution terms for each program are described in the" >> /etc/motd.tail
    echo "individual files in /usr/share/doc/*/copyright." >> /etc/motd.tail
    echo "" >> /etc/motd.tail
    echo "This build of MintPPC GNU/Linux comes with ABSOLUTELY NO WARRANTY," >> /etc/motd.tail
    echo "to the extent permitted by applicable law." >> /etc/motd.tail
    echo "" >> /etc/motd.tail
    echo "More information about MintPPC GNU/Linux can be found at:" >> /etc/motd.tail
    echo "http://mac.linux.be/" >> /etc/motd.tail
    echo ""
    echo "For info you can also email jjhdiederen at zonnet dot nl" >> /etc/motd.tail
    echo ""
    echo "Enjoy Linux MintPPC !" >> /etc/motd.tail
    echo "" >> /etc/motd.tail
}

_installnonfreefirmware()
{
  echo "Now installing nonfree firmware"
  echo "firmware-nonfree_0.28_all.deb"
  #http://packages.debian.org/sid/firmware-linux-nonfree
  wget http://ftp.us.debian.org/debian/pool/non-free/f/firmware-nonfree/firmware-linux-nonfree_0.28_all.deb
  dpkg -i firmware-linux-nonfree_0.28_all.deb
}


_installdebianpackages()
{
echo "_installdebianpackages" >> /var/log/mintppc9_install.log
  echo "Now Installing a lot of Debian packages."
  echo "This is going to take a while. Go have a beer"
  #Install Debian packages
    #----------------------------
    clear
    echo "Installing the rest of the Debian packages"
    echo ""
    sleep 2s
    echo "  installing package group 000 (aka the problem packages)" >> /var/log/mintppc9_install.log
    echo " These are the problem packages samba, wicd and xorg. After they complete you can go have a beer"
    sleep 10s
    apt-get install -y samba wicd xorg
    echo " completed problem packages, go have a beer."
    sleep 5s
    echo "  installing package group 001" >> /var/log/mintppc9_install.log
    apt-get install -y alacarte alsa-base alsa-utils anacron autoconf automake1.7 autotools-dev binfmt-support binutils
    sleep 2s
    echo "  installing package group 002" >> /var/log/mintppc9_install.log
    apt-get install -y build-essential capplets-data cdbs cdrdao checkinstall cheese cpufrequtils debhelper deskbar-applet
    sleep 2s
    echo "  installing package group 003" >> /var/log/mintppc9_install.log
    apt-get install -y djvulibre-desktop docbook-xml dpkg-dev dvd+rw-tools ekiga eog epiphany-browser epiphany-browser-data
    sleep 2s
    echo "  installing package group 004" >> /var/log/mintppc9_install.log
    apt-get install -y epiphany-extensions epiphany-gecko evince evolution exaile feh finger firestarter foo2zjs freepats gconf-editor
    sleep 2s
    echo "  installing package group 005" >> /var/log/mintppc9_install.log
    apt-get install -y gedit gedit-common genisoimage gettext gftp gftp-common gftp-gtk gftp-text giblib1 gimp gkrellm gparted gnome-alsamixer gnome-nettool gnome-system-tools gnome-wise-icon-theme gnuchess
    sleep 2s
    echo "  installing package group 006" >> /var/log/mintppc9_install.log
    apt-get install -y gstreamer0.10-plugins-bad gsynaptics gthumb gthumb-data gtk-theme-switch gtk2-engines-murrine gtk2-engines-ubuntulooks
    sleep 2s
    echo "  installing package group 007" >> /var/log/mintppc9_install.log
    apt-get install -y libgtkhtml3.14-19 libgtkhtml-editor-common gucharmap guile-1.8-libs hardinfo html2text iceweasel
    sleep 2s
    echo "  installing package group 008" >> /var/log/mintppc9_install.log
    apt-get install -y imagemagick initscripts inkscape intltool intltool-debian kerneloops libnotify-bin liferea linux-libc-dev linux-sound-base
    sleep 2s
    echo "  installing package group 009" >> /var/log/mintppc9_install.log
    apt-get install -y make menu-xdg metacity metacity-common mouseemu murrine-themes
    sleep 2s
    echo "  installing package group 010" >> /var/log/mintppc9_install.log
    apt-get install -y nautilus nautilus-data nfs-kernel-server obex-data-server openprinting-ppds
    sleep 2s
    echo "  installing package group 011" >> /var/log/mintppc9_install.log
    apt-get install -y pidgin pidgin-data pkg-config po-debconf ppp ppp-dev python-cddb python-crypto python-cups python-eggtrayicon
    sleep 2s
    echo "  installing package group 012" >> /var/log/mintppc9_install.log
    apt-get install -y python-gamin python-gmenu python-gnupginterface
    sleep 2s
    echo "  installing package group 013" >> /var/log/mintppc9_install.log
    apt-get install -y python-gpod python-imaging python-ipy python-mutagen python-notify python-ogg python-paramiko python-pexpect python-ogg python-pysqlite2 python-pyvorbis
    sleep 2s
    echo "  installing package group 014" >> /var/log/mintppc9_install.log
    apt-get install -y python-software-properties python-vte python-webkit rarian-compat rdesktop recode sane seahorse sg3-utils software-properties-gtk sound-juicer streamripper
    sleep 2s
    echo "  installing package group 015" >> /var/log/mintppc9_install.log
    apt-get install -y samba-common smbfs system-config-printer system-tools-backends tcl8.4 transmission tsclient twm
    sleep 2s
    echo "  installing package group 015" >> /var/log/mintppc9_install.log
    apt-get install -y unattended-upgrades update-manager-core update-notifier update-notifier-common vinagre vino
    sleep 2s
    echo "  installing package group 016" >> /var/log/mintppc9_install.log
    apt-get install -y vorbis-tools w3c-dtd-xhtml wodim wpasupplicant x11proto-composite-dev x11proto-core-dev x11proto-damage-dev
    sleep 2s
    echo "  installing package group 018" >> /var/log/mintppc9_install.log
    apt-get install -y x11proto-fixes-dev x11proto-input-dev x11proto-kb-dev x11proto-randr-dev x11proto-render-dev x11proto-xext-dev
    sleep 2s
    echo "  installing package group 019" >> /var/log/mintppc9_install.log
    apt-get install -y x11proto-xinerama-dev xbitmaps xchat xchat-common xsltproc xterm xtrans-dev yelp zlib1g-dev ntp
    sleep 2s
    echo "  installing package group 020" >> /var/log/mintppc9_install.log
    apt-get install -y  fortune-mod vino ppp python-webkit gnome-wise-icon-theme python-vte python-vte gnome-disk-utility
    sleep 2s
    echo "  installing package group 021" >> /var/log/mintppc9_install.log
    apt-get install -y pyneighborhood system-config-printer python-paramiko python-pexpect hardinfo xfce4-taskmanager pyneighborhood xfburn asunder cheese gnome-mplayer
    sleep 2s
    echo "  installing package group 022" >> /var/log/mintppc9_install.log
    apt-get install -y vlc abiword gnumeric osmo epdfview pidgin transmission simple-scan galculator gnome-power-manager filezilla iceweasel mouseemu catfish
    sleep 2s
    echo "  installing package group 023" >> /var/log/mintppc9_install.log
    apt-get install -y wireless-tools gnome-screenshot gnome-search-tool gnome-system-log icedtea6-plugin openjdk-6-jre
    sleep 2s
    echo "  installing package group 024" >> /var/log/mintppc9_install.log
    apt-get install -y tightvncserver vncviewer ftp gok
}

_cleanuppackages()
{
echo "_cleanuppackages" >> /var/log/mintppc9_install.log
  #Clean up downloaded packages
        echo ""
        echo "Performing \"apt-get clean\"..."
        sleep 1s
        apt-get clean
	echo "Performing \"apt-get autoremove\"..."
        sleep 1s
        apt-get autoremove
}

_clenupprompt()
{
echo "_cleanupprompt" >> /var/log/mintppc9_install.log
    clear
    echo "Clean up. A number of packages were downloaded during"
    echo "the set-up routine. These packages are no longer needed,"
    echo "please choose whether or not you would like to remove them."
    echo ""
    echo -n "Remove downloaded packages? (Y|n) > "
    read a
    if [ "$a" = "y" ] || [ "$a" = "Y" ] || \
    [ "$a" = "" ]; then
	_cleanuppackages
    else
	echo "Skipping package cleanup..."
    fi
}

_installmint()
{
echo "_installmint" >> /var/log/mintppc9_install.log
cd $_pkgdir
        echo ""
        echo "installing MintPPC specific programs"
        echo ""
        sleep 2s
        wget http://mintppc.org/files/mintppc9/isadora_packages.tar.gz
	tar -zxvf isadora_packages.tar.gz
	cd isadora
	dpkg -i chestnut-dialer_0.3.3-3mint3_all.deb mint-common_1.0.5_all.deb mintsystem_7.6.9_all.deb chestnut-dialer-gtk2_0.3.3-3mint3_all.deb  mintdesktop_3.2.1_all.deb mint-translations_2010.09.01_all.deb cowsay_3.03+dfsg1-2_all.deb mint-info-lxde_9.0.1_all.deb mintupdate_4.0.8_all.deb fortune-mod_1.99.1-4_powerpc.deb mintinput_1.1_all.deb mintupload_3.7.8_all.deb fortunes-husse_1.0.1_all.deb mint-wallpapers-extra_1.0.1_all.deb gtk2-engines-aurora_1.5.1-1_powerpc.deb mintwelcome_1.3.3_all.deb mint-artwork-common_1.1.3_all.deb mintnanny_1.3.8_all.deb vino-xfce_1.2-0mint1_all.deb mint-artwork-lxde_9.0.5_all.deb mint-search-addon_2.0_all.deb mintbackup_2.0.6_all.deb mint-stylish-addon_1.0.1_all.deb
	sleep 5s
	#Cleaning up
	cd ..
	rm -Rf isadora
	rm isadora_packages.tar.gz
	# Install the fortunes in bash#
	# still _installmint function
	wget http://mintppc.org/files/mintppc9/fortunes-installer.tar.gz
	tar -C /etc -zxvf fortunes-installer.tar.gz
	rm -rf /etc/skel/.bashrc
	rm -rf /root/.bashrc
	rm fortunes-installer.tar.gz
	clear
	echo "Fortunes should be in place now"
	sleep 4s

	# Install the menu items in /usr/share/applications
	# First remove all the old crap out
	# still _installmint function
	clear
	echo "We will now perform the mintification of Debian, starting with menu items"
	rm -Rf /usr/share/applications
	wget http://mintppc.org/files/mintppc9/applications.tar.gz
	tar -C /usr/share/ -xzvf applications.tar.gz
	rm applications.tar.gz
	echo "Menu items are in place"
	sleep 2s

	# Remove personal stuff in home
	# still _installmint function
	#rm /home/.bashrc
	#rm -Rf /home/.config/

	# Install lxde-default-settings
	# still _installmint function
	clear
	echo "We will now install the LXDE default settings and the GDM themes"
	wget http://mintppc.org/files/mintppc9/mint-lxde-default-settings.tar.gz
	tar -C / -xzvf mint-lxde-default-settings.tar.gz
	rm mint-lxde-default-settings.tar.gz
	sleep 2s

	# Install the GDM-themes
	# still _installmint function
	wget http://mintppc.org/files/mintppc9/gdm-themes.tar.gz
	tar -C /usr/share/gdm -xzvf gdm-themes.tar.gz
	rm gdm-themes.tar.gz
	wget http://mintppc.org/files/mintppc9/gdm.conf.tar.gz
	tar -C /etc/gdm -xzvf gdm.conf.tar.gz
	rm gdm.conf.tar.gz
	echo "GDM themes were put in place"
	sleep 2s

	# Add pmu_battery to /etc/modules
	# still _installmint function
	# old way
	#wget http://mac.linux.be/files/Isadora/modules.tar.gz
	#tar -C /etc -xzvf modules.tar.gz
	#rm modules.tar.gz
	#sleep 2s
	# new way
	 cat /etc/modules | grep snd-xenon || echo snd-xenon >> /etc/modules
	 cat /etc/modules | grep apm_emu || echo apm_emu >> /etc/modules
	 cat /etc/modules | grep loop || echo loop >> /etc/modules
	 cat /etc/modules | grep sbp2 || echo sbp2 >> /etc/modules

	# Theme tweaks
	# still _installmint function
}

_installmintprompt()
{
echo "_installmintprompt" >> /var/log/mintppc9_install.log
# Download and install the Mint programs
# still _installmint function
    #---------------------------
    clear
    echo "Would you like install the MintPPC specific programs?"
    echo "If not just enter to skip \"n\""
    echo ""
    echo -n "install the MintPPC files? (Y|n) > "
    read a
	if [ "$a" = "y" ] || [ "$a" = "Y" ] || \
	[ "$a" = "" ]; then
		_installmint
	fi
}

_rebootingprompt()
{
echo "_rebooting" >> /var/log/mintppc9_install.log
    #Prompt for reboot
    #-----------------
	sed -i 's/#LEDS=+num/LEDS=+num/' /etc/console-tools/config
	sed -i '/^root/a xbox     ALL=(ALL:ALL) ALL' /etc/sudoers
	apt-get install xserver-xorg-input-evdev xserver-xorg-input-kbd xserver-xorg-input-mouse -y --force-yes
	apt-get install build-essential openssh-server console-tools -y --force-yes
	cd /usr/lib/xorg/modules/drivers/
	rm -r -f *
	wget http://file.libxenon.org/free60/linux/xenosfb_drv.so_squeeze
	mv xenosfb_drv.so_squeeze xenosfb_drv.so
    clear
    echo "Installation complete! Thank you for using this install script for your Debian Squeeze/MintPPC GNU/Linux build."
    echo "You will now need to reboot your system."
    echo "You might need to adapt your /etc/X11/xorg.conf file."
    echo "Please consult http://mac.linux.be/ -> Apple PowerPC wiki -> Xorg.conf files and the MintPPC forum for that"
    echo ""
    echo -n "Reboot now? (Y|n) > "
    read a
    if [ "$a" = "y" ] || [ "$a" = "Y" ] || \
    [ "$a" = "" ]; then
        echo "Goodbye, hoping all went well :)"
        echo "Rebooting..."
        sleep 4s
        reboot
        exit
    else
        echo "Issue the following command as root to reboot:"
        echo ""
        echo "reboot"
        echo ""
        echo "Goodbye! :)"
    fi
  exit
}

#_foundAirport()
#{
#echo "_foundAirport" >> /var/log/mintppc9_install.log
	#cd $_pkgdir
	#wget http://www.ant2ne.com/downloads/iBook_orinoco.fw.tar.bz2
	#tar -xvjf iBook_orinoco.fw.tar.bz2
	#mv orinoco.fw /lib/firmware/agere_sta_fw.bin
	#modprobe airport
	#cat /etc/modules | grep airport || echo airport >> /etc/modules
#}

#_foundbroadcom()
#{
#echo "_foundbroadcom" >> /var/log/mintppc9_install.log
#	cd $_pkgdir
#	wget http://mintppc.org/files/mintppc9/firmware-b43-installer_4.150.10.5-4_all.deb
#	wget http://mintppc.org/files/mintppc9/b43-fwcutter_013-2_powerpc.deb
#	dpkg -i firmware-b43-installer_4.150.10.5-4_all.deb b43-fwcutter_013-2_powerpc.deb
#	modprobe b43
#	cat /etc/modules | grep b43 || echo b43 >> /etc/modules
#}

_installpowerprefs()
{
## installs powerprefs to have better power management on Apple laptops
cd $_pkgdir
wget http://ftp.us.debian.org/debian/pool/main/p/powerprefs/powerprefs_0.5.1-2_powerpc.deb
apt-get install -y pbbuttonsd
dpkg -i powerprefs_0.5.1-2_powerpc.deb
}

#_installotherpkgs()
#{
## installs better orinoco driver if the airport module is detected
## if that module is not detected then this driver will not be installed
#echo "_installorinicoupgrade" >> /var/log/mintppc9_install.log
#	lsmod | grep airport && _foundAirport
## installs powerprefs if powerprefs is not already installed
#echo "_installpowerprefs" >> /var/log/mintppc9_install.log
#	dpkg -l | grep powerprefs || _installpowerprefs
#}

#_installbroadcom()
#{
## installs the broadcom firmware if the b43 module is found
## as all later Macs use 1443:4320 rev3 (BCM4306/03 chipset) it's safe to assume that we can use b43
#echo "_installbroadcom" >> /var/log/mintppc9_install.log
#lsmod | grep b43 && _foundbroadcom
#}

_bashrcMint()
{
echo "_bashrc" >> /var/log/mintppc9_install.log
# loops through each /home/user and backs up the .bashrc file
# then modifies the bashrc to perform some things at next login
# the final line of the modified bashrc overwrites the bashrc
# with the backup made previously.
	FILES=/home/*
	for f in $FILES
		do
			_bashrc=$f/.bashrc
			cp $_bashrc ${_bashrc}.bkup
			if [ -f ${_bashrc}_premint ]; then
				echo ${_bashrc}_premint exists so I am not over writing it.
			else
				cp $_bashrc ${_bashrc}_premint
				chmod -w ${_bashrc}_premint
			fi
			cat $_bashrc | grep usr/share/backgrounds/mint-lxde/Talento-1.jpg || echo 'pcmanfm -w /usr/share/backgrounds/mint-lxde/Talento-1.jpg' >> $_bashrc
			cat $_bashrc | grep wallpaper-mode=stretch || echo 'pcmanfm --wallpaper-mode=stretch'  >> $_bashrc
			cat $_bashrc | grep bashrc_premint || echo 'cp ~/.bashrc_premint ~/.bashrc'  >> $_bashrc
		done
}
_bashfix()
{
rm /root/.bashrc
mv /root/.bashrc.orginal /root/.bashrc
alsactl init
gconftool-2 --type string --set /system/gstreamer/0.10/default/audiosink "alsasink"
gconftool-2 --type string --set /system/gstreamer/0.10/default/musicaudiosink "alsasink"
gconftool-2 --type string --set /system/gstreamer/0.10/default/chataudiosink "alsasink"
}
_repository()
{
	echo "_repository" >> /var/log/mintppc9_install.log
	# will try to update the sources.list in /etc/apt to include the MintPPC repository
	# We will start to have the right keyring of MintPPC:
	gpg --keyserver subkeys.pgp.net --recv-keys 36885F6D
	gpg -a --export 36885F6D | sudo apt-key add -
	# we will now add the actual repository:
	echo "" >> /etc/apt/sources.list
	echo "# MintPPC repository"
	echo "deb http://www.mintppc.org/repository isadora main" >> /etc/apt/sources.list
	# update and upgrade the repository
	apt update
	apt upgrade -y --force-yes
}

###################################################################
###################################################################
## All actual installation functions above this line             ##
## Below this line is logic calling for installation functions.  ##
###################################################################
###################################################################

_installwithprompt()
{
echo "_installwithprompt" >> /var/log/mintppc9_install.log
	_welcomemsg
	_installprompt
	_upgradeRepo
	_installnonfreefirmware
	_installhugepackages
	_motd
	_installdebianpackages
	_clenupprompt
	_installmintprompt
	_installpowerprefs
	#_installotherpkgs
	#_installbroadcom
	_repository
	#_rebootingprompt
}

_installnoprompt()
{
echo "_installnoprompt" >> /var/log/mintppc9_install.log
	_welcomemsg
	_installnopromptmsg
	_upgradeRepo
 	_installnonfreefirmware
	_installhugepackages
	_motd
	_installdebianpackages
	_cleanuppackages
	_installmint
	_installpowerprefs
	#_installbroadcom
	_repository
	#_installotherpkgs
}

###################################################################
###################################################################
## All functions above this line                                 ##
## Below this line is execution instructions                     ##
###################################################################
###################################################################


kickOffMint()
{
_installnoprompt
}

installMint()
{
aptitude install lxde -y
kickOffMint
_bashfix
_bashrcMint
_rebootingprompt
}
installSqueeze()
{

_bashfix
_rebootingprompt

}

# capture CTRL+C, CTRL+Z and quit singles using the trap
trap 'echo "Control-C disabled."' SIGINT
trap 'echo "Cannot terminate this script."'  SIGQUIT
trap 'echo "Control-Z disabled."' SIGTSTP
echo "Debian Squeeze Base System Install Complete!"
echo ""
while true; do
       echo "-------------------------------------"
       echo "|        Please choose one          |"
       echo "-------------------------------------"
       echo "| [1] Install Mint                  |"
       echo "| [2] Stop here and use Squeeze     |"
       echo "====================================="
       echo -n "Enter your menu choice [1-2]: "
       read yourch
     case $yourch in
           1) installMint; read ;;
           2) installSqueeze; read ;;
           *) echo "Please select choice 1 or 2";
		   echo "Press a key. . ." ; read ;;
     esac 


done
