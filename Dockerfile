FROM alpine:3.17

LABEL maintainer="gentlehoneylover"

ENV BUILD_DATE="7-Nov-2023"
ENV FILEBOT_VERSION 5.1.2
ENV FILEBOT_URL https://get.filebot.net/filebot/FileBot_$FILEBOT_VERSION/FileBot_$FILEBOT_VERSION-portable.tar.xz
ENV FILEBOT_PLUGIN_VERSION 2.0.3-py3.9
ENV FILEBOT_PLUGIN_URL https://github.com/Laharah/deluge-FileBotTool/releases/download/2.0.3/FileBotTool-$FILEBOT_PLUGIN_VERSION.egg

RUN \
  echo "**** Create required folders ****" && \
	mkdir -p /var/log/supervisor /etc/supervisor.d /usr/share/GeoIP/ /opt/filebot /defaults/plugins && \
	echo "**** Install packages ****" && \
  apk add --no-cache \
		supervisor \
    py3-future py3-requests deluge \
		openjdk16-jre-headless mediainfo chromaprint && \
  echo "**** Grab GeoIP database ****" && \
  wget -O \
    /usr/share/GeoIP/GeoIP.dat \
    "https://infura-ipfs.io/ipfs/QmWTWcPRRbADZcLcJeANZmcJZNrcpmuQgKYBi6hGdddtC6" && \
	echo "**** Fetch filebot package ****" && \
	wget -O /tmp/filebot.tar.xz "$FILEBOT_URL" && \
	echo "**** Extract application files ****" && \
	tar --extract --file /tmp/filebot.tar.xz --directory /opt/filebot --verbose && \
	echo "**** Fetch filebot plugin for Deluge ****" && \
	wget -P /defaults/plugins/ "$FILEBOT_PLUGIN_URL" && \
	echo "**** Cleanup ****" && \
	find /opt/filebot/lib -type f -not -name libjnidispatch.so -delete && \
	rm -rf \
    $HOME/.cache \
    /tmp/* && \
	echo "**** Create filebot config and binary symlinks ****" && \
	ln -s /config/filebot /opt/filebot/data && \
	ln -s /opt/filebot/filebot.sh /usr/bin/filebot

ENV LANG="C.UTF-8"
ENV CONFIG="/config"
ENV DELUGE_CONFIG="$CONFIG/deluge"
ENV PYTHON_EGG_CACHE="$DELUGE_CONFIG/plugins/.python-eggs"
ENV DELUGE_LOGLEVEL="warning"
ENV HOME="$CONFIG/filebot"
ENV FILEBOT_OPTS="-Dapplication.deployment=docker -Duser.home=$HOME"
ENV HISTFILE=
ENV UMASK="002"
ENV PUID="1000"
ENV PGID="1000"

COPY root/ /
RUN chmod +x /opt/init.sh

EXPOSE 8112 58846 58946 58946/udp
VOLUME /config /downloads /watchfolder /data

ENTRYPOINT ["/opt/init.sh"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=20s --retries=3 CMD wget --no-verbose --tries=1 --spider localhost:8112 || exit 1