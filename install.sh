#!/bin/bash
apt-get update
apt-get install -y qbittorrent-nox
apt-get install -y python
apt-get install -y python3
apt-get install -y python3-pip
apt-get install -y git
apt-get install -y fuse

debconf-set-selections <<< "postfix postfix/mailname string seedbox"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get install -y postfix
apt-get install -y procmail
cd ~
git clone https://github.com/yadayada/acd_cli.git &>/dev/null
cd acd_cli && python3 setup.py install &>/dev/null

