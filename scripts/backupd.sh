#!/bin/bash

# Description : "Backup deamon"

#define backup folder
script_path="$(dirname $(readlink -f $0))/"
backup_path="$script_path../backup" # ici /root/minecraft/scripts/../backup
server_path="$script_path.." # ici /root/minecraft/scripts/..


if [ "$#" = 0 ];
then
	## PARTIE PAS D'ARGUMENTS. LE BACKUP S'EFFECTUE SUR TOUS LES SERVEURS
	echo "Backup de tous les serveurs ..."

	for SERV in `ls $server_path | grep ".mc"`
	do
		echo "Prevention des joueurs sur $SERV ..."
		screen -R "$SERV" -X stuff " say Redemarrage du serveur pour Backup dans 2 minutes !$(printf "\r")"
	done

	sleep 120s

	for SERV in `ls $server_path | grep ".mc"`
	do
		echo "Arret de $SERV."
		screen -R "$SERV" -X stuff "say Redemarrage imminent. $(printf "\r")"
		sleep 2s
		screen -R "$SERV" -X stuff "stop $(printf "\r")"
	done
	
	echo "On attends que les serveurs s'eteignent."
	sleep 30s

	for SERV in `ls $server_path | grep ".mc"`
	do
		echo "Backup de $SERV."
		if [ -d "$backup_path/$SERV" ];
		then
    			echo "Directory exists."
    		else
    			echo "$backup_path/$SERV doesent exist. Creating it ..."
			mkdir $backup_path/$SERV
    		fi
	src="$server_path/$SERV"
	dest="$backup/$serv/backup-$(date +%F\ -\ %Hh).tar.gz"
	
	echo "backup de ($src) sur ($dest)."
    	tar -cvpzf "$dest" "$src"
    	done

    	for SERV in `ls $server_path | grep ".mc"`
    	do
    		echo "Démarrage de $SERV."
    		screen -R "$SERV" -X stuff "cd ~/minecraft/$SERV/ $(printf "\r")"
    		screen -R "$SERV" -X stuff "./start.sh $(printf "\r")"
    	done
	
    	echo "Serveurs en cours de démarrage ..."
else
	#PARTIE ARGUMENTS. DANS CETTE PARTIE LE BACKUP S4EFFECTUE SEULEMENT SUR LES SERVEURS SPECIFIES
	for SERV in "$@"
	do
		echo "Prevention des joueurs sur $SERV ..."
		screen -R "$SERV" -X stuff " say Redemarrage du serveur pour Backup dans 2 minutes !$(printf "\r")"
	done

	sleep 120s

	for SERV in "$@"
	do
		echo "Arret de $SERV."
		screen -R "$SERV" -X stuff "say Redemarrage imminent. $(printf "\r")"
		sleep 2s
		screen -R "$SERV" -X stuff "stop $(printf "\r")"
	done
	
	echo "On attends que les serveurs s'eteignent."
	sleep 30s

	for SERV in "$@"
	do
		echo "Backup de $SERV."
		if [ -d "$backup_path/$SERV" ];
		then
    			echo "Directory exists."
    		else
			echo "$backup_path/$SERV doesent exist. Creating it ..."
    			mkdir $backup_path/$SERV
    		fi
		src="$server_path/$SERV"
		dest="$backup/$SERV/backup-$(date +%F\ -\ %Hh).tar.gz"
	
		echo "backup de ($src) sur ($dest)."
    		tar -cvpzf "$dest" "$src"
    	done


    	for SERV in "$@"
    	do
    		echo "Démarrage de $SERV."
    		screen -R "$SERV" -X stuff "cd ~/minecraft/$SERV/ $(printf "\r")"
    		screen -R "$SERV" -X stuff "./start.sh $(printf "\r")"
    	done

    	echo "Serveurs en cours de démarrage ..."

fi
