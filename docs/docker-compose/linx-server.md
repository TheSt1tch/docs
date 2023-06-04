[Self-hosted файл/медиа хостинг.](https://github.com/ZizzyDizzyMC/linx-server/)

## Демо

Как выглядит, можно посмотреть на: [https://put.icu/](https://put.icu/)

### Клиенты

|     |     |     |
| --- | --- | --- |
| Официальный | CLI: **linx-client** | [Source](https://github.com/andreimarcu/linx-client) |
| Не официальный | Android: **LinxShare** | [Source](https://github.com/iksteen/LinxShare/) \| [Google Play](https://play.google.com/store/apps/details?id=org.thegraveyard.linxshare) |
| CLI: **golinx** | [Source](https://github.com/mutantmonkey/golinx) |

## Features

-   Отображение базовых типов файлов (картинки, видео, аудио, markdown, pdf)
-   Отображение подсветки кода во строенном редакторе
-   API для работы. С документацией
-   Скачивание торрентов
-   Установка срока действия файлов и ссылок, удаление ключей, рандомные имена файлов

## Screenshots

|     |     |     |
| --- | --- | --- |
| ![](https://user-images.githubusercontent.com/4650950/76579039-03c82680-6488-11ea-8e23-4c927386fbd9.png) | ![](https://user-images.githubusercontent.com/4650950/76578903-771d6880-6487-11ea-8baf-a4a23fef4d26.png) | ![](https://user-images.githubusercontent.com/4650950/76578910-7be21c80-6487-11ea-9a0a-587d59bc5f80.png) |
| ![](https://user-images.githubusercontent.com/4650950/76578908-7b498600-6487-11ea-8994-ee7b6eb9cdb1.png) | ![](https://user-images.githubusercontent.com/4650950/76578907-7b498600-6487-11ea-8941-8f582bf87fb0.png) |     |

## Начало

1.  Создать папки `files` и `meta` и запустить `chown -R 65534:65534 meta && chown -R 65534:65534 files`
2.  Создайте файл конфигурации (пример предоставлен в репозитории), мы будем называть его **linx-server.conf** в следующих примерах.

Пример:

```
docker run -p 8080:8080 -v /path/to/linx-server.conf:/data/linx-server.conf -v /path/to/meta:/data/meta -v /path/to/files:/data/files andreimarcu/linx-server -config /data/linx-server.conf
```

Пример с docker-compose

```yaml
version: "3.7"

# linx - self-hosting picture and data
  linx:
    container_name: linx-server
    image: andreimarcu/linx-server
    command: -config /data/linx-server.conf
    volumes:
      - $DOCKER_APP/linx/files:/data/files
      - $DOCKER_APP/linx/meta:/data/meta
      - $DOCKER_APP/linx/linx-server.conf:/data/linx-server.conf
    networks:
      - direct_net
    environment:
      PUID: $PUID
      PGID: $PGID
    ports:
      - "8090:8080"
    restart: unless-stopped
```

В идеале вы должны использовать обратный прокси-сервер, такой как nginx, traefik или caddy, для обработки сертификатов TLS.

## Автор

Andrei Marcu, [https://andreim.net/](https://andreim.net/)