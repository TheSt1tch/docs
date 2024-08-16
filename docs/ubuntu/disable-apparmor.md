# Отключение AppArmor в Ubuntu

**AppArmor** — это модуль безопасности для **Ubuntu** и **Debian** , который применяет политики контроля доступа к приложениям. В определенных средах эти ограничения могут мешать определенным операциям или требовать корректировки. Отключение **AppArmor** может потребоваться для обеспечения совместимости с определенными приложениями или конфигурациями.

В системах, где гибкость имеет решающее значение, например, в средах разработки, может потребоваться отключение или удаление AppArmor. __Этот процесс включает остановку службы, отключение ее запуска при загрузке и удаление пакета AppArmor__ и его зависимостей. Важно понимать последствия для безопасности, поскольку отключение AppArmor снижает защиту системы.

Обычно рекомендуется держать AppArmor включенным в производственных средах. Однако, если ситуация требует этого, отключение AppArmor следует выполнять с осторожностью. Имейте в виду, что некоторые пакеты, такие как snapd , могут переустановить AppArmor при удалении.

## Действия по отключению и удалению AppArmor в Ubuntu и Debian:

1. Откройте терминал в вашей системе.
2. Остановите службу AppArmor .
  ```
  sudo systemctl stop apparmor
  ```
3. Отключить запуск AppArmor при загрузке.
  ```
  sudo systemctl disable apparmor
  
  Synchronizing state of apparmor.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
  Executing: /usr/lib/systemd/systemd-sysv-install disable apparmor
  Removed "/etc/systemd/system/sysinit.target.wants/apparmor.service".
  ```
4. При необходимости удалите пакет AppArmor и его зависимости.
  ```
  sudo apt remove --assume-yes --purge apparmor

  Reading package lists... Done
  Building dependency tree       
  Reading state information... Done
  The following packages will be REMOVED:
    apparmor* snapd*
  0 upgraded, 0 newly installed, 2 to remove and 0 not upgraded.
  After this operation, 122 MB disk space will be freed.
  ##### snipped
  ```

!!! tip

    Это также удалит snapd . Продолжайте, только если вы не используете snapd для управления пакетами. Переустановка snapd также установит AppArmor как зависимость.