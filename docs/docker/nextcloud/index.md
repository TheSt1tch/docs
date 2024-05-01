# Nextcloud - свое облако для файлов

Запуск через docker-compose. Для начала создадим файл `.env` со следующим содержанием:

```env title=".env"
PUID=
PGID=
TZ=
NEXTCLOUD_DOMAIN_NAME=
REDIS_PASSWORD=
```

Далее создаем файл `docker-compose.yml`

```yaml title="docker-compose.yml"
version: "3.7"

services:
  # Nextcloud Docker Application
  nextcloud:
    image: nextcloud:28
    container_name: nextcloud
    restart: always
    volumes:
      - ./nextcloud:/var/www/html
      - ./nextcloud/apps:/var/www/html/custom_apps
      - ./nextcloud/config:/var/www/html/config
      - ./nextcloud/data:/var/www/html/data
    environment:
      - POSTGRES_HOST=192.168.1.12
      - POSTGRES_DB_FILE=/run/secrets/nextcloud_postgres_db
      - POSTGRES_USER_FILE=/run/secrets/nextcloud_postgres_user
      - POSTGRES_PASSWORD_FILE=/run/secrets/nextcloud_postgres_password
      - NEXTCLOUD_ADMIN_PASSWORD_FILE=/run/secrets/nextcloud_admin_password
      - NEXTCLOUD_ADMIN_USER_FILE=/run/secrets/nextcloud_admin_user
      #- REDIS_HOST=
      #- REDIS_HOST_PASSWORD=
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TZ
      - NEXTCLOUD_TRUSTED_DOMAIN=$NEXTCLOUD_DOMAIN_NAME
      - TRUSTED_PROXIES=172.18.0.253
      - OVERWRITEPROTOCOL=https
    labels:
      - com.centurylinklabs.watchtower.enable=False
```