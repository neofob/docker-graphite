# NGINX as web interface for browsing graphite metrics

FROM phusion/baseimage:0.10.2 as builder
LABEL maintainer "tuan t. pham <tuan at vt dot edu>"

ENV DEBIAN_FRONTEND=noninteractive \
PKGS="libffi-dev gcc wget python-setuptools python-dev" \
PYTHONPATH="/var/lib/graphite/webapp" \
WHISPER_VERSION="1.1.4" \
GRAPHITE_WEB_VERSION="1.1.4" \
GRAPHITE_ROOT="/var/lib/graphite" \
SSL_PKG="http://ftp.osuosl.org/pub/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb"

RUN  apt-get -yq update && apt-get -yq dist-upgrade && \
  apt-get -yq install --no-install-recommends ${PKGS} && \
  wget -q -O /tmp/libssl1.1_amd64.deb ${SSL_PKG} && \
  dpkg --install /tmp/libssl1.1_amd64.deb && \
  easy_install pip && \
  pip install --install-option="--prefix=${GRAPHITE_ROOT}" \
  --install-option="--install-lib=${GRAPHITE_ROOT}/webapp" \
  graphite-web==${GRAPHITE_WEB_VERSION} && \
  apt-get autoremove -yq && \
  apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/*


FROM nginx:latest

COPY --from=builder /var/lib/graphite/webapp/content /var/lib/graphite/webapp/content
