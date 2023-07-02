# Удаление папок из Мой компьютер

Многим с момента появления Windows 10 в 2015 не нравилось, что в **Мой компьютер** располагаются папки, такие как Видео; Загрузки; Музыка; Документы; Изображения; Рабочий стол; Объемные объекты. В этом руководстве, я напишу, как можно убрать все папки или только некоторые из них.

## Удалить через реестр

Для начала нужно узнать разрядность вашей операционной системы: зайдите в меню «Пуск» ⇒ параметры ⇒ система ⇒ о системе. Или нажмите на «Этот компьютер» правой клавишей мыши ⇒ выберите свойства ⇒ посмотрите напротив «Тип системы».

Откройте реестр: в строке поиска или в меню выполнить, введите команду `regedit` и нажмите клавишу Enter.

То есть, к примеру вы хотите удалить папку **«Видео»** из **«Этот компьютер»** - вам нужно:
-   в редактор реестра перейти по пути `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\` 
-   Найти и удалить разделы `{A0953C92-50DC-43bf-BE83-3742FED03C9C}` и `{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}`

## Списки разделов

=== "32-х разрядная"

    | Название папки | Путь |
    | --- | --- |
    | Объемные объекты | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}` |
    | Рабочий стол | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}` |
    | Документы | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}` |
    | Загрузки | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {374DE290-123F-4565-9164-39C4925E467B}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {088e3905-0323-4b02-9826-5d99428e115f}`|
    | Музыка | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {1CF1260C-4DD0-4ebb-811F-33C572699FDE}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}` |
    | Изображения | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {24ad3ad4-a569-4530-98e1-ab02f9417aa8}` |
    | Видео | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {A0953C92-50DC-43bf-BE83-3742FED03C9C}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}`|

=== "64-х разрядная"

    | Название папки | Путь |
    | --- | --- |
    | Объемные объекты | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {0DB7E03F-FC29-4DC6-9020-FF41B59E513A}` |
    | Рабочий стол | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}` |
    | Документы | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {d3162b92-9365-467a-956b-92703aca08af}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {d3162b92-9365-467a-956b-92703aca08af}`  |
    | Загрузки | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft \Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft \Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}` |
    | Музыка | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {1CF1260C-4DD0-4ebb-811F-33C572699FDE}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {1CF1260C-4DD0-4ebb-811F-33C572699FDE}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\ {3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}` |
    | Изображения | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft \Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft \Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}` |
    | Видео | `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft \Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft \Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}`<br>`HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}` |