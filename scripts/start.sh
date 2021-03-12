#!/bin/bash

# Description : "Start script of the minecraft server in this folder."
#

# Do not alter : code to get folder of script and go there.
script_path="$(dirname $(readlink -f $0))/"
cd $script_path

# You can alter this : This is the normal code for minecraft java edition
java -Xmx1G -Xms1G -jar server.jar nogui

echo "Minecraft Server Launched !"
