# MySQL / MariaDB

## Настройки

Список настроечных параметров и их значения

```sql
mysqld --verbose --help
```

## Управление пользователями

Список пользователей

```sql
mysql> SELECT User,Host FROM mysql.user;
```

Список прав у пользователя root@localhost

```sql
mysql> SHOW GRANTS FOR root@localhost;
```

Создание нового пользователя

```sql
mysql> CREATE USER 'user'@'localhost' IDENTIFIED BY 'secret';
```

Добавим выбранные привилегии для всех таблиц БД *dbname* пользователю *'user'@'localhost'*

```sql
mysql> GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER,INDEX 
ON dbname.* TO 'user'@'localhost';
```

Добавим все привилегии для всех таблиц БД *dbname* пользователю *'user'@'localhost'*

```sql
mysql> GRANT ALL PRIVILEGES ON dbname.* TO 'user'@'localhost';
```

Удаление прав пользователя 'user'@'localhost' для БД *dbname*:

```sql
mysql> REVOKE ALL ON dbname.* FROM 'user'@'localhost';
```

Удаление пользователя:

```sql
mysql> DROP USER user@localhost;
```

Перезагрузка привилегий

```sql
mysql> FLUSH PRIVILEGES;
```

Новый пароль для root

```sql
$ mysqladmin -uroot password 'secret'
```

## Управление базой данных

Создание базы данных

```sql
mysql> CREATE DATABASE dbname COLLATE utf8_general_ci;
```

Создание базы данных из консоли

```sql
$ mysqladmin -u root -p create dbname
```

Удаления базы данных из консоли

```sql
mysqladmin -u root -p drop dbname
```

## Другие sql-команды

Замена в поле определенной подстроки на другую

```sql
mysql> UPDATE table SET field=replace(field, 'original string', 'new string');
```

Вставка данных из одной таблицы в другую

```sql
mysql> INSERT INTO table1 (fld1, fld2) SELECT table2.fld1, table2.fld2 FROM table2 WHERE table2.fld2 > 7;
```

Просмотр структуры таблицы blog\_posts

```sql
mysql> DESCRIBE blog_posts;
```

Просмотр sql-запроса на создание структуры таблицы blog\_posts

```sql
mysql> SHOW CREATE TABLE  blog_posts;
```

## Мониторинг и статистика

Список всех баз данных

```sql
mysql> SHOW DATABASES;
```

Список всех таблиц в выбранной базе данных

```sql
mysql> SHOW TABLES;
```

Статистика по работе сервера

```sql
mysql> SHOW GLOBAL STATUS;
```

