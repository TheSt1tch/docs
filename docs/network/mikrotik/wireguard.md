# Настройка WireGuard на Mikrotik

# Что такое WireGuard

Если не касаться wiki и официального сайта, и объяснять как можно проще, то это VPN туннелирование через UDP.

Это возможность быстро, максимально просто и надёжно, с хорошим уровнем безопасности соединить две точки между собой.

Соединение одноранговое, открытый исходный код, и полу-автоматизированное создание маршрутов(для некоторых клиентов) – что еще нужно, для счастья 😉

Возможность использовать WireGuard появилась в mikrotik начиная с седьмой версии RouterOS.

## Как работает подключение (простым языком)

У нас есть две точки:
-   Точка А с внешним адресом 111.111.111.111
-   Точка Б с внешним адресом 222.222.222.222

С точки зрения WireGuard эти адреса называются `Endpoint`.

Также у точек есть внутренние сети или LAN:
-   Точка А. 192.168.100.0/24
-   Точка Б. 192.168.200.0/24

Эти сети мы и хотим связать между собой. Для WireGuard это называется **AllowedAddress**, или разрешенные адреса для точки. Для Точки А нам нужно будет указать разрешенные адреса – `192.168.200.0/24`. Для Точки Б, соответственно – `192.168.100.0/24`

Помимо этого мы должны определить для точек А и Б их адреса. Они используются для интерфейса, который создает WireGuard и передачи внутри протокола. В настройках большинства клиентов это будет называться `Address`. В mikrotik мы создадим отдельный адрес.

-   Точка А. 10.10.10.1
-   Точка Б. 10.10.11.1

Всё! Этого достаточно для создания подключения и его работы.

В итоге всё это будет выглядеть так:

