FROM ubuntu:18.04

LABEL maintainer="gentlehoneylover"

# environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV PYTHON_EGG_CACHE="/config/plugins/.python-eggs"

# install software
RUN \
	echo "**** install packages ****" && \
	apt-get update && \
	apt-get install -y \
	supervisor \
	deluged deluge-console deluge-web \
	python3-future python3-requests \
	p7zip-full unrar unzip && \
	echo "**** cleanup ****" && \
	rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
	echo "**** create required folders ****" && \
	mkdir -p /var/log/supervisor

# add local files
COPY services.conf /etc/supervisor/conf.d/services.conf

# ports and volumes
EXPOSE 8112 58846 58946 58946/udp
VOLUME /config /downloads

CMD ["/usr/bin/supervisord"]