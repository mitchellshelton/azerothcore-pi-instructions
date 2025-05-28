# Raspberry Pi 5 and AzerothCore with Playerbot
The following instructions include the required steps to get AzerothCore with the Playerbot module working on a Raspberry Pi 5.

---

Disclaimer: The Raspberry Pi 5 is not adequate to run AzerothCore as a public server and the assumption is that this will be a single player instance with a limit of 25 bots running. I recommend shutting down the docker containers when not in use for the best long term results. I do not know the long term impact running this would have on your hardware. Please proceed at your own risk.

I do not officially support or represent anyone in the AzerothCore or Playerbot community. Please use these instructions at your own risk. I am not responsible for any damage, lost time, or other inconviences that following these instructions may lead to.

I am unable to offer support for this process. Please see the resources below for more assistance.

---

These are not full instructions for how to set up and configure AzerothCore. Please see the official AzerothCore website (https://www.azerothcore.org) and the liyunfan1223 GitHub pages (https://github.com/liyunfan1223) for more information.

For detailed instructions on how to set this up on a VirtualBox machine please see https://www.youtube.com/watch?v=9WUZ6J7f03U 

For detailed written directions see Nirv's compainion text to his video here:
https://nirv.mooo.com:84/api/public/dl/ShUDo8u5?inline=true

I recommend going through the VirtualBox process if you struggle with the Raspberry Pi process outlined below. This is how I started and I learned a lot by working through the manual build process.

Special thanks to Nirv for providing that earlier guidance. You will certainly find some guidance inspired by his efforts throughout this documentation.

--- 
Quick Notes:

There are a few critical steps to getting AzerothCore working on Raspberry Pi that can be summed up very quickly. If you are already working on getting this running, these critical steps should help.

- Install clang
  ```bash
  sudo apt install clang
  ```
- Change paging to 4k from 16k
  ```bash
  vim /boot/firmware/config.txt
  ```

  ```bash
  # Change paging to 4k
  kernel=kernel8.img
  ```
- Use download instructions from liyunfan1223 NOT azerothcore GitHub
  https://github.com/liyunfan1223
- Change permissions on the azerothcore-wotlk directory before running the build command for the first time
  ```bash
  chmod -Rf 777 ~/azerothcore-wotlk
  ```

## Getting started
First we need to prepare the Raspberry Pi 5 for the process.

### Change to root user
```bash
sudo -i
```

### Update your pi
```bash
sudo apt update
```

- You should run these commands more than once to confirm that everything is updated, upgraded, and clean.

### Upgrade your pi
```bash
sudo apt upgrade
```

### Remove packages that are no longer required
```bash
sudo apt autoremove
```

### Install vim
```bash
sudo apt install vim
```

This is optional. Nano comes installed on the Raspberry Pi and also works just fine. 

### Install clang
```bash
sudo apt install clang
```

This is a dependency for Azeroth Core Installation with docker. 

## Install and Configure Docker
The Docker install process is the best approach for the Raspberry Pi. Note that the Debian that comes with the Pi is not equal to just vanilla Debian. There are many dependency issues that are resolved immediately by just using docker.

### Install Docker
```bash
sudo apt install docker.io
```

### Install and Link Docker Compose to Docker
Confirm that docker is installed:
```bash
docker -v
```

- Download the docker compose plugin from the official docker github page
  - https://github.com/docker/compose/releases
  - Select the arm version, not the arch version

```bash
wget https://github.com/docker/compose/releases/download/v2.34.0/docker-compose-linux-armv6
```

Create the plugin directory as root
```bash
mkdir -p ~/.docker/cli-plugins/
```

Rename the downloaded file
```bash
mv docker-compose-linux-armv6 ~/.docker/cli-plugins/docker-compose
```

Make the file executable:
```bash
chmod +x ~/.docker/cli-plugins/docker-compose
```

NOTE: Do not use "apt install docker-compose". This will not work for commands 
formatted as docker compose. 

## Change paging to 4k from 16k

edit this file:

```bash
vim /boot/firmware/config.txt
```

Add this line at the top:

```bash
# Change paging to 4k
kernel=kernel8.img
```

Reboot for the changes to take effect

## Install AzerothCore

Note: Use the playerbot version from liyunfan1223, not the official version, it won't work.

```bash
sudo -i
cd ~/
git clone https://github.com/liyunfan1223/azerothcore-wotlk.git --branch=Playerbot
cd azerothcore-wotlk/modules
git clone https://github.com/liyunfan1223/mod-playerbots.git --branch=master
cd ~/azerothcore-wotlk
touch docker-compose.override.yml
vim docker-compose.override.yml
```

Add the following: 

```yaml
services:
  ac-worldserver:
    volumes:
      - ./modules:/azerothcore/modules:ro
```

```bash
chmod -Rf 777 ~/azerothcore-wotlk
```
Note: This is a critical step. The build process will fail with permission issues.

```bash
docker compose up -d --build
```

Note: This process takes a long time the first time you run the build command.
It takes around 4 minutes before you reach step 22/29 on a Raspberry Pi 5 with 8GB
of RAM. This step includes ac-db-import build item 8/8 which is a very long build step. 
It does show a percentage, which is helpful to make sure that things aren't frozen. 
The first time this is run just the ac-db-import build process will take a little 
over 1 hour to complete. After ac-db-import build is complete it was take an additional 
20 minutes to wrap up the final tasks. It should total around 1 hour and 30 minutes for 
the first build. Note that future builds will take closer to 10-20 minutes. 

If for some reason the process stops, crashes, or errors out just restart it. 
It will resume where it left off. If you need to troubleshoot you can view the 
docker logs for the ac-db-import process with this command:

```bash
docker compose logs -f ac-db-import
```

Note: I recently had an issue where during the build process the sql scripts were not getting run completely. I created the file below to help with this:
https://github.com/mitchellshelton/azerothcore-pi-instructions/blob/main/update-playerbot-sql.sh

## Set your IP Address Manually
```bash
nmcli con mod "Wired connection 1" ipv4.addresses <your_ip_address>/24
nmcli con mod "Wired connection 1" ipv4.gateway <your_gateway_address>
nmcli con mod "Wired connection 1" ipv4.dns "<your_gateway_address>"
nmcli con mod "Wired connection 1" ipv4.method manual
nmcli con up "Wired connection 1"
```

WARNING: If you are connected remotely this will terminate your 
connection because it changes the IP Address. It is best if you run these 
commands while connected directly to the pi.

## Add your IP Address to the db realmlist
```bash
docker ps
docker exec -it ac-database bash
mysql -u root -p
```

(default password is "password")

```sql
show databases;
use acore_auth
UPDATE realmlist SET address = '<your_ip_address>' WHERE id = 1;
exit;
```

## Change the name of your realm (Optional)
```bash
docker ps
docker exec -it ac-database bash
mysql -u root -p
```

```sql
show databases;
use acore_auth;
UPDATE realmlist SET name = 'Azeroth Core' WHERE id = 1;
exit;
```

## Create your account
```bash
docker ps
docker attach ac-worldserver
account create <username> <password>
account set gmlevel <username> 3 -1
```

## Edit the realmlist in ChromieCraft
\ChromieCraft\Data\enUS\realmlist.wtf

```bash
set realmlist <your_ip_address>
```

## Edit the worldserver.conf
```bash
vim ~/azerothcore-wotlk/env/dist/etc/worldserver.conf
```

```yaml
MonsterSight = 20.000000
ListenRange.Say = 80
MailDeliveryDelay = 5
MaxGroupXPDistance = 255
InstantLogout = 0
MaxPrimaryTradeSkill = 11
PreventAFKLogout = 2
```

## Edit the playerbots.conf
```bash
cp playerbots.conf.dist playerbots.conf
```

```bash
vim ~/azerothcore-wotlk/env/dist/etc/modules/playerbots.conf
```

Note: Keep the bots as low as possible. The Raspberry Pi is not powerful 
enough to run more than 25 bots with a best performance configuration.

I recommend that you check out this documentation before proceeding with 
bot configuration:
https://github.com/liyunfan1223/mod-playerbots/wiki/Playerbot-Configuration

I have used the "best performance with high bot count." configuration here:

```yaml
AiPlayerbot.BotActiveAlone = 10
AiPlayerbot.botActiveAloneSmartScale = 1
AiPlayerbot.botActiveAloneSmartScaleWhenMinLevel = 1
AiPlayerbot.botActiveAloneSmartScaleWhenMaxLevel = 80
```

```yaml
AiPlayerbot.MinRandomBots = 25
AiPlayerbot.MaxRandomBots = 25
AiPlayerbot.UseGroundMountAtMinLevel = 5
AiPlayerbot.RandomBotMinLevel = 1
AiPlayerbot.RandomBotMaxLevel = 1
AiPlayerbot.RandomBotMaxLevelChance = 0
AiPlayerbot.DisableRandomLevels = 1
AiPlayerbot.RandombotStartingLevel = 1
```

### Bot Performance Testing on the Raspberry Pi
The Raspberry Pi should probaby only be used for solo local network play. I was 
unable to test with more than one player connected. Even with conservative settings,
I was only able to get 25 bots working at a cpu usage level that I felt comfortable 
with. Below are the results of the stress tests I did to arrive at the 25 bot limit.

#### Stress Tests

Note: These stress tests were run with option 3 from the performance guide here:
https://github.com/liyunfan1223/mod-playerbots/wiki/Playerbot-Configuration
(All bots active regardless your latency and performance impact.)

##### 5 Bots
- .server info output:
  - Mean: 1ms
  - Median: 1ms
  - Percentiles (95, 99, max): 5ms, 6ms, 6ms
- console top for wordserver
  - Random CPU Sampling: 61.5%, 62.8%, 63.3%
  - Memory: 19.3%

---

##### 20 Bots
- .server info output:
  - Mean: 3ms
  - Median: 1ms
  - Percentiles (95, 99, max): 8ms, 9ms, 10ms
- console top for wordserver
  - Random CPU Sampling: 86.7%, 84%, 85%
  - Memory: 18.2%
  
---

##### 50 Bots
- .server info output:
  - Mean: 4ms
  - Median: 1ms
  - Percentiles (95, 99, max): 10ms, 16ms, 741ms
- console top for wordserver
  - Random CPU Sampling: 93.3%, 94%, 93.4%
  - Memory: 18.9%
  
---

#### Conclusion - 25 Bots
Note: This configuration was run with option 1 from the performance guide here:
https://github.com/liyunfan1223/mod-playerbots/wiki/Playerbot-Configuration
(best performance with high bot count.)

This was what I settled on based on the numbers above.

- 25 Bots
  - .server info output:
    - Mean: 2ms
    - Median: 1ms
    - Percentiles (95, 99, max): 8ms, 9ms, 34ms
  - console top for wordserver
    - Random CPU Sampling: 78.3%, 81.3%, 77%
    - Memory: 19%
    - Max CPU Spike to 87% with 5 summoned bots in party
    
---

## Install more modules
Find more at https://www.azerothcore.org/catalogue.html

```bash
cd ~/azerothcore-wotlk/modules/
git clone https://github.com/BytesGalore/mod-no-hearthstone-cooldown.git
git clone https://github.com/azerothcore/mod-account-mounts
docker compose up -d --build
```

## Hacking the database (optional)
WARNING: This can destroy everything you have done. Proceed with caution.
Make backups and only execute commands that you understand.

```bash
docker ps
docker exec -it ac-database bash
mysql -u root -p
```

(default password is "password")

Below is an example of how I would review the database for lowering the
first ground mount requirement from level 20 to level 5. This is meant to
be an example for how you can explore the databases to make changes to items 
and vendors. While I have implemented these changes successfully, do so at your 
own risk.

### List the available databases
```sql
show databases;
```

### Select the database we will be modifying
```sql
use acore_world;
```

### Find out which tables are in the database
```sql
show tables;
```

### Examine the database so we can figure out what we need to change
```sql
show columns in npc_trainer;
```

### Find our trainer spell that we are going to modify
```sql
SELECT * FROM npc_trainer WHERE spellid = 33388;
```

### Update our trainers so we can train mounts at level 5
```sql
UPDATE npc_trainer SET reqlevel = 5 WHERE spellid = 33388;
```

### Examine the database so we can figure out what we need to change
```sql
show columns in item_template;
```

### View all of the mounts so we can get a specific named one to review
```sql
SELECT name FROM item_template WHERE description LIKE '%Teaches you how to summon this mount.%';
```

### View all of the columns for a single mount to identify fields to modify
```sql
SELECT * FROM item_template WHERE name LIKE 'Reins of the Striped Nightsaber';
```

### This narrows down our search to only 44 mounts, down from 291
```sql
SELECT name FROM item_template WHERE RequiredSkill = 762 AND RequiredLevel = 20;
```

### Using our narrowed results let's set our 44 mounts to level 5 
```sql
UPDATE item_template SET RequiredLevel = 5 WHERE RequiredSkill = 762 AND RequiredLevel = 20;
```

```sql
UPDATE item_template SET ItemLevel = 5 WHERE RequiredSkill = 762 AND RequiredLevel = 5;
```

Note: Items are cached locally, so these changes won't show up even after
rebooting the server. You need to delete the local cache.

Delete all the wdb files in this directory (files only, no folders)
/ChromieCraft/Cache/WDB/enUS

## Some useful GM Commands
For the complete list of commands:
https://www.azerothcore.org/wiki/gm-commands

- I recommend that you turn the gm mode off. This can cause issues during standard gameplay.
  ```bash
  .gm off
  ```
- This will give your character 50,000 gold. It is given in "copper" so 1 gold is equal to 100 silver and 1 silver is equal to 100 copper. To simplify this just add 4 zeros to the number of copper to get amount of gold you want to give your character.
  ```bash
  .modify money 500000000
  ```
- Create a guild for yourself and your favorite bots
  ```bash
  .guild create [$GuildLeaderName] "$GuildName"
  ```
- Invite a bot to your guild
  ```bash
  .guild invite [$CharacterName] "$GuildName"
  ```
- Kick a bot out of their bot guild so you can invite them to your guild.
  ```bash
  .guild uninvite [$CharacterName]
  ```
- Get unstuck
  ```bash
  .unstuck $playername [inn/graveyard/startzone]
  ```