![Краткая схема работы WireGuard](https://habrastorage.org/r/w1560/getpro/habr/upload_files/ba4/847/961/ba48479616baa45e5a2d49e35668e926.png)

## Отличия WireGuard и OpenVPN

Я не являются специалистом по сетевым протоколов и криптографических систем, поэтому не могу дать детальное сравнение этих решений. Но могу выделить несколько основных отличий для меня, как пользователя и администратора:

-   В WireGuard не нужно создавать сертификаты, в отличии от OpenVpn, и следить за ними. Это и плюс и минус в зависимости от цели использования.
-   В WireGuard создаются одноранговые соединения, где каждая точка может быть как сервером так и клиентом. Это позволяет создавать, помимо классических “звёзд”, ещё и mesh сети.
-   OpenVPN позволяет более тонко управлять клиентами и их подключениями. Например, можно индивидуально раздавать маршруты и DNS-серверы для клиентов. WireGuard так не умеет.
-   Отдельно для mikrotik есть недостаток в том, что для каждой подсети нужно настраивать маршруты. Для win-клиентов они определяются и задаются исходя из `AllowedAddress`.

В целом я для себя сделал вывод, что для внешних пользователей удобнее и, возможно, безопаснее использовать OpenVPN. А для железных(ака аппаратных) или программных роутеров и их связи между собой удобнее WireGuard. По принципу – настроил и забыл.

## Подготовка к настройке

Для начала нужно убедится в том, что наш роутер Mikrotik умеет работать с WireGuard. Далее я буду показывать на примере интерфейса winbox. Если Вы пользуете командную строку, то Вы, скорее всего, сами сможете определить наличие WireGuard.

Проверить, это можно просто взглянув на пункты меню (актуально для версии 7.5):

![](https://habrastorage.org/r/w1560/getpro/habr/upload_files/a70/2fb/4ac/a702fb4ac21cbfc064c036eceae95c7c.png)

Обновить можно попробовать так:

![стандартный способ обновления](https://habrastorage.org/r/w1560/getpro/habr/upload_files/fb4/029/b5d/fb4029b5d003f6b1ed3a639b140f47fa.png "стандартный способ обновления")

стандартный способ обновления

Если так не получилось, то смотрите свою версию в заголовке winbox устройства

![в данном случае это mipsbe](https://habrastorage.org/r/w1560/getpro/habr/upload_files/a59/8d9/653/a598d9653e2ad09ce2ff88de5bc85854.png "в данном случае это mipsbe")

в данном случае это mipsbe

и идите на [официальный сайт mikrotik](https://mikrotik.com/download) для скачивания последней версии ОС.

Коротко, как обновить через загрузку файла на Mikrotik:

![](https://habrastorage.org/r/w1560/getpro/habr/upload_files/cde/592/687/cde592687e0b10fc7cb74d0255d31c3f.png)

Если у Вас много точек и так же для удобства настройки и дальнейшего обслуживания я рекомендую создать Вам подобную таблицу:

| Name | Address | Endpoint | EndpointIp | AllowedIPs | ListenPort | PrivateKey | PublicKey |
|--|--|--|--|--|--|--|--|
| PointA | 10.10.10.1 | www.pointA.com | 222.222.222.222 | 10.10.11.1/32,192.168.200.0/24 | 13231 | `<your_key>` | `ucwL8IWLNYrPHOu9qk70ZOagPgjJXhzvvkg7ZLooaj4=` |
| PointB | 10.10.11.1 | www.pointB.com | 111.111.111.111 | 10.10.10.1/32,192.168.100.0/24 | 13231 | `<your_key>` | `FxNwKIFINspWh5pkoFpS5LzNKMDjkqcAV/Ypo2Ed8ys=` |

Вам так будет проще ориентироваться в дальнейшем

## Настройка WireGuard на Mikrotik

Итак, у Вас есть WireGuard на Mikrotik, и теперь мы можем начать настройку.

Прежде всего нам нужно создать интерфейс, чтобы получить публичный ключ или `Public Key`. Я ранее про него не писал умышленно, чтобы было проще понять принцип работы WireGuard.

Но без публичного ключа установить соединение не получится. Он служит ключом шифрования и, можно сказать, паролем точки и для каждой точки он должен быть уникальным. При создании интерфейса он генерируется автоматически, так что Вам не нужно об этом переживать:

![Создаем интерфейсы и копируем публичные ключи](https://habrastorage.org/r/w1560/getpro/habr/upload_files/e22/93a/b58/e2293ab586ed08adc7734ded260ea949.png "

## Скрипт для быстрой настройки

Далее я дам два варианта настройки простой и быстрый, и немного подольше. Для начала простой, которым пользуюсь сам. Вот скрипт который, я сделал для Вашего удобства:
```
# EXAMPLE start
# Peer A params
# Name peerAname "PointA"
# Interaface Address peerAifAddress "10.10.10.1/24"
# AllowedIPs peerAallowed 10.10.11.1/32,192.168.200.0/24
# EndPoint peerAendAddress "111.111.111.111"
# EndPort peerAendPort 13231
# PublicKey peerAkey "ucwL8IWLNYrPHOu9qk70ZOagPgjJXhzvvkg7ZLooaj4="
# Peer B params
# Name peerBname "PointB"
# Interaface peerBif "PointB"
# AllowedIPs peerBallowed 10.10.10.1/32,192.168.100.0/24
# EndPoint peerBendAddress "222.222.222.222"
# EndPort 13231
# PublicKey "FxNwKIFINspWh5pkoFpS5LzNKMDjkqcAV/Ypo2Ed8ys="
# EXAMPLE end

{
# Peer A params
# SET PARAMS HERE
:local peerAname "PointA"
:local peerAifAddress "10.10.10.1/24"
:local peerAallowed 10.10.11.1/32,192.168.200.0/24
:local peerAendAddress "111.111.111.111"
:local peerAendPort 13231
:local peerAkey "ucwL8IWLNYrPHOu9qk70ZOagPgjJXhzvvkg7ZLooaj4="
# Peer B params
:local peerBname "PointB"
:local peerBifAddress "10.10.11.1/24"
:local peerBallowed 10.10.10.1/32,192.168.100.0/24
:local peerBendAddress "222.222.222.222"
:local peerBendPort 13231
:local peerBkey "FxNwKIFINspWh5pkoFpS5LzNKMDjkqcAV/Ypo2Ed8ys="
# start select
:local input do={:put $input;:return}
:local selectedPeer [$input "Enter current Peer A or B"]
:put "You select is $selectedPeer. Finished!"
# end select
{
# start for A
:if ($selectedPeer = "A") do={
# add address
/ip address
add address=$peerAifAddress interface=$peerAname comment=$peerAname
# add firewall rule
/ip firewall filter
add action=accept chain=input dst-port=$peerAendPort in-interface-list=WAN protocol=udp comment="WireGuard $peerAname"
# add peer
/interface/wireguard/peers
add allowed-address=$peerBallowed endpoint-address=$peerBendAddress endpoint-port=$peerBendPort interface=$peerAname public-key=$peerBkey persistent-keepalive=10 comment=$peerBname
# add route
/ip/route
:foreach peer in=$peerBallowed do={
add dst-address=$peer gateway=$peerAname comment=$peerBname
}
}
# end for A
# start for B
:if ($selectedPeer = "B") do={
# add address
/ip address
add address=$peerBifAddress interface=$peerBname comment=$peerBname
# add firewall rule
/ip firewall filter
add action=accept chain=input dst-port=$peerBendPort in-interface-list=WAN protocol=udp comment="WireGuard $peerBname"
# add peer
/interface/wireguard/peers
add allowed-address=$peerAallowed endpoint-address=$peerAendAddress endpoint-port=$peerAendPort interface=$peerBname public-key=$peerAkey persistent-keepalive=10 comment=$peerAname
# add route
/ip/route
:foreach peer in=$peerAallowed do={
add dst-address=$peer gateway=$peerBname comment=$peerAname
}
}
# end for B
}
}
```

Его можно запускать прямо из терминала, либо из winbox открыв терминал. Так же вы можете добавить его в `System -> Scripts` и запустить из терминала, но так как это разовая процедура, не вижу в этом особого смысла.

> Для начала внесите все необходимые параметры в строки переменных
`:local`, затем скопируйте и вставьте скрипт в терминал. Вам нужно будет только выбрать точку в которой вы находитесь `А` или `B`. Введите её и нажмите `Enter`.

Так нужно будет повторить в каждой точке!

Скрипт создаёт `address`, правило firewall для доступа из вне по списку `interface list` `WAN`. Список интерфейсов `WAN` создаётся по умолчанию. Если его нет, то добавьте.

Далее, скрипт создаёт настройки точки `Peers` для подключения и добавляет все необходимые маршруты `Routes`, которые берёт из `Allowed Address`

Ну или вы можете прописать всё руками по следующим скриншотам:

![Создаём адрес и подсеть для нашего интерфейса](https://habrastorage.org/r/w1560/getpro/habr/upload_files/b6a/79c/890/b6a79c8907d945705ade7dd112fc5816.png)

Создаём адрес и подсеть для нашего интерфейса

![Создаём правило Firewall](https://habrastorage.org/r/w1560/getpro/habr/upload_files/776/c16/094/776c16094a52aa01d1b20ee7568ef440.png)

Создаём правило Firewall

![Прописываем маршруты](https://habrastorage.org/r/w1560/getpro/habr/upload_files/cb2/9d0/b13/cb29d0b1306b94391612fc9118770cdb.png "Прописываем маршруты")

Прописываем маршруты

![Добавляем точку к которой хотим подключится](https://habrastorage.org/r/w1560/getpro/habr/upload_files/291/636/634/291636634012a197fd5f611b026e9829.png)

Добавляем точку к которой хотим подключится

Надеюсь эта статья помогла кому-то быстро всё понять и настроить. Так как я на понимание, тесты и настройку потратил минимум один день, а то и больше.

И в конце добавлю общую схему со всеми параметрами:

![Общая схема работы и настройки WireGuard](https://habrastorage.org/r/w1560/getpro/habr/upload_files/7c0/a5c/cb8/7c0a5ccb8f649e9b51533b0ef75b1a1e.png)