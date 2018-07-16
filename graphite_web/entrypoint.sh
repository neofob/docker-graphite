#!/usr/bin/env bash

GRAPHITE_STORAGE=${GRAPHITE_STORAGE:=/var/lib/graphite/storage}
function init_database()
{
	if [ ! -f $GRAPHITE_STORAGE/graphite.db ]; then
		echo "Initializing graphite.db"
		PYTHONPATH=/var/lib/graphite/webapp django-admin migrate \
			--settings=graphite.settings --noinput
		chown www-data:www-data $GRAPHITE_STORAGE/log/webapp/*
		chown www-data:www-data $GRAPHITE_STORAGE/graphite.db
	fi
}

init_database
gunicorn "$@"
