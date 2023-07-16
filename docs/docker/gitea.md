# Gitea

[Gitea](https://gitea.io/en-us/) - это self-hosted сервис, аналог GitHub. Основное отличие от GitLab - меньшее потребление ресурсов, прозрачность при обновлении. Gitea может использоваться как локально, так и в облачном режиме.

## Создание файлов конфигурации

Создадим папку, где будут храниться файл `docker-compose.yml`, а так же другие файлы, связанные с gitea.

Создадим файл `docker-compose.yml`:

```yaml title="docker-compose.yml"
version: '3.7'

services:
  server:
    image: gitea/gitea:latest
    container_name: gitea
    environment:
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TZ
      - GITEA__database__DB_TYPE=postgres
      - "GITEA__database__HOST=192.168.1.12:5432"
      - GITEA__database__NAME=gitea
      - GITEA__database__USER=gitea
      - "GITEA__database__PASSWD=nyxGsayHUq%t5W4^Pj#ei%^xN*GUp75Kxz"
    restart: always
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - ./data:/data
      - ./custom:/app/gitea/custom 
      - ./log:/app/gitea/log
    ports:
      - 10880:3000
      - 10022:22
```

В нем:

<table>
<tr>
<td><b>Параметр</b></td>
<td><b>Описание</b></td>
</tr>
<tr>
<td>

```yaml
    image: gitea/gitea:latest
```

</td>
<td>Указываем, что используем последнию версию образа gitea, доступную в Docker Hub</td>
</tr>
<tr>
<td>

```yaml
    container_name: gitea
```

</td>
<td>Имя контейнера</td>
</tr>
<tr>
<td>

```yaml
    restart: always
```

</td>
<td>Автоматический перезапуск контейнера, при остановке</td>
</tr>
<tr>
<td>

```yaml
    environment: 
      - USER_UID=1000 
      - USER_GID=1000
```

</td>
<td>ID пользователя и группы, использующиеся в контейнере</td>
</tr>
<tr>
<td>

```yaml
    environment: 
      - USER_UID=1000 
      - USER_GID=1000
```

</td>
<td>ID пользователя и группы, использующиеся в контейнере</td>
</tr>
<tr>
<td>

```yaml
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - ./data:/data
      - ./custom:/app/gitea/custom 
      - ./log:/app/gitea/log
```

</td>
<td>

- `/etc/timezone` и `/etc/localtime` - берем таймзону и время из настроек хоста
- `./data` - хранение файлов данных gitea
- `./custom` - пользовательские файлы конфигурации
- `./log` - логи


</td>
</tr>
<tr>
<td>

```yaml
    ports: 
      - "3000:3000" 
      - "10022:22"
```

</td>
<td>
Задаем порты, для доступа к gitea. 3000 - для веб-интерфейса. 10022 - для доступа через SSH
</td>
</tr>
</table>

## Запуск контейнера

Перейдем в директорию, где находится файл `docker-compose.yml` и запустим с помощью команды:

```
docker-compose up -d
```

Произойдет запуск контейнера gitea в фоновом режиме. В первый раз может занять какое-то время.

После запуска, нужно открыть браузер и ввести адрес: `http://server-ip:3000`. Заполняем поля. По умолчанию используется БД SQLite. В Administrator Account Settings обязательно укажите имя пользователя и пароль для учетной записи администратора.

Готово. 

