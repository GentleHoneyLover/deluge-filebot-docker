#!/bin/bash

echo "$(date +%d.%m.%Y\ %H:%M:%S) - Starting the container..."

# Calling out user-defined environment variables
echo "Grabbing PUID=${PUID} and PGID=${PGID}..."
echo "Grabbing UMASK=${UMASK}..."
echo "Grabbing DELUGE_LOGLEVEL=${DELUGE_LOGLEVEL}..."
echo "Grabbing TZ=${TZ}..."

#readonly PYTHON_VER=$(python3 -V | cut -f2 -d " " | cut -f1,2 -d ".")
echo "Grabbing PYTHON_VER=${PYTHON_VER}..."
readonly PLUGIN_VER=$(ls /defaults/plugins | cut -f2 -d "-")
echo "Grabbing PLUGIN_VER=${PLUGIN_VER}..."

# Change IDs of xyz user and group
echo "Setting PUID=${PUID} and PGID=${PGID} to xyz user and group"
groupmod -o -g "$PGID" xyz
usermod -o -u "$PUID" xyz

# Handling default configs
echo "Handling default config for Deluge..."
if [[ ! -f $DELUGE_CONFIG/core.conf ]]; then
	cp /defaults/*.conf $DELUGE_CONFIG/
fi

echo "Installing the FileBot plugin if it's missing..."
if [[ ! -f $DELUGE_CONFIG/plugins/FileBotTool-*$PYTHON_VER.egg ]]; then
	echo "FileBot plugin is missing... Installing..."
	if [[ ! -f $DELUGE_CONFIG/plugins/FileBotTool-*.egg ]]; then
		echo "Creating plugins folder..."
		mkdir -p $DELUGE_CONFIG/plugins
	else
		echo "Removing old plugins..."
		rm $DELUGE_CONFIG/plugins/FileBotTool-*.egg
	fi
	cp /defaults/plugins/FileBotTool-*.egg $DELUGE_CONFIG/plugins/FileBotTool-$PLUGIN_VER-py$PYTHON_VER.egg
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