#!/bin/bash

# This program is free software : you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

echo #
echo -e "\033[43;30m SCRIPT DE NETTOYAGE ET DE MISE À JOUR SYSTÈME LINUX / https://github.com/Kusanagi8200 \033[0m"

#Fonction qui vérifie que le script est lancé en sudo ou root.

echo #
if [ `whoami` != "root" ]
then
        echo -e "\033[5;41;30m ATTENTION. VOUS DEVEZ AVOIR LES DROITS SUDO POUR LANCER CE SCRIPT \033[0m"
        exit 1
fi

#Fonction qui vérifie la presence des fichiers de log et les crée au besoin. 

echo #
echo -e "\033[43;30m ---> CHECK DES FICHIERS DE LOG \033[0m"

echo #
if [ -e /var/log/update_upgrade.log ]
then
    echo -e "\033[47;32m FICHIER \033[0m" /var/log/update_upgrade.log = "\033[47;32m OK \033[0m"
else
    echo -e "\033[47;31m LE FICHIER N'EXISTE PAS \033[0m" & touch /var/log/update_upgrade.log
    echo -e "\033[41;33m --> CRÉATION DU FICHIER \033[0m" /var/log/update_upgrade.log = "\033[47;32m DONE \033[0m"
fi

echo #
if [ -e /var/log/update_upgrade.err ]
then
    echo -e "\033[47;32m FICHIER \033[0m" /var/log/update_upgrade.err = "\033[47;32m OK \033[0m"
else
    echo -e "\033[47;31m LE FICHIER N'EXISTE PAS \033[0m" & touch /var/log/update_upgrade.err
    echo -e "\033[41;33m --> CRÉATION DU FICHIER \033[0m" /var/log/update_upgrade.err = "\033[47;32m DONE \033[0m"
fi
echo #

#Séquence de nettoyage systeme update

echo #
echo -e "\033[43;30m ---> NETTOYAGE PRE-MAJ \033[0m"
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

echo #
echo -e "\033[43;30m <--- FIN DU NETTOYAGE PRE-MAJ \033[0m"

echo #
echo # 

#Séquence de mise à jours des paquets

echo -e "\033[43;30m ---> MISE À JOUR DES PAQUETS \033[0m"
apt update 

apt list --upgradable

apt-get upgrade  >> /var/log/update_upgrade.log 2>> /var/log/update_upgrade.err

apt-get --fix-broken install

echo # 

echo -e "\033[43;30m <--- MISE À JOUR DES PAQUETS TERMINÉE \033[0m"
echo #
echo # 

#Séquence de nettoyage systeme post mise à jour 

echo -e "\033[43;30m ---> NETTOYAGE POST-MAJ \033[0m"
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

echo -e "\033[43;30m ---> NETTOYAGE DU CACHE \033[0m"
sync; echo 3 > /proc/sys/vm/drop_caches
echo -e "\033[44;37m DONE \033[0m"
echo # 

echo -e "\033[43;30m ---> NETTOYAGE POUBELLE \033[0m"
rm -r -f ~/.local/share/Trash/files/*
echo -e "\033[44;37m DONE \033[0m"
echo #

echo -e "\033[43;30m ---> NETTOYAGE DES CONFIG DE PAQUETS \033[0m"
[[ $(dpkg -l | grep ^rc) ]] && sudo dpkg -P $(dpkg -l | awk '/^rc/{print $2}') || echo -e "\033[44;37m PAS DE PAQUETS À PURGER \033[0m"
echo #

echo -e "\033[43;30m <--- FIN DU NETTOYAGE POST-MAJ \033[0m"
echo #

#Fonction qui verifie les fichiers de log et affiche le log erreur si des erreurs sont presentes.

echo # 
echo -e "\033[43;30m ---> FICHIER LOG ERREUR MAJ \033[0m"

if [ -N /var/log/update_upgrade.err ]
  then 
	echo -e "\033[5;41;37m ATTENTION \033[0m" & cat /var/log/update_upgrade.err 
        echo #
else
	echo -e "\033[44;37m PAS D'ERREUR DE MAJ \033[0m" 
fi 
echo #

echo -e "\033[43;30m ---> THE END <--- \033[0m"
echo #
