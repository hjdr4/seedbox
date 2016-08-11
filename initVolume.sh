#!/bin/bash
cd ~
git clone https://github.com/CouchPotato/CouchPotatoServer.git
git clone https://github.com/SickRage/SickRage.git
git clone https://github.com/yadayada/acd_cli.git
cd acd_cli && python3 setup.py install
cd ~
cp -f /remount.sh ~/remount.sh
mkdir -p ~/acd
/root/remount.sh || { echo "ERROR : Could not mount ACD" ; exit 1; }
mkdir -p ~/acd/temp
mkdir -p ~/acd/Shows
mkdir -p ~/acd/Movies
mkdir -p ~/acd/Anime
mkdir -p ~/.cache/acd_cli/
mkdir -p ~/.config/qBittorrent
cp -n /qBittorrent.conf ~/.config/qBittorrent/qBittorrent.conf
mkdir -p ~/.couchpotato
cp -n /couchpotato_settings.conf ~/.couchpotato/settings.conf
cp -n /sickrage_config.ini ~/SickRage/config.ini
mkdir -p ~/downloads/completed
mkdir -p ~/downloads/incomplete
mkdir -p ~/downloads/torrents
ln -s ~/acd/temp ~/downloads/Shows
ln -s ~/acd/Movies ~/downloads/Movies
cp -f /move.sh ~/move.sh
cp -f /startDownloadSuite.sh ~/startDownloadSuite.sh
cp  ~/SickRage/config.ini  ~/SickRage/_config.ini-`date +%s` && cp -f /sickrage_config.ini ~/SickRage/config.ini
