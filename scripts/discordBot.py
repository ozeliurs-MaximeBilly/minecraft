import discord
import os
import subprocess
import time
import psutil

installPath = "/root/minecraft"
help = "Voici la liste des commandes : \n$help : Afficher ce message.\n$ping : Tester si le bot fonctionne.\n$tps <nom_du_serv> : Afficher le tps du serveur\n$start <nom_du_serv> : Demarrer le serveur\n$stop <nom_du_serv> : Arreter le serveur\n$restart <nom_du_serv> : Redemarrer le serveur\n$backup <nom_du_serv> : Faire un backup du serveur\n$cpu : Afficher l'utilisation globale du serveur."

def getServers():
    servers = subprocess.check_output(('ls '+installPath+'/').split(" "))
    servers = str(servers)[2:-3].split("\\n")
    servers.remove("scripts")
    return servers

client = discord.Client()

@client.event
async def on_ready():
    print('We have logged in as {0.user}'.format(client))

@client.event
async def on_message(message):
    if message.author == client.user:
        return

    if message.content.startswith('$ping'):
        await message.channel.send('pong')

    if message.content.startswith('$help'):
        await message.reply(help)

    if message.content.startswith("$tps"):
        server = message.content.split("$tps")[1].strip()
        if ".mc" not in server:
            server += ".mc"

        servers = getServers()

        if server in servers:

            os.system('screen -R "' + server + '" -X stuff "tps $(printf "\r")"')
            time.sleep(3)
            try:
                out = str(subprocess.check_output(['tail', '-n1', ("/root/minecraft/"+ server +"/logs/latest.log")]))
                await message.reply(server + " : " + out.split("[Server thread/INFO]: ")[1].split("\\")[0])
            except subprocess.CalledProcessError as err:
                print(err)

        else:
            await message.reply("Les serveurs disponibles sont :\n" + "\n".join(servers))

    if message.content.startswith('$backup'):

        server = message.content.split("$backup")[1].strip()
        if ".mc" not in server:
            server += ".mc"

        servers = getServers()

        if server in servers:
            os.system(installPath + '/scripts/async.sh "' + installPath + "/scripts/backupd.sh "+server + '"')
            await message.reply("Backup de "+server+" en cours ...")
        else:
            await message.reply("Les serveurs disponibles sont :\n" + "\n".join(servers))

    if message.content.startswith('$restart'):
        server = message.content.split("$restart")[1].strip()
        if ".mc" not in server:
            server += ".mc"

        servers = getServers()

        if server in servers:
            os.system(installPath + "/scripts/restartd.sh " + server)
            await message.reply("Redemarrage de " + server + " en cours ...")
        else:
            await message.reply("Les serveurs disponibles sont :\n" + "\n".join(servers))

    if message.content.startswith('$start'):
        server = message.content.split("$start")[1].strip()
        if ".mc" not in server:
            server += ".mc"

        servers = getServers()

        if server in servers:
            os.system(installPath + "/scripts/startd.sh " + server)
            await message.reply("Demarrage de " + server + " en cours ...")
        else:
            await message.reply("Les serveurs disponibles sont :\n" + "\n".join(servers))

    if message.content.startswith('$stop'):
        server = message.content.split("$stop")[1].strip()
        if ".mc" not in server:
            server += ".mc"

        servers = getServers()

        if server in servers:
            os.system(installPath + "/scripts/stopd.sh " + server)
            await message.reply("Arret de " + server + " en cours ...")
        else:
            await message.reply("Les serveurs disponibles sont :\n" + "\n".join(servers))
    
    if message.content.startswith('$cpu'):
        await message.reply("Le CPU est a " + str(psutil.cpu_percent(10) + "% sur les 10 dernières secondes.") 


# Main
try:
    with open(".env","r",encoding="utf8") as env:
        token = env.read().split("TOKEN=")[1].split("\n")[0].strip()
except:
    print("You haven't configured you .env file properly")

client.run(token)
