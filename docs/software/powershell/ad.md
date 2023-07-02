# Powershell. Active Directory

## Список кто добавлял пользователя в домен
Чтобы узнать кто завел юзера в домен, будем использовать журналы безопасности контроллера домена Active Directory.

При заведении нового пользователя в журнале безопасности контроллера домена (только того DC, на котором создавалась учетная запись) появляется событие с кодом EvenId 4720 (на DC должна быть включена политика аудита Audit account management в политике Default Domain Controller Policy).

В описании этого события содержится строка A user account was created, а затем указан аккаунт, из-под которого была создана новая учетка пользователя AD.

Скрипт для выгрузки всех событий создания аккаунтов из журнала контроллера домена за последние 24 часа может выглядеть следующим образом:

```powershell
$time =  (get-date) - (new-timespan -hour 24)
$filename = Get-Date -Format yyyy.MM.dd
$exportcsv=”c:\ps\ad_users_creators” + $filename + “.csv”
Get-WinEvent -FilterHashtable @{LogName="Security";ID=4720;StartTime=$Time}| Foreach {
    $event = [xml]$_.ToXml()
    if($event)
    {
        $Time = Get-Date $_.TimeCreated -UFormat "%Y-%m-%d %H:%M:%S"
        $CreatorUser = $event.Event.EventData.Data[4]."#text"
        $NewUser = $event.Event.EventData.Data[0]."#text"
        $dc = $event.Event.System.computer
        $dc + “|” + $Time + “|” + $NewUser + “|” + $CreatorUser| out-file $exportcsv -append
    }
}
```
## Список кто последних созданных пользователей
```powershell
$lastday = ((Get-Date).AddDays(-1))
$filename = Get-Date -Format yyyy.MM.dd
$exportcsv=”c:\ps\new_ad_users_” + $filename + “.csv”
Get-ADUser -filter {(whencreated -ge $lastday)} | Export-csv -path $exportcsv
```
## Подсчет количества юзеров с полем
```powershell
(Get-ADUser -Filter {(L -Eq "Склад") -and (Enabled -eq $True)} -SearchBase "OU=user,DC=example,DC=com").count
```
## Вывод юзеров в группе по логинам
```powershell
get-adgroup -filter {name -like "group"} -Properties Members | Get-ADGroupMember | select samaccountname
```

