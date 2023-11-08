# Настройка cron

запустить редактор crontab
```
crontab -e
```
В редакторе добавляем:
```
*/5  *  *  *  * docker exec -u www-data nextcloud php cron.php
```
