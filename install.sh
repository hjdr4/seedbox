#!/bin/bash
test -f /.dockerenv && DOCKER="true" || DOCKER=""

$SUDO apt-get update
$SUDO apt-get install -y qbittorrent-nox
$SUDO apt-get install python
$SUDO apt-get install -y python3
$SUDO apt-get install -y python3-pip
$SUDO apt-get install -y git

cd ~
git clone https://github.com/CouchPotato/CouchPotatoServer.git
git clone https://github.com/SickRage/SickRage.git
git clone https://github.com/yadayada/acd_cli.git
cd acd_cli && python3 setup.py install
cd ~

cat > ~/remount.sh << EOF
#!/bin/bash
lockfile -r 0 /tmp/remount.lock || exit 1
cd ~ && fusermount -u acd
ps aux |grep -i python3 |grep -i acdcli|grep -v grep|awk '{print $2}'|xargs kill -9
rm  -f ~/.cache/acd_cli/nodes.db
acdcli sync
acdcli mount -ao -i 30 ~/acd 2>&1 1>/dev/null
rm -f /tmp/remount.lock
EOF

chmod +x  ~/remount.sh

cat > ~/move.sh << EOF
#!/bin/bash
source="$1"
destination="$2"

while true
do
	mv -f "$source" "$destination"
	if [ $? -ne 0 ]
	then 
		~/remount.sh		
	else
		break
	fi
	sleep 1
done
EOF

chmod +x  ~/move.sh

cat > ~/startDownloadSuite.sh << EOF
#!/bin/bash
~/remount.sh
qbittorrent-nox & 
python $prefix/CouchPotatoServer/CouchPotato.py --daemon 
python ~/SickRage/SickBeard.py --nolaunch --daemon
EOF

chmod +x ~/startDownloadSuite.sh 

cat > ~/initFolders.sh << EOF
mkdir -p ~/downloads/completed
mkdir -p ~/downloads/incomplete
mkdir -p ~/downloads/torrents
ln -s ~/acd/Shows ~/downloads/Shows
ln -s ~/acd/Movies ~/downloads/Movies
EOF

chmod +x ~/initFolders.sh

mkdir -p ~/.cache/acd_cli/
mkdir -p .config/qBittorrent


cat > .config/qBittorrent/qBittorrent.conf << EOF
[General]
MainWindowLastDir=~/downloads/torrents

[AddNewTorrentDialog]
expanded=false
qt5\treeHeaderState="@ByteArray(\0\0\0\xff\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x4\x4\0\0\0\x1\0\0\0\x2\0\0\0\x64\0\0\x1,\0\0\0\x4\x1\x1\0\x1\0\0\0\0\0\0\0\0\0\0\0\0\x64\xff\xff\xff\xff\0\0\0\x81\0\0\0\0\0\0\0\x4\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\x3\xe8\0)"
width=486
y=389

[AutoRun]
enabled=true
program=~/move.sh \"%F\" \"~/downloads/%L/\"

[LegalNotice]
Accepted=true

[MainWindow]
geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x2\0\0\0\0\a\xcf\0\0\x1r\0\0\v`\0\0\x3\xa4\0\0\a\xcf\0\0\x1r\0\0\v`\0\0\x3\xa4\0\0\0\0\0\0\0\0\xf\0)
qt5\vsplitterState=@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x2\0\0\0x\0\0\x2\xe\x1\xff\xff\xff\xff\x1\0\0\0\x1\0)

