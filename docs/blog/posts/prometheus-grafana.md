# Как запустить Prometheus и Grafana используя Docker Compose

----------

Docker Compose используется для запуска нескольких контейнеров как одной службы. Если у вас есть приложение/стек, требующий разных служб, docker compose позволяет создать один файл, который запустит все контейнеры как одну службу и избавит вас от необходимости запускать их по отдельности. Также можно запускать по одной службе за раз с помощью docker compose. Сегодня мы рассмотрим, как запустить Prometheus и Grafana с помощью docker compose.

Чтобы иметь возможность использовать Docker Compose, в вашей системе должны быть установлены как Docker, так и Docker Compose.

Prometheus — это база данных временных рядов, использующая экспортеры для мониторинга различных серверов/сервисов, а Grafana — один из самых популярных инструментов мониторинга. В сочетании с Prometheus, Grafana предлагает мощный инструмент визуализации данных временных рядов.

Чтобы запустить Prometheus и Grafana с помощью docker compose, нам нужно создать файл docker compose, определяющий отдельные сервисы (Prometheus и Grafana), используемые образы, запущенные порты и все остальное необходимое.

## Использование постоянных томов с Docker Compose

Нам нужно учитывать тот факт, что для Grafana требуется файл конфигурации и файл источника данных. Promemetheus также требует файла конфигурации. Для этого мы будем использовать смонтированные тома (постоянные тома), чтобы можно было легко вносить изменения в файлы, когда это необходимо.

Создайте рабочий каталог с именем _prometheus-grafana_ и внутри него создайте каталоги для хранения файлов конфигурации Prometheus и Grafana.

mkdir -p ~/prometheus-grafana/{grafana,prometheus}

Теперь перейдите в каталог  _grafana_  и создайте файлы конфигурации. Файл конфигурации  **Grafana**  по умолчанию предоставляется в официальном репозитории Github. Создайте файл с именем _grafana.ini,_ скопируйте и вставьте конфигурацию grafana по умолчанию в этот файл и сохраните.

Контент для конфигурации Grafana по умолчанию можно найти по _адресу https://github.com/grafana/grafana/blob/master/conf/defaults.ini_ . Обратите внимание, что вы можете вносить изменения в файл конфигурации по умолчанию в соответствии с вашими потребностями.

wget https://raw.githubusercontent.com/grafana/grafana/main/conf/defaults.ini -O ~/prometheus-grafana/grafana/grafana.ini vim ~/prometheus-grafana/grafana/grafana.ini

После этого перейдите в папку Prometheus и создайте файл конфигурации prometheus, чтобы указать Prometheus, где брать метрики. Поскольку у меня нет отдельного сервера для мониторинга, отображаемые метрики относятся к самому серверу prometheus (localhost:9090)

nano ~/prometheus-grafana/prometheus/prometheus.yml

<code>global:

scrape_interval: 15s

scrape_timeout: 10s

evaluation_interval: 15s

alerting:

alertmanagers:

- static_configs:

- targets: []

scheme: http

timeout: 10s

api_version: v1

scrape_configs:

- job_name: prometheus

honor_timestamps: true

scrape_interval: 15s

scrape_timeout: 10s

metrics_path: /metrics

scheme: http

static_configs:

- targets:

- localhost:9090</code>

Вы можете открыть и изменить файл в соответствии с вашим вариантом использования.

nano ~/prometheus-grafana/prometheus/prometheus.yml

На данный момент Grafana не показывает, откуда брать данные. Нам нужно сказать ему, чтобы он достался от Прометея. Создайте файл с именем _datasource.yml_ в каталоге grafana.

nano ~/prometheus-grafana/grafana/datasource.yml

apiVersion: 1

datasources:

- name: Prometheus

type: prometheus

url: http://localhost:9090

isDefault: true

access: proxy

editable: true

Дальнейшая модификация может быть выполнена:

nano ~/prometheus-grafana/grafana/datasource.yml

К настоящему времени у нас готовы все тома. Давайте продолжим, чтобы создать файл docker-compose.

nano ~/prometheus-grafana/docker-compose.yml

Содержимое должно выглядеть так, как показано ниже. Убедитесь, что вы изменили путь к файлам конфигурации в соответствии с путями в вашей системе.

version:  "3.7"

networks:

direct_net:

name: direct_net

driver: bridge

ipam:

config:

