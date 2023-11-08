# Удаление папки WindowsApps 

```bash
takeown /f d:\windowsapps /r
icacls d:\windowsapps /grant administrators:F /t
rd d:\windowsapps /s /q
```