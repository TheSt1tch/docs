Docker , также известный как Docker Engine, представляет собой технологию контейнеризации приложений с открытым исходным кодом. Это позволяет пользователям устанавливать приложения внутри программных контейнеров.

Это означает, что приложения могут быть отделены/изолированы от операционной системы, в которой они работают.

Прежде чем начать, необходимо включить аппаратную виртуализацию. Это относится к VT-x на Intel и AMD-V на материнских платах AMD. Это необходимо для запуска Docker.

На материнских платах AMD AMD-V включен по умолчанию. Однако на материнских платах Intel вам нужно будет вручную включить VT-x из BIOS/UEFI.

## Шаг 1. Обновите и установите зависимости Docker

Во-первых, давайте обновим список наших пакетов и установим необходимые зависимости Docker.

`sudo apt update`

Затем используйте следующую команду для установки зависимостей или необходимых пакетов.

`sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release`

## Шаг 2. Добавьте репозиторий Docker в источники APT

Хотя установка Docker Engine из репозиториев Ubuntu проще, добавление официального репозитория Docker обеспечивает более быстрые обновления. Вот почему это рекомендуемый метод.

Во-первых, давайте получим ключ GPG, необходимый для подключения к репозиторию Docker. Для этого используйте следующую команду.

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

Используйте следующую команду для настройки репозитория:

```bash
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Приведенная выше команда автоматически заполнит ваше кодовое имя выпуска ( **jammy** для 22.04, **focus** для 20.04 и **bionic** для 18.04).

Наконец, снова обновите свои пакеты.

`sudo apt update`

## Шаг 3: Установите Docker Engine, containerd и Docker Compose

В этом руководстве по установке Ubuntu Docker мы установим пакет **docker-ce** (а не пакет **docker.io** ).

Чтобы установить Docker в Ubuntu или Debian, используйте следующую команду:

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Это загрузит и установит несколько сотен МБ пакетов

## Шаг 4. Убедитесь, что Docker работает в Ubuntu

Есть много способов проверить, работает ли Docker в Ubuntu. Один из способов — использовать следующую команду:

`sudo systemctl status docker`

Вы должны увидеть вывод, который говорит, что активен для статуса.

## Шаг 5. Добавьте пользователя в группу Docker

Для запуска контейнеров Docker и управления ими требуются привилегии sudo. Это означает, что вам придется вводить sudo для каждой команды или переключаться на учетную запись пользователя root. Но вы можете обойти это, добавив текущего пользователя в группу **докеров** с помощью следующей команды:

`sudo usermod -aG docker ${USER}`

Вы можете заменить **${USER}** своим именем пользователя или просто запустить команду как есть, пока вы вошли в систему.

Хотя это может быть незначительным риском для безопасности, все должно быть в порядке, если применяются другие [меры безопасности Docker](https://www.smarthomebeginner.com/traefik-docker-security-best-practices/) .

`sudo timedatectl set-timezone America/New\_York`