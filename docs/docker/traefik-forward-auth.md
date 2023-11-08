# Traefik Forward Auth

[![](https://img.shields.io/github/stars/thomseddon/traefik-forward-auth?label=%E2%AD%90%20Stars)](https://github.com/thomseddon/traefik-forward-auth)
[![](https://img.shields.io/github/v/release/thomseddon/traefik-forward-auth?label=%F0%9F%9A%80%20Release)](https://github.com/thomseddon/traefik-forward-auth/releases/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/thomseddon/traefik-forward-auth.svg)

-   Бесшовно накладывает любой http-сервис на одну конечную точку (см.: `url-path`в [разделе «Конфигурация](https://github.com/thomseddon/traefik-forward-auth#configuration) ») .
-   Поддерживает несколько поставщиков, включая Google и OpenID Connect (поддерживается Azure, Github, Salesforce и т. д.).
-   Поддерживает несколько доменов/поддоменов, динамически генерируя redirect\_uri
-   Позволяет выборочно применять/обходить аутентификацию на основе параметров запроса (см `rules`. [Конфигурация](https://github.com/thomseddon/traefik-forward-auth#configuration) )
-   Поддерживает использование централизованной аутентификации host/redirect\_uri (см `auth-host`. [Конфигурация](https://github.com/thomseddon/traefik-forward-auth#configuration) )
-   Позволяет сохранять аутентификацию в нескольких доменах (см. [Домены cookie](https://github.com/thomseddon/traefik-forward-auth#cookie-domains) )
-   Поддерживает расширенную аутентификацию за пределами срока действия токена Google (см.: `lifetime`в разделе [«Конфигурация](https://github.com/thomseddon/traefik-forward-auth#configuration) »).

## Применение

docker-compose

```yaml
version: "3.9"

# docker network create --gateway 172.18.0.254 --subnet 172.18.0.0/24 traefik_net
networks:
  traefik_net:
    external: true

services:
  traefik-forward-auth:
    image: thomseddon/traefik-forward-auth
    container_name: traefik-forward-auth
    restart: always
    networks:
      traefik_net:
        ipv4_address: 172.18.1.4
    environment:
      - DEFAULT_PROVIDER=oidc
      # Keycloak Section
      #- PROVIDERS_OIDC_ISSUER_URL=https://auth.example.ru/auth/realms/traefik #for keycloak
      #- PROVIDERS_OIDC_CLIENT_ID=$PROVIDERS_OIDC_CLIENT_ID
      #- PROVIDERS_OIDC_CLIENT_SECRET=$PROVIDERS_OIDC_CLIENT_SECRET
      # Google OAuth
      - PROVIDERS_GOOGLE_CLIENT_ID=your-client-id
      - PROVIDERS_GOOGLE_CLIENT_SECRET=your-client-secret
      - SECRET=secret #replace
      - LOG_LEVEL=warn
    labels:
      - "traefik.enable=true"
      - "traefik.http.middlewares.traefik-forward-auth.forwardauth.address=http://traefik-forward-auth:4181"
      - "traefik.http.middlewares.traefik-forward-auth.forwardauth.authResponseHeaders=X-Forwarded-User"
      - "traefik.http.services.traefik-forward-auth.loadbalancer.server.port=4181"
```

Более полный файл [docker-compose.yml](https://github.com/thomseddon/traefik-forward-auth/blob/master/examples/traefik-v2/swarm/docker-compose.yml) или [kubernetes/simple-separate-pod](https://github.com/thomseddon/traefik-forward-auth/blob/master/examples/traefik-v2/kubernetes/simple-separate-pod/) можно найти в каталоге примеров

## Google провайдер

Настройка провайдера на примере Google. [Другие провайдеры](https://github.com/thomseddon/traefik-forward-auth/wiki/Provider-Setup) можно посмотреть на Github автора.

Перейдите на [https://console.developers.google.com](https://console.developers.google.com/) и убедитесь, что вы переключились на правильную учетную запись электронной почты.

Создайте новый проект, затем найдите и выберите «Учетные данные» в строке поиска. Заполните вкладку «Экран согласия OAuth».

Нажмите «Создать учетные данные» > «Идентификатор клиента OAuth». Выберите «Веб-приложение», введите имя своего приложения, пропустите «Авторизованные источники JavaScript» и заполните «Авторизованные URI перенаправления» со всеми доменами, с которых вы разрешите аутентификацию, добавив (например, https: `url-path`//app.test [. com/\_oauth](https://app.test.com/_oauth) )

Вы должны установить параметры конфигурации `providers.google.client-id`и `providers.google.client-secret`

## Авторские права

2018 Том Седдон