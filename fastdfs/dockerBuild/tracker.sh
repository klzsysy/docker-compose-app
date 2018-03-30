#!/bin/sh
set -e
mkdir -p ${BASE_PATH}/tracker
[ -n "$TRACKER_PORT" ] && sed -i "s/^port.*/port=$TRACKER_PORT/g" /etc/fdfs/tracker.conf

/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf restart
tail -f /var/local/fdfs/tracker/logs/trackerd.log
