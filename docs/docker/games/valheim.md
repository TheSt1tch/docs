# Запуск своего сервера игры Valheim

![Valheim](https://raw.githubusercontent.com/lloesche/valheim-server-docker/main/misc/Logo_valheim.png)

!!! note 
    Для запуска используем docker образ от [lloesche](https://github.com/lloesche). Полная информация по запуску, доступна на [Github](https://github.com/lloesche/valheim-server-docker). 

Запуск сервера будем производить на Ubuntu, по ссылке выше на Github, можно найти инструкцию, как запустить на других системах. 

Запустить сервер можно 2 путями: через **консоль** (базовое) или через **docker-compose**

## Требования к серверу

Без игроков сервер потребляет в среднем 3Гб RAM и 30% одного ядра CPU на процессоре Intel Xeon E5-2620 v3 (частота 2,4ГГц)
При подключении игроков, нагрузка на CPU возрастает на 15% за хаждого игрока.

|  | Минимальные | Рекомендуемые |
|----------|----------|-------|
| CPU | 2 Core | 4 Core, 2.8+Ghz |
| RAM | 4 Gb | 8 Gb |

Большая тактовая частота ЦПУ лучше, чем большее количество ядер.

## Запуск через docker-compose

Я рекомендую именно этот способ

Скопируйте и вставьте следующее в консоль

```
mkdir -p $HOME/valheim-server/config $HOME/valheim-server/data
cd $HOME/valheim-server/
cat > $HOME/valheim-server/.env << EOF
SERVER_NAME=My Server
WORLD_NAME=Dedicated
SERVER_PASS=secret
SERVER_PUBLIC=true
PUID=1000
PGID=1000
UPDATE_IF_IDLE=true
UPDATE_CRON="30 5 * * *"
BEPINEX=true
EOF
```

Далее создадим сам docker-compose файл:

```
nano docker-compose.yml
```
и заполним его
```yaml
version: '3.7'

services: 
  valheim: 
    image: ghcr.io/lloesche/valheim-server:latest
    container_name: valheim-server
    cap_add:
      - sys_nice
    volumes: 
      - $HOME/valheim-server/config:/config
      - $HOME/valheim-server/data:/opt/valheim
    ports: 
      - "2456-2458:2456-2458/udp"
      - "9001:9001/tcp"
    env_file:
      - $HOME/valheim-server/valheim.env
    restart: always
    stop_grace_period: 2m
```
Запуск через 
```
docker-compose up
```

## Базовое использование (консоль)

Имя образа Docker — `ghcr.io/lloesche/valheim-server`.

Каталог монтирования конфигурации сервера `/config` в контейнере Docker.

Если у вас есть существующий мир в системе Windows, вы можете скопировать его, например:
`C:\Users\Lukas\AppData\LocalLow\IronGate\Valheim\worlds_local` в 
`$HOME/valheim-server/config/worlds_local` , и запустить образ с `$HOME/valheim-server/configтомом`, смонтированным `/config` внутри контейнера. 
Каталог контейнера `/opt/valheim` содержит загруженный сервер. При желании его можно смонтировать в томе, чтобы не загружать сервер при каждом новом запуске.

```
$ mkdir -p $HOME/valheim-server/config/worlds_local $HOME/valheim-server/data
# copy existing world
$ docker run -d \
    --name valheim-server \
    --cap-add=sys_nice \
    --stop-timeout 120 \
    -p 2456-2457:2456-2457/udp \
    -v $HOME/valheim-server/config:/config \
    -v $HOME/valheim-server/data:/opt/valheim \
    -e SERVER_NAME="My Server" \
    -e WORLD_NAME="Neotopia" \
    -e SERVER_PASS="secret" \
    ghcr.io/lloesche/valheim-server
```

!!! warning
    `SERVER_PASS` должен быть не менее 5 символов. Иначе `valheim_server.x86_64` откажется запускаться!

Новый запуск займет несколько минут в зависимости от скорости вашего интернет-соединения, поскольку контейнер загрузит выделенный сервер Valheim из Steam (~ 1 ГБ).

Не забудьте изменить `WORLD_NAME`, чтобы отразить название вашего мира! Для существующих миров это имя файла в `worlds_local/` папке без `.db/.fwl` расширения.

!!! note
    Если вы хотите играть с друзьями через Интернет и находитесь за NAT, убедитесь, что порты UDP 2456-2457 перенаправлены на хост-контейнер.

**Кроссплей:** чтобы включить кроссплей между разными платформами, добавьте `-crossplay` в `SERVER_ARGS`:
```
    -e SERVER_ARGS="-crossplay"
```

Более подробная информация находится в разделе [Как найти свой сервер](https://github.com/lloesche/valheim-server-docker#finding-your-server) .

Информацию об игре только по локальной сети см. в разделе [Избранные сервера Steam и LAN](https://github.com/lloesche/valheim-server-docker#steam-server-favorites--lan-play).

Предоставление `CAP_SYS_NICE` контейнеру не является обязательным. Это позволяет библиотеке Steam, которую использует Valheim, увеличить количество циклов процессора. Без него вы увидите сообщение `Warning: failed to set thread priority` в журнале запуска.

### Значения переменных

Я не буду описывать значения всех переменных, используемых к образе. Я опишу лишь те. что использовал на своем сервере. По [ссылке](https://github.com/lloesche/valheim-server-docker#environment-variables) можно найти другие.

!!! note
    Все имена и значения переменных чувствительны к регистру!

| Name | Default | Purpose |
|----------|----------|-------|
| `SERVER_NAME` | `My Server` | Имя сервера, отображаемое в браузере серверов |
| `WORLD_NAME` | `Dedicated` | Имя мира без  `.db/.fwl` |
| `SERVER_PASS` | `secret` | Пароль для входа на сервер, минимум **5 символов!** |
| `SERVER_PUBLIC` | `true` | Отображение сервера в браузере серверов (`true`) или нет (`false`) |
| `UPDATE_CRON` | `*/15 * * * *` | [Cron расписание](https://en.wikipedia.org/wiki/Cron#Overview) для проверки обновлений (отключено, если задана пустая строка или установлен `UPDATE_INTERVAL`) |
| `UPDATE_IF_IDLE` | `true` | Запуск проверки обновлений, когда на сервере пусто (`true` или `false`) |
| `BEPINEX` | `false` | Должен быть загружен мод [BepInExPack Valheim](https://valheim.thunderstore.io/package/denikson/BepInExPack_Valheim/) (конфиг в `/config/bepinex`, плагины в `/config/bepinex/plugins`). Не использовать вместе с `VALHEIM_PLUS`. |
| `PUID` | `0` | UID для запуска valheim-сервера как |
| `PGID` | `0` | GID для запуска valheim-сервера как |

### Развертывание

Создайте файл конфигурации `/etc/sysconfig/valheim-server`

```
SERVER_NAME=My Server
SERVER_PORT=2456
WORLD_NAME=Dedicated
SERVER_PASS=secret
SERVER_PUBLIC=true
```
Затем включите контейнер Docker при загрузке системы.
```
$ sudo mkdir -p /etc/valheim /opt/valheim
$ sudo curl -o /etc/systemd/system/valheim.service https://raw.githubusercontent.com/lloesche/valheim-server-docker/main/valheim.service
$ sudo systemctl daemon-reload
$ sudo systemctl enable valheim.service
$ sudo systemctl start valheim.service
```

## Обновления

По умолчанию контейнер будет проверять наличие обновлений сервера Valheim каждые 15 минут, если в данный момент к серверу не подключены игроки. Если обновление найдено, оно загружается, и сервер перезапускается. Это расписание обновлений можно изменить с помощью `UPDATE_CRON` переменной.
В перменных выше, указана чистота проверки обновлений "30 5 * * *" - это означает, что сервер будет првоерять обновления раз в сутки, в 5:30. Чтобы было проще указывать параметры cron, я советую использовать [crontab.guru](https://crontab.guru/)

[Github](https://github.com/lloesche/valheim-server-docker){ .md-button .md-button--primary }