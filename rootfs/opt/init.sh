#!/bin/sh

echo "$(date +%d.%m.%Y\ %H:%M:%S) - Starting the container..."

# Calling out user-defined environment variables
echo "Grabbing PUID=${PUID} and PGID=${PGID}..."
echo "Grabbing UMASK=${UMASK}..."
echo "Grabbing DELUGE_LOGLEVEL=${DELUGE_LOGLEVEL}..."
echo "Grabbing TZ=${TZ}..."

readonly PYTHON_VER=$(python3 -V | cut -f2 -d " " | cut -f1,2 -d ".")
echo "Grabbing PYTHON_VER=${PYTHON_VER}..."
readonly PLUGIN_VER=$(ls /defaults/plugins | cut -f2 -d "-")
echo "Grabbing PLUGIN_VER=${PLUGIN_VER}..."

# Create xyz user and group
echo "Setting PUID=${PUID} and PGID=${PGID} to xyz user and group"
adduser --system --disabled-password --no-create-home --uid "$PUID" xyz
addgroup --system --gid "$PGID" xyz
adduser xyz xyz

#Handling default configs
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

echo "Checking for legacy FileBot licence files..."
if [[ -f $CONFIG/filebot/.filebot/license.txt ]]; then
	echo "Legacy FileBot license found..."
	if [[ -f $CONFIG/filebot/.license ]]; then
		echo "New license file is also present... Nothing to be done..."
	else
		echo "Copying legacy license file to a new location..."
		cp $CONFIG/filebot/.filebot/license.txt $CONFIG/filebot/.license
	fi
fi

# Setting folder ownership
echo "Setting container volumes ownership to user xyz"
chown -R xyz:xyz /config
chown -R xyz:xyz /downloads
chown -R xyz:xyz /watchfolder
chown -R xyz:xyz /data
chown -R xyz:xyz /opt/filebot

# Setting folder ownership
echo "Setting container volumes ownership to user xyz"
chown -R xyz:xyz /config
chown -R xyz:xyz /downloads
chown -R xyz:xyz /watchfolder
chown -R xyz:xyz /data
chown -R xyz:xyz /opt/filebot

echo "All done! Starting the services via supervisord..."
/usr/bin/supervisord

exit 1
