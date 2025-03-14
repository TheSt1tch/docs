# Uptime Kuma - простой инструмент для мониторинга

[![](https://img.shields.io/github/stars/louislam/uptime-kuma.svg?label=%E2%AD%90%20Stars&style=flat-square)](https://github.com/louislam/uptime-kuma)
[![](https://img.shields.io/docker/pulls/louislam/uptime-kuma?color=brightgreen)](https://hub.docker.com/r/louislam/uptime-kuma)

Чтобы установить Uptime Kuma с использованием Docker, выполните следующие шаги:

1. Создайте контейнер Uptime Kuma с помощью Docker Compose. Для этого создайте файл `docker-compose.yml` и добавьте следующий код:
```yaml
version: '3'
services:
  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    ports:
      - 3001:3001
    volumes:
      - ./data:/app/data
    restart: unless-stopped
```
Этот файл содержит конфигурацию для запуска контейнера Uptime Kuma. Контейнер будет использовать порт 3001 и хранить данные в локальном каталоге ./data.

2. Запустите контейнер, выполнив следующую команду:
```
docker-compose up -d
```

3. После успешного запуска Uptime Kuma станет доступным по адресу http://localhost:3001. Для входа используйте учетную запись администратора с именем пользователя admin и паролем admin.