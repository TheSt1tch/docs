Traefik — это обратный прокси-сервер с открытым исходным кодом, обеспечивающий простую работу с микросервисами и/или просто контейнерами с вашими приложениями.

Обратный прокси-сервер (reverse proxy, реверс-прокси) служит для ретрансляции запросов из внешней сети к каким-либо серверам/сервисам внутренней сети (например веб-сервера, БД или файловые хранилища) и позволяет:
- обеспечить сокрытие структуры внутренней сети и подробностей о находящейся в ней сервисах;
- осуществлять балансировку нагрузки (load balancing) между экземплярами одного и того же сервиса или серверами с одинаковыми задачами;
- обеспечить зашифрованное (HTTPS) соединение между клиентом и любым сервисом, в таком случае SSL сессия создается между клиентом и прокси, а между прокси и сервисом во внутренней сети устанавливается незашифрованное HTTP соединение, если сервис поддерживает HTTPS то можно организовать зашифрованное соединение и во внутренней сети;
- организовать контроль доступа к сервисам (аутентификацию клиента), а также установить файрвол (брандмауэр).

В статье будет описываться использование Traefik в Docker в качестве реверс-прокси для других контейнеров Docker, а также не контейнеризированных сервисов.

## Введение
Traefik позиционируется разработчиками как “Edge Router”, то есть можно направить его непосредственно в глобальную сеть одной стороной и во внутреннюю другой. Если у читателя создалось впечатление что таким образом создается единая точка отказа всей системы, то так и есть, но есть несколько моментов:
- во-первых, **Traefik** имеет развитый функционал для автоматического восстановления при сбоях;
- во-вторых, существует **Traefik EE** — платная версия, в которой помимо прочих преимуществ имеется HA (Hight Availability, Высокая доступность), что подразумевает распределение нагрузки между несколькими экземплярами сервиса (узлами), таким образом при отказе одного его задачи перераспределяются на другие узлы, а отказавший узел отключается и затем немедленно вводится обратно в эксплуатацию.

> В качестве примечания отметим, что в статье будет рассматриваться бесплатная версия Traefik.

Одним из основных достоинств Traefik является возможность изменения его конфигурации без приостановки работы (“на лету”) при применении любого из поддерживаемых бэкэндов, называемых провайдерами.

Список основных провайдеров:
- Docker
- Kubernetes
- Consul Catalog
- Marathon
- Rancher
- File

В рамках этой статьи будут рассмотрены первый и последний провайдеры из этого списка.

Вероятно, не знакомому с темой читателю будет не понятно, чем является провайдер с именем — “File”, это некоторый файл (или папка с файлами), в котором описана конфигурация какого-либо сервиса, не связанного с другими провайдерами, но который должен быть скрыт за реверс-прокси. Остальные же провайдеры являются различными системами оркестрации контейнеров.

Файл конфигурации Traefik, а также файлы для провайдера “File” могут быть написаны на TOML либо YAML, в статье будут приведены примеры на YAML так как этот синтаксис больше нравится автору, а какой-либо функциональной разницы между ними нет, а также не составляет трудности переписать файлы на другой формат конфигурации. Traefik будет развернут в Docker. Для развертывания будет использоваться docker-compose, для обеспечения простоты повторного развертывания.

> В статье будут приведены команды для ОС Linux.

## Деплой Traefik

Предполагается что у читателя установлены и настроены `docker` и `docker-compose`, их установка выходит за рамки этой статьи.

Создадим в домашней папке пользователя папку `traefik`, в которой будем хранить всю конфигурацию, и перейдем в эту папку

```bash
mkdir ~/traefik
cd ~/traefik
```

Для развертывания (деплоя) Traefik создадим файл `docker-compose.yml` и отредактируем его в любом удобном вам редакторе. Для начала этот файл будет иметь следующий вид:
```yaml
version: '3.9'
services:
  traefik:
    image: traefik:v2.10
    container_name: traefik
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    ports:
      - 80:80
      - 443:443
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./data/traefik.yml:/traefik.yml:ro
```

Во внешний мир будут смотреть порты 80 и 443 для HTTP и HTTPS соответственно. Также пробросим в контейнер сокет демона Docker для работы механизма автоматической конфигурации. Конфигурацию Traefik будем описывать в файле `traefik.yml` находящемся в папке `data` в текущей директории.

