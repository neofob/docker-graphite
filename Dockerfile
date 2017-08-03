# Original https://github.com/nickstenning/docker-graphite
# Update to phusion/baseimage and refactor to use go-carbon and carbon-c-relay
# Reference: https://fosdem.org/2017/schedule/event/graphite_at_scale/
# TODO:
# 1. Replace graphite-web with carbonapi and what not
# 2. Decompose these components into separated containers
#	* carbon-c-relay (See PR #291 @ grobian/carbon-c-relay)
#	* nginx
#	* carbonapi/carbonzipper
#	* go-carbon
#	* whisper_data

FROM	phusion/baseimage:0.9.22
LABEL	maintainer "tuan t. pham <tuan@vt.edu>"

ENV PKGS="python-ldap python-cairo python-django python-twisted \
python-django-tagging python-simplejson python-memcache python-pysqlite2 \
python-tz python-pip gunicorn supervisor nginx-light libffi-dev wget" \
GO_CARBON="https://github.com/lomik/go-carbon/releases/download/v0.10.1/go-carbon_0.10.1_amd64.deb" \
CARBON_C_RELAY="https://launchpad.net/ubuntu/+archive/primary/+files/carbon-c-relay_2.5-1_amd64.deb" \
WHISPER_VERSION="1.0.2" \
GRAPHITE_WEB_VERSION="1.0.2" \
GRAPHITE_ROOT="/var/lib/graphite"

RUN	apt-get -yq update && \
	apt-get -yq install ${PKGS} && \
	pip install -U pip && \
	pip install whisper==${WHISPER_VERSION} && \
	pip install --install-option="--prefix=${GRAPHITE_ROOT}" \
	--install-option="--install-lib=${GRAPHITE_ROOT}/webapp" \
	graphite-web==${GRAPHITE_WEB_VERSION} && \
	wget -q -O /tmp/go-carbon_amd64.deb ${GO_CARBON} && \
	wget -q -O /tmp/carbon-c-relay_amd64.deb ${CARBON_C_RELAY} && \
	dpkg --install /tmp/go-carbon_amd64.deb /tmp/carbon-c-relay_amd64.deb && \
	apt-get autoremove -yq && \
	apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/*

COPY	./local_settings.py ./graphite_wsgi.py /var/lib/graphite/webapp/graphite/
COPY	./entrypoint.sh /entrypoint.sh

# Nginx
EXPOSE	80 2003 2003/udp 2004 7002

CMD	["/entrypoint.sh"]

# vim:ts=8:noet:
