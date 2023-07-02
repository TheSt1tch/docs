# WikiJS

```yaml
version: "3.7"

networks:
  traefik_net:
    external: true

services:
  wikijs:
    image: lscr.io/linuxserver/wikijs
    container_name: wikijs
    environment:
      PUID: $PUID
      PGID: $PGID
      TZ: $TZ
    networks:
      - traefik_net
    volumes:
      - $DOCKER_APP/wiki/config:/config
      - $DOCKER_APP/wiki/data:/data
    ports:
      - 4000:3000
    restart: unless-stopped
```