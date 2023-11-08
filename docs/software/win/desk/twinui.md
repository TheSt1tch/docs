# TWINUI в свойствах файла

При открытии jpg/png/bmp при помощи программы по умолчанию, пишет что не найден файл. По умолчанию в свойствах файла стоит **twinui**.

Запускаем **powershell** с админскими правами и вставляем:

```powershell
Repair-WindowsImage -Online –RestoreHealth
```