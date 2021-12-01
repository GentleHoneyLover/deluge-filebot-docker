FROM ubuntu:18.04

LABEL maintainer="gentlehoneylover"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV PYTHON_EGG_CACHE="/config/deluge/plugins/.python-eggs"
ENV FILEBOT_VERSION 4.9.2
ENV HOME /config/filebot
ENV LANG C.UTF-8
ENV FILEBOT_OPTS "-Dapplication.deployment=docker -Duser.home=$HOME"

# install software
RUN \
	echo "**** install packages ****" && \
	apt-get update && \
	apt-get install -y \
	supervisor \
	deluged deluge-console deluge-web	\
	python3-future python3-requests p7zip-full unrar unzip \
	default-jre-headless libjna-java mediainfo libchromaprint-tools p7zip-rar mkvtoolnix mp4v2-utils gnupg curl file inotify-tools && \
	echo "**** add repositories ****" && \
	apt-key adv --fetch-keys https://raw.githubusercontent.com/filebot/plugins/master/gpg/maintainer.pub && \
	echo "deb [arch=all] https://get.filebot.net/deb/ universal main" > /etc/apt/sources.list.d/filebot.list && \
	apt-get update && \
	apt-get install -y --no-install-recommends \ 
	filebot && \
	echo "**** cleanup ****" && \
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
	echo "**** create required folders ****" && \
	mkdir -p /var/log/supervisor

# add local files
COPY services.conf /etc/supervisor/conf.d/services.conf

# ports and volumes
EXPOSE 8112 58846 58946 58946/udp
VOLUME /config /downloads

ENTRYPOINT ["/usr/bin/supervisord"]