> Если для разделения внешней и внутренней сетей используются networks Docker-а, то Traefik должен иметь доступ к внешней сети и ко всем внутренним в которых находятся целевые сервисы.

Создадим и будем постепенно наполнять этот файл.

Для начала опишем точки входа в наш прокси (те самые порты, которые смотрят во внешний мир):
```yaml
entryPoints:
  http:
    address: ":80"
  https:
    address: ":443"
```

Здесь `http` и `https` это просто названия (могут быть любыми, хоть `a` и `b`) и были выбраны так для удобства.

Теперь добавим первого провайдера — Docker, это делается следующим образом:

```yaml
providers:
  docker:
    endpoint: "unix:///var/run/docker.sock"
    exposedByDefault: false
```

Параметром указываем что Traefik не должен брать все контейнеры подряд, далее будет объяснено каким образом мы будем сообщать какие контейнеры нас интересуют. Также здесь видно зачем мы пробрасывали сокет в контейнер — именно через него Traefik будет получать сведения о запускаемых контейнерах на этом хосте (можно подключиться и к демону на другом хосте).

Следующим шагом развернем весь HTTP трафик в HTTPS (почему это было сделано именно таким образом будет описано дальше):

```yaml
http:
  routers:
    http-catchall:
      rule: HostRegexp(`{host:.+}`)
      entrypoints:
      - http
      middlewares:
      - redirect-to-https
  middlewares:
    redirect-to-https:
    redirectScheme:
      scheme: https
      permanent: false
```

Traefik может проксировать не только HTTP трафик, но и просто TCP и UDP, поэтому указываем что этот блок конфигурации относится к `http`.

Здесь мы встречаем два из трех основных элементов роутинга в Traefik 2 routers (роутеры) и middlewares(промежуточные обработчики), рассмотрим их подробнее.

### Routers (роутеры)

Рассмотрим на примере описанного выше роутера:

-  `http-catchall` — имя роутера, может быть любым, но обязано быть уникальным в рамках блока `http` всей конфигурации Traefik;
-  `rule:` — правило, описывает какой трафик попадает в этот роутер, в данном случае описывается `HostRegexp`, то есть поле `Host` запроса должно попадать под регулярное выражение `.+` (то есть любое), здесь мы видим специфику регулярных выражений в Traefik — оно должно быть заключено в фигурные скобки и иметь наименование (`host` в данном случае), то есть синтаксис имеем вид `{name:reg_exp}`;
-  `entrypoints` — массив описанных ранее точек входа, которые будут использоваться этим роутером, в нашем случае используем только `http`;
-  `middlewares` — массив промежуточных обработчиков, куда попадает трафик перед передачей к сервису (сервисы будут рассмотрены позднее).

