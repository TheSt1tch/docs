# Plex in Docker

[![](https://img.shields.io/github/stars/plexinc/pms-docker?label=%E2%AD%90%20Stars&style=flat-square)](https://github.com/plexinc/pms-docker)
[![Docker Pulls](https://img.shields.io/docker/pulls/plexinc/pms-docker.svg?maxAge=60&style=flat-square)](https://hub.docker.com/r/plexinc/pms-docker/)

[Plex](https://www.plex.tv/) — это клиент-серверная система медиаплеера и пакет программного обеспечения, состоящий из двух основных компонентов (медиа-сервера и клиентских приложений).

![](../../images/docker/plex_1.png)

## Требования для запуска

!!! summary "Уже развернуто"

    * [X] [Traefik](../traefik/index.md) настроен согласно инструкциям
    * [X] Запись DNS для имени хоста, которое вы собираетесь использовать (или подстановочный знак ), указывающая на ваш поддерживаемый IP-адрес .


## Подготовка

### Папка

Для запуска контейнера, нужен будет каталог, где Plex сможет хранить свои данные:

```
mkdir /opt/appdata/plex
```

### Файл .env

Далее создадим `.env` файл, где будут храниться переменные. Для **PUID** и **PGID** нужно задать **UID** и **GID** пользователя системы, которому принадлежат права на медиафайлы в локальной файловой системе.

```yaml title=".env"
VERSION=latest
PUID=1001
PGID=1001
PLEX_CLAIM=
```

### Plex Claim

Не забываем прописать `PLEX_CLAIM` - параметр нужен, чтобы привязать этот экземпляр медиасервера к учетной записи Plex. Получить можно по ссылке: [https://www.plex.tv/claim](https://www.plex.tv/claim)

### Docker Compose для Plex

Ниже приведен файл Docker Compose, рекомендованный для начала работы с Plex. 

```yaml title="docker-compose.yml"
version: "3.7"
services:
  plex:
    container_name: plex
    image: plexinc/pms-docker:latest
    restart: unless-stopped
    #devices:
    # - /dev/dri:/dev/dri # for harware transcoding
    ports:
      - "32400:32400"
      - "32400:32400/udp"
    security_opt:
      - no-new-privileges:true
    volumes:
      - /opt/appdata/plex:/config
      - /opt/appdata/plex/temp:/transcode
      - /mnt:/mnt:ro
    environment:
      - ADVERTISE_IP="http://172.18.1.250:32400/"
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TZ
      - VERSION=docker
      - PLEX_CLAIM=$PLEX_CLAIM
```

Разберем, что значат некоторые параметры в файле:

- Мы используем образ докера **plexinc/pms-docker:public** Plex. Вы также можете использовать изображение **plexpass** , которое предлагает некоторые преимущества вместо **public** . Благодаря поддержке Plex на серверах Raspberry Pi Docker (ARM), [образ Plex Linuxserver.io](https://github.com/linuxserver/docker-plex) также является хорошим.
- Plex будет принадлежать к сети типа мост "default". Это нормально для большинства пользователей.
- Мы также сопоставляем несколько портов контейнера Plex (правая часть двоеточия) с хостом Docker (слева от двоеточия). Plex будет доступен на IP-адресе хоста Docker через порт Plex Docker 32400. Например, мой хост Docker имеет IP-адрес 192.168.1.111 . Итак, Plex будет доступен по адресу http://192.168.1.111:32400 .
/dev/dri обычно представляет собой видеокарту. Вы можете передать видеокарту вашего хоста докера в контейнер докера Plex для аппаратного перекодирования. Раскомментируйте эти строки (удалите # впереди), чтобы включить видеокарты. Вам придется включить аппаратное перекодирование в настройках Plex. Это особенно полезно для NAS, поддерживающих Plex (например, Synology).
В разделе «тома» мы сопоставляем постоянный том для конфигурации Plex, еще один том, на котором находится наш носитель. Вы можете сделать его доступным только для чтения, добавив :ro в конце. Наконец, мы передаем ОЗУ для более быстрого перекодирования (убедитесь, что /transcode установлен в качестве папки перекодирования в настройках медиасервера Plex).
С помощью $PUID и $PGID мы указываем, что Plex запускается с идентификатором пользователя и группой пользователей, которые мы определили ранее в файле .env .
PLEX_CLAIM — это ваш токен заявки Plex .
ADVERTISE_IP настраивает URL-адреса доступа к пользовательскому серверу в настройках сети сервера Plex. Он указывает другие IP-адреса, по которым можно получить доступ к тому же серверу Plex.
ALLOWED_NETWORKS: предназначено исключительно для регулирования пропускной способности. Указанные здесь IP-адреса считаются локальными (LAN) сетями.




Удаление мусора из PhotoTranscoder

```bash
find "/home/plex/plexconfig/Library/Application Support/Plex Media Server/Cache/PhotoTranscoder" -name "*.jpg" -type f -mtime +5 -delete
```




https://www.smarthomebeginner.com/plex-docker-compose/
https://www.smarthomebeginner.com/adguard-home-raspberry-pi-2023/
https://www.smarthomebeginner.com/wireguard-adblocker-on-the-go/
https://geek-cookbook.funkypenguin.co.nz/recipes/plex/