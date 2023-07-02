# Установка xRDP

Выполняем обновление пакетов

```bash
apt-get -y update
```

Устанавливаем графическое окружение, сервис xRDP:

```bash
apt-get -y install xfce4 xrdp
```

Настраиваем использование сервером установленной графической оболочки по умолчанию:

```bash
echo xfce4-session >~/.xsession
```

Редактируем файл запуска xRDP с помощью любого редактора, например, nano:

```bash
nano /etc/xrdp/startwm.sh
```

Итоговое содержимое файла должно быть таким:

```sh
#!/bin/sh
 if [ -r /etc/default/locale ]; then
 . /etc/default/locale
 export LANG LANGUAGE
 fi
 startxfce4
```
!!! note
    В конце файла необходимо добавить пустую строку. Сохраните результаты редактирования сочетанием клавиш `Ctrl+O` и выйдите из редактора через `Ctrl +X`. Делаем перезапуск xRDP сервера:

```bash
service xrdp restart
```

Перезапускаем виртуальный сервер выполнив команду:

```bash
reboot
```