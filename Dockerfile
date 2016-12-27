FROM	phusion/baseimage:0.9.19

ENV PKGS "python-ldap python-cairo python-django python-twisted \
python-django-tagging python-simplejson python-memcache python-pysqlite2 \
python-tz python-pip gunicorn supervisor nginx-light expect"
ENV WHISPER_VERSION 0.9.15

RUN	apt-get -yq update
RUN	apt-get -yq install ${PKGS}
RUN	pip install whisper==${WHISPER_VERSION}
RUN	pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib" carbon==0.9.15
RUN	pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/webapp" graphite-web==0.9.15

# Add system service config
ADD	./nginx.conf /etc/nginx/nginx.conf
ADD	./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add graphite config
#ADD	./initial_data.json /var/lib/graphite/webapp/graphite/initial_data.json
ADD	./local_settings.py /var/lib/graphite/webapp/graphite/local_settings.py
ADD	./carbon.conf /var/lib/graphite/conf/carbon.conf
ADD	./storage-schemas.conf /var/lib/graphite/conf/storage-schemas.conf
ADD	./django_admin_init.exp /usr/local/bin/django_admin_init.exp
RUN	mkdir -p /var/lib/graphite/storage/whisper
RUN	touch /var/lib/graphite/storage/graphite.db /var/lib/graphite/storage/index
RUN	chown -R www-data /var/lib/graphite/storage
RUN	chmod 0775 /var/lib/graphite/storage /var/lib/graphite/storage/whisper
RUN	chmod 0664 /var/lib/graphite/storage/graphite.db
RUN	/usr/local/bin/django_admin_init.exp
RUN cp /var/lib/graphite/conf/graphite.wsgi.example /var/lib/graphite/webapp/graphite/graphite_wsgi.py
#RUN	cd /var/lib/graphite/webapp/graphite && python manage.py syncdb --noinput
RUN     apt-get autoremove -yq && rm -rf /var/lib/apt/lists/*
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
