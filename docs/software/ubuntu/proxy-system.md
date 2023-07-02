# Настройка прокси на системном уровне

Настроить прокси на системном уровне можно и через конфигурационные файлы (True UNIX-way). Для этого нужно открыть на редактирования с правами root файл */etc/environment* (например `sudo nano /etc/environment`). В конец файла добавим строки:

```plaintext
https_proxy="https://user:pass@proxy:port/"  
http_proxy="http://user:pass@proxy:port/"
ftp_proxy="ftp://user:pass@proxy:port/"
socks_proxy="socks://user:pass@proxy:port/"
```

Если прокси без авторизации, то строки должны быть вида:

```plaintext
<бла-бла>_proxy="https://proxy:port/"
```

Для применения настроек придется пере-загрузиться, изменения в файле /etc/environment вступили в силу при запуске процесса init - родителя всех процессов в системе и именно от него все дочерние процессы унаследуют настройки прокси в переменных окружения.

## Chromium-browser

Также может использовать глобальные настройки и имеет свои. Для того чтобы назначить ему прокси персонально, откройте файл /etc/chromium-browser/default и допишите следующие строки:

```plaintext
CHROMIUM_FLAGS="-proxy-server=адрес:порт"
```

И перезапустите браузер

## APT

В новых версиях умеет работать с глобальными настройками, но в более старых мог работать только с персональными настройками. Сообщенные настройки: в файле `/etc/apt/apt.conf `нужно указать:

```plaintext
Acquire::http::proxy "http://логин:пароль@ip_прокси:порт_прокси/";
Acquire::https::proxy "http://логин:пароль@ip_прокси:порт_прокси/";
Acquire::ftp::proxy "http://логин:пароль@ip_прокси:порт_прокси/";
Acquire::socks::proxy "http://логин:пароль@ip_прокси:порт_прокси/";
Acquire::::Proxy "true";
Если сервер без авторизации, то логин:пароль@ нужно убрать.
```

## Bash

Само собой настройка через `/etc/environment` (описано выше в разделе глобальных настроек) будет работать для всех программ запущенных из терминала. Если вы хотите указать настройки персонально для запускаемой программы, то перед ее запуском нужно выполнить:

```plaintext
export http_proxy='http://логин:пароль@ip_прокси:порт_прокси/'
export ftp_proxy='http://логин:пароль@ip_прокси:порт_прокси/'
```

## wget

Дописываем в файл `/etc/wgetrc` :

```plaintext
proxy-user = username  
proxy-password = password
http_proxy = http://xxx.xxx.xxx.xxx:8080/
ftp_proxy = http://xxx.xxx.xxx.xxx:8080/
use_proxy = on
```

Если прокси без авторизации, то `proxy-user` и `proxy-password` нужно убрать

## apt-add-repository

Многие компании и университеты блокируют все неизвестные порты наружу. Обычно блокируется и порт 11371, используемый утилитой apt-add-repository для добавления репозиториев. Есть простое решение, как получать ключи репозиториев через 80-ый порт, который используется для доступа к web-страницам и чаще всего не блокируется.

Редактируем файл `/usr/lib/python2.6/dist-packages/softwareproperties/ppa.py` (нужны привилегии root, вместо */usr/lib/python2.6* может быть версия *2.7*). Ищем фразу `keyserver.ubuntu.com`, заменяем

```plaintext
hkp://keyserver.ubuntu.com
```

на

```plaintext
hkp://keyserver.ubuntu.com:80
```

В версии 16.04 достаточно иметь настроенной переменную окружения

```plaintext
https_proxy="https://user:pass@proxy:port/"
```