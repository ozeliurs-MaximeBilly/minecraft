#!/bin/bash

# Description : "Cold Start Daemon"

#define backup folder
script_path="$(dirname $(readlink -f $0))/"
backup_path="$script_path../backup" # ici /root/minecraft/scripts/../backup
server_path="$script_path.." # ici /root/minecraft/scripts/..

echo "Démarrage du bot discord ..."
screen -S discord -d -m
screen -R discord -X stuff "python3 $script_path/discordBot.py $(printf "\r")"
echo "Bot Discord en cours de démarrage ..."

echo "Démarrage de tous les serveurs ..."

for SERV in `ls $server_path | grep ".mc"`
do
  echo "Démarrage de $SERV"
  screen -S "$SERV" -d -m 
  screen -R "$SERV" -X stuff "cd ~/minecraft/$SERV/ $(printf "\r")"
  screen -R "$SERV" -X stuff "./start.sh $(printf "\r")"
done

echo "Serveurs en cours de démarrage ..."
