#!/bin/sh

echo "$(date +%d.%m.%Y\ %H:%M:%S) - Starting the container..."

# Calling out user-defined environment variables
echo "Grabbing PUID=${PUID} and PGID=${PGID}..."
echo "Grabbing UMASK=${UMASK}..."
echo "Grabbing DELUGE_LOGLEVEL=${DELUGE_LOGLEVEL}..."
echo "Grabbing TZ=${TZ}..."

# Change IDs of xyz user and group
echo "Setting PUID=${PUID} and PGID=${PGID} to xyz user and group"
groupmod -o -g "$PGID" xyz
usermod -o -u "$PUID" xyz

# Setting folder ownership
echo "Setting container volumes ownership to user xyz"
chown xyz:xyz /config
chown xyz:xyz /downloads
chown xyz:xyz /watchfolder
chown xyz:xyz /data

echo "All done! Starting the services via supervisord..."
/usr/bin/supervisord

exit 1