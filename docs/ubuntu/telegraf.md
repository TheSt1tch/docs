Telegraf это агент, написанный на Go для сбора метрик производительности из системы и сервисов, где он запущен. Собираемые метрики отправляются в **InfluxD** или в другие поддерживаемые хранилища. Из InfluxDB можно визуализировать данные и производительность используя Grafana. [Github](https://github.com/influxdata/telegraf/)

Базовый способ использования Telegraf следующий:

1.  Агент Telegraf устанавливается на все сервера, откуда нужно собирать метрики (Ubuntu, Debian, Windows, CentOS и прочие)
2.  Метрики собираются и отправляются в InfluxDB
3.  Источник данных InfluxDB добавляется в Grafana
4.  Созданы графики Grafana - они получают данные из источника данных InfluxDB.

Установка Telegraf на Ubuntu 22.04 производится из репозитория Influxdata. После добавления репозитория пакет можно установить с помощью диспетчера пакетов **apt**. Добавьте репозиторий InfluxData в файл `/etc/apt/sources.list.d/influxdata.list`
```bash
wget -q https://repos.influxdata.com/influxdata-archive_compat.key
echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | sudo tee /etc/apt/sources.list.d/influxdata.list
```

Обновить **apt** индекс и установить Telegraf

```bash
sudo apt update && sudo apt install telegraf -y
```

Запустить и включить сервис, для запуска при загрузке

```bash
sudo systemctl enable --now telegraf
sudo systemctl is-enabled telegraf
```

Проверить статус сервиса

```bash
systemctl status telegraf
```

## Решение проблем

### S.M.A.R.T. Input плагин

You will need the following in your telegraf config:

[[inputs.smart]]
  use_sudo = true

You will also need to update your sudoers file:

$ visudo
# For smartctl add the following lines:
Cmnd_Alias SMARTCTL = /usr/bin/smartctl
telegraf  ALL=(ALL) NOPASSWD: SMARTCTL
Defaults!SMARTCTL !logfile, !syslog, !pam_session

# For nvme-cli add the following lines:
Cmnd_Alias NVME = /path/to/nvme
telegraf  ALL=(ALL) NOPASSWD: NVME
Defaults!NVME !logfile, !syslog, !pam_session

https://github.com/influxdata/telegraf/tree/master/plugins/inputs/smart