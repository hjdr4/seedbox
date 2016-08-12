#!/bin/bash
/root/remount.sh
qbittorrent-nox &
python /root/CouchPotatoServer/CouchPotato.py --daemon
python /root/SickRage/SickBeard.py --nolaunch --daemon
exec /bin/bash
