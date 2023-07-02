# Резервное копирования на Яндекс.Диск

```bash
#!/bin/bash
rsync -avzr --progress /var/www/html/ /var/www/tmp/backup/ >> result.txt
mysqldump joomla > /var/www/tmp/backup/backup.sql
tar -cvzf backup-$(date +%Y%m%d).tar.gz --absolute-names /var/www/tmp/backup/ >> result.txt
find /mnt/yad/ -name "backup*.tar.gz" -mtime +7 -exec rm -f {} \; >> result.txt
rsync -avzr --progress /root/bin/backup*.tar.gz /mnt/yad/ >> result.txt
rm -rf /root/bin/backup*.tar.gz >> result.txt
echo "Посмотрите файл на наличие ошибок и исправьте их" | mail -a "/root/bin/result.txt" -s "Резервная копия создана" -- ****@gmail.com
rm -rf /root/bin/result.txt
rm -rf /var/www/tmp/backup/*
```
Примеры заданий в кроне:
- `0 0 * * 6 /root/bin/backup.sh` — запускаем скрипт бэкапа каждую субботу в 00-00 
- `0 0 */3 * * /root/bin/backup.sh` — запускаем скрипт бэкапа каждые 3 дня в 00-00