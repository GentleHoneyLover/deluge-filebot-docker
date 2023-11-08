#!/bin/sh

echo "$(date +%d.%m.%Y\ %H:%M:%S) - Starting the container..."

# Calling out user-defined environment variables
echo "Grabbing PUID=${PUID} and PGID=${PGID}..."
echo "Grabbing UMASK=${UMASK}..."
echo "Grabbing DELUGE_LOGLEVEL=${DELUGE_LOGLEVEL}..."
echo "Grabbing TZ=${TZ}..."

# Create xyz user and group
echo "Setting PUID=${PUID} and PGID=${PGID} to xyz user and group"
adduser --system --disabled-password --no-create-home --uid "$PUID" xyz
addgroup --system --gid "$PGID" xyz
adduser xyz xyz

# Handling default configs
echo "Handling default config for Deluge"
if [[ ! -f $DELUGE_CONFIG/core.conf ]]; then
    cp /defaults/core.conf $DELUGE_CONFIG/core.conf
fi
echo "Installing the filebot plugin if it's missing"
if [[ ! -f $DELUGE_CONFIG/plugins/FileBotTool-$FILEBOT_PLUGIN_VERSION.egg ]]; then
    readonly PYTHON_VER=$(python3 -V | cut -f2 -d " " | cut -c 1-4)
		cp "/defaults/plugins/FileBotTool-$FILEBOT_PLUGIN_VERSION.egg" "$DELUGE_CONFIG/plugins/FileBotTool-2.0.3-py${PYTHON_VER}.egg"
fi

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