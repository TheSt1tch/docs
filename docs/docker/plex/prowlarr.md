# Prowlarr

[![](https://img.shields.io/github/stars/Prowlarr/Prowlarr?label=%E2%AD%90%20Stars&style=flat-square)](https://github.com/Prowlarr/Prowlarr)
[![](https://img.shields.io/github/v/release/Prowlarr/Prowlarr?label=%F0%9F%9A%80%20Release&style=flat-square)](https://github.com/Prowlarr/Prowlarr/releases/latest)
[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/prowlarr.svg?maxAge=60&style=flat-square)](https://hub.docker.com/r/linuxserver/prowlarr/)

![](../../images/docker/prowlarr-1.png)

Prowlarr — это менеджер индексаторов и прокси, построенный на стеке *arr .NET/ReactJS. Prowlarr поддерживает торрент-трекеры и индексаторы Usenet для интеграции с приложениями PVR, Lidarr, Mylar3, Radarr, Readarr и Sonarr. 

Некоторые из функций, которые делают Prowlarr достойным использования, включают в себя:

- Собственная поддержка Usenet для 24 индексаторов, включая VIP для наушников, а также поддержка любого индексатора, совместимого с Newznab, через «Generic Newznab».
- Поддержка Torrent для более чем 500 трекеров, постоянно добавляемых новых.
- Поддержка торрентов для любого трекера, совместимого с Torznab, через «Generic Torznab».
- Индексатор синхронизируется с [Sonarr](./sonarr.md)/[Radarr](./radarr.md)/Readarr/Lidarr/Mylar3, поэтому ручная настройка других приложений не требуется.
- История и статистика индексатора
- Ручной поиск трекеров и индексаторов на уровне категории.
- Поддержка отправки выпусков непосредственно в ваши клиенты загрузки из Prowlarr.
- Уведомления о работоспособности и статусе индексатора
- Поддержка прокси-сервера индексатора (SOCKS4, SOCKS5, HTTP, Flaresolver)

С Prowlarr у вас будет одно место для управления всеми индексаторами всех ваших приложений Arr. Это отличная замена [Jackett](./jackett.md).

```yaml title="docker-compose.yml"

services:
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=Europe/Moscow
    volumes:
      - ./prowlarr:/config
    ports:
      - 9696:9696
    restart: unless-stopped
```