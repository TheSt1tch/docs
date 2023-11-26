# Factorio

[![Docker Version](https://img.shields.io/docker/v/factoriotools/factorio?sort=semver)](https://hub.docker.com/r/factoriotools/factorio/) 
[![Docker Pulls](https://img.shields.io/docker/pulls/factoriotools/factorio.svg?maxAge=600)](https://hub.docker.com/r/factoriotools/factorio/) 
[![Docker Stars](https://img.shields.io/docker/stars/factoriotools/factorio.svg?maxAge=600)](https://hub.docker.com/r/factoriotools/factorio/)


```yaml title="docker-compose.yml"
version: "3.7"

networks:
  direct_net:
    external: true

services:
  factorio:
    container_name: factorio
    image: factoriotools/factorio:1.1.96
    ports:
      - "34197:34197/udp"
      #- "27015:27015/tcp"
    volumes:
      - /opt/appdata/games/factorio:/factorio
    networks:
      - direct_net
    security_opt:
      - no-new-privileges:true
    restart: unless-stopped
    environment:
      - PUID=1000
      - PGID=1000
      - TZ="Asia/Yekaterinburg"
      - UPDATE_MODS_ON_START=true
      - SAVE_NAME
```