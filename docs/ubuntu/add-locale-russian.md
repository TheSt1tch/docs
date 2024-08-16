# Русский язык для консоли Ubuntu

**Локаль (locale)** — это файл, который содержит таблицу с указанием того, какие символы считать буквами, и как их следует сортировать. Операционная система использует эту таблицу для отображения букв определенного национального алфавита.

После установки чистой системы Linux Ubuntu или Debian, если не был выбран русский ввод и вывод, то их надо установить.

Для начала проверяем, какая локаль установлена:

```
locale
```
Если вывод команды такой:
```
LANG=
LANGUAGE=
LC_CTYPE="POSIX"
LC_NUMERIC="POSIX"
LC_TIME="POSIX"
LC_COLLATE="POSIX"
LC_MONETARY="POSIX"
LC_MESSAGES="POSIX"
LC_PAPER="POSIX"
LC_NAME="POSIX"
LC_ADDRESS="POSIX"
LC_TELEPHONE="POSIX"
LC_MEASUREMENT="POSIX"
LC_IDENTIFICATION="POSIX"
LC_ALL=
```

То нужно настроить локаль.

Выполним команду:
```
dpkg-reconfigure locales
```
Откроется диалоговое окно, в котором необходимо установить нужное значение региональных настроек (локали). 

Выбираем: `ru_RU.UTF-8 UTF-8`

Установим пакет `console-cyrillic`:
```
sudo apt install console-cyrillic
```

Далее необходимо перезагрузить систему командой:
```
reboot
```
После загрузки системы выполним команду:

```
locale
```
В результате должен быть вывод:
```
LANG=ru_RU.UTF-8
LC_CTYPE="ru_RU.UTF-8"
LC_NUMERIC="ru_RU.UTF-8"
LC_TIME="ru_RU.UTF-8"
LC_COLLATE="ru_RU.UTF-8"
LC_MONETARY="ru_RU.UTF-8"
LC_MESSAGES="ru_RU.UTF-8"
LC_PAPER="ru_RU.UTF-8"
LC_NAME="ru_RU.UTF-8"
LC_ADDRESS="ru_RU.UTF-8"
LC_TELEPHONE="ru_RU.UTF-8"
LC_MEASUREMENT="ru_RU.UTF-8"
LC_IDENTIFICATION="ru_RU.UTF-8"
LC_ALL=
```