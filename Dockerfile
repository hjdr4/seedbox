FROM ubuntu:latest
ADD install.sh /install.sh
RUN /install.sh
ADD sickrage_config.ini /sickrage_config.ini
ADD couchpotato_settings.conf /couchpotato_settings.conf
ADD qBittorrent.conf /qBittorrent.conf
ADD remount.sh /remount.sh
ADD move.sh /move.sh
ADD initVolume.sh /initVolume.sh
add startDownloadSuite.sh /startDownloadSuite.sh
VOLUME /root/
EXPOSE 5050 8080 8081
CMD /bin/bash
