#!/bin/bash

# Description : "Start deamon"

#define folders
script_path="$(dirname $(readlink -f $0))/"
backup_path="$script_path../backup" # ici /root/minecraft/scripts/../backup
server_path="$script_path.." # ici /root/minecraft/scripts/..

if [ "$#" = 0 ];
then
	echo "Démarrage de tous les serveurs ..."

		for SERV in `ls $server_path/ | grep ".mc"`
		do
		  echo "Démarrage de $SERV."
		  screen -R "$SERV" -X stuff "cd $server_path/$SERV/ $(printf "\r")"
		  screen -R "$SERV" -X stuff "./start.sh $(printf "\r")"
		done

		echo "Serveurs en cours de démarrage ..."

else
	for SERV in "$@"
	do
		for SERV in "$@"
		do
		  echo "Démarrage de $SERV."
		  screen -R "$SERV" -X stuff "cd $server_path/$SERV/ $(printf "\r")"
		  screen -R "$SERV" -X stuff "./start.sh $(printf "\r")"
		done

		echo "Serveurs en cours de démarrage ..."
	done
fi
