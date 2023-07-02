# Небольшие заметки по использованию, чтобы не забывать. 

## Перед выполнение скриптового файла

```powershell
set-executionpolicy remotesigned
```

## Получить помощь

```powershell
# помощь по команде Get-Process
get-help Get-Process

# пример использования команды Get-Process
get-help Get-Process -examples

# Получить методы возвращаемого объекта Get-Process
Get-Process| Get-Member

# Узнать тип объекта. В данном случае переменной с каталогом пользователя
$home.GetType()
```

## Операции сравнения

| **Операция** | **без учета регистра** | **с учетом регистра** | **C#** |
| --- | --- | --- | --- |
| равно(equal) | `-eq` | `-ceq` | `==` |
| не равно (not equal) | `-ne` | `-cne` | `!=`  |
| больше чем (greater then) | `-gt` | `-cgt` | `>`  |
| меньше чем (less than) | `-lt` | `-clt` | `<`   |
| больше равно (greater or equal) | `-ge` | `-cge` | `>=` |
| меньше равно (less than or equal) | `-le` | `-cle` | `⇐`   |

## Операции со строками

Полная аналогия с C#. Разбить строку по пробелам

```powershell
$string = "Test string"
$string.split(" ")
```

Ищем в $string первый пробел

```powershell
$string.IndexOf(" ")
```

## Предопределенные переменные

-   `$home` — каталог пользователя 
-   `$NULL` — пусто 
-   `$true` — истина 
-   `$false` — ложь
-   `$DebugPreference` (См. команду `Write-Debug`)
    -   «Continue» выводить отладку
    -   «SilentlyContinue» не выводить отладочную информацию. 

## Работа с файлами

Дописать `$string` новой строкой в файл $file

```powershell
$string | Out-File $file -Append
```

Получить в `$string` содержимое файла $file

```powershell
$string = get-content -Path $file
```

Проверить существование файла

```powershell
Test-Path "C:test.txt"
```

Найти все файлы с определенным расширением расширением в каталоге и подкаталогах. Затем скопировать эти файлы в другой каталог.

```powershell
$flist = get-childitem e:doc* -include *.pdf -recurse
$flist | ForEach-Object{$_.CopyTo("e:docall_pdf" + $_.PSChildName)}
```

Текущий каталог

```powershell
$local = Get-Location
$local.Path # Рабочий каталог
$local.Drive.Root # Корень
$local.Drive.Name # Буква диска
$local.Drive.Used # Использовано диска
$local.Drive.Free # Свободно на диске
```

## Вывод текста на экран

```powershell
# текст на который надо обратить внимание. Выделяется желтым.
Write-Warning("Текст требующий внимания")

# Просто выводит текст
Write-Host("Просто текст")

#включили вывод отладочной информации
$DebugPreference = "Continue"

# вывели отладочную информацию
Write-Debug "Cannot open file."

# отключили отладочную вывод отладочной информации
$DebugPreference = "SilentlyContinue"
```

## Сделать паузу на несколько секунд

```powershell
Start-Sleep -s 15 # Пауза на 15 секунд
```

## Пауза в консоли, до нажатия Enter

```powershell
Read-Host "Нажмите Enter"
```

## Работа с процессами

Задача: убить все процессы с именем Notepad

```powershell
# Способ №1
get-process Notepad | Stop-Process

# Способ №2 (Работает только с одним процессом)
$plist = get-process Notepad
$plist.Kill()

# Способ №3 (то же что и 2, но все процессы)
$plist = get-process Notepad
$plist | ForEach-Object {$_.Kill()}
```

## Получить процессы и даты их запуска

```powershell
Get-Process| Format-Table Name,StartTime -AutoSize
```

## Список сессий RDP

```powershell
$servers = "server1", "server2"
 
$ts = qwinsta /server:$server
$td = ($ts | where { $_ -notlike "*Подключено*" -and $_ -notlike "*services*" -and $_ -notlike "*Прием*"})
foreach ($server in $servers) {
    "Users: $server"
    $td
}
```