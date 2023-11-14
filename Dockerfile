FROM ubuntu:18.04

LABEL maintainer="gentlehoneylover"

ARG DEBIAN_FRONTEND="noninteractive"
ENV FILEBOT_PLUGIN_VER 1.2.11
ENV PYTHON_VER 2.7
ENV FILEBOT_PLUGIN_URL https://github.com/Laharah/deluge-FileBotTool/releases/download/$FILEBOT_PLUGIN_VER/FileBotTool-$FILEBOT_PLUGIN_VER-py$PYTHON_VER.egg

RUN \
	echo "**** Create required folders ****" && \
	mkdir -p /var/log/supervisor /defaults/plugins && \
	echo "**** Install pre-requisites ****" && \
	apt-get update && \
	apt-get install -y --no-install-recommends \ 
		supervisor gnupg wget \
		python3-future python3-requests \
		default-jre-headless libjna-java mediainfo libchromaprint-tools && \
	echo "**** Add repositories ****" && \
	apt-key adv --fetch-keys https://raw.githubusercontent.com/filebot/plugins/master/gpg/maintainer.pub && \
	echo "deb [arch=all] https://get.filebot.net/deb/ universal main" > /etc/apt/sources.list.d/filebot.list && \
	echo "**** Install main packages ****" && \
	apt-get update && \
	apt-get install -y --no-install-recommends \ 
		deluged deluge-console deluge-web	\
		filebot && \
	echo "**** Fetch filebot plugin for Deluge ****" && \
	wget -P /defaults/plugins/ "$FILEBOT_PLUGIN_URL" && \
	echo "**** Cleanup ****" && \
	apt-get remove -y \
		gnupg wget && \
	apt-get autoremove -y && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	echo "**** Create xyz user ****" && \
	useradd --system --user-group xyz

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

COPY rootfs/ /
RUN chmod +x /opt/init.sh

EXPOSE 8112 58846 57988/tcp 57988/udp
VOLUME /config /downloads /watchfolder /data

ENTRYPOINT ["/opt/init.sh"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=20s --retries=3 CMD wget --no-verbose --tries=1 --spider localhost:8112 || exit 1