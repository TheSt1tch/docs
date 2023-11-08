# LVM - Logical Volume Manager

Logical Volume Manager (LVM) - это очень мощная система управления томами с данными для Linux. Она позволяет создавать поверх физических разделов (или даже неразбитых винчестеров) логические тома, которые в самой системе будут видны как обычные блочные устройства с данными (т.е. как обычные разделы). 

Основные преимущества LVM в том, что во-первых одну группу логических томов можно создавать поверх любого количества физических разделов, а во-вторых размер логических томов можно легко менять прямо во время работы. Кроме того, LVM поддерживает механизм снапшотов, копирование разделов «на лету» и зеркалирование, подобное RAID-1.

Если планируются большие работы с LVM, то можно запустить специальную оболочку командой `sudo lvm`. Команда `help` покажет список команд.

## Создание и удаление

Большинство команд требуют [прав суперпользователя](https://help.ubuntu.ru/wiki/%D1%81%D1%83%D0%BF%D0%B5%D1%80%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D1%82%D0%B5%D0%BB%D1%8C_%D0%B2_ubuntu).

Как уже отмечалось, LVM строится на основе разделов жёсткого диска и/или целых жёстких дисков. На каждом из дисков/разделов должен быть создан **физический том** (physical volume). К примеру, мы используем для LVM диск *sda* и раздел *sdb2*:
```
pvcreate /dev/sda
pvcreate /dev/sdb2
```
На этих физических томах создаём **группу томов**, которая будет называться, скажем, `vg1`:
```
vgcreate -s 32M vg1 /dev/sda /dev/sdb2
```
Посмотрим информацию о нашей группе томов:
```
vgdisplay vg1
```
Групп можно создать несколько, каждая со своим набором томов. Но обычно это не требуется.

Теперь в группе томов можно создать **логические тома** `lv1` и `lv2` размером 20 Гбайт и 30 Гбайт соответственно:
```
lvcreate -n lv1 -L 20G vg1
lvcreate -n lv2 -L 30G vg1
```
Теперь у нас есть блочные устройства `/dev/vg1/lv1` и `/dev/vg1/lv2`.

Осталось создать на них файловую систему. Тут различий с обычными разделами нет:
```
mkfs.ext4 /dev/vg1/lv1 
mkfs.reiserfs /dev/vg1/lv2
```
Удаление LVM (или отдельных его частей, например, логических томов или групп томов) происходит в обратном порядке - сначала нужно отмонтировать разделы, затем удалить логические тома (`lvremove`), после этого можно удалить группы томов (`vgremove`) и ненужные физические тома (`pvremove`).

## Добавление физических томов

Чтобы добавить новый винчестер `sdc` в группу томов, создадим физический том:
```
pvcreate /dev/sdc
```
И добавим его в нашу группу:
```
vgextend vg1 /dev/sdc
```
Теперь можно создать ещё один логический диск (`lvcreate`) или увеличить размер существующего (`lvresize`).

## Удаление физических томов

Чтобы убрать из работающей группы томов винчестер `sda` сначала перенесём все данные с него на другие диски:
```
pvmove /dev/sda
```
Затем удалим его из группы томов:
```
vgreduce vg1 /dev/sda
```
И, наконец, удалим физический том:
```
pvremove /dev/sda
```
Вообще-то, последняя команда просто убирает отметку о том, что диск является членом lvm, и особой пользы не приносит. После удаления из LVM для дальнейшего использования диск придётся переразбивать/переформатировать.

## Изменение размеров

LVM позволяет легко изменять размер логических томов. Для этого нужно сначала изменить сам логический том:
```
lvresize -L 40G vg1/lv2
```
а затем файловую систему на нём:
```
resize2fs /dev/vg1/lv2
resize_reiserfs /dev/vg1/lv2
```
Изменение размеров физического тома - задача весьма сложная и обычно не применяется. Целесообразнее и безопаснее удалить физический том, изменить размер раздела и создать том заново.

## Как просто попробовать

Если LVM устанавливается не для дальнейшего использования, а «напосмотреть», то диски и разделы можно заменить файлами. Не понадобятся ни дополнительные диски, ни виртуальные машины. Мы создадим виртуальные накопители и будем с ними работать. Например, можно создать 4 диска по 1 Гбайт, но можно создать другое количество большего или меньшего размера как вам хочется. Создаем сами файлы, имитирующие устройства:
```
mkdir /mnt/sdc1/lvm
cd /mnt/sdc1/lvm 
dd if=/dev/zero of=./d01 count=1 bs=1G
dd if=/dev/zero of=./d02 count=1 bs=1G 
dd if=/dev/zero of=./d03 count=1 bs=1G
dd if=/dev/zero of=./d04 count=1 bs=1G
```
Создаем loopback устройства из файлов:
```
losetup -f --show ./d01
losetup -f --show ./d02
losetup -f --show ./d03 
losetup -f --show ./d04
```
Дальше поступаем так же, как если бы ми создавали LVM на реальных дисках. Обратите внимание на названия loop-устройств — они могут отличаться от приведённых здесь.
```
pvcreate /dev/loop0  
pvcreate /dev/loop1  
pvcreate /dev/loop2
pvcreate /dev/loop3
vgcreate -s 32M vg /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
lvcreate -n first -L 2G vg 
lvcreate -n second -L 400M vg 
...
```
## Смена имени LVM группы

### Измените имя группы томов

Утилита [**vgrename**](http://man.cx/vgrename(8)) будет использоваться для изменения имени тома LVM с `nst_localhost` на `nst20`:

```plaintext
vgrename -v nst_localhost nst20
```

### Обновите файл конфигурации файловой системы: /etc/fstab

Используйте редактор (например, **nano** ), чтобы изменить имя устройства отображения группы томов LVM в файле конфигурации файловой системы: `/etc/fstab` на новое имя **nst20** для **root** и **swap** логических томов.

**До:**

```plaintext
[root@localhost ~]# cat /etc/fstab

/dev/mapper/nst_localhost-root /                       ext4    defaults        1 1
UUID=8c72887d-d7db-4a3d-9b09-0d619fc11d9c /boot                   ext4    defaults        1 2
/dev/mapper/nst_localhost-swap swap                    swap    defaults        0 0
```

**После:**

```plaintext
[root@localhost ~]# cat /etc/fstab

/dev/mapper/nst20-root /                       ext4    defaults        1 1
UUID=8c72887d-d7db-4a3d-9b09-0d619fc11d9c /boot                   ext4    defaults        1 2
/dev/mapper/nst20-swap swap                    swap    defaults        0 0
```

### Обновите файл конфигурации Grub2: /boot/grub2/grub.cfg

Используйте редактор (например, **nano** ), чтобы изменить имя устройства отображения группы томов LVM в файле конфигурации файловой системы: `/boot/grub2/grub.cfg` на новое имя **nst20** для **root** и **swap** . Логические тома для всех соответствующих записей.

**До**

!!! note "Примечание"
    Для примера показан только один пункт меню Grub2. Необходимо изменить все соответствующие записи.

??? info
    ```plaintext
    .
    .
    .
    menuentry " ---------------------NST 20 (64 Bit) Boot Choices---------------------" {
    true
    }

    menuentry 'Console, Kernel: 3.12.5-302.fc20.x86_64' --class nst --class gnu-linux --class gnu --class os {
            savedefault
        load_video
            set gfxpayload=keep
            insmod gzio
            insmod part_msdos
            insmod ext2
            set root='hd0,msdos1'
            if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 --hint='hd0,msdos1'  8c72887d-d7db-4a3d-9b09-0d619fc11d9c
            else
            search --no-floppy --fs-uuid --set=root 8c72887d-d7db-4a3d-9b09-0d619fc11d9c
            fi
            echo    'Loading Linux 3.12.5-302.fc20.x86_64 ...'
            linux   /vmlinuz-3.12.5-302.fc20.x86_64 root=/dev/mapper/nst_localhost-root ro rd.lvm.lv=nst_localhost/swap rd.lvm.lv=nst_localhost/root vconsole.font=latarcyrheb-sun16 crashkernel=auto systemd.unit=multi-user.target
            echo    'Loading initial ramdisk ...'
            initrd  /initramfs-3.12.5-302.fc20.x86_64.img
    }
    .
    .
    .
    ```

**После:**

??? info

    ```plaintext
    .
    .
    .
    menuentry " ---------------------NST 20 (64 Bit) Boot Choices---------------------" {
    true
    }

    menuentry 'Console, Kernel: 3.12.5-302.fc20.x86_64' --class nst --class gnu-linux --class gnu --class os {
            savedefault
        load_video
            set gfxpayload=keep
            insmod gzio
            insmod part_msdos
            insmod ext2
            set root='hd0,msdos1'
            if [ x$feature_platform_search_hint = xy ]; then
            search --no-floppy --fs-uuid --set=root --hint-bios=hd0,msdos1 --hint-efi=hd0,msdos1 --hint-baremetal=ahci0,msdos1 --hint='hd0,msdos1'  8c72887d-d7db-4a3d-9b09-0d619fc11d9c
            else
            search --no-floppy --fs-uuid --set=root 8c72887d-d7db-4a3d-9b09-0d619fc11d9c
            fi
            echo    'Loading Linux 3.12.5-302.fc20.x86_64 ...'
            linux   /vmlinuz-3.12.5-302.fc20.x86_64 root=/dev/mapper/nst20-root ro rd.lvm.lv=nst20/swap rd.lvm.lv=nst20/root vconsole.font=latarcyrheb-sun16 crashkernel=auto systemd.unit=multi-user.target
            echo    'Loading initial ramdisk ...'
            initrd  /initramfs-3.12.5-302.fc20.x86_64.img
    }
    .
    .
    .
    ```

### Пересоберите файл initramfs ядра

Образ ядра [**initramfs**](http://en.wikipedia.org/wiki/Initramfs) необходимо перестроить, чтобы отразить изменение имени группы томов LVM. Для выполнения этой задачи будет использоваться [**mkinitrd**](http://man7.org/linux/man-pages/man8/mkinitrd.8.html), использующий инструмент [**dracut**](https://dracut.wiki.kernel.org/index.php/Main_Page).

**Пример для ядра: 3.12.5-302.fc20.x86\_64**

```plaintext
[root@localhost ~]# ls -al /boot/initramfs-3.12.5-302.fc20.x86_64.img
-rw------- 1 root root 11435288 Jan  1 11:07 /boot/initramfs-3.12.5-302.fc20.x86_64.img
```

```plaintext
[root@localhost ~]# uname -r
3.12.5-302.fc20.x86_64 
```

```plaintext
[root@localhost ~]# mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
Creating: target|kernel|dracut args|basicmodules 
Executing: /usr/sbin/dracut -v -f /boot/initramfs-3.12.5-302.fc20.x86_64.img 3.12.5-302.fc20.x86_64
*** Including module: bash ***
*** Including module: i18n ***
*** Including module: ifcfg ***
*** Including module: drm ***
*** Including module: plymouth ***
*** Including module: dm ***
Skipping udev rule: 64-device-mapper.rules
Skipping udev rule: 60-persistent-storage-dm.rules
Skipping udev rule: 55-dm.rules
*** Including module: kernel-modules ***
*** Including module: lvm ***
Skipping udev rule: 64-device-mapper.rules
Skipping udev rule: 56-lvm.rules
Skipping udev rule: 60-persistent-storage-lvm.rules
*** Including module: resume ***
*** Including module: rootfs-block ***
*** Including module: terminfo ***
*** Including module: udev-rules ***
Skipping udev rule: 91-permissions.rules
*** Including module: biosdevname ***
*** Including module: systemd ***
*** Including module: usrmount ***
*** Including module: base ***
*** Including module: fs-lib ***
*** Including module: shutdown ***
*** Including modules done ***
*** Installing kernel module dependencies and firmware ***
*** Installing kernel module dependencies and firmware done ***
*** Resolving executable dependencies ***
*** Resolving executable dependencies done***
*** Pre-linking files ***
*** Pre-linking files done ***
*** Hardlinking files ***
*** Hardlinking files done ***
*** Stripping files ***
*** Stripping files done ***
*** Creating image file ***
*** Creating image file done ***
```

```plaintext
[root@localhost ~]# ls -al /boot/initramfs-3.12.5-302.fc20.x86_64.img
-rw------- 1 root root 11435512 Jan  1 14:20 /boot/initramfs-3.12.5-302.fc20.x86_64.img
```

## Перезагрузите систему

После внесения всех вышеперечисленных изменений используйте утилиту [**systemctl**](https://wiki.archlinux.org/index.php/systemd) для перезагрузки системы:

```plaintext
[root@localhost ~]# systemctl reboot
```