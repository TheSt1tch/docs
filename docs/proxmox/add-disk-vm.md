# Proxmox VE, проброс физического HDD в виртуальную машину

Периодически так бывает, что нужно подключить к виртуальной машине дополнительный физический диск. Долго расписывать не буду что и как. 

Все решается 1 командой на ноде Proxmox VE:

```bash
qm set <vm_id> -[virtio|sata|ide|scsi][№] [/dev/disk/by-id|/dev/disk/by-uuid]
```

где:

* `vm_id` - номер виртуальной машины (в интерфейсе Proxmox указывается перед именем VM)
* `virtio|sata|ide|scsi` - допустимый тип и номер HDD интерфейса
* `/dev/disk/by-id|/dev/disk/by-uuid` - пробрасываемою физическое устройство

# ID и UUID

Возникает вопрос: где же взять путь `/dev/disk/by-id` или `/dev/disk/by-uuid`.

Все просто, чтобы вывести UUID диска, нужно выполнить:

```bash
blkid /dev/sdb1
```

Так же, можно проверить, есть ли диск в директории /by-uuid:

```bash
ls /dev/disk/by-uuid/
```

Если диска нет, то можно использовать его ID. Чтобы получить идентификатор (серийный номер диска) выполните:

```bash
lshw -class disk -class storage
```

Скопируйте значение serial. Например, *Serial: QP8516N*

Выведите идентификаторы диска и разделов на нем по его серийному номеру:

```bash
ls -l /dev/disk/by-id | grep QP8516N
```

# Команда

Итого. Чтобы пробросить диск по ID, выполняем команду:

```bash
qm set 100 -virtio2 /dev/disk/by-id/scsi-36003005700ba2e00ff00002a02aec9e8
```

А для UUID:

```bash
qm set 100 -virtio2 /dev/disk/by-uuid/0b56138b-6124-4ec4-a7a3-7c503516a65c
```

Проверить, что диск подключился можно в веб-интерфейсе Proxmox, на вкладке Hardware виртуалки или проверив конфигурационный файл ВМ:

```bash
cat /etc/pve/qemu-server/100.conf
```

# Проверка

Должно появится строка вида

```bash
virtio0: volume=/dev/disk/by-uuid/0b56138b-6124-4ec4-a7a3-7c503516a65c
```

или

```bash
sata0: volume=/dev/disk/by-uuid/0b56138b-6124-4ec4-a7a3-7c503516a65c
```


---

Можно почитать [тут](https://pve.proxmox.com/wiki/Passthrough_Physical_Disk_to_Virtual_Machine_(VM)#Check_Configuration_File)