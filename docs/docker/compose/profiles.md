# Docker Compose Profile - профили

Те, кто юзает docker-compose, обычно делятся на 2 типа: 

- пихаем все в 1 файл на каждый хост
- пихаем в разные файлы с какой-то логикой

А что если я напишу, что можно совместить эти 2 типа людей. Один файл, но с разбивкой по профилям с какой-то логикой. Звучит правда классно?

Возьмем классический монолитный файл docker-compose:

```yaml title="docker-compose.yml"
version: "3.9"
services:
  nginx1:
    image: nginx
    container_name: nginx1
    profiles: 
      - prod
      - test
  nginx2:
    image: nginx
    container_name: nginx2
    profiles: 
      - prod
  nginx3:
    image: nginx
    container_name: nginx3
    profiles: 
      - test
```

Используя profile, можно поместить 1 службу в несколько профилей, что  дает больше гибкости, чем несколько файлов.

```bash
user@test tmp % docker-compose --profile test up -d
[+] Running 2/2
 ⠿ Container nginx1  Started  0.1s
 ⠿ Container nginx3  Started
```

 Пример выше показывает, что были запущены только сервисы, с профилем `test`. Больше информации можно найти в [документации Docker](https://docs.docker.com/compose/profiles/) .

!!! note

    Eсли включаем профиль, то простой вариант `docker-compose up -d` не выполнится:
    ```bash
    user@test tmp % docker-compose up -d
    no service selected
    ```