[Preferences]
Advanced\AnnounceToAllTrackers=true
Advanced\AnonymousMode=false
Advanced\IgnoreLimitsLAN=true
Advanced\IncludeOverhead=false
Advanced\LtTrackerExchange=false
Advanced\OutgoingPortsMax=0
Advanced\OutgoingPortsMin=0
Advanced\RecheckOnCompletion=false
Advanced\SuperSeeding=false
Advanced\TrayIconStyle=0
Advanced\confirmTorrentDeletion=true
Advanced\confirmTorrentRecheck=true
Advanced\osCache=true
Advanced\trackerEnabled=false
Advanced\trackerPort=9000
Advanced\useSystemIconTheme=true
Bittorrent\AddTrackers=false
Bittorrent\DHT=true
Bittorrent\Encryption=0
Bittorrent\LSD=true
Bittorrent\MaxConnecs=500
Bittorrent\MaxConnecsPerTorrent=100
Bittorrent\MaxRatio=-1
Bittorrent\MaxRatioAction=@Variant(\0\0\0\x7f\0\0\0\xfMaxRatioAction\0\0\0\0\0)
Bittorrent\MaxUploads=-1
Bittorrent\MaxUploadsPerTorrent=-1
Bittorrent\PeX=true
Bittorrent\TrackersList=
Bittorrent\uTP=true
Bittorrent\uTP_rate_limited=true
Connection\GlobalDLLimit=-1
Connection\GlobalDLLimitAlt=10
Connection\GlobalUPLimit=100
Connection\GlobalUPLimitAlt=10
Connection\InetAddress=
Connection\Interface=
Connection\InterfaceListenIPv6=false
Connection\InterfaceName=
Connection\MaxHalfOpenConnec=20
Connection\PortRangeMin=8999
Connection\Proxy\Authentication=false
Connection\Proxy\IP=0.0.0.0
Connection\Proxy\Password=
Connection\Proxy\Port=8080
Connection\Proxy\Username=
Connection\ProxyForce=true
Connection\ProxyOnlyForTorrents=false
Connection\ProxyPeerConnections=false
Connection\ProxyType=-1
Connection\ResolvePeerCountries=true
Connection\ResolvePeerHostNames=false
Connection\UPnP=true
Downloads\AppendLabel=false
Downloads\DblClOnTorDl=0
Downloads\DblClOnTorFn=1
Downloads\DiskWriteCacheSize=0
Downloads\DiskWriteCacheTTL=60
Downloads\DownloadInScanDirs=1
Downloads\FinishedTorrentExportDir=
Downloads\NewAdditionDialog=false
Downloads\NewAdditionDialogFront=true
Downloads\PreAllocation=false
Downloads\SavePath=~/downloads/completed
Downloads\SaveResumeDataInterval=3
Downloads\ScanDirs=~/downloads/torrents
Downloads\ScanDirsDownloadPaths=~/torrents
Downloads\ScanDirsLastPath=~/downloads/torrents
Downloads\StartInPause=false
Downloads\TempPath=~/downloads/incomplete
Downloads\TempPathEnabled=true
Downloads\TorrentExportDir=
Downloads\UseIncompleteExtension=true
DynDNS\DomainName=changeme.dyndns.org
DynDNS\Enabled=false
DynDNS\Password=
DynDNS\Service=0
DynDNS\Username=
ExecutionLog\enabled=true
General\AlternatingRowColors=true
General\CloseToTray=false
General\ExitConfirm=false
General\Locale=en
General\MinimizeToTray=false
General\NoSplashScreen=false
General\PreventFromSuspend=false
General\ProgramNotification=true
General\RefreshInterval=1500
General\StartMinimized=false
General\SystrayEnabled=false
General\UseRandomPort=false
IPFilter\Enabled=false
IPFilter\File=
IPFilter\FilterTracker=false
MailNotification\email=
MailNotification\enabled=false
MailNotification\password=
MailNotification\req_auth=false
MailNotification\req_ssl=false
MailNotification\smtp_server=smtp.changeme.com
MailNotification\username=
Queueing\IgnoreSlowTorrents=false
Queueing\MaxActiveDownloads=10
Queueing\MaxActiveTorrents=10
Queueing\MaxActiveUploads=3
Queueing\QueueingEnabled=true
Scheduler\Enabled=false
Scheduler\days=0
Scheduler\end_time=@Variant(\0\0\0\xf\x4J\xa2\0)
Scheduler\start_time=@Variant(\0\0\0\xf\x1\xb7t\0)
State\hSplitterSizes=115, 638
State\pos=@Point(952 242)
State\size=@Size(779 591)
WebUI\Enabled=true
WebUI\HTTPS\Enabled=false
WebUI\LocalHostAuth=false
WebUI\Port=8080
WebUI\UseUPnP=true


[SpeedWidget]
graph_enable_0=true
graph_enable_1=true
graph_enable_2=false
graph_enable_3=false
graph_enable_4=false
graph_enable_5=false
graph_enable_6=false
graph_enable_7=false
graph_enable_8=false
graph_enable_9=false
period=1

