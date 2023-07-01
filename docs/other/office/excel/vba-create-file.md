# Создание файла VBA

Простое

```vba
iFullName = ThisWorkbook.Path & "name.xlsx"
```
С именем из ячейки:

```vba
iFullName = ThisWorkbook.Path & "\" & Range("A1").Value & ".xlsx"
```