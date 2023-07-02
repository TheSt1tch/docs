# Резервное копирования на Google Диск

Создаем файл скрипта:
```
nano backup_gdrive.sh
```
заполняем:
```bash
#!/bin/bash
#удаляем файлы которые старше 7дней с g.drive
/usr/sbin/drive list -q "modifiedDate < '$(date -d '-7 day' '+%Y-%m-%d')'" | cut -d" " -f1 - | xargs -L 1 drive delete -i
rsync -avzr --progress /var/www/html/ /var/www/tmp/backup/ >> result.txt
mysqldump joomla > /var/www/tmp/backup/backup.sql
tar -cvzf backup-$(date +%Y%m%d).tar.gz --absolute-names /var/www/tmp/backup/ >> result.txt
#закачиваем файл на g.drive
/usr/sbin/drive upload -f /root/bin/backup*.tar.gz >> result.txt
rm -rf /root/bin/backup*.tar.gz >> result.txt
echo "Посмотрите файл на наличие ошибок и исправьте их" | mail -a "/root/bin/result.txt" -s "Резервная копия создана" -- ******@gmail.com
rm -rf /root/bin/result.txt
rm -rf /var/www/tmp/backup/*
```
Запустив скрипт, он выполнился:
```
sh backup_gdrive.sh

Removed file 'DSC_2151.NEF'
Removed file 'DSC_2153.NEF'
Removed file 'DSC_2159.NEF'
Removed file 'DSC_2226.NEF'
Removed file 'DSC_2225.NEF'
```
Проверим наличие файла в Google Drive:
```
drive list

Id Title Size Created
1oay3-FAWBZRjHtma1cRTLrOvf3t8hRpD backup-20190904.tar.gz 9.6 MB 2019-09-04 14:43:25
```
С веб-интерфейса его так же видно, как и с консоли:
Таким образом мы получаем скрипт, который выполняет проверку на наличие старых бэкапов в облаке Google Диск, удаляет их если они попадают под требования, после чего создает резервную копию сайта и отправляет ее в это же облако.