- subnet:  192.168.200.0/24

services:

prometheus:

user:  "$PUID:$PGID"

container_name: prometheus

image: prom/prometheus:latest

restart: always

networks:

- direct_net

ulimits:

nofile:

soft:  200000

hard:  200000

command:

--config.file=/data/prometheus.yml

--storage.tsdb.path=/data

--storage.tsdb.retention.time=180d

--web.enable-admin-api

volumes:

- $DOCKER_APP/prometheus:/data

- /etc/timezone:/etc/timezone:ro

- /etc/localtime:/etc/localtime:ro

grafana:

user:  "$PUID:$PGID"

container_name: grafana

image: grafana/grafana:latest

restart: always

networks:

- direct_net

security_opt:

- no-new-privileges:true

environment:

GF_INSTALL_PLUGINS:  "grafana-clock-panel,grafana-simple-json-datasource,grafana-worldmap-panel,grafana-piechart-panel"

volumes:

- ~/prometheus-grafana/grafana/data:/var/lib/grafana

- /etc/timezone:/etc/timezone:ro

- /etc/localtime:/etc/localtime:ro

Если вам нужно указать конкретную версию Prometheus или Grafana, вы можете добавить номер версии, чтобы он выглядел так:

services:

prometheus:

image: prom/prometheus:<VERSION-TAG>#get tag https://hub.docker.com/r/prom/prometheus/tags

---

grafana:

image: grafana/grafana:<VERSION-TAG># Tags https://hub.docker.com/r/grafana/grafana/tags

Также целью создания стека Prometheus/Grafana является мониторинг других сервисов, работающих, возможно, на разных серверах. Prometheus использует разные экспортеры для предоставления метрик, связанных с аппаратным обеспечением и ядром, в зависимости от отслеживаемого вами сервиса, наиболее распространенным из которых является node-exporter. Экспортеры устанавливаются на хостах, за которыми нужно следить.

Поскольку у меня нет другого внешнего сервера, я собираюсь установить экспортер узлов на локальном компьютере. Для этого в конец файла  _~/prometheus-grafana/docker-compose.yml_  добавляем:

node-exporter:

image: prom/node-exporter:latest

container_name: monitoring_node_exporter

restart: unless-stopped

expose:

- 9100

Также я должен обновить файл prometheus.yml, чтобы добавить node-exporter в качестве цели.

static_configs:

- targets: ['localhost:9090','node-exporter:9100']

Или формат:

static_configs:

- targets:

- localhost:9090

- node-exporter:9100

Если у вас есть другие экспортеры из других сервисов, вы можете добавить в массив по подобию.

### Запуск контейнеров с помощью docker-compose

Перейдите в каталог данных:

cd ~/prometheus-grafana<code></code>

Теперь все готово для запуска наших контейнеров. Чтобы запустить контейнеры, выполните команду, как показано ниже:

docker compose up -d

Проверте запуск контейнеров:

docker compose ps

Получите доступ к Prometheus и grafana из браузера, используя порты по умолчанию. Для Прометея мы используем _`http://serverip_or_hostname:9090`_. Если вы перейдете к **status** -> target , вы сможете увидеть статус своих целей, как показано ниже **_:_**

![](https://techviewleo.com/wp-content/uploads/2021/03/How-to-run-prometheus-and-grafana-with-docker-compose.png?ezimgfmt=rs:640x143/rscb7/ng:webp/ngcb7)

Для Grafana зайдите `http://serverip_or_hostname:3000`и войдите в систему, используя имя пользователя и пароль, указанные в `.ini` файле конфигурации. Учетные данные по умолчанию: _admin:admin_

![](https://techviewleo.com/wp-content/uploads/2021/03/How-to-run-prometheus-and-grafana-with-docker-compose-1.png?ezimgfmt=rs:640x214/rscb7/ng:webp/ngcb7)

Теперь вы можете продолжить и создать информационную панель для мониторинга. Одна вещь, которую я отметил, заключается в том, что я не мог получить метрики для использования при создании графиков, когда «доступ» в разделе «HTTP» источников данных был установлен на «сервер». Мне пришлось установить его как «браузер», как показано ниже:

![](https://techviewleo.com/wp-content/uploads/2021/03/How-to-run-prometheus-and-grafana-with-docker-compose-4.png?ezimgfmt=rs:640x326/rscb7/ng:webp/ngcb7)