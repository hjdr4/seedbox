# seedbox
Container for running SickRage, CouchPotato and qBittorrent storing on Amazon Cloud Drive easily
(ACD provides unlimited storage for $60/year actually, with good performance)

Clone this repos  
Build: docker build -t seedbox .  
Run: docker run --rm -P --net=host --privileged --device /dev/fuse -v \<volume\>:/root -it --name seedbox seedbox /bin/bash  
Put your oauth_data file into \<volume\>/.cache/acd_cli/oauth_data 
Init: /initVolume.sh
Start the download suite : ~/startDownloadSuite.sh  

CouchPotato:5050  
SickRage:8081  
qBittorrent:8080  

Login to services to setup credentials  

Software is provided with default configuration :  
/root is a volume  
/root/acd is your ACD mount point
incomplete downloads go into /root/downloads/incomplete
/root/downloads/Movies|Shows symlink to /root/acd/Movies|temp
qBittorrents executes ~/move.sh "%F" "~/downloads/%L/" at the end of download. It moves the download in /root/downloads/\<label\>/ (retrying if the cloud drive throw errors).  
SickRage will use qBittorrent, using Shows as label  
SickRage looks for shows in /root/acd/Shows  
SickRage renaming will occur for things in /root/acd/temp  
CouchPotato will use qBittorrent, using Movies as label  
CouchPotato renaming will occur for things in /root/acd/Movies  

TODO  
Fix an error from SickRage to qBittorrent when using anonymous authentication : SickRage get rejected by qBittorrent for too many bad requests (!)