Подробнее о различных видах правил можно прочитать в [документации](https://docs.traefik.io/routing/routers/#rule).

### Middlewares(промежуточные обработчики)

-  `redirect-to-https` — имя обработчика, может быть любым, но обязано быть уникальным в рамках блока `http` всей конфигурации Traefik;
-  `redirectScheme` — тип обработчика, в данном случае изменение схемы запроса;
-  `scheme: https` — вынуждает клиента использовать схему HTTPS при запросе к прокси;
-  `permanent: false` — говорит клиенту что это не навсегда и может измениться в будущем.

Подробнее о различных обработчиках можно прочитать в [документации](https://docs.traefik.io/middlewares/overview/) (дальше в статье будет описан ещё один обработчик — BasicAuth).

??? note "Полностью файл traefik.yml"
	```yaml
	entryPoints:
	  http:
	    address: ":80"
	  https:
	    address: ":443"
	providers:
	  docker:
	    endpoint: "unix:///var/run/docker.sock"
	    exposedByDefault: false
	http:
	  routers:
	    http-catchall:
	      rule: HostRegexp(`{host:.+}`)
	      entrypoints:
	      - http
	      middlewares:
	      - redirect-to-https
	  middlewares:
	    redirect-to-https:
	    redirectScheme:
	      scheme: https
	      permanent: false
	```

Таким образом мы получим первую рабочую конфигурацию. Выполняем
```bash
sudo docker-compose up -d
```
И прокси должен подняться, можно почитать логи (`sudo docker-compose logs -f`) и убедиться, что всё работает.

## Let’s Encrypt

Поскольку мы хотим использовать HTTPS нам нужно где-то взять SSL сертификаты для сервисов, есть возможность использовать свои сертификаты, но мы настроем автоматическое получение бесплатных сертификатов от Let’s Encrypt.

Добавим в конфигурацию (`traefik.yml`) новый блок:

```yaml
certificatesResolvers:
  letsEncrypt:
    acme:
      email: postmaster@example.com
      storage: acme.json
      caServer: "https://acme-staging-v02.api.letsencrypt.org/directory"
      httpChallenge:
        entryPoint: http
```

Здесь:
-  `letsEncrypt` — это просто имя резолвера;
-  `acme` — тип резолвера (других типов в общем-то и нет);
-  `storage` — файл, в котором хранятся сведения о полученных сертификатах;
-  `httpChallenge` — тип acme-челенжа, дополнительно указываем параметр — точку входа;
-  `caServer: "https://acme-staging-v02.api.letsencrypt.org/directory"` — позволяет использовать не основной сервер Let’s Encrypt в тестовых целях, так как основной имеет строгие лимиты API (можно закомментировать, когда наладите получение сертификатов).

Также дополним пункт `volumes` в файле `docker-compose.yml`, чтобы сохранять сертификаты при перезапуске контейнера (предварительно создав файл `data/acme.json`):

```yaml
  volumes:
	- /etc/localtime:/etc/localtime:ro
	- /var/run/docker.sock:/var/run/docker.sock:ro
	- ./data/traefik.yml:/traefik.yml:ro
	- ./data/acme.json:/acme.json
```

## Docker провайдер

HTTPS настроен, пришло время поднять первый сервис, пусть это будет дашборд самого Traefik, так как Traefik у нас в Docker, воспользуемся этим провайдером.

Для описания конфигурации в Docker Traefik использует метки (labels) контейнеров. Допишем в наш файл `docker-compose.yml`:
```yaml
	labels:
	  - "traefik.enable=true"
	  - "traefik.http.routers.traefik.entrypoints=https"
	  - "traefik.http.routers.traefik.rule=Host(`traefik.example.com`)"
	  - "traefik.http.routers.traefik.tls=true"
	  - "traefik.http.routers.traefik.tls.certresolver=letsEncrypt"
	  - "traefik.http.routers.traefik.service=api@internal"
	  - "traefik.http.services.traefik-traefik.loadbalancer.server.port=888"
```
Разберем построчно:
- `traefik.enable=true` — указываем что Traefik должен обеспечить
   доступ к этому контейнеру, необходимо для всего остального;
- `traefik.http.routers.traefik.entrypoints=https` — создаем новый
   роутер с точной входа `https`;
- `traefik.http.routers.traefik.rule=Host(`traefik.example.com`)` —
   роутер будет жить по адресу traefik.example.com;
- `traefik.http.routers.traefik.tls=true` — указываем что используется
   TLS;
-  `traefik.http.routers.traefik.tls.certresolver=letsEncrypt` —
   указываем через какой резолвер получать сертификат;
- `traefik.http.routers.traefik.service=api@internal` — указываем, что
   сервер за этим роутером — `api@internal`, это специальный сервис,
   созданный по умолчанию, это как раз и есть дашбоард который мы хотели
   увидеть;
- `traefik.http.services.traefik-traefik.loadbalancer.server.port=888`
   — издержки интерфейса, без этого не заработает, но можно написать
   абсолютно любую цифру.

Дашбоард надо включить, для этого добавим в файл `traefik.yml`:

```yaml
api:
	dashboard: true
```

На данном этапе можно пересоздать контейнер (нужно так как мы меняли `docker-compose.yml`):

```bash
sudo docker-compose down && sudo docker-compose up -d
```

Когда всё поднимется можно перейти на `traefik.example.com` (тут на самом деле должен быть ваш домен, который направлен на хост с Traefik) и увидеть дашборд.

Дашбоард это хорошо, но мы не хотим, чтобы все пользователи интернета имели к нему доступ, закроем его от внешнего мира с помощью BasicAuth, для это в Traefik есть специальный middleware.

Для начала сгенерируем для нас строку с логином и паролем (admin/password)^

```bash
$ htpasswd -nb admin password
admin:$apr1$vDSqkf.v$GTJOtsd9CBiAFFnHTI2Ds1
```


Теперь добавим в наш `docker-compose.yml` новые строчки:
```yaml
- "traefik.http.middlewares.traefik-auth.basicauth.users=admin:$$apr1$$vDSqkf.v$$GTJOtsd9CBiAFFnHTI2Ds1"
- "traefik.http.routers.traefik.middlewares=traefik-auth"
```

Заметим, что символы `$` из полученной строки мы должны заменить на `$$`.  
- `traefik.http.middlewares.traefik-auth.basicauth.users=...` — создаем middleware типа `basicauth` с параметром `users`;  
- `traefik.http.routers.traefik.middlewares=traefik-auth` — указываем что роутер `traefik` использует только что-то созданный middleware.

??? note "Весь docker-compose.yml"
	```yaml
	version: '3.9'
	services:
	  traefik:
	    image: traefik:v2.10
	    container_name: traefik
	    restart: unless-stopped
	    security_opt:
	      - no-new-privileges:true
	    ports:
	      - 80:80
	      - 443:443
	    volumes:
	      - /etc/localtime:/etc/localtime:ro
	      - /var/run/docker.sock:/var/run/docker.sock:ro
	      - ./data/traefik.yml:/traefik.yml:ro
	      - ./data/acme.json:/acme.json
	    labels:
	      - "traefik.enable=true"
	      - "traefik.http.routers.traefik.entrypoints=https"
	      - "traefik.http.routers.traefik.rule=Host(`traefik.example.com`)"
	      - "traefik.http.routers.traefik.tls=true"
	      - "traefik.http.routers.traefik.tls.certresolver=letsEncrypt"
	      - "traefik.http.routers.traefik.service=api@internal"
	      - "traefik.http.services.traefik-traefik.loadbalancer.server.port=888"
	```

Теперь при попытке доступа к дашборду у нас спросят логин и пароль.

Приведем также кофигурацию некого другого сервиса, развернутого через docker-compose (аналогично работает и для обычного docker):

```yaml
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.test.entrypoints=https"
      - "traefik.http.routers.test.rule=Host(`test.example.com`)"
      - "traefik.http.routers.test.tls=true"
      - "traefik.http.routers.test.tls.certresolver=letsEncrypt"
      - "traefik.http.services.test-service.loadbalancer.server.port=80"
```

Здесь одна новая метка `traefik.http.services.test-service.loadbalancer.server.port=80` — присваиваем этому контенеру имя сервиса `test-service` и порт 80, он автоматически присоединится к роутеру `test`, Traefik автоматически постороит маршрут до этого контенера, даже если он находится на другом хосте.

## File провайдер

С контейнерами работает, а как быть если есть какой-то сервис работающий на выделенном хосте (пускай IP 192.168.1.222 и порт 8080) и мы его хотим пропустить через этот же прокси, заодно закрыв его с помощью HTTPS. Для этого есть решение.

Добавим в `docker-compose.yml` ещё один `volume`:

```yaml
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./data/traefik.yml:/traefik.yml:ro
      - ./data/custom/:/custom/:ro
      - ./data/acme.json:/acme.json
```

Пускай описания таких хостов у нас будут лежать в `data/custom/` (а что, вдруг ещё появятся).

Добавим в `traefik.yml` конфигурацию file провайдера для этих файлов:

```yaml
providers:
...
  file:
    directory: /custom
    watch: true
```

Директория следует из нашего `docker-compose.yml`, а `watch: true` значит что Traefik будет автоматически обновлять конфигурацию при обнаружении изменений в этих файлах (помните про обновление конфигурации “на лету”, вот работает даже для файлов, а не только для оркестраторов).

Перезапускаем Traefik и теперь можно создать файл с описанием нашего отдельного хоста (`data/custom/host.yml`):

```yaml
http:
  routers:
    host:
      entryPoints: 
      - https
      service: service-host
      rule: Host(`host.example.com`) 
      tls:
        certResolver: letsEncrypt
  services:
    service-host:  
      loadBalancer:
        servers:
        - url: http://192.168.1.222:8080/
        passHostHeader: true 
```

Роутер описывался раньше, тут добавилось только `service: service-host` — связь с нашим сервисом, и конфигурация для TLS.

Описание для сервиса имеет вид:

```yaml
имя_сервиса:
  loadBalancer:
    servers:
    - хосты для балансировки нагрузки
    - ...
```

Дополнительно мы указываем параметр `passHostHeader: true` чтобы тот хост думал, что он на самом деле смотрит в сеть и прокси нет.