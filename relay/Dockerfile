# Original https://github.com/nickstenning/docker-graphite
# Update to phusion/baseimage and refactor to use go-carbon and carbon-c-relay
# Reference:
# https://fosdem.org/2017/schedule/event/graphite_at_scale/
# https://github.com/bodsch/docker-carbon-c-relay


FROM phusion/baseimage:0.10.2 as builder

ARG VERSION

ENV DEBIAN_FRONTEND=noninteractive \
PKGS="automake g++ git make musl-dev zlib1g-dev liblz4-dev libssl-dev ca-certificates"

RUN apt-get -yq update && apt-get -yq dist-upgrade && \
    apt-get -yq install --no-install-recommends ${PKGS} && \
    cd /tmp && git clone https://github.com/grobian/carbon-c-relay.git && \
    cd carbon-c-relay && \
    git checkout tags/v${VERSION} 2> /dev/null

RUN cd /tmp/carbon-c-relay && \
    ./configure && \
    make && make install

CMD ["/bin/sh"]   
 

# -------------------------------------------------------
FROM  phusion/baseimage:0.10.2
LABEL  maintainer "tuan t. pham <tuan@vt.edu>"

ENV DEBIAN_FRONTEND=noninteractive \
PKGS="zlib1g liblz4-1 libssl1.0.0"

RUN  apt-get -yq update && apt-get -yq dist-upgrade && \
     apt-get -yq install --no-install-recommends ${PKGS} && \
     apt-get autoremove -yq && \
     apt-get autoclean && rm -rf /var/lib/apt/lists/* /tmp/* && \
     mkdir /etc/carbon-c-relay


COPY --from=builder /usr/local/bin/relay /usr/bin

COPY ./carbon-c-relay.conf /etc/carbon-c-relay

EXPOSE  2003 2003/udp

ENTRYPOINT ["/sbin/my_init", "--", "/usr/bin/relay"]
# vim:ts=2:noet:expandtab
