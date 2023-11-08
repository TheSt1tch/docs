# Drone CI

```yaml title="docker-compose.yml"
version: '3.7'

services:
  drone:
    image: drone/drone:latest
    container_name: drone
    environment:
      - DRONE_GITEA_SERVER=https://gitea.example.com/
      - DRONE_GIT_ALWAYS_AUTH=true
      - DRONE_GITEA_CLIENT_ID=<DRONE_GITEA_CLIENT_ID>
      - DRONE_GITEA_CLIENT_SECRET=<DRONE_GITEA_CLIENT_SECRET>
      - DRONE_SERVER_HOST=drone.example.com
      - DRONE_SERVER_PROTO=https
      - DRONE_RPC_SECRET=<DRONE_RPC_SECRET>
      - DRONE_USER_CREATE=username:admin,admin:true # Имя указать, что юзается в gitea
      # Если есть PostgreSQL
      #- DRONE_DATABASE_DRIVER=postgres
      #- DRONE_DATABASE_DATASOURCE=postgres://root:password@1.2.3.4:5432/drone?sslmode=disable
    restart: unless-stopped

  drone-runner-docker:
    image: drone/drone-runner-docker:1
    container_name: drone-runner-docker
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - DRONE_RPC_PROTO=https
      - DRONE_RPC_HOST=drone.example.com>
      - DRONE_RUNNER_CAPACITY=2
      - DRONE_RUNNER_NAME=whatsinaname
    restart: unless-stopped
```