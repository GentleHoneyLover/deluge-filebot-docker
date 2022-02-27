FROM ubuntu:18.04

LABEL maintainer="gentlehoneylover"

ENV DELUGE_VERSION="1.3.15"
ENV FILEBOT_VERSION="4.9.5"
ENV LANG="C.UTF-8"
ARG DEBIAN_FRONTEND="noninteractive"

RUN \
	echo "**** install pre-requisites ****" && \
	apt-get update && \
	apt-get install -y \
		gnupg wget curl supervisor \
		python3-future python3-requests unzip unrar p7zip-full p7zip-rar \
		default-jre-headless libjna-java mediainfo libchromaprint-tools mkvtoolnix mp4v2-utils file inotify-tools && \
	echo "**** add repositories ****" && \
	apt-key adv --fetch-keys https://raw.githubusercontent.com/filebot/plugins/master/gpg/maintainer.pub && \
	echo "deb [arch=all] https://get.filebot.net/deb/ universal main" > /etc/apt/sources.list.d/filebot.list && \
	echo "**** install main packages ****" && \
	apt-get update && \
	apt-get install -y --no-install-recommends \ 
		deluged deluge-console deluge-web	\
		filebot && \
	echo "**** cleanup ****" && \
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
	echo "**** create required folders ****" && \
	mkdir -p /var/log/supervisor && \
	echo "**** create xyz user ****" && \
 	useradd --system --user-group xyz

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

COPY init.sh /opt/init.sh
COPY services.conf /etc/supervisor/conf.d/services.conf
RUN chmod +x /opt/init.sh

EXPOSE 8112 58846 58946 58946/udp
VOLUME /config /downloads /watchfolder /data

ENTRYPOINT ["/opt/init.sh"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=20s --retries=3 CMD wget --no-verbose --tries=1 --spider localhost:8112 || exit 1