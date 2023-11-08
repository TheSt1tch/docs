# Proxmox VE

## Failed to run lxc.hook.pre-start for container <ID>

После добавления диска в систему, перестали запускаться контейнер. Гугление показало, что можно посмотреть через команду `pct start <id>`, что мешает запуску.

```bash
root@pve:~# pct start 101
run_buffer: 322 Script exited with status 2
lxc_init: 844 Failed to run lxc.hook.pre-start for container "101"
__lxc_start: 2027 Failed to initialize container "101"
startup for container '101' failed
```

Это тоже самое, что выводит web-gui при запуске контейнера в логах. 

Далее, попробуем смонтировать ресурсы контейнера на хосте, используя команду `pct mount <id>`

```bash
root@pve:~# pct mount 101
mounting container failed
directory '/dev/sda1 does not exist
```
После этого надо смотреть, что не так с диском. 

В моем случае было, что из-за добавления диска, перестал работать один из портов на мат.плате.