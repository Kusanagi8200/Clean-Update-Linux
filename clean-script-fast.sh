#!/bin/bash

echo #
echo -e "\033[43;30mSCRIPT DE NETTOYAGE ET DE MISE A JOUR SYSTEME LINUX / Copyright (C) Elijah Kaminski/2022\033[0m"

#Fonction qui vérifie que le script est lancé en sudo ou root.

echo #
if [ `whoami` != "root" ]
then
        echo -e "\033[5;41;30mATTENTION. VOUS DEVEZ AVOIR LES DROITS SUDO POUR LANCER CE SCRIPT \033[0m"
        exit 1
fi

#Fonction qui vérifie la presence des fichiers de log et les crée au besoin. 

echo #
echo -e "\033[43;30m ---> CHECK DES FICHIERS DE LOG \033[0m"

echo #
if [ -e /var/log/update_upgrade.log ]
then
    echo -e "\033[47;32mFICHIER\033[0m" /var/log/update_upgrade.log = "\033[47;32m OK \033[0m"
else
    echo -e "\033[47;31mLE FICHIER N'EXISTE PAS \033[0m" & touch /var/log/update_upgrade.log
    echo -e "\033[41;33m--> CRÉATION DU FICHIER\033[0m" /var/log/update_upgrade.log = "\033[47;32m DONE \033[0m"
fi

echo #
if [ -e /var/log/update_upgrade.err ]
then
    echo -e "\033[47;32mFICHIER\033[0m" /var/log/update_upgrade.err = "\033[47;32m OK \033[0m"
else
    echo -e "\033[47;31mLE FICHIER N'EXISTE PAS \033[0m" & touch /var/log/update_upgrade.err
    echo -e "\033[41;33m--> CRÉATION DU FICHIER\033[0m" /var/log/update_upgrade.err = "\033[47;32m DONE \033[0m"
fi
echo #

#Séquence de nettoyage systeme update

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

#Séquence de mise à jours des paquets

echo -e "\033[43;30m ---> MISE A JOUR DES PAQUETS \033[0m"
apt update && apt list --upgradable

apt-get -y upgrade  >> /var/log/update_upgrade.log 2>> /var/log/update_upgrade.err

apt-get --fix-broken install

echo # 

echo -e "\033[43;30m <--- MISE À JOUR DES PAQUETS TERMINÉE \033[0m"
echo #
echo # 

#Séquence de nettoyage systeme post mise à jour 

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

#Fonction qui verifie les fichiers de log et affiche le log erreur si des erreurs sont presentes.

echo # 
echo -e "\033[47;31m ---> FICHIER DE LOG ERREUR \033[0m"

if [ -N /var/log/update_upgrade.err ]
  then 
	echo "ATTENTION - ERREURS LORS DE LA MISE A JOUR" & cat /var/log/update_upgrade.err
  else
	echo "Pas d'erreur de mise à jour." 
fi 
echo #
 
zenity --title "REBOOT" --question --text "Voulez vous Redémarrer ?"
if [ $? -eq 0 ]
then 
        reboot
fi

echo -e "\033[43;30m ---> THE END <--- \033[0m"
echo #
