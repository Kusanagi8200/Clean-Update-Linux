#!/bin/bash

# This program is free software : you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

echo #
echo -e "\033[43;30m LINUX SYSTEM CLEANUP AND UPDATE SCRIPT / https://github.com/Kusanagi8200 \033[0m"

echo #
if [ `whoami` != "root" ]
then
        echo -e "\033[5;41;30m WARNING. YOU MUST HAVE SUDO RIGHTS TO RUN THIS SCRIPT \033[0m"
        exit 1
fi

echo #
echo -e "\033[43;30m ---> CHECK LOG FILES \033[0m"

echo #
if [ -e /var/log/update_upgrade.log ]
then
    echo -e "\033[47;32m FILE \033[0m" /var/log/update_upgrade.log = "\033[47;32m OK \033[0m"
else
    echo -e "\033[47;31m FILE DOESN'T EXIST \033[0m" & touch /var/log/update_upgrade.log
    echo -e "\033[41;33m --> FILE CREATION \033[0m" /var/log/update_upgrade.log = "\033[47;32m DONE \033[0m"
fi

echo #
if [ -e /var/log/update_upgrade.err ]
then
    echo -e "\033[47;32m FILE \033[0m" /var/log/update_upgrade.err = "\033[47;32m OK \033[0m"
else
    echo -e "\033[47;31m FILE DOESN'T EXIST \033[0m" & touch /var/log/update_upgrade.err
    echo -e "\033[41;33m --> FILE CREATION \033[0m" /var/log/update_upgrade.err = "\033[47;32m DONE \033[0m"
fi
echo #

echo #
echo -e "\033[43;30m ---> PRE-UPDATE CLEANING \033[0m"
echo #
echo -e "\033[44;37m APT CLEAN \033[0m"
apt clean 
echo Done
echo #
echo -e "\033[44;37m APT AUTOCLEAN \033[0m"
apt autoclean
echo #
echo -e "\033[44;37m APT REMOVE \033[0m"
apt remove 
echo #
echo -e "\033[44;37m APT AUTOREMOVE \033[0m"
apt autoremove
echo #
echo -e "\033[44;37m APT PURGE \033[0m"
apt purge
echo #
echo -e "\033[44;37m APT CHECK \033[0m"
apt check
echo #
echo -e "\033[43;30m <--- END OF PRE-UPDATE CLEANING \033[0m"

echo #
echo # 


echo -e "\033[43;30m ---> UPDATING PACKAGES \033[0m"
apt update 

apt list --upgradable && 

apt-get -y upgrade  >> /var/log/update_upgrade.log 2>> /var/log/update_upgrade.err

apt-get --fix-broken install

echo # 

echo -e "\033[43;30m <--- UPDATING PACKAGES \033[0m"
echo #
echo # 

#Séquence de nettoyage systeme post mise à jour 

echo -e "\033[43;30m --->  \033[0m"
echo #
echo -e "\033[44;37m APT CLEAN \033[0m"
apt clean 
echo Done
echo #
echo -e "\033[44;37m APT AUTOCLEAN \033[0m"
apt autoclean
echo #
echo -e "\033[44;37m APT REMOVE \033[0m"
apt remove 
echo #
echo -e "\033[44;37m APT AUTOREMOVE \033[0m"
apt autoremove
echo #
echo -e "\033[44;37m APT PURGE \033[0m"
apt purge
echo #
echo -e "\033[44;37m APT CHECK \033[0m"
apt check
echo #

echo -e "\033[43;30m ---> CACHE CLEANING \033[0m"
sync; echo 3 > /proc/sys/vm/drop_caches
echo -e "\033[44;37m DONE \033[0m"
echo # 

echo -e "\033[43;30m ---> BIN CLEANING \033[0m"
rm -r -f ~/.local/share/Trash/files/*
echo -e "\033[44;37m DONE \033[0m"
echo #

echo -e "\033[43;30m ---> PACKAGE CONFIG CLEANUP \033[0m"
[[ $(dpkg -l | grep ^rc) ]] && sudo dpkg -P $(dpkg -l | awk '/^rc/{print $2}') || echo -e "\033[44;37m NO PACKETS TO PURGE \033[0m"
echo #

echo -e "\033[43;30m <--- END OF POST-UPDATE CLEANUP \033[0m"
echo #

echo # 
echo -e "\033[43;30m ---> UPDATE ERROR LOG FILE \033[0m"

if [ -N /var/log/update_upgrade.err ]
  then 
	echo -e "\033[5;41;37m ATTENTION \033[0m" & cat /var/log/update_upgrade.err 
        echo #
else
	echo -e "\033[44;37m NO UPDATE ERROR \033[0m" 
fi 
echo #

zenity --title "REBOOT" --question --text "\nDo you want to reboot ?"
if [ $? -eq 0 ]
then 
        reboot
fi

echo -e "\033[43;30m ---> THE END <--- \033[0m"
echo #
