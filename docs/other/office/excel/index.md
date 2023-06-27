## Отключение обновления экрана
```vba
Application.ScreenUpdating = False
' в конце
Application.ScreenUpdating = True
```

## Список уникальных значений VBA

```vba
PS = Range("A" & Rows.Count).End(xlUp).Row
Range("N6:N" & PS).AdvancedFilter Action:=xlFilterCopy, CopyToRange:=Range("T11"), Unique:=True
Range("T11:T300").Font.ColorIndex = 5
MsgBox "Создали уникальный список источников"
```