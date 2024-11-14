новый контроллер

https://wirenboard.com/wiki/Wiren_Board_7.4

обновляем прошивку https://wirenboard.com/wiki/Wiren_Board_7.4_Firmware_Update#web-ui

сменить пароль рута https://wirenboard.com/wiki/SSH#%D0%9B%D0%BE%D0%B3%D0%B8%D0%BD_%D0%B8_%D0%BF%D0%B0%D1%80%D0%BE%D0%BB%D1%8C

защитить веб интерфейс https://wirenboard.com/wiki/%D0%97%D0%B0%D1%89%D0%B8%D1%82%D0%B0_%D0%BF%D0%B0%D1%80%D0%BE%D0%BB%D0%B5%D0%BC

Установите верный часовой пояс. https://wirenboard.com/wiki/Time

```
timedatectl set-timezone Asia/Yekaterinburg
```

## Новое устройство для Modbus

Первым делом, увеличиваем скорость работы. Со стандартных 9600 на 115200, что соответствует "быстрому modbus"

Подключаемся к контроллеру по ssh и останавливаем службу `wb-mqtt-serial`. Затем выставляем нужную скорость и запускаем службу обратно.

```bash
systemctl stop wb-mqtt-serial
modbus_client --debug -mrtu -b9600 -pnone -s2 /dev/ttyRS485-2 -a212 -t0x06 -r110 1152
systemctl start wb-mqtt-serial
```
Разберем 2 строчку подробнее:

- `-b9600` - текущая скорость работы
- `-a212` - адрес устройство в modbus
- `/dev/ttyRS485-2` - через какой интерфейс подключаемся
- `-r110 1152` - записываем в регистр **110** значение скорости *115200*

## Смена ID-адреса у устройства

Останавливаем службу `wb-mqtt-serial`. Затем выставляем новый адрес и запускаем службу обратно.
Идентификацию делам по серийноу номеру:
```
systemctl stop wb-mqtt-serial
wb-modbus-scanner -d /dev/ttyRS485-2 -b 115200 -s 174072 -i 51 - сменить адрес у устройства с SN=174072
systemctl start wb-mqtt-serial
```

Разберем 2 строчку подробнее:

- `-b 115200` - текущая скорость работы
- `-s 174072` - серийник устройства
- `/dev/ttyRS485-2` - через какой интерфейс подключаемся
- `-i 51` - новый адрес
