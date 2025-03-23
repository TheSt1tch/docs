# Vaultwarden - Неофициальный сервер, совместимый с Bitwarden

```yaml
services:
## Bitwarden - Password Vault
  bitwarden:
    container_name: bitwarden
    image: vaultwarden/server:latest
    restart: always
    ports:
      - "80:80"
      - "3012:3012"
    security_opt:
      - no-new-privileges:true
    volumes:
      - ./vaultwarden:/data
      - /var/log/docker:/var/log/docker
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    environment:
      #- SIGNUPS_ALLOWED=true # Change to false after first login
      - INVITATIONS_ALLOWED=true # Send invitation using admin page
      - WEBSOCKET_ENABLED=true
      - LOG_FILE=/var/log/docker/bitwarden.log
      - ADMIN_TOKEN=${BW_ADMIN_TOKEN}
      - DATABASE_URL=$DATABASE_URL
      #- DISABLE_ADMIN_TOKEN=false

  postgres:
    container_name: postgres
    image: docker.io/library/postgres:14-alpine
    restart: always
    ports:
      - "5432:5432"
    environment:
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TZ 
      - POSTGRES_PASSWORD=$PG_ROOT_PASSWORD
    security_opt:
      - no-new-privileges:true
    volumes:
      - $DOCKER_APP/postgres:/bitnami/postgresql
      - $DOCKER_APP/db-backup:/dbbackup
      - /etc/localtime:/etc/localtime:ro
    #healthcheck:
    #  test: ["CMD-SHELL", "pg_isready -d $${POSTGRES_DB} -U $${POSTGRES_USER}"]
    #  interval: 1s
    #  timeout: 5s
    #  retries: 10
```