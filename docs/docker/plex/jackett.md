# Jackett

[![](https://img.shields.io/github/stars/Jackett/Jackett?label=%E2%AD%90%20Stars&style=flat-square)](https://github.com/Jackett/Jackett)
[![](https://img.shields.io/github/v/release/Jackett/Jackett?label=%F0%9F%9A%80%20Release&style=flat-square)](https://github.com/Jackett/Jackett/releases/latest)
[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/jackett.svg?maxAge=60&style=flat-square)](https://hub.docker.com/r/linuxserver/jackett/)

Jackett - нужен для преобразования запросов от Radarr/Sonarr/Lidarr/Readarr и прочих в  HTTP-запросы, специфичные для сайта трекера, анализирует ответ html или json и затем отправляет результаты обратно запрашивающему программному обеспечению. Это позволяет получать последние загрузки (например, RSS) и выполнять поиск. 

Jackett — это единый репозиторий поддерживаемой логики очистки и перевода индексаторов, который снимает нагрузку с других приложений.

## Установка

Устанавливать будем через Docker Compose

```yaml title="docker-compose.yml"
version: "3.7"

services:
  jackett:
    container_name: jackett
    image: linuxserver/jackett:latest
    restart: always
    ports:
      - "9117:9117"
    security_opt:
      - no-new-privileges:true
    volumes:
      - ./jackett:/config
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Moscow
```