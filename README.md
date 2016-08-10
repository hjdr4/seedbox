# seedbox
Clone this repos
Build: docker build . -t seedbox
Run: docker run --net=host -v <volume>:/root/downloads -itd --name seedbox seedbox /bin/bash
Init: docker exec seedbox /root/initFolders.sh
Put your oauth_data file into /root/.cache/acd_cli/oauth_data
Mount your Amazon Cloud Drive with ~/remount.sh, it is mounted as ~/acd
When it's done, create ~/acd/temp, ~/acd/Shows, ~/acd/Movies : mkdir -p ~/acd/temp ~/acd/Shows ~/acd/Movies

Start CouchPotato, SickRage and qBittorrent with ~/startDownloadSuite.sh, you can leave the container with ctrl+p crtl+q

CouchPotato:5050
SickRage:8081
qBittorrent:8080

Login to services to setup credentials

Setup CouchPotato to use Movies tag
Setup Sickrage to use Shows tag, make postprocessing point to /root/acd/temp


