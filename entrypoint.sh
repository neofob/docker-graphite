#!/usr/bin/env bash
# __author__: tuan t. pham

CONFIG_FILE=${CONFIG_FILE:=/conf/configuration.lst}

# Create a symlink SRC_DIR DST_DIR
# Example /conf/etc/carbon-c-relay/carbon-c-relay.conf /etc/carbon-c-relay
function create_symlink()
{
	SRC=$(echo $1 | awk '{print $1}')
	DEST=$(echo $1 | awk '{print $2}')
	echo "Creating a symlink from DEST=$DEST/. to SRC=$SRC"
	[ -d $DEST ] || mkdir -p $DEST
	eval ln -sf $SRC $DEST/.
}

# Process the config file
function process_config()
{
	if [ -d /conf ]; then
		if [ -f ${CONFIG_FILE} ]; then
			local IFS=$'\n'
			for d in `grep "^[^#].*" ${CONFIG_FILE}`; do
				create_symlink $d
			done
		else
			echo "Configuration file ${CONFIG_FILE} does not exist"
			exit 1
		fi
	else
		echo "Directory /conf does not exist"
		exit 1
	fi
}

# whisper could be data volume from host so we need to set the permission
function set_permission()
{
	mkdir -p /var/lib/graphite/storage/log/webapp
	chown www-data:www-data /var/lib/graphite/storage
	chown www-data:www-data /var/lib/graphite/storage/{whisper,log}
	chown www-data:www-data /var/lib/graphite/storage/log/webapp
	chown www-data:www-data /var/log/supervisor
	chown www-data:www-data /var/log/go-carbon
	chmod 755 /var/lib/graphite/storage/{whisper,log}

	# Set the maximum of open file descriptor
	ulimit -S -n 8192
}

process_config
set_permission

/usr/bin/supervisord
