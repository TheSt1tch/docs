# Exception during scan .. is locked

Столкнулся с такой проблемой, в логах nextcloud стала всплывать ошибка

`Error: opendir(/mnt/downloads/): Failed to open directory: Permission denied at /var/www/html/lib/private/Files/Storage/Local.php#153`

Поиск решения проблемы, привело к запуску команды на сканирование файлов пользователей. Для Docker запускается командой:
```bash
docker exec -ti -u 33 nextcloud php -f /var/www/html/console.php files:scan --all
```

В ходе сканирования файлов пользователей, всплыла новая ошибка:

`Exception while scanning: "files/0e3e13890e7b79a0edc572f53b262079" is locked #0 /volume1/web/nextcloud/lib/private/Files/Storage/Common.php(680)`

Согласно [базе знаний Nextcloud](https://help.nextcloud.com/t/file-is-locked-how-to-unlock/1883), для её решения, нужно:

=== "Вручную отключить состояние блокировки"
    -   Переведите Nextcloud в режим обслуживания: отредактируйте `config/config.php`и измените эту строку:  
        `'maintenance' => true,`
    -   Пустая таблица `oc_file_locks`: используйте такие инструменты, как phpmyadmin, или подключитесь напрямую к своей базе данных и запустите (префикс таблицы по умолчанию — `oc_`, этот префикс может быть другим или даже пустым):  
        `DELETE FROM oc_file_locks WHERE 1`
    -   Отключите режим обслуживания (отменить первый шаг).
    -   Убедитесь, что ваши cron-jobs работают правильно (страница администратора сообщает вам, когда cron запускался в последний раз): [Docs Nextcloud](https://docs.nextcloud.org/server/13/admin_manual/configuration_server/background_jobs_configuration.html)
=== "Постоянное решение"
    -   На вашем **собственном сервере** : используйте Redis для этой функции. Это быстрее, и до сих пор никаких проблем не было зарегистрировано. Вы можете следовать [инструкциям по кэшированию памяти в документах](https://docs.nextcloud.org/server/13/admin_manual/configuration_server/caching_configuration.html#id4)
    -   **Общий хостинг** (Те, кто не может установить Redis): вы можете отключить блокировку файлов, отредактировав файл конфигурации `config/config.php`:  
        `'filelocking.enabled' => false,` однако отключение не является хорошим решением. Вы можете столкнуться с проблемами, когда несколько процессов пытаются записать в файл (особенно онлайн-редакторы в веб-интерфейсе). В однопользовательских и одноклиентских средах это, вероятно, не такая уж проблема. 
    -   У меня поднят [redis](../redis.md) для кеширования с веб-мордой redis-commander, поэтому идем в веб-интерфейс и делаем flushall.
    -   После запускаем сканирование файлов. Проблема решена. Файлы доступны. Ошибок в логе нет.
