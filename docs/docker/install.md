Docker , также известный как Docker Engine, представляет собой технологию контейнеризации приложений с открытым исходным кодом. Это позволяет пользователям устанавливать приложения внутри программных контейнеров.

Это означает, что приложения могут быть отделены/изолированы от операционной системы, в которой они работают.

Прежде чем начать, необходимо включить аппаратную виртуализацию. Это относится к VT-x на Intel и AMD-V на материнских платах AMD. Это необходимо для запуска Docker.

На материнских платах AMD AMD-V включен по умолчанию. Однако на материнских платах Intel вам нужно будет вручную включить VT-x из BIOS/UEFI.

!!! tip "Скрипт для автоустановки Docker и Docker Compose"

    ```bash
    curl -fsSL get.docker.com | sh
    ```
    Установится последняя версия. После этого, дальнейшие шаги можно не делать.

## Шаг 1. Обновите и установите зависимости Docker

Во-первых, давайте обновим список наших пакетов и установим необходимые зависимости Docker.

```bash
sudo apt update
```

Затем используйте следующую команду для установки зависимостей или необходимых пакетов.

```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release
```

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

```bash
sudo systemctl status docker
```

Вы должны увидеть вывод, который говорит, что активен для статуса.

## Шаг 5. Добавьте пользователя в группу Docker

Для запуска контейнеров Docker и управления ими требуются привилегии sudo. Это означает, что вам придется вводить sudo для каждой команды или переключаться на учетную запись пользователя root. Но вы можете обойти это, добавив текущего пользователя в группу **докеров** с помощью следующей команды:

```bash
sudo usermod -aG docker ${USER}
```

Вы можете заменить **${USER}** своим именем пользователя или просто запустить команду как есть, пока вы вошли в систему.

Хотя это может быть незначительным риском для безопасности, все должно быть в порядке, если применяются другие [меры безопасности Docker](https://www.smarthomebeginner.com/traefik-docker-security-best-practices/).

## Шаг 6. Установим таймзону

Установим таймзону, чтобы в будущем было удобнее использовать. По умолчанию, установлена таймзона UTC+0. Поставим Московскую:

```bash
sudo timedatectl set-timezone Europa/Moscow
timedatectl status
```
# Команды Docker

Существует множество команд docker и docker compose, и их описание не является целью этого поста. Вы можете увидеть все возможные команды, используя следующую команду:

```bash
docker
```

Но вот несколько команд **docker** и **docker compose** для начала:

-   `sudo docker info` — информация об установке докера.
-   `sudo docker search IMAGE_NAME `— поиск определенных образов/контейнеров.
-   `sudo docker start CONTAINER_NAME` — запустить один или несколько контейнеров.
-   `sudo docker stop CONTAINER_NAME` — остановить один или несколько контейнеров.
-   `sudo docker restart CONTAINER_NAME` — перезапустить один или несколько контейнеров.
-   `sudo docker top CONTAINER_NAME` — просмотр запущенных процессов контейнера.
-   `sudo docker rm CONTAINER_NAME` — удалить один или несколько контейнеров.
-   `sudo docker pull CONTAINER_NAME` — извлекать обновленные образы из Docker Hub.
-   `sudo docker network ls` — просмотреть все определенные сети докеров.
-   `sudo docker ps -a` — просмотреть все запущенные контейнеры.
-   `sudo docker logs CONTAINER_NAME` — просмотр журналов одного, нескольких или всех контейнеров.
-   `sudo docker-compose up -d CONTAINER_NAME` — запустить определенные или все службы, определенные в docker-compose.yml.
-   `sudo docker-compose down CONTAINER_NAME` — остановить определенные или все службы, определенные в docker-compose.yml.

Обратите внимание, что в большинстве случаев **CONTAINER\_NAME** не является обязательным, и команда применяется ко всем возможным контейнерам, если имя контейнера не указано.