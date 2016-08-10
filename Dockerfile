FROM ubuntu:latest
ADD install.sh /install.sh
VOLUME /root/downloads
RUN /bin/bash /install.sh
EXPOSE 5050 8080 8081
CMD /bin/bash
