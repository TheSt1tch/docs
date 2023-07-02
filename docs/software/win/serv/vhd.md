# VHD

## Сжатие VHD

Откройте командную строку с правами администратора и наберите в ней:

```plaintext
diskpart
```

Выберите диск, который вы хотите сжать, указав диски и путь к vhd файлу:

```plaintext
select vdisk file="c:\Data\DAT22GB.vhd"
```

Подключите диск в режиме чтения Read-only:

```plaintext
attach vdisk readonly
```

И выполните команду сжатия:

```plaintext
compact vdisk
```

В зависимости от размера виртуального диска, процедура сжатия может занять достаточно продолжительно время.

Если сжатие прошло успешно, появится надпись:

> DiskPart successfully compacted the virtual disk file

Отмонтируйте диск VHD:

```plaintext
detach vdisk
```

## Создание VHD через bat

```bat
@Echo off
Title Creating Virtual Disk (VHD) v5& Cls
setlocal enabledelayedexpansion
CD /D %~dp0

:: Название будущего VHD файла и путь к нему
set vhd="D:\Win7-1.vhd"
:: Размер VHD файла
set mb=25000
:: Задание бувы виртуальному диску
set installdisk=Y:

:: Формирование файла сценария для diskpart
:: ------------------------------------------------------------------
If Exist "%~dp0scene.ini" Del "%~dp0scene.ini"
Echo create vdisk file=%vhd% maximum=%mb% type=fixed >> scene.ini
Echo select vdisk file=%vhd% >> scene.ini
Echo attach vdisk >> scene.ini
Echo online disk noerr >> scene.ini
Echo attributes disk clear readonly noerr >> scene.ini
Echo create partition primary >> scene.ini
Echo online volume noerr >> scene.ini
Echo attributes volume clear readonly noerr >> scene.ini
Echo active >> scene.ini
Echo format quick fs=ntfs label="Win7 VHD" >> scene.ini
Echo assign letter=%installdisk% >> scene.ini

diskpart /s "%~dp0%scene.ini"
timeout /t 2 > Nul
Del "%~dp0scene.ini"
```