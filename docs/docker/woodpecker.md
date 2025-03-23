# Woodpecker - простой, но мощный движок CI/CD

Woodpecker — простой, но мощный движок CI/CD с большими возможностями расширения.

Woodpecker использует Docker-контейнеры для выполнения этапов конвейера.

![](../../images/docker/woodpecker.png)

[![](https://img.shields.io/github/stars/woodpecker-ci/woodpecker?label=%E2%AD%90%20Stars&style=flat-square)](https://github.com/woodpecker-ci/woodpecker)
[![](https://img.shields.io/github/v/release/woodpecker-ci/woodpecker?label=%F0%9F%9A%80%20Release&style=flat-square)](https://github.com/woodpecker-ci/woodpecker/releases/latest)
[![Docker Pulls](https://img.shields.io/docker/pulls/woodpeckerci/woodpecker-server.svg?maxAge=60&style=flat-square)](https://hub.docker.com/r/woodpeckerci/woodpecker-server)

## Что такое CI/CD или конвейеры? 

CI/CD означает **Continuous Integration and Continuous Deployment** (непрерывная интеграция и непрерывное развертывание). По сути, это конвейерная лента, которая перемещает ваш код из разработки в производство, выполняя всевозможные проверки, тесты и процедуры по пути. Типичный конвейер может включать следующие шаги:

1. Проведение тестов
2. Создание вашего приложения
3. Развертывание вашего приложения

[Более глубокое изучение самое идеи CI/CD](https://blog.skillfactory.ru/glossary/ci-cd/)

## Развертывание Woodpecker

Развертывание Woodpecker состоит из 2 частей:

- Сервер, являющийся сердцем системы и предоставлюящий веб интерфейс
- Агенты, которык запускают конвееры

Каждый агнет может обрабатывать 1 рабочий процесс. То есть 6 агентов могут обрабатывать 6 рабочих процессов параллельно.

### Системный требования

Минимальные требования:

- Сервер: CPU 1 ядро, RAM 200 Mb
- Агент: CPU 1 ядро, RAM 32 Mb

Так же потребуется база данных, которой тоже нужны будут ресурсы.

### Docker Compose

Устанавливать будем через Docker Compose, используя базу данных SQLite, которая не требует установки или настройки. Посмотреть настройки для других баз данных можно на [странице](https://woodpecker-ci.org/docs/administration/database)

https://woodpecker-ci.org/docs/intro
https://woodpecker-ci.org/docs/administration/getting-started
https://woodpecker-ci.org/docs/administration/deployment-methods/docker-compose