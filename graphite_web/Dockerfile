# graphite-web daemon
FROM  phusion/baseimage:0.10.1
LABEL maintainer "tuan t. pham <tuan at vt dot edu>"

ENV DEBIAN_FRONTEND=noninteractive \
PKGS="python-ldap python-cairo python-django python-twisted \
python-django-tagging python-simplejson python-memcache python-pysqlite2 \
python-tz gunicorn libffi-dev gcc wget python-dev" \
PYTHONPATH="/var/lib/graphite/webapp" \
WHISPER_VERSION="1.1.3" \
GRAPHITE_WEB_VERSION="1.1.3" \
GRAPHITE_ROOT="/var/lib/graphite" \
SSL_PKG="http://ftp.osuosl.org/pub/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4.1_amd64.deb"

RUN  apt-get -yq update && apt-get -yq dist-upgrade && \
  apt-get -yq install --no-install-recommends ${PKGS} && \
  wget -q -O /tmp/libssl1.1_amd64.deb ${SSL_PKG} && \
  dpkg --install /tmp/libssl1.1_amd64.deb && \
  easy_install pip && \
  pip install -U pip && \
  pip install whisper==${WHISPER_VERSION} && \
  pip install --install-option="--prefix=${GRAPHITE_ROOT}" \
  --install-option="--install-lib=${GRAPHITE_ROOT}/webapp" \
  graphite-web==${GRAPHITE_WEB_VERSION} && \
  apt-get autoremove -yq && \
  apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/*


COPY  ./local_settings.py ./graphite_wsgi.py /var/lib/graphite/webapp/graphite/
COPY  ./entrypoint.sh /
WORKDIR /var/lib/graphite/webapp

EXPOSE 8000
# Added parameters in docker-compose command:
# -b0.0.0.0:8000 -w2 graphite.graphite_wsgi:application
ENTRYPOINT ["/sbin/my_init", "--", "/entrypoint.sh"]

# vim:ts=2:noet:expandtab
