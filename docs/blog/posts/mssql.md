---
draft: true 
date: 2023-10-17
---
# Microsoft SQL Server

## Переименование сервера MS SQL

Проверить имя:

```sql
select @@Servername
```

Переименовать:

```sql
sp_dropserver "old_name";
GO
sp_addserver "new_name", local;
GO
```

## Скрипт бекапа базы

```sql
RESTORE DATABASE [backup_base_new]
FROM DISK = 'C:\backup_base.bak'
WITH RECOVERY,
FILE=1,
MOVE 'backup_base&' TO 'C:\SQLDB\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\backup_base_new.mdf',
MOVE 'backup_base_log' TO 'C:\SQLDB\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\backup_base_new_log.ldf'
GO
```

## Удаление Log Shipping без второго сервера

![Database Properties](http%3A%2F%2Flh3.googleusercontent.com%2F-8u7Gar1yO54%2FVbBhpg9uqII%2FAAAAAAAAAxk%2FscsPJqqKNRI%2Fimage_thumb%5B5%5D.png)

![Error Deleting Log Shipping Configuration](http%3A%2F%2Flh3.googleusercontent.com%2F-0bXadZHuNDo%2FVbBhqc0arwI%2FAAAAAAAAAxw%2FiTkT7RLZsJQ%2Fimage_thumb%5B7%5D.png)

![image](http%3A%2F%2Flh3.googleusercontent.com%2F-2JVo2aXEBAU%2FVbBhq7Ocz-I%2FAAAAAAAAAyA%2FMB1kTPPthvM%2Fimage_thumb%5B9%5D.png)

Удаление через скрипт

```sql
USE [master]
GO
EXEC sp_delete_log_shipping_primary_secondary @primary_database = '[Database_Name]',
@secondary_server = '[Secondary_Server_Name]',
@secondary_database = '[Database_Name]';
GO
EXEC sp_delete_log_shipping_primary_database @database = '[Database_Name]'
GO
```