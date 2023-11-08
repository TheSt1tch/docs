# Очистка диска в Windows Server

!!! note
    По умолчанию утилита «Очистка диска» (Disk Cleanup) не установлена.

Её можно получить, доустановив **Desktop Experience**. Однако, зачем на боевом сервере все эти рюшечки? Есть другой простой способ — необходимо скопировать уже имеющийся на диске **cleanmgr.exe** в `%systemroot%\System32` и **cleanmgr.exe.mui** в `%systemroot%\System32\en-US`. В различных редакциях, эти файлы лежат в разных местах.

=== "2008 32bit"

    -   `C:\Windows\winsxs\x86\_microsoft-windows-cleanmgr\_31bf3856ad364e35\_6.0.6001.18000\_none\_6d4436615d8bd133\cleanmgr.exe`
    -   `C:\Windows\winsxs\x86\_microsoft-windows-cleanmgr.resources\_31bf3856ad364e35\_6.0.6001.18000\_en-us\_5dd66fed98a6c5bc\cleanmgr.exe.mui`

=== "2008 64bit"

    -   `C:\Windows\winsxs\amd64\_microsoft-windows-cleanmgr.resources\_31bf3856ad364e35\_6.0.6001.18000\_en-us\_b9f50b71510436f2\cleanmgr.exe.mui`
    -   `C:\Windows\winsxs\amd64\_microsoft-windows-cleanmgr\_31bf3856ad364e35\_6.0.6001.18000\_none\_c962d1e515e94269\cleanmgr.exe.mui`

==="2008 r2"

    -   `C:\Windows\winsxs\amd64\_microsoft-windows-cleanmgr\_31bf3856ad364e35\_6.1.7600.16385\_none\_c9392808773cd7da\cleanmgr.exe`
    -   `C:\Windows\winsxs\amd64\_microsoft-windows-cleanmgr.resources\_31bf3856ad364e35\_6.1.7600.16385\_en-us\_b9cb6194b257cc63\cleanmgr.exe.mui`

После того, как **cleanmgr.exe** оказался в `%systemroot%\System32`, а **cleanmgr.exe.mui** — в `%systemroot%\System32\en-US`, запустить «Очистку диска» можно либо из `%systemroot%\System32`, либо набрав в командной строке `cleanmgr`. Всё будет работать «как обычно».