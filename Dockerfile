# Original https://github.com/nickstenning/docker-graphite
# Update to phusion/baseimage and refactor to use go-carbon and carbon-c-relay
# Reference: https://fosdem.org/2017/schedule/event/graphite_at_scale/

FROM	phusion/baseimage:0.9.22
LABEL	maintainer "tuan t. pham <tuan@vt.edu>"


ENV PKGS "python-ldap python-cairo python-django python-twisted \
python-django-tagging python-simplejson python-memcache python-pysqlite2 \
python-tz python-pip gunicorn supervisor nginx-light expect carbon-c-relay wget"
ENV GO_CARBON https://github.com/lomik/go-carbon/releases/download/v0.9.1/go-carbon_0.9.1_amd64.deb
ENV WHISPER_VERSION 0.9.15

RUN	apt-get -yq update && \
	apt-get -yq install ${PKGS} && \
	apt-get -yq install carbon-c-relay && \
	pip install -U pip && \
	pip install whisper==${WHISPER_VERSION} && \
	pip install --install-option="--prefix=/var/lib/graphite" \
	--install-option="--install-lib=/var/lib/graphite/webapp" \
	graphite-web==0.9.15 && \
	wget -q -O /tmp/go-carbon_amd64.deb ${GO_CARBON} && \
	dpkg --install /tmp/go-carbon_amd64.deb

ADD	./local_settings.py /var/lib/graphite/webapp/graphite/local_settings.py
ADD	./django_admin_init.exp /usr/local/bin/django_admin_init.exp
RUN	chmod 755 /usr/local/bin/django_admin_init.exp
RUN	mkdir -p /var/lib/graphite/storage/whisper
RUN	touch /var/lib/graphite/storage/graphite.db /var/lib/graphite/storage/index
RUN	chown -R www-data /var/lib/graphite/storage
RUN	chmod 0775 /var/lib/graphite/storage /var/lib/graphite/storage/whisper
RUN	chmod 0664 /var/lib/graphite/storage/graphite.db
RUN	/usr/local/bin/django_admin_init.exp
RUN	cp /var/lib/graphite/conf/graphite.wsgi.example /var/lib/graphite/webapp/graphite/graphite_wsgi.py
RUN     apt-get autoremove -yq && rm -rf /var/lib/apt/lists/* /tmp/*
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
