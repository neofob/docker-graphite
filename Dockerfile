# Original https://github.com/nickstenning/docker-graphite
# Update to phusion/baseimage and refactor to use go-carbon and carbon-c-relay
# Reference: https://fosdem.org/2017/schedule/event/graphite_at_scale/
# TODO:
# 0. Fix django-admin syncdb sqlite3 database with new graphite-web, maybe?
# 1. Replace graphite-web with carbonapi and what not
# 2. Decompose these components into separated containers
#	* carbon-c-relay
#	* nginx
#	* carbonapi/carbonzipper
#	* go-carbon
#	* whisper_data

FROM	phusion/baseimage:0.9.22
LABEL	maintainer "tuan t. pham <tuan@vt.edu>"

ENV PKGS="python-ldap python-cairo python-django python-twisted \
python-django-tagging python-simplejson python-memcache python-pysqlite2 \
python-tz python-pip gunicorn supervisor nginx-light expect carbon-c-relay \
libffi-dev wget" \
GO_CARBON="https://github.com/lomik/go-carbon/releases/download/v0.9.1/go-carbon_0.9.1_amd64.deb" \
WHISPER_VERSION="1.0.2" \
GRAPHITE_WEB_VERSION="1.0.2" \
GRAPHITE_ROOT="/var/lib/graphite"

RUN	apt-get -yq update && \
	apt-get -yq install ${PKGS} && \
	apt-get -yq install carbon-c-relay && \
	pip install -U pip && \
	pip install whisper==${WHISPER_VERSION} && \
	pip install --install-option="--prefix=${GRAPHITE_ROOT}" \
	--install-option="--install-lib=${GRAPHITE_ROOT}/webapp" \
	graphite-web==${GRAPHITE_WEB_VERSION} && \
	wget -q -O /tmp/go-carbon_amd64.deb ${GO_CARBON} && \
	dpkg --install /tmp/go-carbon_amd64.deb

RUN	mkdir -p ${GRAPHITE_ROOT}/storage/whisper && \
	touch ${GRAPHITE_ROOT}/storage/graphite.db ${GRAPHITE_ROOT}/storage/index && \
	chown -R www-data ${GRAPHITE_ROOT}/storage && \
	chmod 0775 ${GRAPHITE_ROOT}/storage ${GRAPHITE_ROOT}/storage/whisper && \
	chmod 0664 ${GRAPHITE_ROOT}/storage/graphite.db

COPY	./local_settings.py /var/lib/graphite/webapp/graphite/local_settings.py
COPY	./graphite_wsgi.py /var/lib/graphite/webapp/graphite/graphite_wsgi.py
RUN	PYTHONPATH=/var/lib/graphite/webapp django-admin migrate \
	--settings=graphite.settings --noinput && \
	cd ${GRAPHITE_ROOT}/webapp && pyclean . && apt-get autoremove -yq && \
	apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/*

COPY	./entrypoint.sh /entrypoint.sh

# Nginx
EXPOSE	80
# Carbon line receiver port
EXPOSE	2003
# Carbon UDP receiver port
EXPOSE	2003/udp
# Carbon pickle receiver port
EXPOSE	2004
# Carbon cache query port
EXPOSE	7002

CMD	["/entrypoint.sh"]

# vim:ts=8:noet:
