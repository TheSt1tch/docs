# Semaphore

!!! note

    Ansible Semaphore — это веб-интерфейс для запуска Ansible-плейбуков с расширенными возможностями:

      - объединение Ansible-плейбуков в проекты;
      - запуск задач по расписанию;
      - хранение и просмотр логов выполнения задач;
      - управление правами доступа;
      - уведомления на электронную почту и в Telegram.

    Ansible Semaphore написан на Go и распространяется с исходным кодом под свободной лицензией.

## Подготовка

Для установки, нужен хост, где уже стоит и одна из СУБД: MariaDB, BoltDB либо PostgreSQL.

### Установка MariaDB

Добавляем репозиторий MariaDB

```
curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup
```

Устанавливаем СУБД
```
sudo apt -y install MariaDB-server MariaDB-client MariaDB-backup
```

Запускаем сервис
```
sudo systemctl enable --now mariadb
systemctl status mariadb
```

Запускаем скрипт инициализации и настройки
```
sudo mariadb-secure-installation
```
Создаем пользователя и базу
```
mysql -u root -p

CREATE DATABASE semaphoredb;
GRANT ALL PRIVILEGES ON semaphore.* TO 'semaphore'@'localhost' IDENTIFIED BY 'semaphorepass';
exit
```
### Установка PostgreSQL 15

Добавляем репозиторий PostgreSQL
```
sudo apt -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
sudo apt update -y
```
Отключаем модуль postgresql, что не не устанавливался PostgreSQL из дефолтных репозиториев
```
sudo apt -qy module disable postgresql
```
Устанавливаем PostgreSQL 15
```
sudo apt install -y postgresql15-server
```
Инициализируем БД
```
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb
```
Правим конфиг pg_hba.conf
```
sudo nano /var/lib/pgsql/15/data/pg_hba.conf
...
host    all             all             127.0.0.1/32            md5          
# IPv6 local connections:
host    all             all             ::1/128                 md5
...
```
Запускаем PostgreSQL
```
sudo systemctl enable postgresql-15 --now
sudo systemctl status postgresql-15
```
Устанавливаем пароль пользователя postgres
```
sudo -u postgres psql
=# ALTER USER postgres WITH PASSWORD 'PostgreSQLPass';
```
Создаем пользователя и базу для Ansible Semaphore
```
=# CREATE USER semaphore WITH ENCRYPTED PASSWORD 'semaphorepass';
=# CREATE DATABASE semaphoredb OWNER semaphore;
=# GRANT ALL PRIVILEGES ON DATABASE semaphoredb TO semaphore;
=# \l
=# \q
```
### Установка Git
Устанавливаем git, смотрим версию
```
sudo apt -y install git
git --version
```