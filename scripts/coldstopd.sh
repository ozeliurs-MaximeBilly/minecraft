#!/bin/bash

# Description : "Stop everything deamon"

#define backup folder
script_path="$(dirname $(readlink -f $0))/"
backup_path="$script_path../backup" # ici /root/minecraft/scripts/../backup
server_path="$script_path.." # ici /root/minecraft/scripts/..

echo "Arret de tous les serveurs ..."

for SERV in `ls $server_path | grep ".mc"`
do
  echo "Arret de $SERV."
  screen -R "$SERV" -X stuff "stop $(printf "\r")"
done

sleep 30s

for SERV in `ls ~/minecraft/ | grep ".mc"`
do
  echo "Arret du screen : $SERV."
  screen -X -R "$SERV" quit
done

echo "Arret du bot discord ..."
screen -X -R discord quit
echo "Bot Discord arrêté"

echo "Tout est arrêté !"
