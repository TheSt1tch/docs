# Яндекс.Диск через WebDAV

WebDAV — набор расширений и дополнений к протоколу HTTP , поддерживающих совместную работу над редактированием файлов и управление файлами на удаленных серверах.

Пакет `davfs2` уже должен быть установлен в системе, но если нет, установим. Нужно подключить репозиторий Epel и установить сам пакет через yum:

```
apt install epel-release -y 
apt install davfs2 -y
```
Проверяем, что модуль **fuse** на машине присутствует:
```
ls -l /dev/fuse
```
Вывод должен быть примерно таким:
```
ls -l /dev/fuse
crw-rw-rw- 1 root root 10, 229 Sep 2 09:54 /dev/fuse
```
Создаем отдельную директорию для нашего облачного хранилища:
```

mkdir /mnt/yad/
```
Монтируем Яндекс.Диск к созданной ранее директории:
```
mount -t davfs https://webdav.yandex.ru /mnt/yad/
```
После ввода команды, в консоли выйдут поля, где нужно будет указать ваш почтовый ящик на Яндексе и пароль от него
```
Username: 
Password:
```
У меня диск подключился без проблем:
```
$ df -h

Filesystem Size Used Avail Use% 
Mounted on 
/dev/vda2 80G 1.2G 79G 2% 
/ devtmpfs 1.9G 0 1.9G 0% 
/dev tmpfs 1.9G 0 1.9G 0% 
/dev/shm tmpfs 1.9G 8.5M 1.9G 1% 
/run tmpfs 1.9G 0 1.9G 0% 
/sys/fs/cgroup 
/dev/vda1 240M 109M 115M 49% 
/boot tmpfs 379M 0 379M 0% 
/run/user/0 
https://webdav.yandex.ru 10G 39M 10G 1% /mnt/yad 
```
По-умолчанию Яндекс предлагает всем своим пользователям бесплатно 10 Гб на облачном Яндекс.Диске.

И сразу можно убедиться, что содержимое Яндекс.Диска теперь доступно в Linux:
```
$ ls -la 
/mnt/yad/ 

total 39867 
drwxr-xr-x 3 root root 392 Apr 5 2012 . 
drwx—— 2 root root 0 Sep 2 11:56 lost+found 
-rw-r–r– 1 root root 1762478 Sep 2 11:54 Горы.jpg 
-rw-r–r– 1 root root 1394575 Sep 2 11:54 Зима.jpg 
-rw-r–r– 1 root root 1555830 Sep 2 11:54 Мишки.jpg 
-rw-r–r– 1 root root 1080301 Sep 2 11:54 Море.jpg 
-rw-r–r– 1 root root 1454228 Sep 2 11:54 Москва.jpg 
-rw-r–r– 1 root root 2573704 Sep 2 11:54 Санкт-Петербург.jpg 
-rw-r–r– 1 root root 31000079 Sep 2 11:54 Хлебные крошки.mp4
```
Создадим файл в подключеном WebDav каталоге файлы и проверим, что он появился в веб-версии Яндекс.Диска:
```
$ touch /mnt/yad/test.txt 
$ls -la 
/mnt/yad/ 

 total 39867 
drwxr-xr-x 3 root root 424 Apr 5 2012 . 
drwx—— 2 root root 0 Sep 2 11:56 lost+found 
-rw-r–r– 1 root root 0 Sep 2 12:08 test.txt 
```
Файл появился, наше подключение к облачному хранилищу Яндекс.Диск работает нормально, локальный файл автоматически синхронизируется с облаком.

Для упрощения монтирования, добавим его в `rc.local`, чтобы после рестарта сервера, хранилище Яндекс.Диск монтировалось автоматически.

Для этого, создаем файл `/etc/davfs2/secrets`:
```
touch /etc/davfs2/secrets
```
и добавляем туда путь до директории, в которую монтируем Яндекс.Диск и логин/пароль пользователя Яндекс:
```
/mnt/yad user password
```
В `rc.local` добавляем следующую строку:
```
mount -t davfs https://webdav.yandex.ru /mnt/yad/
```
Делаем рестарт Linux и проверяем доступность облачного диска:
```
mount -t davfs _https://webdav.yandex.ru /mnt/yad/
```
Если файл `rc.local` не читается при запуске сервера, в таком случае для автозапуска сервиса rc-local выполните следующие команды:
```
chmod +x /etc/rc.d/rc.local 
systemctl enable rc-local 
```
