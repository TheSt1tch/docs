# Установка DialUX на Windows 10

Во время установки потребуется net.framework 3.5, который по умолчанию отключен в win10. для его установки нужно:

```
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:D:\sources\sxs
```

где `D:\sources\sxs `\- путь к дистрибутиву верной версии Windows (работают сетевые пути)

Пример:

```plaintext
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:"\\0400-97srv\distr\ISO\Windows 10 1903 x64 09.19\sources\sxs"
```

!!! warning
    Все выполнять от админа