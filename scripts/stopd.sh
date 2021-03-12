#!/bin/bash

# Description : "Stop deamon"

#define backup folder
script_path="$(dirname $(readlink -f $0))/"
backup_path="$script_path../backup" # ici /root/minecraft/scripts/../backup
server_path="$script_path.." # ici /root/minecraft/scripts/..

if [ "$#" = 0 ];
then
	  echo "Arret de tous les serveurs ..."

		for SERV in `ls $server_path | grep ".mc"`
		do
		  echo "Arret de $SERV."
		  screen -R "$SERV" -X stuff "stop $(printf "\r")"
		done

else
	for SERV in "$@"
	do

		for SERV in "$@"
		do
		  echo "Arret de $SERV."
		  screen -R "$SERV" -X stuff "stop $(printf "\r")"
		done
    
	done
fi
