[![](https://img.shields.io/github/stars/Taxel/PlexTraktSync?label=%E2%AD%90%20Stars)](https://github.com/Taxel/PlexTraktSync)

Сервис добавляет двустороннюю сихронизацию между trakt.tv и Plex Media Server. Для этого требуется учетная запись trakt.tv, но без премиум-подписки Plex или VIP-подписки Trakt, в отличие от приложения Plex, предоставляемого Trakt.

## Функции
- Медиа из Plex добавлено в коллекцию Trakt
- Сихронизация рейтингов
- Сихронизация статуса просмотра (даты не синхронизируются от Trakt до Plex)
- Списки понравившегося в Trakt загружаются, все фильмы в Plex, принадлежащие к этому списку, объединяются в коллекцию
- Сихронизация списков налюдения
- Можно отредактировать файл конфигурации, чтобы выбрать, что синхронизировать

Ни одно из вышеперечисленных действий не требует членства в Plex Pass или Trakt VIP. Недостаток: необходимо выполнять вручную или через cronjob, нельзя использовать оперативные данные через веб-хуки.

## Установка через docker-compose

```yaml
version: "3.7"

services:
  plextraktsync:
    image: ghcr.io/taxel/plextraktsync
    container_name: plextraktsync
    restart: on-failure:2
    volumes:
      - ./config:/app/config
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Yekaterinburg
    command: sync
```

Запустить синхронизацию: `docker-compose run --rm plextraktsync sync`

Для запуска автоматически по расписанию можно использовать crontab или sheduler:

=== "Crontab"
    ```
    $ crontab -e
    0 */2 * * * $HOME/.local/bin/plextraktsync sync
    ```
    
=== "Sheduler"
    ```yaml
    version: '2'
    services:
      scheduler:
        image: mcuadros/ofelia:latest
        container_name: scheduler
        depends_on:
          - plextraktsync
        command: daemon --docker
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock:ro
        labels:
          ofelia.job-run.plextraktsync.schedule: "@every 6h"
          ofelia.job-run.plextraktsync.container: "plextraktsync"
    ```

## Настройки

Если будет ошибка, что не найден сервер Plex, то надо в ручную прописать сервер в файле `servers.yml`:

```yaml
servers:
  default:
    token: token
    urls:
    - http://plex:32400
```