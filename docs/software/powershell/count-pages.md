# Скрипт для отправки статистики по отпечатанным страницам принтеров на почту

```powershell
function Send-Email {
$SMTPServer = "smtp.example.ru"
$port = 587
$EmailFrom = "test@example.ru" 
$EmailTo = "list@example.ru"
$Body = "Статистика по печати за  $(get-date -f dd.MM.yyyy)"
$EmailSubject = "Статистика по печати за  $(get-date -f dd.MM.yyyy)"
$EmailUser = "admin@example.ru"
$EmailPass = "password"
$Date = $(get-date -f yyyy.MM.dd)
$File = "c:\count\$Date.txt"
 
$Message = New-Object System.Net.Mail.MailMessage $EmailFrom, $EmailTo
$Att  = New-object Net.Mail.Attachment($File)
$Message.Subject = $EmailSubject
$Message.IsBodyHTML = $True
$Message.Body = $Body
$Message.Attachments.Add($Att)
$SMTP = New-Object Net.Mail.SmtpClient($SMTPServer)
 
$SMTP.Credentials = New-Object System.Net.NetworkCredential($EmailUser, $EmailPass);
$SMTP.Send($Message)
$att.Dispose()
}
 
 
function Get-InfoPrintersKyocera {
$snmp = New-Object -ComObject olePrn.OleSNMP
cls
foreach ($n in 1..119)
{
    # IP можно изменить на свой
    $ip = "192.168.1.$n"
    if (Test-Connection $ip -Quiet -Count 2)
    {
        $snmp.open($ip, 'public', 1, 3000)
    }
    else {Continue}
  
    Try {$model = $snmp.Get('.1.3.6.1.2.1.25.3.2.1.3.1')}
    Catch {Continue}
  
    New-Object PSObject -Property ([ordered]@{
        "Serial Number"  = $snmp.Get('.1.3.6.1.4.1.1347.43.5.1.1.28.1')
        "PrinterModel"   = $model
        "IP"             = $ip
#       "Description"    = $snmp.Get('.1.3.6.1.2.1.1.1.0')
        "TotalPageCount" = $snmp.Get('.1.3.6.1.4.1.1347.43.10.1.1.12.1.1')
        "Date"           = $(get-date -f dd.MM.yyyy)
    })
  
}
 
}
 
Get-InfoPrintersKyocera | export-csv -NoTypeInformation -encoding UTF8 "C:\count\$(get-date -f yyyy.MM.dd)-PrinterCount.csv"
 
Send-Email
```