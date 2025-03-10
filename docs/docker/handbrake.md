```yaml title="docker-compose.yml"

version: "3.7"
services:

## Handbrake - Video Converter
  handbrake:
    container_name: handbrake
    image: jlesage/handbrake:latest
    restart: always
    networks:
      - traefik_proxy
#    ports:
#      - "5800:5800"
    security_opt:
      - no-new-privileges:true
    volumes:
      - $USERDIR/docker/handbrake/config:/config:rw
      - $USERDIR/docker/handbrake/watch:/watch:rw # Watch folder
      - $USERDIR/docker/handbrake/output:/output:rw # Output folder
      - /mnt/storage:/storage:ro # Data folder - can be anything
      - $USERDIR/dwnloads:/downloads:ro # Data folder - can be anything
    environment:
      - USER_ID=$PUID
      - GROUP_ID=$PGID
      - TZ=$TZ
      - UMASK=002
      - DISPLAY_WIDTH=1600
      - DISPLAY_HEIGHT=768
#      - AUTOMATED_CONVERSION_PRESET=H.265 MKV 480p30
      - AUTOMATED_CONVERSION_PRESET=H.265 MKV 1080p30
      - AUTOMATED_CONVERSION_FORMAT=mkv
    labels:
      - "traefik.enable=true"
      ## HTTP Routers
      - "traefik.http.routers.handbrake-rtr.entrypoints=https"
      - "traefik.http.routers.handbrake-rtr.rule=Host(`handbrake.$DOMAINNAME`)"
      ## Middlewares
      - "traefik.http.routers.handbrake-rtr.middlewares=secure-chain@file"
      ## HTTP Services
      - "traefik.http.routers.handbrake-rtr.service=handbrake-svc"
      - "traefik.http.services.handbrake-svc.loadbalancer.server.port=5800"

networks:
  traefik_proxy:
    external: true
```