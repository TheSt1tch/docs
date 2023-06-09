[Github](https://github.com/motioneye-project/motioneye)

Docker-compose:

```yaml
  # Login: admin / *no password*
  motioneye:
    image: ccrisan/motioneye:master-amd64
    container_name: motioneye
    restart: always
    networks:
      - traefik_net
    ports:
      - "8081:8081"
      - "8082:8082"
      - "8765:8765"
    security_opt:
      - no-new-privileges:true
    volumes:
      - $DOCKERDIR_APP/motioneye/etc:/etc/motioneye
      - /opt/cloud/motioneye:/var/lib/motioneye
      - /etc/localtime:/etc/localtime:ro
    environment:
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TZ
    labels:
      - "traefik.enable=true"
      ## HTTP Routers
      - "traefik.http.routers.motioneye-rtr.entrypoints=https"
      - "traefik.http.routers.motioneye-rtr.rule=Host(`motioneye.$DOMAINNAME`)"
      ## Middlewares
      - "traefik.http.routers.motioneye-rtr.middlewares=secure-chain@file"
      ## HTTP Services
      - "traefik.http.routers.motioneye-rtr.service=motioneye-svc"
      - "traefik.http.services.motioneye-svc.loadbalancer.server.port=8765"
```

Docker-file:

```docker
FROM debian:buster-slim
LABEL maintainer="Marcus Klein <himself@kleini.org>"

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="extra/Dockerfile" \
    org.label-schema.license="GPLv3" \
    org.label-schema.name="motioneye" \
    org.label-schema.url="https://github.com/ccrisan/motioneye/wiki" \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/ccrisan/motioneye.git"

# By default, run as root.
ARG RUN_UID=0
ARG RUN_GID=0

COPY . /tmp/motioneye

RUN echo "deb http://snapshot.debian.org/archive/debian/$(date +%Y%m%d) buster contrib non-free" >>/etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -t buster --yes --option Dpkg::Options::="--force-confnew" --no-install-recommends install \
      curl \
      ffmpeg \
      libmicrohttpd12 \
      libpq5 \
      lsb-release \
      mosquitto-clients \
      python-jinja2 \
      python-pil \
      python-pip \
      python-pip-whl \
      python-pycurl \
      python-setuptools \
      python-tornado \
      python-tz \
      python-wheel \
      v4l-utils \
      motion \
      default-libmysqlclient-dev && \
    # Change uid/gid of user/group motion to match our desired IDs.  This will
    # make it easier to use execute motion as our desired user later.
    sed -i -e "s/^\(motion:[^:]*\):[0-9]*:[0-9]*:\(.*\)/\1:${RUN_UID}:${RUN_GID}:\2/" /etc/passwd && \
    sed -i -e "s/^\(motion:[^:]*\):[0-9]*:\(.*\)/\1:${RUN_GID}:\2/" /etc/group && \
    pip install /tmp/motioneye && \
    # Cleanup
    rm -rf /tmp/motioneye && \
    apt-get purge --yes python-setuptools python-wheel && \
    apt-get autoremove --yes && \
    apt-get --yes clean && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

ADD extra/motioneye.conf.sample /usr/share/motioneye/extra/

# R/W needed for motioneye to update configurations
VOLUME /etc/motioneye

# Video & images
VOLUME /var/lib/motioneye

CMD test -e /etc/motioneye/motioneye.conf || \
    cp /usr/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf ; \
    # We need to chown at startup time since volumes are mounted as root. This is fugly.
    chown motion:motion /var/run /var/log /etc/motioneye /var/lib/motioneye /usr/share/motioneye/extra ; \
    su -g motion motion -s /bin/bash -c "/usr/local/bin/meyectl startserver -c /etc/motioneye/motioneye.conf"

EXPOSE 8765
```