#!/bin/bash

echo "$(date +%d.%m.%Y\ %H:%M:%S) - Starting the container..."

# Calling out user-defined environment variables
echo "Grabbing PUID=${PUID} and PGID=${PGID}..."
echo "Grabbing UMASK=${UMASK}..."
echo "Grabbing DELUGE_LOGLEVEL=${DELUGE_LOGLEVEL}..."
echo "Grabbing TZ=${TZ}..."

echo "Grabbing PYTHON_VER=${PYTHON_VER}..."
readonly PLUGIN_NAME=$(ls /defaults/plugins | cut -c 1-20)
echo "Grabbing PLUGIN_NAME=${PLUGIN_NAME}..."

# Change IDs of xyz user and group
echo "Setting PUID=${PUID} and PGID=${PGID} to xyz user and group"
groupmod -o -g "$PGID" xyz
usermod -o -u "$PUID" xyz

# Handling default configs
echo "Handling default config for Deluge..."
if [[ ! -f $DELUGE_CONFIG/core.conf ]]; then
	cp /defaults/core.conf $DELUGE_CONFIG/core.conf
fi
echo "Installing the FileBot plugin if it's missing..."
if [[ ! -f $DELUGE_CONFIG/plugins/FileBotTool-*$PYTHON_VER.egg ]]; then
	echo "FileBot plugin is missing... Installing..."
	rm $DELUGE_CONFIG/plugins/FileBotTool-*.egg
	cp /defaults/plugins/FileBotTool-*.egg $DELUGE_CONFIG/plugins/$PLUGIN_NAME$PYTHON_VER.egg
fi

# Setting folder ownership
echo "Setting container volumes ownership to user xyz"
chown xyz:xyz /config
chown xyz:xyz /downloads
chown xyz:xyz /watchfolder
chown xyz:xyz /data

echo "All done! Starting the services via supervisord..."
/usr/bin/supervisord

exit 1