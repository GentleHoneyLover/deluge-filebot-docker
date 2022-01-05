#!/bin/sh

# Setup a log file
LOG="/config/init.log"

echo "---" >> $LOG
echo "$(date +%d.%m.%Y\ %H:%M:%S) - Starting the container..." | tee -a $LOG

# Use IDs passed to container or otherwise use default IDs of 988
echo "Grabbing PUID=${PUID} and PGID=${PGID}..." | tee -a $LOG
PUID=${PUID:-988}
PGID=${PGID:-988}

# Use umask passed to container or otherwise use default mask of 022
echo "Grabbing UMASK=${UMASK}..." | tee -a $LOG
UMASK=${UMASK:-022}

# Change IDs of xyz user and group
echo "Setting PUID=${PUID} and PGID=${PGID} to xyz user and group" | tee -a $LOG
groupmod -o -g "$PGID" xyz | tee -a $LOG
usermod -o -u "$PUID" xyz | tee -a $LOG

# Setting folder ownership
echo "Setting container volumes ownership to user xyz" | tee -a $LOG
chown xyz:xyz /config
chown xyz:xyz /downloads
chown xyz:xyz /watchfolder
chown xyz:xyz /data

echo "All done! Starting the services via supervisord..." | tee -a $LOG
/usr/bin/supervisord | tee -a $LOG

exit 0