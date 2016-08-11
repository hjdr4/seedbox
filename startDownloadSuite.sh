#!/bin/bash
~/remount.sh
qbittorrent-nox &
python ~/CouchPotatoServer/CouchPotato.py --daemon
python ~/SickRage/SickBeard.py --nolaunch --daemon