-   [Install Innotop to Monitor MySQL Server Performance](http://www.tecmint.com/install-innotop-to-monitor-mysql-server-performance/)
-   [Install Mtop (MySQL Database Server Monitoring)](http://www.tecmint.com/install-mtop-mysql-database-server-monitoring-in-rhel-centos-6-5-4-fedora-17-12/)
-   [Check The Number Of MySQL Open Database Connections on Linux Or Unix-like Server](http://www.cyberciti.biz/faq/howto-show-mysql-open-database-connections-on-linux-unix/)

## Оптимизация баз данных

При помощи команды mysqlcheck можно выполнять проверку, оптимизацию и исправление ошибок.

Поверка на ошибки БД dbname

```sql
$ mysqlcheck -p dbname
```

Восстановление и оптимизация всех БД

```sql
$ mysqlcheck -Aor -p
```

Описание аргументов

-   `-p` – использовать пароль
-   `-A` – проверять все базы данных
-   `-r` – ремонтировать БД
-   `-o` – оптимизировать БД

Скрипт простой оптимизации БД, можно добавить в крон для выполнение раз в сутки

```sql
mysqlcheck --repair --analyze --optimize --all-databases --auto-repair -u root -p SECRET
```

## Изменение строки приглашения (prompt)

В`  ~/.my.cnf  `добавим

```sql
[client]
default-character-set = 'utf8'
pager = 'less -n -i -S'
prompt = '\u@\h [\d] > '
user = 'root'
password = 'secret'
```

Делают эти настройки следующие

-   устанавливаем кодировку по-умолчанию в utf8
-   используем less для вывода результатов запроса
-   меняем строку приглашения, \\u - пользователь, \\h - хост, \\d - база данных
-   указываем логин и пароль для mysql-консоли, удобно при разработке на локальном сервере

## Дамп (резервная копия)

Дамп базы данных

```sql
$ mysqldump -uroot -p dbname > dump.sql
```

Дамп выбранных баз

```sql
$ mysqldump -uroot -p -B dbname1 dbname2 > dump.sql
```

Дамп всех баз

```sql
$ mysqldump -uroot -p -A > dump.sql
```

Дамп только структуры, без данных

```sql
$ mysqldump -uroot -p --no-data dbname > database.sql
```

Другие опции

-   `--add-drop-tabl`e - добавляет команду DROP TABLE перед каждой командой CREATE TABLE
-   `--add-locks` - добавляет команду LOCK TABLES перед выполнением и UNLOCK TABLE после выполнения каждого дампа таблицы
-   `--no-create-db, -n` - не добавлять команду CREATE DATABASE, которая добавляется при использовании параметров --databases и --all-databases
-   `--no-data, -d` - дампить только структуру таблиц
-   `--no-create-info, -t` - не создавать команду CREATE TABLE
-   `--skip-comments` - не выводить комментарии.
-   `--compact` - использовать компактный формат
-   `--create-options` - добавляет дополнительную информацию о таблице в команду CREATE TABLE: тип, значение AUTO\_INCREMENT и т.д. Не нужные опции можно вырезать с помощью sed.
-   `--extended-insert, -e` - применение команды INSERT с многострочным синтаксисом (повышает компактность и быстродействие операторов ввода)
-   `--tables` - дампить только таблицы из списка, следующего за этим параметром, разделитель - пробел

Применение дампа

```sql
$ mysql -uroot -p dbname1 < dump.sql
```

## Изменение кодировка для текстового поля

Список полей для таблицы table с информацией о поле, в том числе и кодировка поля

```sql
SHOW FULL COLUMNS FROM table;
```

Меняем charset для поля field

```sql
ALTER TABLE table MODIFY field VARCHAR(255) CHARACTER SET utf8;
```

## Изменение кодировка при импорте с дампа

Определение кодировки файла

```sql
file --mime-encoding dump.sql
```

Конвертирование из кодировки latin1 в utf8

```sql
mysqldump --add-drop-table -uroot -p dbname | replace CHARSET=latin1 CHARSET=utf8 | iconv -f latin1 -t utf8 | mysql -uroot -p dbname
```

## Восстановление root-пароля

```sql
$ service mysqld stop
$ mysqld_safe --skip-grant-tables &
$ mysql
mysql> UPDATE mysql.user SET Password=PASSWORD('secret') WHERE User='root';
mysql> FLUSH PRIVILEGES;
$ service mysqld restart
```

## MySQL + Python

Иногда при компиляция MySQL-python может выскочить такая ошибка *configure: error: mysql\_config executable not found*, это значит, что не установлен пакет _libmysqlclient15-dev_. Под Ubuntu устанавливается так

```sql
sudo apt-get install libmysqlclient15-dev
```

## Перенос директории с данным (data directory)

Останавливаем MySQL

```sql
service mysqld stop
```

Копируем существующею директорию с данными в новое место

```sql
mkdir -p /path/new/dir
sudo chown -R mysql:mysql /path/new/dir
sudo cp -R -p /var/lib/mysql /path/new/dir
```

Укажем в my.cnf путь к новой директории, секция mysqld

```sql
# sudo vim /etc/mysql/my.cnf

[mysqld]
datadir=/path/new/dir/mysql
```

Запускаем MySQL

```sql
service mysqld start
```

## Как конвертировать MyISAM в InnoDB

Просмотр всех таблиц и их типов

```sql
SELECT TABLE_NAME, ENGINE
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'database' and ENGINE = 'myISAM'
```

Следущая комманда конвертирует таблицу в InnoDB

```sql
ALTER TABLE table1 ENGINE=InnoDB;
```