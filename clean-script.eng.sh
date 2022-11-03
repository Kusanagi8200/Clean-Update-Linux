#!/bin/bash

echo -e "\033[43;30mLINUX SYSTEM CLEANUP AND UPDATE SCRIPT / Copyright (C) Elijah Kaminski/2022\033[0m"

if [ `whoami` != "root" ]
then
        echo -e "\033[5;41;30mWARNING. YOU MUST HAVE SUDO RIGHTS TO RUN THIS SCRIPT \033[0m"
        exit 1
fi

zenity --question --text "An update may damage your system.\nTake a Snapshot - Timeshift before running this script.\nDo you want to continue?" \
       --ok-label "OK" --cancel-label "QUIT"
if [ "$?" != "0" ] ; then
  exit 0
fi

echo #
echo -e "\033[43;30m ---> PRE-UPDATE CLEANING \033[0m"
echo #
echo -e "\033[44;37mAPT CLEAN\033[0m"
apt clean 
echo Done
echo #
echo -e "\033[44;37mAPT AUTOCLEAN\033[0m"
apt autoclean
echo #
echo -e "\033[44;37mAPT REMOVE\033[0m"
apt remove 
echo #
echo -e "\033[44;37mAPT AUTOREMOVE\033[0m"
apt autoremove
echo #
echo -e "\033[44;37mAPT PURGE\033[0m"
apt purge
echo #
echo -e "\033[44;37mAPT CHECK\033[0m"
apt check
echo #
echo -e "\033[43;30m <--- END OF PRE-UPDATE CLEANING \033[0m"

echo #
echo # 

echo -e "\033[43;30m ---> UPDATE \033[0m"
apt update && apt list --upgradable

zenity --title "UPGRADE" --question --text "Do you want to update ?"

if [ $? -eq 0 ]
then 
	apt upgrade
        apt  --fix-broken install
fi
echo # 

echo -e "\033[43;30m <--- END OF UPDATE \033[0m"
echo #
echo # 

echo -e "\033[43;30m ---> POST-UPDATE CLEANING \033[0m"
echo #
echo -e "\033[44;37mAPT CLEAN\033[0m"
apt clean 
echo Done
echo #
echo -e "\033[44;37mAPT AUTOCLEAN\033[0m"
apt autoclean
echo #
echo -e "\033[44;37mAPT REMOVE\033[0m"
apt remove 
echo #
echo -e "\033[44;37mAPT AUTOREMOVE\033[0m"
apt autoremove
echo #
echo -e "\033[44;37mAPT PURGE\033[0m"
apt purge
echo #
echo -e "\033[44;37mAPT CHECK\033[0m"
apt check
echo #

echo -e "\033[43;30m ---> CACHE CLEANING \033[0m"
sync; echo 3 > /proc/sys/vm/drop_caches
echo Done
echo # 

echo -e "\033[43;30m ---> TRASH CLEANING \033[0m"
rm -r -f ~/.local/share/Trash/files/*
echo Done
echo #

echo -e "\033[43;30m ---> PACKETS CONFIGURATION CLEANING \033[0m"
[[ $(dpkg -l | grep ^rc) ]] && sudo dpkg -P $(dpkg -l | awk '/^rc/{print $2}') || echo "No packets to purge."
echo #

echo -e "\033[43;30m <--- END OF POST-CLEANING \033[0m"
echo #
echo # 

echo -e "\033[43;30m ---> SYSTEM INFORMATION <--- \033[0m"
cat /proc/version
echo #

cat /etc/os-release
echo #

echo -e "\033[43;30m KERNEL VERSION \033[0m"
uname -a
echo #

echo -e "\033[43;30m KERNEL LIST \033[0m"
dpkg -l | grep -Ei "linux-(g|h|i|lo|si|t)" |sort -k3 | cut -d" " -s -f1,2,3 | column -s" " -t
echo #

echo -e "\033[43;30m FREE DISK SPACE \033[0m"
df -h 
echo #

echo -e "\033[43;30m HARDWARE AND USER INFORMATION\033[0m"

zenity --title "NEOFETCH" --question --text "Install Neofetch for more informations ?"
if [ $? -eq 0 ]
then 
       apt install neofetch 
fi
echo # 

neofetch

zenity --title "REBOOT" --question --text "Do you want to reboot ?"
if [ $? -eq 0 ]
then 
        reboot
fi

echo -e "\033[43;30m ---> THE END <--- \033[0m"
