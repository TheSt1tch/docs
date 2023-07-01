# Открытие файла VBA

## 1 файл
Для открытия 1 файла и передачи его на дальнейшую обработку, используй этот код:

```vba
avFiles = Application.GetOpenFilename _
      ("Excel files(*.xls*),*.xls*", 1, "Выбери Excel файл", , False)
If VarType(avFiles) = vbBoolean Then
      'была нажата кнопка отмены - выход из процедуры
      Exit Sub
End If
 
Set avFiles1 = Workbooks.Open(Filename:=avFiles)
```

## Несколько файлов
Чтобы открыть много файлов и запустить обработку по ним, используем цикл:

```vba
FilesToOpen = Application.GetOpenFilename _
      (FileFilter:="All files (*.*), *.*", _
      MultiSelect:=True, Title:="Files to Merge")
 
If TypeName(FilesToOpen) = "Boolean" Then
      MsgBox "Не выбрано ни одного файла!"
      Exit Sub
End If
 
'проходим по всем выбранным файлам
x = 1
While x <= UBound(FilesToOpen)
    With Workbooks.Open(FilesToOpen(x)).Sheets(1)
        ...
        ...
    End With
     x = x + 1
Wend
```