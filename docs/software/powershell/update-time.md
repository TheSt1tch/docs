# Обновление времени в Windows из Powershell

## проверка статуса службы W32Time
Проверим статус службы [W32Time](https://docs.microsoft.com/ru-ru/windows-server/networking/windows-time-service/windows-time-service-tools-and-settings). По умолчанию данная служба остановлена на Windows 10 Pro. Powershell должен быть запущен с правами администратора!

```powershell
Get-Service -Name W32Time | Format-Wide -Property Status -Column 1

Stopped
```

Более подробную информацию о сервисе можно узнать выполнив команду:

```powershell
Get-Service W32Time | Select-Object *
```

Получить список требуемых служб:

```powershell
Get-Service W32Time -RequiredServices
```

Теперь, когда вы убедились, что служба остановлена её необходимо запустить. Выполните следующую команду:

```powershell
Start-Service W32Time
```
!!! note

    Обращаю ваше внимание, если powershell не был запущен с правами администратора, то при выполнении команды запуска службы вы получите ошибку.

Никакого вывода о состоянии службы после окончания выполнения команды не будет. Чтобы проверить статус службы повторно выполните команду для проверки статуса службы приведённую выше.

## Синхронизация времени

Выполним следующую команду для обновления времени:

```
w32tm /resync /force
```

По умолчанию время будет браться с ntp-сервера *time.windows.com*. Если необходимо изменить его на другой ntp-сервер:

```
w32tm /config /syncfromflags:manual /manualpeerlist:"0.ru.pool.ntp.org"
w32tm /config /reliable:yes
```

Перезапустите службу w32time:

```powershell
Restart-Service W32Time
```
Проверить, что ntp-сервер изменился:

```
w32tm /query /configuration
```
## Изменение таймзоны

Посмотреть свою временную зону:

```powershell
Get-TimeZone
```

Получить список всех доступных временных зон:

```powershell
Get-TimeZone -ListAvailable
```
Изменить временную зону:

```powershell
Set-TimeZone -Name "Moscow Standard Time"
```
---

Больше об:
- [w32tm](https://docs.microsoft.com/en-us/windows-server/networking/windows-time-service/windows-time-service-tools-and-settings)  
- [Set-TimeZone](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-timezone?view=powershell-6)  
- [Get-TimeZone](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-timezone?view=powershell-6)