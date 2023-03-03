#!/bin/bash

# This program is free software : you can redistribute it and/or modify it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

echo #
echo -e "\033[43;30m SCRIPT DE NETTOYAGE ET DE MISE À JOUR SYSTÈME LINUX / https://github.com/Kusanagi8200 \033[0m"

if [ `whoami` != "root" ]
then
        echo -e "\033[5;41;30m ATTENTION. VOUS DEVEZ AVOIR LES DROITS SUDO POUR LANCER CE SCRIPT \033[0m"
        exit 1
fi

zenity --title "ATTENTION" --question --text "Une MAJ peut endommager votre système.\nFaire un snapshot avant de lancer la MAJ.\n\n     VOULEZ VOUS CONTINUER ?" \
       --ok-label "OK" --cancel-label "QUITTER"
if [ "$?" != "0" ] ; then
  exit 0
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
echo -e "\033[44;37m APT CHECK \033[0m"
apt check
echo #
echo -e "\033[43;30m <--- FIN DU NETTOYAGE PRE-MAJ \033[0m"

echo #
echo # 

#Séquence de mise à jours des paquets

echo -e "\033[43;30m ---> MISE A JOUR DES PAQUETS \033[0m"
apt update && apt list --upgradable

zenity --title "UPGRADE" --question --text "\n Voulez vous faire la MAJ ?"

if [ $? -eq 0 ]
then
	apt upgrade
        apt --fix-broken install
fi
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
echo -e "\033[44;37m APT CHECK \033[0m"
apt check
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
echo #

#Séquence d'informations système

echo -e "\033[43;30m ---> INFORMATIONS SYSTEME <--- \033[0m"
cat /proc/version
echo #

cat /etc/os-release
echo #
echo #

echo -e "\033[43;30m LISTE DES NOYAUX \033[0m"
dpkg -l | grep -Ei "linux-(g|h|i|lo|si|t)" |sort -k3 | cut -d" " -s -f1,2,3 | column -s" " -t
echo #
echo #

echo -e "\033[43;30m ESPACE DISQUE DISPONIBLE \033[0m"
df -h 
echo #
echo #

echo -e "\033[43;30m INFORMATIONS HARDWARE ET USER \033[0m"

zenity --title "NEOFETCH" --question --text "\nInstaller Neofetch pour plus d'informations ?"

if [ $? -eq 0 ]
then 
       apt install neofetch 
fi
echo # 
echo #

neofetch
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
echo #

# Reboot ? Function
confirm()
{
    read -r -p "${1} [y/N] " response

    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

if confirm "REBOOT ?"; then
   reboot
else
    echo #
    echo -e "\033[44;30m ---> FIN DU SCRIPT <--- \033[0m"
    
fi
echo #
