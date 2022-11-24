#!/bin/bash

echo -e "\033[43;30mSCRIPT DE NETTOYAGE ET DE MISE A JOUR SYSTEME LINUX / Copyright (C) Elijah Kaminski/2022\033[0m"

if [ `whoami` != "root" ]
then
        echo -e "\033[5;41;30mATTENTION. VOUS DEVEZ AVOIR LES DROITS SUDO POUR LANCER CE SCRIPT \033[0m"
        exit 1
fi

echo #
echo -e "\033[43;30m ---> NETTOYAGE PRE MAJ \033[0m"
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
echo -e "\033[43;30m <--- FIN DU NETTOYAGE PRE MAJ \033[0m"

echo #
echo # 

echo -e "\033[43;30m ---> MISE A JOUR DES PAQUETS \033[0m"
apt update && apt list --upgradable

apt-get -y upgrade  >> /var/log/update_upgrade.log 2>> /var/log/update_upgrade.err

apt-get --fix-broken install

echo # 

echo -e "\033[43;30m <--- MISE À JOUR DES PAQUETS TERMINÉE \033[0m"
echo #
echo # 

echo -e "\033[43;30m ---> NETTOYAGE POST MAJ \033[0m"
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

echo -e "\033[43;30m ---> NETTOYAGE DU CACHE \033[0m"
sync; echo 3 > /proc/sys/vm/drop_caches
echo Done
echo # 

echo -e "\033[43;30m ---> NETTOYAGE POUBELLE \033[0m"
rm -r -f ~/.local/share/Trash/files/*
echo Done
echo #

echo -e "\033[43;30m ---> NETTOYAGE DES CONFIG DE PAQUETS \033[0m"
[[ $(dpkg -l | grep ^rc) ]] && sudo dpkg -P $(dpkg -l | awk '/^rc/{print $2}') || echo "Pas de paquet à purger."
echo #

echo -e "\033[43;30m <--- FIN DU NETTOYAGE POST MAJ \033[0m"
echo #
echo # 


zenity --title "REBOOT" --question --text "Voulez vous Redémarrer ?"
if [ $? -eq 0 ]
then 
        reboot
fi

echo -e "\033[43;30m ---> THE END <--- \033[0m"
