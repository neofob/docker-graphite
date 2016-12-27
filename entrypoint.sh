#!/bin/bash
# Recreate some missing dirs and set permission
# if the directories are exported from host

mkdir -p /var/lib/graphite/storage/log/webapp
chown www-data:www-data /var/lib/graphite/storage \
	/var/lib/graphite/storage/{whisper,log}	\
	/var/lib/graphite/storage/log/webapp \
	/var/log/supervisor
chmod 755 /var/lib/graphite/storage/{whisper,log}

/usr/bin/supervisord
