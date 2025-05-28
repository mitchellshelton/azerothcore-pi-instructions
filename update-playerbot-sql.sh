#!/bin/bash

#
# update-playerbot-sql.sh
#
# Confirm your database container name
# docker ps
#
# Open a shell to the container
# docker exec -it ac-database bash
#
# Connect to SQL
# mysql -u root -p
# (default password is "password")
#
# Confirm you database names for use in the scripts
# show databases;
#
# Loop over each directory creating an easy to copy/paste list of file names
# find ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/characters/ -type f -exec basename {} \;
# find ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/world/ -type f -exec basename {} \;
# find ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/ -type f -exec basename {} \;
#
# This is the command that you need to execute for each file
# docker exec -i ac-database mysql -u root -ppassword acore_characters < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/characters/playerbots_arena_team_names.sql
#
# You could write a script to loop over each database/file. I just put each command on a single line and ran the script
# Don't forget to make your script executable with chmod +x
#
# Note: This will likely change, so you probably want to generate your own...but here it is for as long as it works
#

docker exec -i ac-database mysql -u root -ppassword acore_characters < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/characters/playerbots_arena_team_names.sql
docker exec -i ac-database mysql -u root -ppassword acore_characters < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/characters/playerbots_guild_names.sql
docker exec -i ac-database mysql -u root -ppassword acore_characters < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/characters/playerbots_names.sql
docker exec -i ac-database mysql -u root -ppassword acore_world < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/world/world_charsections_dbc.sql
docker exec -i ac-database mysql -u root -ppassword acore_world < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/world/world_emotetextsound_dbc.sql
docker exec -i ac-database mysql -u root -ppassword acore_world < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/world/world_playerbots_rpg_races.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_random_bots.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_tele_cache.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_db_store.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_enchants.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_weightscale_data.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_custom_strategy.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_speech_probability.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_guild_tasks.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_account_links.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/updates_include.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/ai_playerbot_texts.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_equip_cache.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_item_info_cache.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_weightscales.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/ai_playerbot_texts_chance.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_rarity_cache.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_rnditem_cache.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_speech.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_dungeon_suggestion_strategy.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/updates.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_travelnode.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_account_keys.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_dungeon_suggestion_definition.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_dungeon_suggestion_abbrevation.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_travelnode_path.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_preferred_mounts.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/playerbots_travelnode_link.sql
docker exec -i ac-database mysql -u root -ppassword acore_playerbots < ~/azerothcore-wotlk/modules/mod-playerbots/data/sql/playerbots/base/version_db_playerbots.sql
