
[![](https://img.shields.io/badge/Github-blue)](https://github.com/fluencelabs/docker-socket-proxy)
[![](https://img.shields.io/github/stars/fluencelabs/docker-socket-proxy?label=%E2%AD%90%20Stars)](https://github.com/fluencelabs/docker-socket-proxy)

## Что это?
Это прокси-сервер с повышенной безопасностью для Docker Socket.

## Зачем?
Предоставление доступа к вашему сокету Docker может означать предоставление root-доступа к вашему хосту или даже ко всему вашему множеству, но некоторым службам требуется подключение к этому сокету, чтобы реагировать на события и т. д. Использование этого прокси-сервера позволяет вам блокировать все, что, по вашему мнению, эти службы не должны делать.

```yaml title="docker-compose.yml"
version: "3.8"

services:
# Docker Socket Proxy - Security Enchanced Proxy for Docker Socket
  socket-proxy:
    container_name: socket-proxy
    image: fluencelabs/docker-socket-proxy
    restart: always
    privileged: true
    security_opt:
      - no-new-privileges:true
    ports:
      - 2375:2375
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    environment:
      - LOG_LEVEL=warning # debug,info,notice,warning,err,crit,alert,emerg
      ## Variables match the URL prefix (i.e. AUTH blocks access to /auth/* parts of the API, etc.).
      # 0 to revoke access.
      # 1 to grant access.
      ## Granted by Default
      - EVENTS=1
      - PING=1
      - VERSION=1
      ## Revoked by Default
      # Security critical
      - AUTH=0
      - SECRETS=0
      - POST=1 # Watchtower
      - DELETE=1 # Watchtower
        # GET Optons
      - BUILD=0
      - COMMIT=0
      - CONFIGS=0
      - CONTAINERS=1 # Traefik, portainer, etc.
      - DISTRIBUTION=0
      - EXEC=1 # Portainer
      - IMAGES=1 # Portainer, Watchtower
      - INFO=1 # Portainer
      - NETWORKS=1 # Portainer, Watchtower
      - NODES=0
      - PLUGINS=0
      - SERVICES=1 # Portainer
      - SESSION=0
      - SWARM=0
      - SYSTEM=0
      - TASKS=1 # Portaienr
      - VOLUMES=1 # Portainer
      # POST Options
      - CONTAINERS_CREATE=1 # WatchTower
      - CONTAINERS_START=1 # WatchTower
      - CONTAINERS_UPDATE=1 # WatchTower
      # DELETE Options
      - CONTAINERS_DELETE=1 # WatchTower
      - IMAGES_DELETE=1 # WatchTower
```