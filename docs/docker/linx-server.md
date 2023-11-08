# Linx - свой хостинг для картинок, гифок, видяшек и документов. 

[![](https://img.shields.io/docker/pulls/andreimarcu/linx-server?color=brightgreen)](https://hub.docker.com/r/andreimarcu/linx-server)
[![](https://img.shields.io/github/stars/andreimarcu/linx-server.svg?label=Stars&style=social)](https://github.com/andreimarcu/linx-server)
[![](https://img.shields.io/badge/Demo-purple)](https://put.icu/)

Таких сервисов много, это лиш один из них. Позводяет захостить у себя сервис по хранению и выдаче различных медия. Аля imgur.

## Запуск

1.  Создать папки `files` и `meta` и запустить `chown -R 65534:65534 meta && chown -R 65534:65534 files`
2.  Создайте файл конфигурации (пример предоставлен в репозитории), мы будем называть его **linx-server.conf** в следующих примерах.

=== "Docker"

    ```bash
    docker run andreimarcu/linx-server \
      -p 8080:8080 \
      -v /path/to/linx-server.conf:/data/linx-server.conf \
      -v /path/to/meta:/data/meta \
      -v /path/to/files:/data/files \
      -config /data/linx-server.conf
    ```

=== "Docker Compose"

    ```yaml title="docker-compose.yaml"
    version: "3.9"

    service:
    # linx - self-hosting picture and data
      linx:
        container_name: linx-server
        image: andreimarcu/linx-server
        command: -config /data/linx-server.conf
        volumes:
          - ./linx/files:/data/files
          - ./linx/meta:/data/meta
          - ./linx/linx-server.conf:/data/linx-server.conf
        environment:
          PUID: 1000
          PGID: 1000
        ports:
          - "8080:8080"
        restart: unless-stopped
    ```

## Возможности

-   Отображение базовых типов файлов (картинки, видео, аудио, markdown, pdf)
-   Отображение подсветки кода во строенном редакторе
-   API для работы. С документацией
-   Скачивание торрентов
-   Установка срока действия файлов и ссылок, удаление ключей, рандомные имена файлов
