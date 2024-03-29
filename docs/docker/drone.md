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

## Примеры

### Нотификация в telegram

```yaml
- name: telgram_notify
  image: appleboy/drone-telegram
  when:
    status:
      #- success
      - failure
  settings:
    # The secrets below can be entered from the Drone UI for this repo
    token:
      from_secret: telegram_token
    to:
      from_secret: telegram_chat_id
    format: markdown
    message: >
      {{#success build.status}}
      ✅ Build #{{build.number}} of `{{repo.name}}` succeeded.
      📝 Commit by {{commit.author}} on `{{commit.branch}}`:
      ```
      {{commit.message}}
      ```
      🌐 {{ build.link }}
      {{else}}
      ❌ Build #{{build.number}} of `{{repo.name}}` failed.
      📝 Commit by {{commit.author}} on `{{commit.branch}}`:
      ```
      {{commit.message}}
      ```
      🌐 {{ build.link }}
      {{/success}}
```

### Сборка mcdocs

```yaml
- name: build states
  image: squidfunk/mkdocs-material:latest:latest
  pull: if-not-exists
  volumes:
  - name: site
    path: /site
  commands:
    - mkdocs build
    - cp -r site/ /site
    - chown 1000:1000 /site
    - chmod -R 777 /site
  when:
    event: 
      - push
    branch: 
      - states/*

volumes:
- name: site
  host:
    path: /opt/appdata/mkdocswiki
```