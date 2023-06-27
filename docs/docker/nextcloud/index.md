```env
PUID=
PGID=
TZ=
DOCKER_APP=
SECRETSDIR=
NEXTCLOUD_DOMAIN_NAME=
REDIS_PASSWORD=
```

docker-compose.yml

```yaml
version: "3.7"

secrets:
  nextcloud_admin_password:
    file: $SECRETSDIR/nextcloud_admin_password # put admin password in this file
  nextcloud_admin_user:
    file: $SECRETSDIR/nextcloud_admin_user # put admin username in this file
  nextcloud_postgres_db:
    file: $SECRETSDIR/nextcloud_postgres_db # put postgresql db name in this file
  nextcloud_postgres_password:
    file: $SECRETSDIR/nextcloud_postgres_password # put postgresql password in this file
  nextcloud_postgres_user:
    file: $SECRETSDIR/nextcloud_postgres_user # put postgresql username in this file

services:
  # Nextcloud Docker Application
  nextcloud:
    image: nextcloud:25.0.4
    container_name: nextcloud
    restart: always
    volumes:
      - $DOCKER_APP/nextcloud:/var/www/html
      - $DOCKER_APP/nextcloud/apps:/var/www/html/custom_apps
      - $DOCKER_APP/nextcloud/config:/var/www/html/config
      - /mnt/NAS/Nextcloud:/var/www/html/data
      - /mnt:/mnt
    environment:
      - POSTGRES_HOST=192.168.1.12
      - POSTGRES_DB_FILE=/run/secrets/nextcloud_postgres_db
      - POSTGRES_USER_FILE=/run/secrets/nextcloud_postgres_user
      - POSTGRES_PASSWORD_FILE=/run/secrets/nextcloud_postgres_password
      - NEXTCLOUD_ADMIN_PASSWORD_FILE=/run/secrets/nextcloud_admin_password
      - NEXTCLOUD_ADMIN_USER_FILE=/run/secrets/nextcloud_admin_user
      - REDIS_HOST=172.18.3.249
      - REDIS_HOST_PASSWORD=$REDIS_PASSWORD
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TZ
      - NEXTCLOUD_TRUSTED_DOMAIN=$NEXTCLOUD_DOMAIN_NAME
      - TRUSTED_PROXIES=172.18.0.253
      - OVERWRITEPROTOCOL=https
    secrets:
      - nextcloud_admin_password
      - nextcloud_admin_user
      - nextcloud_postgres_db
      - nextcloud_postgres_password
      - nextcloud_postgres_user
    labels:
      - com.centurylinklabs.watchtower.enable=False
```