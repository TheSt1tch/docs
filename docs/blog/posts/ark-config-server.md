---
draft: true 
date: 2023-10-17
categories:
  - "ark: se"
  - games
  - игры
  - игровые сервера
---

## RCON Tools

[ARK RCON tool ACCIon](https://survivetheark.com/index.php?/forums/topic/255792-ark-rcon-tool-accion/&)

## Console Commands

[список](https://ark.fandom.com/wiki/Console_commands)

## Генераторы конфигов

[https://ini.arkforum.de/](https://ini.arkforum.de/)

[Dino Spawn Configuration Tool](http://www.gamewalkthrough-universe.com/Walkthroughs-Guides/Ark-Survival-Evolved/Game-Server-Customization/Dino-Spawn/default.aspx)

---

## Файлы конфигурации

Большинство параметров сервера нужно указывать в двух файлах конфигурации `GameUserSettings.ini` и `Game.ini`.  

**Прежде чем вносить изменения в данные файлы, сервер нужно отключить**.

Расположение файлов конфигурации на FTP:

| Файл Конфигурации | Место нахождения |
| --- | --- |
| GameUserSettings.ini | ShooterGame/Saved/Config/LinuxServer/ |
| Game.ini | ShooterGame/Saved/Config/LinuxServer/ |

В файле `GameUserSettings.ini` содержатся параметры, как для клиента игры, так и для игрового сервера. Параметры клиента игры сервером не используются. Параметры сервера указаны в разделе под названием `[ServerSettings]`.

Файл `Game.ini` используется для более продвинутых модификаций - отключение каких либо энграмм, какое количество XP игрок будет получать за новый уровень, отключение специфического контента или изменение баланса в зависимости от предпочтений игроков.  
Изначально Game.ini чист, параметры в него нужно будет вписывать в ручную. Для начала вписываем раздел `[/script/shootergame.shootergamemode]`, только после этого указываем параметр.

Пример:

```
[/script/shootergame.shootergamemode]
MatingIntervalMultiplie=1.0
```

Все параметры в файлах `GameUserSettings.ini` и `Game.ini` нужно обязательно указывать со значением. Если параметр не указан в конфигурационном файле, его значение автоматически используется по умолчанию.  
После команды обязательно ставьте символ `=` только потом значение

Пример:

```
ServerCrosshair=True
AllowThirdPersonPlayer=True
MapPlayerLocation=True
MaxStructuresInRange=100
```

**Важное замечание по значениям параметров**

```plaintext
False - ложь\отключить
True - правда\включить
```