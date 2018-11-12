# Original https://github.com/nickstenning/docker-graphite
# Update to phusion/baseimage and refactor to use go-carbon and carbon-c-relay
# Reference: https://fosdem.org/2017/schedule/event/graphite_at_scale/
# TODO:
# 1. Replace graphite-web with carbonapi and what not
# 2. Decompose these components into separated containers
#  * carbon-c-relay (See PR #291 @ grobian/carbon-c-relay) # done
#  * nginx # done
#  * graphite-web # done
#  * carbonapi/carbonzipper
#  * go-carbon # this one

FROM  phusion/baseimage:0.10.2
LABEL  maintainer "tuan t. pham <tuan@vt.edu>"

ENV DEBIAN_FRONTEND=noninteractive \
PKGS="supervisor libffi-dev wget gcc python-dev" \
GO_CARBON="https://github.com/lomik/go-carbon/releases/download/v0.13.0/go-carbon_0.13.0_amd64.deb" \
SSL_PKG="http://ftp.osuosl.org/pub/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4.1_amd64.deb"

RUN  apt-get -yq update && apt-get -yq dist-upgrade && \
  apt-get -yq install --no-install-recommends ${PKGS} && \
  wget -q -O /tmp/libssl1.1_amd64.deb ${SSL_PKG} && \
  dpkg --install /tmp/libssl1.1_amd64.deb && \
  wget -q -O /tmp/go-carbon_amd64.deb ${GO_CARBON} && \
  dpkg --install /tmp/go-carbon_amd64.deb && \
  apt-get autoremove -yq && \
  apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/*

COPY  ./entrypoint.sh /entrypoint.sh

EXPOSE  2004 7002 8000

ENTRYPOINT ["/sbin/my_init", "--", "/entrypoint.sh"]
# vim:ts=2:noet:expandtab
