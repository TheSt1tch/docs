# Отправка почты VBA

отправляет почту, используя для этого запущенный MS Outlook

```vba
' Запрос ввода темы письма
    Dim vRetVal
        vRetVal = InputBox("Введи тему письма", "Тема", "Test")
    ActiveSheet.Range("I3").Value = vRetVal
 
        Dim OutApp As Object
        Dim OutMail As Object
        Dim cell As Range
         
        Send_ist = Cells(1, 1)
          
        Application.ScreenUpdating = False
        Set OutApp = CreateObject("Outlook.Application")
        OutApp.Session.Logon
        Set OutMail = OutApp.CreateItem(0)
        On Error Resume Next
        With OutMail
            .To = Send_ist
            .Body = "Заполнить в день получения и отправить обратно на your_email"
            .Subject = Range("A1").Value
            .Attachments.Add iFullName
            .Send
        End With
 
        On Error GoTo 0
        Set OutMail = Nothing
```