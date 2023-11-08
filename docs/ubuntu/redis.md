[Redis](https://redis.io/)  — это быстрое хранилище данных типа «ключ‑значение», известное своей гибкостью, производительностью и широким выбором поддерживаемых языков. В этом руководстве описывается установка, настройка и обеспечение безопасности Redis на сервере Ubuntu 22.

Будем устанавливать Redis на Ubuntu Server 22. Нам нужен пользователь без root прав, но с привилегиями `sudo`.


## Установка Redis
 
1.  Обновите списки репозиториев:
    
    ```
    sudo apt-get update
    ```
    
2.  Для установки актуальной версии Redis, добавьте репозиторий с новой версией:
            
    ```
    sudo apt install lsb-release curl gpg
    curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
    ```
            
3.  Далее установите Redis новой версии:
            
    ```
    sudo apt-get update
    sudo apt-get install redis-server   
    ```
            
4.  После установки убедитесь, что сервер запущен:
    
    ```
    ps ax | grep redis
      335 ?        Ssl    0:00 /usr/bin/redis-server 127.0.0.1:6379
    ```
    
5.  Проверьте подключение к базе. По умолчанию для доступа к базе пароль не требуется:
    
    ```
    redis-cli
    127.0.0.1:6379> PING
    PONG
    127.0.0.1:6379>
    ```
    
6.  Добавьте сервис в список приложений, запускаемых автоматически:
    
    ```
    sudo systemctl enable redis-server
    ```
    
Установка завершена.

## Настройка безопасности

### Установка пароля

По умолчанию для доступа к Redis не требуется пароль. Для настройки прав доступа отредактируйте конфигурационный файл  `/etc/redis/redis.conf`. Из-за того, что Redis - высокопроизводительная база данных, позволяющая злоумышленнику проверять до 150 000 паролей в секунд, рекомендуется использовать надежный пароль.

Сгенерируем пароль из 60 символов
    
```
openssl rand 60 | openssl base64 -A
KBXBWCd1Kynbkdbo6IxEwx5fMBhutjj3YTT1J29rKoUjCnRcvo4uxYcptydQpqAjintegDhkYyCJHvx2
```
    
Укажите этот пароль в файле  `/etc/redis/redis.conf`  в разделе  `SECURITY`  в команде  `requirepass`:
    
```
################################## SECURITY ###################################

# Require clients to issue AUTH <PASSWORD> before processing any other
# commands. This might be useful in environments in which you do not trust
# others with access to the host running redis-server.
#
# This should stay commented out for backward compatibility and because most
# people do not need auth (e.g. they run their own servers).
#
# Warning: since Redis is pretty fast an outside user can try up to
# 150k passwords per second against a good box. This means that you should
# use a very strong password otherwise it will be very easy to break.
#
# requirepass foobared

requirepass KBXBWCd1Kynbkdbo6IxEwx5fMBhutjj3YTT1J29rKoUjCnRcvo4uxYcptydQpqAjintegDhkYyCJHvx2
```

### Переименование команд

Для повышения уровня безопасности можно использовать переименование команд либо запрет выполнения команд для работы с базой данных. 

Чтобы переименовать команду, дайте ей другое имя, как показано в приведенных ниже примерах. Переименованные команды должно быть трудно подобрать, но легко запомнить:

```
. . .
# rename-command CONFIG ""
rename-command SHUTDOWN SHUTDOWN_MENOT
rename-command CONFIG ASC12_CONFIG
. . .
```
Чтобы отключить команду, просто укажите пустую строку в качестве имени (обозначается парой кавычек без символов между ними), как показано ниже:
```
. . .
# It is also possible to completely kill a command by renaming it into
# an empty string:
#
rename-command FLUSHDB ""
rename-command FLUSHALL ""
rename-command DEBUG ""
. . .
```
После изменения файла конфигурации, выполните проверку доступности базы данных:

```
sudo systemctl restart redis-server
```

## Сетевой доступ

По умолчанию Redis слушает только 127.0.0.1. Изменим настройки, чтобы можно было подключаться с других хостов.

Отредактируем файл `/etc/redis/redis.conf`. Найдем в нем строчку `bind 127.0.0.1 ::1` и закомментируем её:

```
# IF YOU ARE SURE YOU WANT YOUR INSTANCE TO LISTEN TO ALL THE INTERFACES
# JUST COMMENT THE FOLLOWING LINE.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#bind 127.0.0.1 ::1
```

Перезапустим Redis для применения настроек:

```
sudo systemctl restart redis-server
```
Проверим, что Redis слушает сеть:
```
sudo netstat -tulpn | grep redis
tcp 0 0 0.0.0.0:6379 0.0.0.0:\* LISTEN 1562/redis-server \*
tcp6       0      0 :::6379                 :::\*                    LISTEN      1562/redis-server \*
```

## Установка лимита на память RAM

Теперь установим лимит на использование оперативной памяти и изменим механизм вытеснения ключей при заполнении этого объема памяти.

Это делается в секции **MEMORY MANAGEMENT** файла `/etc/redis/redis.conf`:

```
# maxmemory <bytes>
# maxmemory-policy noeviction
```

- **maxmemory** - указывает на максимальный объем памяти, что можно задействовать. Указывается в байтах, но можно указывать и краткие форматы (kb, mb, gb). Например `maxmemory 4gb`
- **maxmemory-policy** - определяет политику вытеснения ключей, при заполнении памяти.Могут быть разные значения:
    - noeviction — не вытеснять данные, то есть если память закончилась, при попытке записи в базу данных выдавать ошибку (по умолчанию);
    - volatile-lru — удалить наименее используемые в последнее время ключи с настройкой expire;
    - allkeys-lru — удалить наименее используемые в последнее время ключи вне зависимости от настройки expire;
    - volatile-lfu — удалить наименее часто используемые ключи с настройкой expire;
    - allkeys-lfu — удалить наименее часто используемые ключи вне зависимости от настройки expire;
    - volatile-random — удалить случайные ключи с настройкой expire;
    - allkeys-random — удалить случайные ключи вне зависимости от настройки expire;
    - volatile-ttl — удалить ключи, срок действия которых истекает быстрее остальных (то есть время жизни которых приближается к expire).