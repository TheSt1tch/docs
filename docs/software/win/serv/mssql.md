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