Redis - как пишут на википедии, **Redis** (от англ. **remote dictionary server**) — резидентная система управления базами данных класса NoSQL с открытым исходным кодом, работающая со структурами данных типа «ключ — значение». Используется как для баз данных, так и для реализации кэшей, брокеров сообщений.

Простыми словами, Redis это размещаемое в памяти хранилище ключ-значение, обычно используемое для кэшей и подобных механизмов ускорения сетевых приложений.

Redis быстр. Когда я говорю быстр, я имею в виду Быстр с заглавной буквы Б. Это по существу *memcached* с более продуманными типами данных, нежели просто строковые значения. Даже некоторые продвинутые операции такие, как пересечение множеств, выборка диапазонов zset, ослепительно быстры. Есть все поводы использовать Redis для быстроменяющихся активно запрашиваемых данных. Он довольно часто используется в качестве кэша, который может быть перестроен по данным из резервной базы данных. Это мощная замена memcached предоставляющая более продвинутое кэширование для различных видов хранимых вами данных.

## Создание сети

Создать сеть в docker можно с помощью нескольких способов. Я предпочитаю явно через консоль ввести все параметры, тк эту сеть будут использовать и другие контейнеры, а так же, возможно, другие стеки. Создаем базовую сеть `direct_net` со следующими параметрами: 


| --- | --- |
| Name | redis\_network |
| Subnet | 172.18.5.0/24 |
| Gateway | 172.18.5.254 |

Команда для создания через консоль:

`docker network create --gateway 172.18.1.254 --subnet 172.18.1.0/24 direct_net`

Создаем файл .env, где будем хранить переменные. 

`nano .env`

Заполняем его

```plaintext
$DOCKERDIR_APP=/opt/docker/appdata
```

Создаем файл docker-compose.yml 

`nano docker-compose.yml`

Заполняем его

```yaml
version: "3.7"

networks:
  direct_net:
    external: true

services:
  ## Redis - Key-value Store
  redis:
    container_name: redis
    image: redis:latest
    restart: always
    entrypoint: redis-server --appendonly yes
    networks:
       - direct_net
#    ports:
#      - "6379:6379"
    security_opt:
      - no-new-privileges:true
    sysctls:
      net.core.somaxconn: '65535'
    volumes:
      - $DOCKERDIR_APP/redis/data:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
```

в дополнение, можем добавить сервис для управления нашим redis - rediscommander:

```yaml
## Redis Commander - Redis Management Tool
  rediscommander:
    container_name: rediscommander
    image: rediscommander/redis-commander:latest
    restart: always
    depends_on:
      - redis
    networks:
      - direct_net
    ports:
      - "8081:8081"
    security_opt:
      - no-new-privileges:true
    environment:
      - REDIS_HOST=redis
```