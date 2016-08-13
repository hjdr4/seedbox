#!/bin/bash
apt-get update
#apt-get install -y software-properties-common
#add-apt-repository -y ppa:qbittorrent-team/qbittorrent-stable
#apt-get update
apt-get install -y qbittorrent-nox
apt-get install -y python
apt-get install -y python3
apt-get install -y python3-pip
apt-get install -y git
apt-get install -y fuse
apt-get install -y nano
debconf-set-selections <<< "postfix postfix/mailname string seedbox"
debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt-get install -y postfix
apt-get install -y procmail
cd /root
git clone https://github.com/yadayada/acd_cli.git &>/dev/null
cd acd_cli && python3 setup.py install &>/dev/null
#Fixes DECRYPTION_FAILED_OR_BAD_RECORD_MAC
apt-get install -y wget
wget -P /usr/local/share/ca-certificates/cacert.org http://www.cacert.org/certs/root.crt http://www.cacert.org/certs/class3.crt
update-ca-certificates
