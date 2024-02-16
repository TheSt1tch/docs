# Autoscan - автоскан для Plex на Go

[![](https://img.shields.io/github/stars/Cloudbox/autoscan?label=%E2%AD%90%20Stars)](https://github.com/Cloudbox/autoscan)
[![](https://img.shields.io/github/v/release/Cloudbox/autoscan?label=%F0%9F%9A%80%20Release)](https://github.com/Cloudbox/autoscan/releases/latest)

Autoscan - заменяет поведение **Plex** и **Emby** по умолчанию для обнаружения изменений в файловой системе. Autoscan интегрируется с **Sonarr**, **Radarr**, **Readarr**, **Lidarr** и **Google Drive** для получения изменений практически в реальном времени, не полагаясь на файловую систему.

!!! note "От автора"

    Наткнулся случайно, ища как можно поправить большую нагрузку при сканировании библиотеки в **Plex**. У меня достаточно большая медиа библиотека (1500 фильмов и 30000 серий в сериалах) и во время сканирования изменений, система могла некоторое ремя чуть тормозить. Решение нашлось - **Autoscan**. Он позволяет сделать интеграцию с Sonarr и Radarr, чтобы отслеживать моменты изменения файловой системы. Таким образом, сканирование в основом производится, когда что-то добавилось. Так же скан идет тольтко по той папке, что менялась.

Запускать будем через **Docker Compose**. Предпологается, что [Docker](install.md) уже установлен. Так же установлен [Plex](plex.md). Наличии Radarr и Sonarr опционально.

## Образ Docker

Создаем файл `docker-compose.yml`:

```bash
nano docker-compose.yml
```

Заполняем его:

```yaml title="docker-compose.yml"
version: "3.7"

services:
  autoscan:
    image: cloudb0x/autoscan
    container_name: autoscan
    restart: unless-stopped
    environment:
      - PUID=1001
      - PGID=1001
    ports:
      - 3030:3030
    volumes:
      - ./autoscan:/config
      - /mnt:/mnt:ro #Media Library
```

Запустить можно через:

```bash
docker compose up -d
```

## Конфиг файл 

По умолчанию конифг не создается, его нужно создать руками и заполнить параметрами. Ниже представлен пример. А еще ниже описание параметров. Конфиг файл находится по пути: `./autoscan/config.yml`

Создадим его:

```bash
touch ./autoscan/config.yml
```

??? example "Полный файл конфигурации"

    ```yaml title="config.yml"
    # <- processor ->

    # override the minimum age to 30 minutes:
    minimum-age: 30m

    # set multiple anchor files
    #anchors:
    #  - /mnt/unionfs/drive1.anchor


    # <- triggers ->

    # Protect your webhooks with authentication
    authentication:
    username: username
    password: password

    # port for Autoscan webhooks to listen on
    port: 3030

    triggers:
    radarr:
        - name: radarr   # /triggers/radarr
        priority: 2

    sonarr:
        - name: sonarr # /triggers/sonarr
        priority: 2
        # Rewrite the path from within the container
        # to your local filesystem.
        #rewrite:
        #  - from: /mnt/TV/
        #    to: /mnt/Media/TV/

    targets:
    plex:
        - url: https://plex.domain.tld # URL of your Plex server
        token: XXX # Plex API Token
        #rewrite:
        #  - from: /mnt/ # local file system
        #    to: / # path accessible by the Plex docker container (if applicable)
    ```

Типичный конфиг файл состоит из 3 частей:

1. `triggers`
2. `processor`
3. `targets`

### triggers

`triggers` - входные данные для запуска автосканирования. Они переводят входящие данные в общий формат данных, называемый сканированием.

Поддерживается несколько триггеров:

- [A-Train](https://github.com/m-rots/a-train/pkgs/container/a-train) : официальный триггер Google Drive для Autoscan.
- **Inotify**: прослушивает изменения в файловой системе. Его не следует использовать поверх креплений RClone. 
- **Вручную**: если вы хотите просканировать путь вручную.
- **-arrs**: Lidarr, Sonarr, Radarr, Readarr - через webhook

#### Настройка triggers
Рассмотрим более подробно настройку триггера через webhook для Sonarr и Radarr.

Чтобы добавить вебхук в **Sonarr**, **Radarr**, **Readarr** или **Lidarr**, выполните следующие действия:

1. Откройте `settings` страницу в Sonarr/Radarr/Readarr/Lidarr.
2. Выберите вкладку `connect`
3. Нажмите на большой плюсик
4. Выбирать `webhook`
5. Используйте `Autoscan` в качестве имени
6. Выберите `On Import` и `On Upgrade`
7. Задайте URL-адрес URL-адреса автосканирования и добавьте, `/triggers/:name` где имя — это имя, заданное в конфигурации триггера.
8. Установите имя пользователя и пароль.
9. Установите события: `Rename`, `On Movie Delete` или `On Series Delete`, `On Movie File Delete` или `On Episode File Delete`

??? example "Пример куска конфига"

    ```yaml
    triggers:
    radarr:
        - name: radarr   # /triggers/radarr
        priority: 2

    sonarr:
        - name: sonarr # /triggers/sonarr
        priority: 2
        # Rewrite the path from within the container
        # to your local filesystem.
        #rewrite:
        #  - from: /mnt/TV/
        #    to: /mnt/Media/TV/
    ```

### processor

Триггеры передают полученные сканы процессору. Затем процессор сохраняет сканы в свое хранилище данных. В качестве хранилища данных процессор использует **SQLite**.

Все отправляемые сканы в процессор группируются по одинаковой папке. Далее процессор ждет, пока все файлы в этот папке не станут старше `minimum-age`, по дефолту это 10 минут.

Когда все файлы старше минимального возраста, процессор параллельно вызовет все настроенные цели, чтобы запросить сканирование папки.

#### Настройка processor

Настройка процессора сводится к установке минимального времени сканирования. Есть 3 параметра:

- `minimum-age` - сколько времени пройдет после триггера
- `scan-delay` - задержка между процессами сканирования
- `scan-stats` - вывод статистики

```yaml title="Фрагмент файла config.yml"
...
# override the minimum age to 30 minutes:
minimum-age: 30m

# override the delay between processed scans:
# defaults to 5 seconds
scan-delay: 15s

# override the interval scan stats are displayed:
# defaults to 1 hour / 0s to disable
scan-stats: 1m
...
```
В `minimum-age` полях `scan-delay` и `scan-stats` должна быть указана строка в следующем формате:

- `1s` если минимальный возраст должен быть установлен на 1 секунду.
- `5m` если минимальный возраст должен быть установлен на 5 минут.
- `1m30s` если минимальный возраст должен быть установлен на 1 минуту и ​​30 секунд.
- `1h` если минимальный возраст должен быть установлен на 1 час.

### targets

targets - это конечный путь, куда будет сгружаться вся информация по изменениям. Сгружать можно в:

- Plex
- Emby
- Jellyfin
- Autoscan

### Настройка targets

Рассмотрим выгрузку в **Plex**. **Autoscan** заменяет стандартную джобу **Plex** по автоматическому обновлению библиотеки **Plex**. Поэтому лучше отключить параметр `Update my library automatically`

Можно настроить одну или несколько целей **Plex** в конфигурации:

```yaml
...
targets:
  plex:
    - url: https://plex.domain.tld # URL of your Plex server
      token: XXXX # Plex API Token
      rewrite:
        - from: /mnt/Media/ # local file system
          to: /data/ # path accessible by the Plex docker container (if applicable)
...
```

В конфигурации следует обратить внимание на пару вещей:

- `url`. URL-адрес может напрямую ссылаться на контейнер докеров, локальный хост или обратный прокси-сервер, расположенный перед Plex.
- `token`. Нам нужен токен Plex API, чтобы делать запросы от вашего имени. Эта статья должна вам помочь.
- `rewrite`. Если Plex работает не в хостовой ОС, а в Docker-контейнере (или в Docker-контейнере работает Autoscan), то необходимо соответствующим образом [переписать пути](https://github.com/Cloudbox/autoscan#rewriting-paths).