# DHCP 

## DHCP Option

Это может понадобиться, когда необходимо, чтобы один из компьютеров в локальной сети получил нестандартный адрес DNS-Сервера, шлюза, NTP-Сервера и.т.д.. Или например, когда требуется для определенной сети установить нестандартную DHCP-опцию.

[Список RFC DHCP Options](https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml)

## Создадим DHCP опцию для DNS-Сервера.

```plaintext
/ip dhcp-server option
add code=6 name=AD_DC value="'192.168.5.10'"
```

Выведем активные подключения

```plaintext
/ip dhcp-server lease print
```

Установим dhcp опцию для конкретного хоста

```plaintext
/ip dhcp-server lease
set numbers=0 dhcp-option=AD_DC
```

## Настройка DNS-суффикса

Клиенты Windows поддерживают только доменное имя, в то время как Linux/Mac поддерживает только функцию поиска домена.

Windows, установка dhcp-опции для конкретной сети

```plaintext
/ip dhcp-server network print
/ip dhcp-server network
set 0 domain=local.net
```

Linux | Windows, установка dhcp-опции для конкретного хоста

```plaintext
/ip dhcp-server option
add code=119 name=Domain_Search value="'local.net'" | Linux
add code=15 name=Domain_Name value="'local.net'" | Windows
/ip dhcp-server lease print
/ip dhcp-server lease
set numbers=0 dhcp-option=Domain_Search
```

## Настройка выдачи статических маршрутов

[IP Address to HEX](https://ncalculators.com/digital-computation/ip-address-hex-decimal-binary.htm)

[Конвертор чисел HEX/BIN/DEC](https://lin.in.ua/tools/numconv.html)

DHCP Classless Route с Option 249 и Option 121.

## Option 249

**Дано:**

-   MASK = 24 = 0x18
-   DEST = 192.168.5.0 = C0A80500
-   GW = 192.168.6.1 = C0A80601

**Пример:**

-   `0x[MASK][DEST][GW]`

**Итог:**

-  `0x18C0A80500C0A80601`

##  Option 121

( `0.0.0.0/0 [00] gw 192.168.6.1 [C0A80601]`) - необходимо добавить 00C0A80601

Должно получиться:

  `0x18C0A80500C0A8060100C0A80601`

 CLI:

```plaintext
/ip dhcp-server option add name=opt_249 code=249 value=0x18C0A80500C0A80601
/ip dhcp-server option add name=opt_121 code=121 value=0x18C0A80500C0A8060100C0A80601
/ip dhcp-server option sets add name=sets_249+121 options=opt_249,opt_121
/ip dhcp-server network print
/ip dhcp-server network set dhcp-option-set=sets_249+121 numbers=0
```