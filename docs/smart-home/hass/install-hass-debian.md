# Установка Home Assistant на Debian 12

## Подготовка

### Установка Debian

Рассматривать подробно установку не буду. Ищите в интернете.

### Установка OS Agent, Docker и зависимостей

После того, как основная операционная система установилась и была выполнена настройка, начнем установку агента `os-agent`. Он используется для разных типов установки HA и позволяет версии Supervisor обмениваться данными с основной операционной системой.

Для этого в терминале выполним команды обновления Debian, установки Docker, необходимых зависимостей для OS Agent, а также установщика Supervised. 

!!! warning

    Внимание: все команды здесь и далее запускаем по одной, и дожидаемся их завершения!

```bash
sudo -i
```

??? tip "При выполнении команды вы получили сообщение __команда `sudo` не найдена__"

    При установке на "голый" Debian, скорее всего, команды sudo в системе не окажется. Устанавливаем так:

    ```bash
    su -
    apt install sudo
    ```
    Теперь добавляем пользователя в группу sudo:

    ```bash
    usermod -aG sudo [ИМЯПОЛЬЗОВАТЕЛЯ]
    ```

    После, делаем релогон в систему

```bash
apt update && sudo apt upgrade -y && sudo apt autoremove -y
apt --fix-broken install
apt install apparmor jq wget curl udisks2 libglib2.0-bin network-manager dbus lsb-release systemd-journal-remote systemd-resolved -y
```

??? tip "Стала возникать ошибка __#Could not resolve host: get.docker.com__"

    Во время установки зависимостей, ставится пакет systemd-resolved. Из-за его установки, меняется DNS на дефолтный: 127.0.0.1. Чтобы решить проблему, необходимо внести правки в файл `resolved.conf`

    ```bash
    sudo nano /etc/systemd/resolved.conf
    ```
    В открывшемся файле раскомментируем и правим строку DNS, указав адрес вашего роутера, например: `DNS=192.168.1.1`. 

    Сохраняем результат («Ctrl+X», затем «y», а затем «Enter» для подтверждения), после чего перезапускаем systemd-resolved: 
    ```bash
    sudo systemctl restart systemd-resolved
    ```

```bash
curl -fsSL get.docker.com | sh
```

Далее перезагружаем систему. И после ребута, проверяем, что у нас права root:

```bash
sudo -i
```
Затем на [странице OS Agent](https://github.com/home-assistant/os-agent/releases/latest) находим последнюю версию и вставляем её в команды ниже (в примере указана версия 1.6.0):

```bash
wget https://github.com/home-assistant/os-agent/releases/download/1.6.0/os-agent_1.6.0_linux_x86_64.deb
dpkg -i os-agent_1.6.0_linux_x86_64.deb
```

### Установка Home Assistant Supervised

Теперь можно перейти к установке Home Assistant Supervised.

Выполняем команды:
```bash
wget -O homeassistant-supervised.deb https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
apt install ./homeassistant-supervised.deb
```

!!! note

    На этом шаге может появиться предупреждение: 

    `файл /root/homeassistant-supervised.deb недоступен для пользователя _apt. - pkgAcquire::Run (13: Отказано в доступе)` 

    Так как программа-установщик, не имея нужных прав доступа к текущему каталогу, вынуждена была получить привилегии root для выполнения установки. Сама установка при этом завершается успешно, предупреждение можно игнорировать.

Если в процессе установки было предложено выбрать тип машины, то выбираем generic-x86-64.

Время установки обычно в пределах 5 минут, проверить ход настройки Home Assistant, можно подключившись к IP-адресу вашего компьютера в Chrome/Firefox через порт 8123 (например, http://192.168.1.10:8123). Как только вы увидели экран входа в систему - настройка завершена, и пора настроить имя учетной записи и пароль. Также вы можете сразу настроить любые интеллектуальные устройства, которые Home Assistant автоматически обнаружил в вашей сети.