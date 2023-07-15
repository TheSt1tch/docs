# Установка MariaDB на Ubuntu Server 22

[MariaDB](https://mariadb.org/) — это система управления реляционными базами данных с открытым исходным кодом, обычно используемая в качестве альтернативы MySQL.

Краткая версия этого руководства по установке состоит из следующих трех шагов:

-   Обновите индекс вашего пакета, используя`apt`
-   Установите `mariadb-server`пакет с помощью `apt`. Пакет также включает соответствующие инструменты для взаимодействия с MariaDB.
-   Запустите включенный `mysql_secure_installation`скрипт безопасности, чтобы ограничить доступ к серверу

```bash
sudo apt update
sudo apt install mariadb-server
sudo mysql_secure_installation
```

Далее я распишу подробнее все шаги и как проверить, что база работает и имеет безопасную конфигурацию.

## Установка MariaDB

На момент написания этой статьи репозитории APT по умолчанию в Ubuntu 22.04 включают версию MariaDB 10.11.4

Чтобы установить его, обновите индекс пакета на вашем сервере с помощью `apt`:

```bash
sudo apt update
```

Затем установите пакет:

```bash
sudo apt install mariadb-server
```

Эти команды установят MariaDB, но не предложат установить пароль или внести какие-либо другие изменения в конфигурацию. Поскольку конфигурация по умолчанию оставляет вашу установку MariaDB небезопасной, вы будете использовать сценарий, предоставляемый пакетом, `mariadb-server`для ограничения доступа к серверу и удаления неиспользуемых учетных записей.

## Настройка MariaDB

Далее запускаем предлагаемый сценарий настройки безопасности. Этот сценарий изменяет некоторые из менее безопасных параметров по умолчанию для таких вещей, как удаленный вход в систему **root** и пользователей.

Запустите скрипт безопасности:

```bash
sudo mysql_secure_installation
```

После ввода команды, сценарий установки задаст несколько вопросов, позволяющих внести изменения в параметры безопасности MariaDB. 
Первый вопрос просит ввести пароль **root** базы данных. Так как это чистая установка, нажимаем `ENTER`, чтобы указать нет

```
NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, you'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.

Enter current password for root (enter for none):
```
Далее запрос на переключение авторизации сокетов unix. У нас есть уже защищенная учетная запись **root**, поэтому пропускаем этот шаг и нажимаем `n`, а затем `ENTER`

```
. . .
Setting the root password or using the unix_socket ensures that nobody
can log into the MariaDB root user without the proper authorisation.

You already have your root account protected, so you can safely answer 'n'.

Switch to unix_socket authentication [Y/n] n
```
Следующий блок спрашивает, установить ли пароль **root** для базы данных. В Ubuntu **корневая** учетная запись для MariaDB тесно связана с обслуживанием системы, поэтому не следует изменять настроенные методы аутентификации для этой учетной записи. Вводим `n`, а затем нажимаем `ENTER`.

```
. . .
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n] n
```

Позже вы узнаете, как настроить дополнительную учетную запись администратора для доступа по паролю, если аутентификация через сокет не подходит для использования.

> Если же нужно настроить пароль для учетной записи **root**, то
> необходимо выполнить эти команды в **MariaDB**:
> 
> `mariadb; > ALTER USER 'root'@'localhost' IDENTIFIED BY
> 'MyN3wP4ssw0rd'; flush privileges; exit; `

На все последующие вопросы отвечаем `Y`, а затем `ENTER`, чтобы принять значения по умолчанию. Это удалит некоторых анонимных пользователей и тестовую базу данных, отключит удаленный вход в **систему root** и загрузит эти новые правила, чтобы MariaDB немедленно реализовала внесенные изменения.

На этом мы завершили первоначальную настройку безопасности MariaDB. Далее я распишу, что нужно сделать, чтобы аутентифицироваться на своем сервере MariaDB с помощью пароля.

## Создание пользователя-администратора, использующего аутентификацию по паролю

Теперь создадим отдельную учетную запись с правами **root** для доступа на основе пароля. 
Открываем командную строку MariaDB с вашего терминала:

```bash
sudo mariadb
```
Затем создаем нового пользователя с привилегиями **root** и доступом на основе пароля. 

> Не забываем изменить имя пользователя и пароль на те, что нужны

```sql
GRANT ALL ON *.* TO 'admin'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;
```

Сбрасываем привелегии, чтобы убедиться, что они сохранены и доступны в текущем сеансе:

```sql
FLUSH PRIVILEGES;
```
 И выходим из оболочки MariaDB:

```sql
exit
```

Теперь протестируем установку MariaDB.

## Тестирование MariaDB

При установке из репозиториев по умолчанию MariaDB запустится автоматически. Чтобы проверить это, проверим статус.

```bash
sudo systemctl status mariadb
```
Вывод будет примерно таким:

```
● mariadb.service - MariaDB 10.11.4 database server
     Loaded: loaded (/lib/systemd/system/mariadb.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/mariadb.service.d
             └─migrated-from-my.cnf-settings.conf
     Active: active (running) since Fri 2023-06-09 22:54:09 +05; 13h ago
       Docs: man:mariadbd(8)
             https://mariadb.com/kb/en/library/systemd/
   Main PID: 416609 (mariadbd)
     Status: "Taking your SQL requests now..."
      Tasks: 8 (limit: 4571)
     Memory: 78.4M
        CPU: 8.879s
     CGroup: /system.slice/mariadb.service
             └─416609 /usr/sbin/mariadbd
```

Если MariaDB не запущена, можно запустить ее с помощью команды `sudo systemctl start mariadb`.

Для дополнительной проверки, можно попробовать подключиться к базе данных с помощью инструмента `mysqladmin`, который представляет собой клиент, позволяющий выполнять административные команды. 
Например, эта команда предлагает подключиться к MariaDB от имени **пользователя root** , используя сокет Unix, и вернуть версию:

```
sudo mysqladmin version
```

Вывод:

```
mysqladmin  Ver 9.1 Distrib 10.11.4-MariaDB, for debian-linux-gnu on x86_64
Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Server version          10.11.4-MariaDB-1:10.11.4+maria~ubu2210
Protocol version        10
Connection              Localhost via UNIX socket
UNIX socket             /run/mysqld/mysqld.sock
Uptime:                 14 hours 17 min 25 sec

Threads: 1  Questions: 76  Slow queries: 0  Opens: 33  Open tables: 26  Queries per second avg: 0.001
```

## 