[TorrentAdditionDlg]
save_path_history=/tmp

[TorrentImportDlg]
dimensions=@ByteArray(\x1\xd9\xd0\xcb\0\x2\0\0\0\0\x2\xfd\0\0\x1\xe0\0\0\x4\xcc\0\0\x2\xcb\0\0\x2\xfd\0\0\x1\xe0\0\0\x4\xcc\0\0\x2\xcb\0\0\0\0\0\0\0\0\xf\0)

[TorrentProperties]
CurrentTab=-1
Peers\qt5\PeerListState=@ByteArray(\0\0\0\xff\0\0\0\0\0\0\0\x1\0\0\0\x1\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\r\0\x10\0\0\0\x1\0\0\0\f\0\0\0\x64\0\0\x4\x66\0\0\0\r\x1\x1\0\x1\0\0\0\0\0\0\0\0\0\0\0\0\x64\xff\xff\xff\xff\0\0\0\x81\0\0\0\0\0\0\0\r\0\0\0\x1a\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\x3\xe8\0)
SplitterSizes="133,312"
Trackers\qt5\TrackerListState="@ByteArray(\0\0\0\xff\0\0\0\0\0\0\0\x1\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x2~\0\0\0\x5\x1\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\0\x64\xff\xff\xff\xff\0\0\0\x81\0\0\0\0\0\0\0\x5\0\0\0\x1e\0\0\0\x1\0\0\0\0\0\0\x1,\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0l\0\0\0\x1\0\0\0\0\0\0\x3\xe8\0)"
Visible=true
qt5\FilesListState=@ByteArray(\0\0\0\xff\0\0\0\0\0\0\0\x1\0\0\0\x1\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x2\xbc\0\0\0\x4\x1\x1\0\x1\0\0\0\0\0\0\0\0\0\0\0\0\x64\xff\xff\xff\xff\0\0\0\x81\0\0\0\0\0\0\0\x4\0\0\x1\x90\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\x3\xe8\0)

[TransferList]
qt5\HeaderState=@ByteArray(\0\0\0\xff\0\0\0\0\0\0\0\x1\0\0\0\x1\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1d\b\xe0\xff\x1f\0\0\0\x11\0\0\0\x1c\0\0\0\0\0\0\0\xf\0\0\0\0\0\0\0\xe\0\0\0\0\0\0\0\x19\0\0\0\0\0\0\0\x18\0\0\0\0\0\0\0\x1b\0\0\0\0\0\0\0\x1a\0\0\0\0\0\0\0\x15\0\0\0\0\0\0\0\x14\0\0\0\0\0\0\0\x17\0\0\0\0\0\0\0\x16\0\0\0\0\0\0\0\x11\0\0\0\0\0\0\0\x10\0\0\0\0\0\0\0\x3\0\0\0\0\0\0\0\x13\0\0\0\0\0\0\0\x12\0\0\0\0\0\0\0\r\0\0\0\0\0\0\x4\xb0\0\0\0\x1d\x1\x1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\x64\xff\xff\xff\xff\0\0\0\x81\0\0\0\0\0\0\0\x1d\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\x64\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\0\0\0\0\0\x1\0\0\0\0\0\0\x3\xe8\0)

[TransferListFilters]
customLabels=@Invalid()
selectedFilterIndex=1
EOF

echo "Build the container: docker build . -t seedbox"
echo "Run the container with appropriate volume, if required: docker run --net=host -v <volume>:/root/downloads -itd --name seedbox seedbox  /bin/bash"
echo "Initialize required directories: docker exec seedbox /root/initFolders.sh"
echo "Attach to the container : docker attach seedbox, you have a bash"
echo "Put your oauth_data file into ~/.cache/acd_cli/oauth_data"
echo "Mount your Amazon Cloud Drive with ~/remount.sh, it is mounted as ~/acd"
echo "When it's done, create ~/acd/temp, ~/acd/Shows, ~/acd/Movies : mkdir -p ~/acd/temp ~/acd/Shows ~/acd/Movies"
echo "Start CouchPotato, SickRage and qBittorrent with ~/startDownloadSuite.sh"
echo "CouchPotato port=5050, SickRage port=8081, qBittorrent port=8080"
