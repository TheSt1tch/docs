# Проблемы с доступом после перемещения `data`

Иногда так бывает, что при переносе `data` папки используя [инструкцию](https://help.nextcloud.com/t/howto-change-move-data-directory-after-installation/17170) возникают проблемы. 
Одна из них - не возможность удалять или добавлять новые файлы. 
При выполнении команды `sudo -u www-data php -f /var/www/html/nextcloud/console.php files:scan --all`, будет выходить ошибка: `Exception: Environment not properly prepared.`

## Решение

Ошибка идет из-за того, что неверно выданы права на папку `data`. Права должны быть у юзера `www-data`:

```bash
chown -R www-data:www-data /path/to/nextcloud
find /path/to/nextcloud/ -type d -exec chmod 750 {} \;
find /path/to/nextcloud/ -type f -exec chmod 640 {} \;
```