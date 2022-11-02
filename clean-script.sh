#!/bin/bash

echo -e "\033[43;30mSCRIPT DE NETTOYAGE ET DE MISE A JOUR SYSTEME LINUX / Copyright (C) Elijah Kaminski/2022\033[0m"

if [ `whoami` != "root" ]
then
        echo -e "\033[5;41;30mATTENTION. VOUS DEVEZ AVOIR LES DROITS SUDO POUR LANCER CE SCRIPT \033[0m"
        exit 1
fi

zenity --question --text "Une mise à jour peut endommager votre systéme.\nFaites un Snapshot - Timeshift avant de lancer ce script.\nVoulez vous continuer ?" \
       --ok-label "OK" --cancel-label "QUITTER"
if [ "$?" != "0" ] ; then
  exit 0
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

zenity --title "UPGRADE" --question --text "Voulez vous faire la Mise à jour ?"

if [ $? -eq 0 ]
then 
	apt upgrade
        apt  --fix-broken install
fi
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

echo -e "\033[43;30m ---> INFORMATIONS SYSTEME <--- \033[0m"
cat /proc/version
echo #

cat /etc/os-release
echo #

echo -e "\033[43;30m VERSION DU NOYAU \033[0m"
uname -a
echo #

echo -e "\033[43;30m LISTE DES NOYAUX \033[0m"
dpkg -l | grep -Ei "linux-(g|h|i|lo|si|t)" |sort -k3 | cut -d" " -s -f1,2,3 | column -s" " -t
echo #

echo -e "\033[43;30m ESPACE DISQUE DISPONIBLE \033[0m"
df -h 
echo #

echo -e "\033[43;30m INFORMATIONS HARDWARE ET USER \033[0m"

zenity --title "NEOFETCH" --question --text "Installer Neofetch pour plus d'informations ?"
if [ $? -eq 0 ]
then 
       apt install neofetch 
fi
echo # 

neofetch

zenity --title "REBOOT" --question --text "Voulez vous Redémarrer ?"
if [ $? -eq 0 ]
then 
        reboot
fi

echo -e "\033[43;30m ---> THE END <--- \033[0m"
