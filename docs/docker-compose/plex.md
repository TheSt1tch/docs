Plex можно устанавливать разными способами, через **пакет**, через **docker-cli** и **docker compose**. Я предпочитаю **Docker Compose**.

Ниже будет приведен файл Docker Compose. 

[Получение Plex Claim](https://www.plex.tv/claim/)

```yaml
version: "3.7"
services:
  plex:
    container_name: plex
    image: plexinc/pms-docker:latest
    restart: always
      #devices:
        #- /dev/dri:/dev/dri # для hardware траснкодинга - если есть видеокарта, вписать сюда
    ports:
      - "32400:32400"
      - "32400:32400/udp"
      - "32469:32469"
      - "32469:32469/udp"
      - "5353:5353/udp"
      - "1900:1900/udp"
    security_opt:
      - no-new-privileges:true
    volumes:
      - /opt/appdata/plex:/config
      - /mnt:/mnt:ro # перечислить папки с медиа файлами
    environment:
      - PUID=1000
      - PGID=1000
      - VERSION=docker
      - PLEX_CLAIM= # ваш плекс клайм
```

Удаление мусора из PhotoTranscoder
```bash
find "/home/plex/plexconfig/Library/Application Support/Plex Media Server/Cache/PhotoTranscoder" -name "*.jpg" -type f -mtime +5 -delete
```