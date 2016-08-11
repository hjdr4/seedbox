#!/bin/bash
cd ~
git clone https://github.com/CouchPotato/CouchPotatoServer.git &>/dev/null
git clone https://github.com/SickRage/SickRage.git &>/dev/null
cp -f /remount.sh ~/remount.sh
mkdir -p ~/acd
/root/remount.sh &>/dev/null|| { echo "ERROR : Could not mount ACD. Make sure your volume has .cache/acd/oauth_data file" ; exit 1; }
mkdir -p ~/acd/temp
mkdir -p ~/acd/Shows
mkdir -p ~/acd/Movies
mkdir -p ~/.cache/acd_cli/
mkdir -p ~/.config/qBittorrent
cp -n /qBittorrent.conf ~/.config/qBittorrent/qBittorrent.conf
mkdir -p ~/.couchpotato
cp -n /couchpotato_settings.conf ~/.couchpotato/settings.conf
cp -n /sickrage_config.ini ~/SickRage/config.ini
mkdir -p ~/downloads/completed
mkdir -p ~/downloads/incomplete
mkdir -p ~/downloads/torrents
ln -s ~/acd/temp ~/downloads/Shows &>/dev/null
ln -s ~/acd/Movies ~/downloads/Movies  &>/dev/null
cp -f /move.sh ~/move.sh
cp -f /startDownloadSuite.sh ~/startDownloadSuite.sh
test -f ~/SickRage/_init || cp  -f /sickrage_config.ini ~/SickRage/config.ini
touch ~/SickRage/_init
echo "Init completed"
