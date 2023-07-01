# Исправление примечаний VBA

Бывает так, что ты вставляешь примечания и они уползают вниз при действиях со строками. 

Чтобы такого не было, используй этот макрос:

```vba
Sub align_comments()
Dim x As Comment
For Each x In ActiveSheet.Comments
   x.Shape.Left = x.Parent.Offset(0, 1).Left + 10
   x.Shape.Top = x.Parent.Top
Next
End Sub
```