# Проблема при обновлении из контроллера: Update – Failed update, error curl

Зайти на точку по ssh

Ввести `upgrade <ссылка_на_файл>`

файл выкладывать на **http** сервер в корень

пример:
!!! info "Пример"
    Через консоль на точке:
    ```bash
    upgrade http://ip-server/BZ.ar7240.v4.0.15.9872.181229.0259.bin
    upgrade http://ip-server/UAP-LR-v2.v4.0.15.9872.181229.0259.bin
    ```
    через SCP:
    ```bash
    scp /var/www/unifi/fw/UAP-LR-v2.v4.0.80.10875.200111.2335/firmware.bin admin@10.118.13.250:/tmp/fwupdate.bin
    ```